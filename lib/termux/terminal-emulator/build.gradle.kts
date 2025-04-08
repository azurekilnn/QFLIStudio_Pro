plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.maven.publish)
}

android {
    namespace = "com.termux.emulator"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()
    ndkVersion = System.getenv("JITPACK_NDK_VERSION") ?: project.properties["ndkVersion"] as String

    defaultConfig {
        minSdk = (project.properties["minSdkVersion"] as String).toInt()

        externalNativeBuild {
            ndkBuild {
                cFlags("-std=c11", "-Wall", "-Wextra", "-Werror", "-Os", "-fno-stack-protector", "-Wl,--gc-sections")
            }
        }

        ndk {
            abiFilters.addAll(listOf("x86", "x86_64", "armeabi-v7a", "arm64-v8a"))
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }

    externalNativeBuild {
        ndkBuild {
            path = file("src/main/jni/Android.mk")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    testOptions {
        unitTests.isReturnDefaultValues = true
    }
}

tasks.withType<Test> {
    testLogging {
        events("started", "passed", "skipped", "failed")
    }
}

dependencies {
    implementation(libs.androidx.annotation)
    testImplementation(libs.junit)
}
