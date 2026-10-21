# Firebase notifications

The central implementation is `lib/core/services/firebase_notification_service.dart`.
`main.dart` registers the background entry point before `runApp`; optional permission and local notification setup runs after the first destination renders.

- Login, registration verification, and Google login send `fcmToken` when available. Missing APNs/FCM tokens do not block authentication.
- FCM tokens are submitted through existing authentication requests. Session restore/update and resume connect notification sockets and refresh the inbox without a separate token API. The next authentication request retrieves the current token after token rotation.
- Foreground notification payloads on iOS use native banner/sound presentation; Android and foreground data-only messages use local notifications. Background notification payloads are displayed by the OS without a second local copy. iOS native presentation follows system notification permissions and is independent of Dart session/target filtering; the backend must target the correct device token.
- FCM background taps, terminated launches, and local notification taps queue JSON routing data until the authenticated dashboard is ready. Booking events fetch `/api/bookings/:id` and open current details. Unknown/invalid events or failed booking fetches open the inbox; non-user targets are ignored.
- Socket.IO authenticates using the backend JWT and joins `user:join` on every connection. Events/reconnections and resume refresh an open inbox. The existing paginated inbox and read APIs remain authoritative; FCM message IDs are never used as database IDs.
- Logout sends `fcmToken` to the existing backend logout endpoint. A failed logout keeps the session so the user can retry. Successful session clearing disconnects the notification socket, clears pending taps/inbox/local notifications, and invalidates in-flight inbox results. The supplied backend contract says logout invalidates other account sessions too.

## Device verification

### iOS Firebase identity and delivery

The Runner bundle identifier is `com.sosuser.in`. Its Firebase iOS app ID is
`1:957547435039:ios:bfcc1f056b067ea712712a` in project `app-tech-3a417`.
Keep `lib/firebase_options.dart` and `ios/Runner/GoogleService-Info.plist` aligned
with this app; the older `com.squadonsite.in` Firebase app is a different registration.

In Firebase Console → Project settings → Cloud Messaging, configure the Apple
APNs authentication key for this iOS app, with the correct key ID and Apple
developer team (`VYURF3MWBX`). An FCM token alone does not verify APNs delivery.

After rebuilding, reopen the app, allow notifications, and log in so the backend
receives the current token. Send a Firebase Console test notification to that
iPhone's FCM token with the app in the background. If this works but backend
messages do not, check the backend send response and payload. Visible background
notifications need a `notification` title/body or an APNs `aps.alert`; data-only
messages do not automatically display a banner. Do not force the production APNs
environment for a development build.

Debug logs report authorization status, waiting for APNs registration, and received
foreground messages. If authorization is denied, enable notifications in iOS Settings.

1. Ensure the backend Firebase Admin credentials use the same Firebase project as the Android JSON, iOS plist, and `firebase_options.dart`.
2. iOS requires an APNs key uploaded in Firebase and a provisioning profile with Push Notifications enabled. Push entitlement and fetch/remote-notification background modes are present in this project. Xcode signing must supply the appropriate production entitlement for distribution.
3. On real Android/iOS devices, log in and verify the backend receives `fcmToken`.
4. Trigger a booking status change from the backend. Check foreground display, background tap, terminated-app tap, and opening while another screen is active.
5. Deny permission, enable it later in Settings, and verify display after resume. Test that the next login sends the current token after token rotation; also test socket reconnect, read operations, and logout/account switching.
6. Console pushes test FCM delivery only; use backend events to test persisted history and sockets.

Automated auth payload and Google API tests pass (24 tests). Changed notification/session/startup files pass targeted analysis. Full-project analysis also scans downloaded plugin example sources in `build/ios/SourcePackages` and reports existing errors/lints. Real push delivery, APNs provisioning, and backend integration require device testing.

Reference: https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages
