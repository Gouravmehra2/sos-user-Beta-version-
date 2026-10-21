# Google authentication

The app initializes Firebase before launch with the generated platform options,
uses google_sign_in 7.x to exchange Google's ID token for a Firebase session,
then sends the Firebase ID token to the app backend. Firebase alone never
grants an app session.

## Required backend contract

- POST /api/auth/google: `{ "firebaseIdToken": "...", "fcmToken": "..." }`.
  Verify the token with Firebase Admin for this Firebase project, derive the
  verified email from its claims, enforce account status, and return
  `success: true`, `accessToken`, and `refreshToken` (top-level or under `data`).
  Return 404 for an identity with no app account.
- POST /api/auth/google-signup: `{ "firebaseIdToken": "..." }`.
  Verify the identity and return `name` and `email` (top-level or under `data`).
  Return 409 for an existing app email. No app tokens are persisted at this step.
- Return 400 for invalid fields/missing email, 401 for invalid/expired tokens,
  and 403 for inactive/disallowed accounts. The app displays retry guidance for
  connection/server failures and sign-up/login actions for 404/409.

Do not send Firebase tokens as `accessToken` to legacy OAuth endpoints. The
backend implementation is not in this Flutter repository and must be updated
before this flow can work end to end. Firebase Admin credentials stay on the server.

## Signup and sessions

Google signup prefills the existing name/email form using the backend response.
Phone and password remain required; start-register and verify-register retain the
existing phone OTP flow. No fabricated password or Firebase-only login is used.

App credentials are stored with flutter_secure_storage. Existing preference
credentials migrate on startup and are removed from preferences. HTTP logging
omits headers and bodies to avoid exposing credentials. Temporary Firebase and
Google sessions are cleared after each attempt and during app logout.

## Platform setup and verification

Enable Google in Firebase Authentication, register Android SHA-1/SHA-256 for all
signing configurations, and keep Android/iOS Firebase and Google URL scheme
configuration aligned with that project. iOS uses Runner.entitlements for Keychain
Sharing. Install updated native dependencies when building after pub get.

Automated checks:

```
flutter test test/google_auth_api_test.dart test/auth_fcm_payload_test.dart test/session_address_routing_test.dart
```

On physical Android/iOS devices check account selection/cancellation, returning
login, new-account 404, existing-email 409, inactive account, offline retry,
Google signup followed by phone OTP, restart persistence, and logout. These need
an enabled Firebase project and the Firebase-aware backend contract above.
