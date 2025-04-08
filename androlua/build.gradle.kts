plugins {
    alias(libs.plugins.android.library)
}

android {
    namespace = "com.androlua"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()

    defaultConfig {
        minSdk = (project.properties["minSdkVersion"] as String).toInt()
        consumerProguardFiles("consumer-rules.pro")
        ndk {
            abiFilters.addAll(arrayOf("armeabi-v7a", "arm64-v8a"))
        }
    }
    sourceSets {
        getByName("main").apply {
            jniLibs.srcDirs("src/main/jniLibs")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // 启用核心库降糖
        isCoreLibraryDesugaringEnabled = true
    }
}

dependencies {
    coreLibraryDesugaring(libs.desugar)
    api(files("libs/androlua_changed.jar"))
    //api(libs.tencent.tbssdk)
    //api("com.baidu.mobstat:mtj-sdk-circle:latest.integration")
    implementation(libs.androidx.appcompat)
    implementation(libs.google.material)
}