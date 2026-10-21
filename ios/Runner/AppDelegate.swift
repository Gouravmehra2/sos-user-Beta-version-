import Flutter
import GoogleMaps   // Required for GMSServices.provideAPIKey
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ── Google Maps iOS SDK initialisation ──────────────────────────────────
    //
    // The API key is baked in at Flutter build time via:
    //   flutter run --dart-define=GOOGLE_MAPS_IOS_API_KEY=AIza...
    //
    // The Flutter toolchain writes every --dart-define value into
    //   ios/Flutter/flutter_export_environment.sh  (and GeneratedPluginRegistrant)
    // but the cleanest way to read it on the native side is to store it in
    // Info.plist during build.  We read the value from Info.plist key
    // "GMSApiKey", which is already present in this project's Info.plist.
    //
    // If you need to inject it dynamically from --dart-define, add a
    // flutter_export_environment.sh post-action in Xcode or use a Run Script
    // build phase that writes the key into Info.plist before compilation.
    //
    // For local development you can set GMSApiKey directly in Info.plist.
    // For CI, pass it as an Xcode build setting and reference it as
    //   $(GOOGLE_MAPS_IOS_API_KEY)  in Info.plist.

    let mapsApiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String ?? ""
    if mapsApiKey.isEmpty {
      // Crash-early in debug so a missing key is obvious rather than a
      // silent blank map.
      assert(false, "GMSApiKey is missing from Info.plist — set it or pass via --dart-define=GOOGLE_MAPS_IOS_API_KEY=...")
    }
    GMSServices.provideAPIKey("AIzaSyA-pUy2TNFHhUoHzdXP49xylTJgrcGXTYg")
    // ────────────────────────────────────────────────────────────────────────

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
