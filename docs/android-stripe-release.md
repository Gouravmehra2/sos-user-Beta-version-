# Stripe Android release build

With stripe_android 14.1.0 and Android Gradle Plugin 9, release lint can resolve
an optional Issuing compileOnly dependency transitively. The plugin declares
stripe-android-issuing-push-provisioning twice; only one declaration disables
transitive resolution. The other requests Google's private
play-services-tapandpay:18.8.0 artifact, which public Maven repositories cannot
supply.

android/build.gradle.kts makes all declarations of this specific module
non-transitive within stripe_android. This preserves the compile-time Issuing
API used by the plugin, without pulling its optional dependencies into release
lint. The app uses PaymentSheet and does not implement Issuing card provisioning.
Release lint remains enabled. No package-cache edits or extra repositories are
required, so the workaround applies on CI and fresh dependency installs.

Recheck the workaround after upgrading stripe_android; remove it when the
plugin's duplicate transitive declaration is fixed. If Issuing push provisioning
is added to this app, follow Stripe's Issuing setup and obtain Google's private
TapAndPay SDK through the approved distribution process instead.

Verification:

```sh
cd android
./gradlew :stripe_android:lintVitalAnalyzeRelease
cd ..
flutter build appbundle --release
```

Release signing is configured separately. Supply the production upload keystore
as described in android-release-signing.md before building for Google Play.

During local verification, Flutter also required the missing Android SDK
command-line tools for its post-build apkanalyzer symbol check. Installing the
official tools resolved that environment issue; the final
`flutter build appbundle --release --no-pub` completed successfully. Keep Android
SDK Command-line Tools installed on development and CI machines.
