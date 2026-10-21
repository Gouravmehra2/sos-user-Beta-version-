#!/usr/bin/env python3
"""Check release permissions and 64-bit ELF alignment without printing keys."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import xml.etree.ElementTree as ET
import zipfile

ANDROID = '{http://schemas.android.com/apk/res/android}'
FORBIDDEN = {
    'ACCESS_BACKGROUND_LOCATION', 'FOREGROUND_SERVICE',
    'FOREGROUND_SERVICE_LOCATION', 'READ_EXTERNAL_STORAGE',
    'WRITE_EXTERNAL_STORAGE', 'READ_MEDIA_IMAGES', 'READ_MEDIA_VIDEO',
    'MANAGE_EXTERNAL_STORAGE', 'QUERY_ALL_PACKAGES', 'READ_SMS', 'READ_CALL_LOG',
}


def audit(bundle, manifest):
    root = ET.parse(manifest).getroot()
    permissions = sorted(e.get(ANDROID + 'name') for e in root.findall('uses-permission'))
    errors = []
    forbidden = {'android.permission.' + name for name in FORBIDDEN}
    for name in sorted(set(permissions) & forbidden):
        errors.append('Unexpected permission: ' + name)
    for name in ('INTERNET', 'ACCESS_FINE_LOCATION', 'ACCESS_COARSE_LOCATION', 'POST_NOTIFICATIONS'):
        if 'android.permission.' + name not in permissions:
            errors.append('Missing permission: ' + name)
    target = int(root.find('uses-sdk').get(ANDROID + 'targetSdkVersion'))
    if target < 36:
        errors.append('Target SDK must be at least 36 for this release audit')
    if root.find('application').get(ANDROID + 'debuggable') == 'true':
        errors.append('Release manifest is debuggable')
    checked = []
    with zipfile.ZipFile(bundle) as archive:
        for name in sorted(archive.namelist()):
            if not name.endswith('.so') or '/lib/' not in name:
                continue
            data = archive.read(name)
            if data[:5] != b'\x7fELF\x02':  # Only ELF64 requires this check.
                continue
            endian = '<' if data[5] == 1 else '>'
            offset = struct.unpack_from(endian + 'Q', data, 32)[0]
            size, count = struct.unpack_from(endian + 'HH', data, 54)
            for index in range(count):
                fields = struct.unpack_from(endian + 'IIQQQQQQ', data, offset + index * size)
                kind, _, file_offset, vaddr, _, _, _, alignment = fields
                if kind == 1 and (alignment < 16384 or file_offset % 16384 != vaddr % 16384):
                    errors.append('16 KB ELF alignment failure: ' + name)
            checked.append(name)
    if not checked:
        errors.append('No 64-bit native libraries found')
    return {
        'bundle': str(bundle), 'sha256': hashlib.sha256(bundle.read_bytes()).hexdigest(),
        'package': root.get('package'), 'version_code': root.get(ANDROID + 'versionCode'),
        'target_sdk': target, 'permissions': permissions,
        'elf64_libraries_checked': checked, 'errors': errors,
        'limits': 'Also validate BundleConfig zip alignment, signing, runtime behavior, production URLs, and Play Console declarations.',
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bundle', type=Path,
                        default=Path('build/app/outputs/bundle/release/app-release.aab'))
    parser.add_argument('--manifest', type=Path,
                        default=Path('build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml'))
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    result = audit(args.bundle, args.manifest)
    report = json.dumps(result, indent=2) + '\n'
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(report)
    print(report, end='')
    raise SystemExit(bool(result['errors']))


if __name__ == '__main__':
    main()
