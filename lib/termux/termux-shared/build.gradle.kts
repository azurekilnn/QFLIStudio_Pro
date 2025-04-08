plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.maven.publish)
}
android {
    namespace = "com.termux.shared"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()

    defaultConfig {
        minSdk = (project.properties["minSdkVersion"] as String).toInt()

        externalNativeBuild {
            ndkBuild {
                //cppFlags = listOf("") // 如果 cppFlags 为空可以使用这个写法
            }
        }
    }

    dependencies {
        coreLibraryDesugaring(libs.desugar)

        implementation(libs.androidx.appcompat)
        implementation(libs.androidx.annotation)
        implementation(libs.androidx.core)
        implementation(libs.google.material)
        implementation(libs.google.guava)
        implementation(libs.markwon.core)
        implementation(libs.markwon.ext.strikethrough)
        implementation(libs.markwon.linkify)
        implementation(libs.markwon.recycler)
        implementation(libs.hiddenapibypass)

        // Do not increment version higher than 1.0.0-alpha09 since it will break ViewUtils and needs to be looked into
        // implementation(libs.androidx.window)
        implementation(project(":lib:androidx-window"))

        // Do not increment version higher than 2.5 or there will be runtime exceptions on android < 8
        implementation(libs.commons.io)

        implementation(project(":lib:termux:terminal-view"))

        implementation(libs.termux.am.library)
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    externalNativeBuild {
        ndkBuild {
            path = file("src/main/cpp/Android.mk")
        }
    }
}


dependencies {
    coreLibraryDesugaring(libs.desugar)

//    testImplementation(libs.junit)
//    androidTestImplementation(libs.androidx.junit)
//    androidTestImplementation(libs.androidx.espresso.core)
}
