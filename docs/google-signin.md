# Google mobile authentication

Google authorization uses google_sign_in 7.x with userinfo.email and userinfo.profile
scopes. The native service obtains an OAuth access token using authorizationForScopes
or authorizeScopes. Google ID tokens and Firebase ID tokens are not sent to this API.
Firebase remains available for push notifications; Firebase Authentication is not part
of Google login.

- POST `/api/auth/google`: `{ "accessToken": "GOOGLE_OAUTH_ACCESS_TOKEN", "fcmToken": "optional" }`.
  Require success plus both app access and refresh tokens before saving AuthSession.
- POST `/api/auth/google-signup`: `{ "accessToken": "GOOGLE_OAUTH_ACCESS_TOKEN" }`.
  Returns name/email only. No app session is created. Missing name is collected in
  the existing form; the controller preserves the returned Google email.
- Existing start-register and verify-register complete phone/password signup.
  Keep the same full phone number throughout. Resend repeats start-register with
  the same in-memory form data; passwords are never persisted. No devOtp is passed
  to the OTP screen in release builds.

The backend currently matches by Google email; this is not cryptographically bound
Google identity linking. Do not claim that Google signup verifies the new account's
email. Backend audience/email_verified/sub hardening needs a new backend contract.

Cancellation restores idle state without an error. 404 offers signup; 409 offers
existing sign-in; 403 displays the backend message. Network/server failures do not
save a session. Google SDK signOut clears transient credentials after each flow;
disconnect is not called. HTTP request/response bodies and headers are excluded
from debug logs.

Initialization uses the web OAuth client ID from android/app/google-services.json,
with optional GOOGLE_WEB_CLIENT_ID dart-define override. iOS reads GIDClientID and
its callback scheme from Info.plist; these match GoogleService-Info.plist for
com.sosuser.in. No Google client secret belongs in the app. Register Android debug,
release and Play signing fingerprints and configure the OAuth consent screen.

Remaining session lifecycle differences from the supplied backend guide: the current
app has no automatic refresh-token/retry interceptor, and logout retains the local
session when network logout fails. These behaviors are separate from the provider
token exchange changed here and need a dedicated session lifecycle update.

Run Google, Apple and auth payload tests after auth changes. Device verification is
still required for native account selection, scope consent and cancellation, plus
login/signup/OTP on both Android release signing and a provisioned iPhone.
