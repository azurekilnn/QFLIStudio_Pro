plugins {
    alias(libs.plugins.android.library)
}

android {
    namespace = "com.caverock.androidsvg"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()

    defaultConfig {
        minSdk = (project.properties["minSdkVersion"] as String).toInt()
        // testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
   }
   buildTypes {
    getByName("release") {
        isMinifyEnabled = false
        proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
    }
}
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

    dependencies {
    testImplementation(libs.junit)
    testImplementation(libs.tests.robolectric)
    }
//    testOptions {
//        unitTests.isIncludeAndroidResources = true
//    }
}


dependencies {
    //androidTestImplementation(libs.junit)
}