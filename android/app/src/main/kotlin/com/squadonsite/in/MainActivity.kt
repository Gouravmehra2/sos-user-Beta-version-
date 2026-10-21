package com.squadonsite.`in`

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@Suppress("unused")
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "squadonsite/maps",
        ).setMethodCallHandler { call, result ->
            if (call.method != "getPlacesApiKey") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val apiKey = applicationInfo.metaData
                ?.getString("com.google.android.geo.API_KEY")
                ?.trim()
                .orEmpty()

            if (apiKey.isEmpty() || apiKey.startsWith("MISSING_")) {
                result.error(
                    "MAPS_API_KEY_MISSING",
                    "Google Maps API key is not configured in AndroidManifest metadata.",
                    null,
                )
            } else {
                result.success(apiKey)
            }
        }
    }
}