plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.jetbrains.kotlin.android)
    alias(libs.plugins.maven.publish)
}

android {
    namespace = "io.github.rosemoe.sora.langs.textmate"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()

    defaultConfig {
        minSdk = (project.properties["minSdkVersion"] as String).toInt()
        multiDexEnabled = true
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        consumerProguardFiles("consumer-rules.pro")
    }

    buildFeatures {
        buildConfig = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
    }
    val jvmTargetVersion = libs.versions.jvm.target.get()
    kotlinOptions {
        jvmTarget = jvmTargetVersion
    }
}

dependencies {
    coreLibraryDesugaring(libs.desugar)

    compileOnly(project(":lib:sora-editor"))
    implementation(libs.google.gson)

    implementation(libs.jcodings)
    implementation(libs.joni)

    implementation(libs.snakeyaml.engine)
    implementation(libs.jdt.annotation)

    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}
