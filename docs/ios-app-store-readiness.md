# iOS production configuration

UI widgets and layouts are unchanged.

## Configured in this project

- Google iOS client ID and callback scheme match the bundled Firebase plist for `com.sosuser.in`.
- Sign in with Apple entitlement is present for Debug, Profile, and Release configurations.
- Camera and photo purpose descriptions cover profile photo selection.
- Location is requested only while using the app to select a service address. Manual entry remains available.
- Unused location and fetch background modes are removed; remote-notification is retained.
- CocoaPods geolocator builds bypass Always-location permission code. Swift Package Manager does not use the Podfile flag; the installed plugin requests When In Use when that description is present. Inspect the final archive for privacy validation messages.
- Runner bundles a required-reason privacy manifest for app preferences (`UserDefaults`, `CA92.1`). This is not a declaration that the app collects no data. Third-party SDK manifests and App Store Connect privacy answers must cover actual collection.
- Google identity tokens are no longer printed by the social authentication service.

## Remaining external setup and verification

1. Configure Google OAuth clients and consent for project `app-tech-3a417`; Google uses OAuth access tokens directly with the backend. Apple also uses the backend directly, not Firebase Auth. Set backend `APPLE_CLIENT_IDS=com.sosuser.in` and deploy the unique partial appleId index.
2. Enable Sign in with Apple and Push Notifications for the Apple identifier `com.sosuser.in`; refresh provisioning profiles after capability changes. Use an App Store distribution profile when exporting. Xcode should supply production APNs entitlements in the exported app; do not force production in debug signing.
3. Apple login now uses `/api/auth/apple/challenge` and `/api/auth/apple`, and completes new registrations through the existing phone OTP flow. Test with the real backend and a provisioned device, including Hide My Email and repeat sign-ins. See `docs/apple-signin.md`.
4. Build with an explicit public HTTPS `API_BASE_URL`. The project's default remains a developer LAN address. Example, after confirming the production host: `flutter build ipa --release --dart-define=API_BASE_URL=https://YOUR_HOST/api`. Do not submit a build using the LAN default.
5. Configure the Firebase iOS APNs key and test foreground/background notification display on TestFlight. FCM tokens continue to be sent only by existing auth requests; no separate notification token API exists.
6. Validate account deletion against the real backend, including Apple token revocation if Apple accounts are supported. Provide a real privacy contact and hosted privacy policy URL. Complete App Store Connect data collection answers based on backend and SDK practices.
7. In Xcode Organizer validate the archive and generate its privacy report. The app-owned manifest covers preferences; SDK and backend data collection still need review. Supply reviewer credentials and OTP instructions.

References:
- https://developer.apple.com/app-store/review/guidelines/
- https://firebase.google.com/docs/auth/flutter/federated-auth
- https://pub.dev/packages/geolocator
- https://developer.apple.com/documentation/bundleresources/privacy-manifest-files
