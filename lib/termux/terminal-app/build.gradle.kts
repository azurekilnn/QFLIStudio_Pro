plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.maven.publish)
}

val packageVariant: String =
    System.getenv("TERMUX_PACKAGE_VARIANT") ?: "apt-android-7" // Default: "apt-android-7"
extra["packageVariant"] = packageVariant

android {
    namespace = "com.termux"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()
    ndkVersion = System.getenv("JITPACK_NDK_VERSION") ?: project.properties["ndkVersion"] as String

    dependencies {
        implementation(libs.androidx.annotation)
        implementation(libs.androidx.core)

        implementation("androidx.drawerlayout:drawerlayout:1.1.1")
        implementation("androidx.preference:preference:1.1.1")
        implementation("androidx.viewpager:viewpager:1.0.0")
        implementation(libs.google.material)
        implementation(libs.google.guava)
        implementation(libs.markwon.core)
        implementation(libs.markwon.ext.strikethrough)
        implementation(libs.markwon.linkify)
        implementation(libs.markwon.recycler)

        implementation(project(":lib:termux:terminal-view"))
        implementation(project(":lib:termux:termux-shared"))
        testImplementation(libs.junit)
        testImplementation(libs.tests.robolectric)
    }

    defaultConfig {
        minSdk = (project.properties["minSdkVersion"] as String).toInt()

        var manifestPlaceholders = mutableMapOf(
            "TERMUX_PACKAGE_NAME" to "com.qflistudio.azure",
            "TERMUX_APP_NAME" to "Termux",
            "TERMUX_API_APP_NAME" to "Termux:API",
            "TERMUX_BOOT_APP_NAME" to "Termux:Boot",
            "TERMUX_FLOAT_APP_NAME" to "Termux:Float",
            "TERMUX_STYLING_APP_NAME" to "Termux:Styling",
            "TERMUX_TASKER_APP_NAME" to "Termux:Tasker",
            "TERMUX_WIDGET_APP_NAME" to "Termux:Widget"
        )

        externalNativeBuild {
            ndkBuild {
                cFlags(
                    "-std=c11",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-Os",
                    "-fno-stack-protector",
                    "-Wl,--gc-sections"
                )
            }
        }

        ndk {
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a"))
        }

        buildConfigField (
            "String",
            "TERMUX_PACKAGE_VARIANT",
            "\"${project.extra["packageVariant"]}\""
        )
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }

    externalNativeBuild {
        ndkBuild {
            // 2024//11/15 AzureKiln
            // path = file("src/main/cpp/Android.mk")
        }
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    testOptions {
        unitTests.isReturnDefaultValues = true
    }

    buildFeatures {
        buildConfig = true
    }
}


dependencies {
    implementation(project(":lib:termux:termux-shared"))
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    coreLibraryDesugaring(libs.desugar)
}