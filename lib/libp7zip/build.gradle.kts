plugins {
    alias(libs.plugins.android.library)
}

android {
    namespace = "com.hzy.libp7zip"
    compileSdk = (project.properties["compileSdkVersion"] as String).toInt()

    defaultConfig {
        minSdk = (project.properties["minSdkVersion"] as String).toInt()

        externalNativeBuild {
            cmake {
                arguments("-DANDROID_STL=c++_static", "-DANDROID_PLATFORM=android-18")
            }
        }
        ndk {
            abiFilters.addAll(arrayOf("armeabi-v7a", "arm64-v8a"))
        }
    }
    buildTypes {
        getByName("debug") {
            externalNativeBuild {
                cmake {
                    // log switch
                    cppFlags.add("-DNATIVE_LOG")
                }
            }
        }
    }
    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
        }
    }

    ndkVersion = "28.0.12433566 rc1"

    lint {
        abortOnError = false
    }
}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))
}