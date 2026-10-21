# Mobile Apple authentication

Apple uses native iOS authorization and direct backend verification. It does not
use Firebase Auth or the Google endpoint. Existing UI widgets/layouts are unchanged.
All Apple buttons call the shared AppleAuthFlow.

1. POST `/api/auth/apple/challenge` with `{}` obtains the nonce and challengeToken.
2. Pass nonce exactly as returned to native Apple authorization, without hashing.
3. POST `/api/auth/apple` with identityToken, authorizationCode, challengeToken and optional fcmToken.
   No client email, name or appleId is trusted to authenticate. The single-use authorization code is forwarded to the backend for its Apple code exchange.
4. Returning users must receive both app session tokens before AuthSession is
   updated and existing startup routing opens.
5. New users receive a verified email and appleRegistrationToken. These stay in
   memory. The existing signup form prefills the name only if Apple supplied one;
   the controller restores the verified email if edited. Name remains editable.
6. start-register includes the unchanged verified email, ticket, name, phone,
   password and optional FCM token. The existing OTP flow verifies the exact same
   phone value and saves the app session on success. Development OTP values are
   not passed to the OTP screen in release builds.

Cancellation ends the flow without exchanging credentials. Expired registration
requires a new Apple authorization; it cannot silently become ordinary signup.
Switching successfully to Google signup clears the Apple registration context.
Challenges, identity tokens and registration tickets are never persisted. HTTP
headers, bodies and error payloads are excluded from debug HTTP logs to avoid
credential leakage.

Android Apple login is not configured: a Services ID and real HTTPS callback with
OAuth state validation are required before enabling it. No website callback is assumed.

Backend setup: set APPLE_CLIENT_IDS to com.sosuser.in, configure session secrets,
and deploy the unique partial appleId index. Verify 400/401/403/409/503 handling.
An existing email conflict never automatically links accounts.

Release blocker outside this Flutter repository: the provided DELETE /api/auth/me
only deactivates the local account. Implement actual deletion and Apple grant
revocation on the backend before App Store submission. No Apple private key belongs
in Flutter. The backend must implement authorization-code exchange, secure storage of Apple refresh tokens, and grant revocation; these operations require server-side Apple credentials.

Device acceptance: first authorization, returning authorization without a name,
Hide My Email, cancellation, existing-email conflict, expired challenge/ticket,
wrong audience/nonce/signature, inactive account, OTP failure/success, session
restoration and refresh. Unit tests use fake network/native authorization; a real
iOS authorization and backend deployment still require device testing.
