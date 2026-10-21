# Google Play release audit — 15 October 2026

This is a project audit, not confirmation that Google Play has approved the app.
Do not upload the audit bundle with the default development backend.

## Permissions and project changes

- Kept foreground coarse/fine location for service-address selection and
  `POST_NOTIFICATIONS` for booking updates. Both have runtime request flows.
- Removed unused background location and foreground-service permissions. There
  is no background location stream or foreground tracking implementation in this
  app. Adding that feature later requires revisiting permissions and disclosures.
- Removed the unused `file_saver` dependency, which contributed storage permissions.
  Explicit merger removals prevent broad storage/photo/video permissions from
  entering the final manifest. Profile pictures use the external camera intent
  or a system image-selection flow, so a direct `CAMERA` declaration is unnecessary.
- Release network security requires HTTPS. Debug/profile resource overrides allow
  local HTTP development. `API_BASE_URL` now controls the main API client,
  Places, password reset, and socket origin consistently.
- Existing SDK configuration targets API 36, uses AGP 9.0.1 and NDK 28.2,
  and requires the local/CI upload key for release signing.
- Account deletion is available under Profile and calls `DELETE /api/auth/me`.
  Verify server-side deletion and retained-record disclosures against production.

Normal SDK permissions remaining in the merged release manifest include network
state, wake lock, vibration, Firebase messaging, NFC/biometric support from payment
SDKs, Maps services, and a signature-protected internal receiver permission.
Their presence does not mean the app requests those as dangerous runtime permissions.

## Validation results

- Merged release manifest: target SDK 36; required foreground permissions present;
  background location, foreground-service and broad storage/media permissions absent.
- Backend configuration/password reset/address/autocomplete tests: 13 passed with
  an HTTPS endpoint override and mocked network responses.
- Project-owned Dart analysis: zero errors, 25 warnings and 51 lint notices.
  Generated build output is excluded from analysis. Remaining warnings/notices
  are not proof of release readiness and have not been suppressed.
- Local signed AAB build completed: `build/app/outputs/bundle/release/app-release.aab`
  (107.4 MB, version code 1, package `com.squadonsite.in`).
- Google's bundletool 1.18.3 validated the AAB. Bundle configuration specifies
  `PAGE_ALIGNMENT_16K`; all 16 bundled ELF64 libraries passed alignment checks.
- JAR signature verification succeeded, and the signer matches
  `android/upload_certificate.pem`. Google Play account registration of that
  upload certificate cannot be verified from the repository.
- Artifact SHA-256: `7eb4417e11a31fd289649f1b4bd70972fa1ba5b2394dae8e3e6ad13fa3e6e0e6`.
  The generated artifact audit is in `build/reports/play-store-audit.json`.
- The endpoint configuration test also passed with ordinary development defaults.
- This audit bundle uses the private development backend. Rebuild with your
  actual production HTTPS endpoint before uploading. Device testing and
  Play Console checks remain open.

## Required production and Console work

1. Supply the actual production HTTPS API endpoint ending in `/api`. The default
   is a private development host and will not work for Play reviewers or customers.
2. Build with an unused version code if this Play app already has an uploaded build:

   ```sh
   flutter build appbundle --release --dart-define=API_BASE_URL=https://YOUR_PRODUCTION_HOST/api --build-number=YOUR_UNUSED_VERSION_CODE
   ```

3. Restrict the Android Maps key to the app package `com.squadonsite.in` and the
   appropriate release/Play signing certificate. Register the Play app-signing
   certificate fingerprints in Firebase/Google login. Existing upload-key setup
   is described in [android-release-signing.md](android-release-signing.md).
4. Provide publicly accessible privacy-policy and account-deletion-request URLs
   in Play Console. The bundled privacy-policy HTML is not a public URL. Verify
   its contact details and retention claims against the actual business/backend.
5. Complete Data safety, app access/reviewer login, content rating, target audience,
   ads declaration, store listing, and any testing/account-verification steps
   requested by Console. Include actual backend/SDK practices, not only manifest
   permissions. Review location/address, account/contact data, profile photos,
   messages, booking/payment records, and device/push identifiers.
6. Test a Play-installed build: fresh install, denied/approximate location, denied
   notifications, profile gallery/camera, Google login, Stripe return link,
   booking, invoices, account deletion, and a 16 KB Android device/emulator.

## Reproducible artifact checks

```sh
python3 scripts/audit_android_bundle.py --output build/reports/play-store-audit.json
java -jar /path/to/bundletool-all.jar validate --bundle=build/app/outputs/bundle/release/app-release.aab
java -jar /path/to/bundletool-all.jar dump config --bundle=build/app/outputs/bundle/release/app-release.aab
```

Confirm `PAGE_ALIGNMENT_16K` in the bundle configuration in addition to ELF
alignment. The Python audit uses the merged manifest from the same release build;
rebuild before checking. Signing, Play-generated APK installation and runtime
behavior require separate verification.

Backend-override regression check (no live requests):

```sh
flutter test --no-pub --dart-define=API_BASE_URL=https://release.squadonsite.example/api test/api_endpoint_configuration_test.dart test/password_reset_api_test.dart test/address_api_payload_test.dart test/map_picker_autocomplete_test.dart
```

## Official references

- [Target API requirements](https://developer.android.com/google/play/requirements/target-sdk)
- [Background location policy](https://support.google.com/googleplay/android-developer/answer/9799150)
- [Photo/video permission policy](https://support.google.com/googleplay/android-developer/answer/14115180)
- [Image picker setup](https://pub.dev/packages/image_picker)
- [16 KB compatibility](https://developer.android.com/guide/practices/page-sizes)
- [Account deletion requirements](https://support.google.com/googleplay/android-developer/answer/13327111)
