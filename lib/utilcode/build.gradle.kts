plugins {
    alias(libs.plugins.android.library)
}

android {
    namespace = "com.blankj.utilcode"

    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()

    defaultConfig {
        minSdk = (project.properties["minSdkVersion"] as String).toInt()
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
            //consumerProguardFiles = 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation(libs.google.gson)
    implementation(libs.androidx.appcompat)
    compileOnly(libs.google.material)
}

