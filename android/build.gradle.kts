allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Stripe assumes AGP 9 uses built-in Kotlin, but this Flutter project opts out.
// Match Stripe's Java 17 target instead of inheriting the Gradle runtime's JDK.
project(":stripe_android") {
    // stripe_android 14.1.0 declares Issuing twice: one compileOnly declaration
    // still pulls in Google's private TapAndPay SDK during AGP 9 release lint.
    // This app uses PaymentSheet, not Issuing card provisioning. Keep the
    // compile-time Stripe API, but make both declarations non-transitive.
    configurations.configureEach {
        dependencies.withType<org.gradle.api.artifacts.ModuleDependency>().configureEach {
            if (group == "com.stripe" && name == "stripe-android-issuing-push-provisioning") {
                isTransitive = false
            }
        }
    }

    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinJvmCompile>().configureEach {
        compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
