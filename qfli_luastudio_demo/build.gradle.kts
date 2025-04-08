plugins {
    alias(libs.plugins.android.application)
}

android {
    namespace = "com.luastudio.demo"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()

    defaultConfig {
        applicationId = "com.luastudio.demo"
        minSdk = project.findProperty("lsMinSdkVersion")?.toString()?.toInt()
        targetSdk = project.findProperty("lsTargetSdkVersion")?.toString()?.toInt()
        versionCode = project.findProperty("aluaVersionCode")?.toString()?.toInt()
        versionName = project.findProperty("aluaVersionName")?.toString()
        // 设置支持的 ABI 类型
        ndk {
            abiFilters.addAll(arrayOf("armeabi-v7a", "arm64-v8a"))
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true // 启用代码压缩
            // 启用 Proguard 压缩代码
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

}

dependencies {
    coreLibraryDesugaring(libs.desugar)
    implementation(libs.androidx.appcompat)
    implementation(libs.google.material)
    implementation(libs.androidx.recyclerview)

    implementation(project(":androlua"))
    implementation(project(":editor"))
//
//    implementation(libs.bumptech.glide)
//    implementation(libs.squareup.okhttp)
}
