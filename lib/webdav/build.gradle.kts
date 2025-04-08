plugins {
    alias(libs.plugins.android.library)
}

android {
    namespace = "com.qflistudio.webdav"

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
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))
    implementation(libs.google.gson)
    implementation(libs.androidx.appcompat)
    implementation(libs.squareup.okhttp)
    compileOnly(libs.google.material)
}