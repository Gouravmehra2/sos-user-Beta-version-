import java.util.Properties

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Credentials stay local or come from CI secrets. Paths in key.properties are
// resolved relative to android/, so storeFile=app/upload-keystore.jks works.
val uploadProperties = Properties()
val uploadPropertiesFile = rootProject.file("key.properties")
if (uploadPropertiesFile.isFile) {
    uploadPropertiesFile.inputStream().use { uploadProperties.load(it) }
}
fun uploadSetting(name: String, environmentName: String): String? =
    System.getenv(environmentName)?.takeIf { it.isNotBlank() }
        ?: uploadProperties.getProperty(name)?.takeIf { it.isNotBlank() }

val uploadStoreFile = uploadSetting("storeFile", "ANDROID_UPLOAD_STORE_FILE")
val uploadStorePassword = uploadSetting("storePassword", "ANDROID_UPLOAD_STORE_PASSWORD")
val uploadKeyAlias = uploadSetting("keyAlias", "ANDROID_UPLOAD_KEY_ALIAS")
val uploadKeyPassword = uploadSetting("keyPassword", "ANDROID_UPLOAD_KEY_PASSWORD")
val uploadSigningReady = listOf(
    uploadStoreFile, uploadStorePassword, uploadKeyAlias, uploadKeyPassword,
).all { it != null }

val validateUploadSigning = tasks.register("validateUploadSigning") {
    doLast {
        check(uploadSigningReady) {
            "Release signing is missing. Configure android/key.properties " +
                "or ANDROID_UPLOAD_* environment variables. See docs/android-release-signing.md."
        }
        check(rootProject.file(uploadStoreFile!!).isFile) {
            "Release upload keystore was not found. Check storeFile in android/key.properties."
        }
    }
}
// Also protects direct Gradle release builds; debug builds need no upload key.
tasks.configureEach {
    if (name == "preReleaseBuild" || name == "validateSigningRelease") {
        dependsOn(validateUploadSigning)
    }
}

android {
    namespace = "com.squadonsite.in"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.squadonsite.in"
        // google_maps_flutter requires API level 21+
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ── Google Maps API key ───────────────────────────────────────────────
        // Pass at build time:
        //   flutter run --dart-define=GOOGLE_MAPS_ANDROID_API_KEY=AIza...
        //
        // The value is forwarded to AndroidManifest.xml via the placeholder
        //   ${GOOGLE_MAPS_API_KEY}  →  com.google.android.geo.API_KEY meta-data
        val mapsKey: String = System.getenv("GOOGLE_MAPS_ANDROID_API_KEY")
            ?: (project.findProperty("GOOGLE_MAPS_ANDROID_API_KEY") as? String)
            ?: "MISSING_GOOGLE_MAPS_ANDROID_API_KEY"
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = mapsKey
    }

    signingConfigs {
        create("release") {
            if (uploadSigningReady) {
                storeFile = rootProject.file(uploadStoreFile!!)
                storePassword = uploadStorePassword
                keyAlias = uploadKeyAlias
                keyPassword = uploadKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
