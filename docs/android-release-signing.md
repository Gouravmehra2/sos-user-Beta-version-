# Android release signing

Release builds use the `release` signing configuration. Missing upload
credentials stop release builds; debug builds still use the normal debug key.

## Existing Play app

Use the existing upload keystore registered with Play Console. Creating another
key does not make it valid for updates to that app; use Play's upload-key reset
process if the original key is lost.

## New app

Create an upload keystore once, keep an encrypted backup of it and its password,
and keep using that key for subsequent uploads:

```sh
"/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" \
  -genkeypair -v -keystore android/app/upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Copy android/key.properties.example to android/key.properties, then enter the
keystore path, alias and passwords locally. Paths are relative to android/.
Never commit the real credentials or keystore; both are ignored by Git.

CI can instead supply ANDROID_UPLOAD_STORE_FILE, ANDROID_UPLOAD_STORE_PASSWORD,
ANDROID_UPLOAD_KEY_ALIAS and ANDROID_UPLOAD_KEY_PASSWORD as secret environment
variables. The keystore path can be absolute.

## Build and verify

```sh
flutter build appbundle --release
"/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" \
  -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
```

Check that the signer matches the expected upload certificate, not Android Debug.
The old debug-signed bundle must be replaced with a newly built release bundle.

For Google login, register the upload/release certificate SHA-1 and SHA-256 in
Firebase for local release testing. For Google Play installations using Play
App Signing, also register the Play app signing certificate fingerprints from
Play Console. Download updated Firebase configuration if needed.

Reference: https://docs.flutter.dev/deployment/android#sign-the-app

## Local upload key

The new app's upload key is stored at android/app/upload-keystore.jks, with alias
`upload`. Its generated password is in android/key.properties; both files are
Git-ignored and have owner-only file permissions. Back up both files together in
a secure location before publishing, and retain this key for future uploads.

android/upload_certificate.pem is the public certificate. The SHA-1 and SHA-256
fingerprints are in android/upload_certificate_fingerprints.txt. These public
files contain no private key or password.
