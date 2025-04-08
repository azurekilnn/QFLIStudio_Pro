plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.jetbrains.kotlin.android)
    // Compose
    // alias(libs.plugins.jetbrains.kotlin.plugin.compose)
    // kotlin("kapt")
}

android {
    namespace = "com.qflistudio.azure"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()

    defaultConfig {
        applicationId = "com.qflistudio.azure"
        minSdk = project.findProperty("MIN_SDK_VERSION")?.toString()?.toInt()
        targetSdk = project.findProperty("TARGET_SDK_VERSION")?.toString()?.toInt()
        versionCode = project.findProperty("VERSION_CODE")?.toString()?.toInt()
        versionName = project.findProperty("VERSION_NAME")?.toString()
        multiDexEnabled = true

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        // 支持的 ABI 类型
        ndk {
            abiFilters.addAll(arrayOf("armeabi-v7a", "arm64-v8a"))
        }
    }

    packaging {
        resources.excludes.add("META-INF/androidx.window_window.version")
    }

    signingConfigs {
        getByName("debug") {
            storeFile = file("keystore/azure.keystore")
            storePassword = "Azure.LCY"
            keyAlias = "Azure"
            keyPassword = "Azure.LCY"
        }
        create("release") {
            storeFile = file("keystore/azure.keystore")
            storePassword = "Azure.LCY"
            keyAlias = "Azure"
            keyPassword = "Azure.LCY"
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false // 启用代码压缩
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
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
    kotlinOptions {
        jvmTarget = "17"
    }

    // Compose
    // composeOptions {
    //     kotlinCompilerExtensionVersion = libs.versions.compose.get() // 使用从 libs.versions.toml 中获取的版本
    // }
    buildFeatures {
        compose = false
        viewBinding = true
    }

}

dependencies {
    coreLibraryDesugaring(libs.desugar)
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.androidx.browser)
    implementation(libs.androidx.constraintlayout)
    implementation(libs.androidx.navigation.fragment.ktx)
    implementation(libs.androidx.navigation.ui.ktx)
    implementation(libs.androidx.swiperefreshlayout)

    implementation(libs.google.material)

    implementation(libs.androidx.datastore.preferences)
    implementation(libs.androidx.datastore.preferences.core)
    // Compose
    // kapt(libs.androidx.compose.compiler)
    // implementation(platform(libs.androidx.compose.bom))
    // implementation(libs.androidx.activity.compose)
    // implementation(libs.androidx.compose.ui)
    // implementation(libs.androidx.compose.material)
    // implementation(libs.androidx.compose.tooling)
    // implementation(libs.androidx.ui)
    // implementation(libs.androidx.runtime.livedata)
    // implementation(libs.androidx.ui.graphics)
    // implementation(libs.androidx.ui.tooling.preview)
    // implementation(libs.androidx.foundation)
    // implementation(libs.androidx.material3)

    implementation(libs.commons.compress)
    implementation(project(":androlua"))
    implementation(libs.xz)
    //Sora-Editor
    // implementation(platform("io.github.Rosemoe.sora-editor:bom:0.21.1"))
    // implementation("io.github.Rosemoe.sora-editor:language-textmate")
    // implementation(project(":lib:language-textmate"))
    // implementation(libs.sora.editor.language.textmate)
    implementation(project(":editor"))
    implementation(project(":lib:androidsvg"))
    implementation(project(":lib:webdav"))

    implementation(libs.markwon.core)
    implementation(libs.markwon.editor)
    implementation(libs.markwon.image)
    implementation(libs.markwon.image.glide)
    implementation(libs.bumptech.glide)
    implementation(libs.squareup.okhttp)

    implementation(libs.google.gson)

    // lib AndroidUtilCode by BlankJ
    // implementation(libs.utilcodex)
    implementation(project(":lib:utilcode"))

    // lib terminal-view and terminal-editor by Termux
    // implementation(libs.terminal.view)
    // implementation(libs.terminal.emulator)
    implementation(project(":lib:termux:terminal-emulator"))
    implementation(project(":lib:termux:terminal-view"))
    implementation(project(":lib:termux:terminal-app"))
    implementation(project(":lib:termux:termux-shared"))

    // lib : p7zip by Hzy3774
    implementation(project(":lib:libp7zip"))

    implementation(libs.androidx.multidex)

    // implementation "com.baidu.mobstat:mtj-sdk-circle:latest.integration"

    // Tencent TBS
    // implementation 'com.tencent.tbs:tbssdk:44286'

    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}