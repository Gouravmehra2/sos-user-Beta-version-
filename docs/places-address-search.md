# Address search integration

The map picker calls authenticated `POST /api/places/autocomplete` and
`POST /api/places/details` using `ApiEndpoints.apiBaseUrl`. Configure the API
origin with `--dart-define=API_BASE_URL=https://your-host/api` when building.
The login bearer token is supplied by the existing session. Search requests
use a separate HTTP client without request-body logging.

Set `GOOGLE_PLACES_API_KEY` only in the backend environment, enable Places
API (New), and restart that backend. Keep Android and iOS Maps SDK keys
separate and restricted to their respective apps and SDKs. No Places server
key is required in Flutter.

Profile addresses support manual entry, map selection, editable address
components, separate building/floor and street fields, labels, and default
selection. Checkout can select an existing address or use a new address with
optional profile saving. Changing to a saved address from Book Service also
updates the profile default through `setDefaultAddress` before confirmation.
A failed optional save preserves the draft and lets
the customer retry or continue without saving. Save responses refresh the
address list from `data.user.addresses`; saved selections retain the server ID.

Reverse geocoding currently uses the existing native `geocoding` package.
The proposed `/api/places/reverse-geocode` endpoint is not called. A failed
lookup preserves the previous committed address, disables confirmation for
the unresolved pin, and offers retry, previous-location restoration, or
manual entry.

Backend follow-up outside this Flutter repository:

- Fix the documented latitude-truthiness check so saved coordinates with
  latitude `0` survive add/update. Flutter accepts and sends valid zero values.
- Handle `updateAddress.coordinates: null` by clearing stored coordinates
  when the customer manually changes an address identity.
- Confirm permitted retention of saved Google-derived addresses and coordinates.
  Suggestion lists and raw Places responses are not persisted by the picker.
  See [Places policies](https://developers.google.com/maps/documentation/places/web-service/policies).

Before release, check live autocomplete and selection against the configured
backend on Android and iOS. Verify keyboard layout and attribution, denied
location permission, disabled location services, offline retry, and saved
address persistence. Automated tests mock Places and native reverse lookups;
they do not verify Cloud configuration or deployment.

Focused verification:

```sh
flutter test --no-pub test/address_flow_test.dart test/address_api_payload_test.dart test/map_picker_autocomplete_test.dart test/booking_selection_test.dart test/select_location_refresh_test.dart test/session_address_routing_test.dart
```
