// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.jetbrains.kotlin.android) apply false
    alias(libs.plugins.maven.publish) apply false
    alias(libs.plugins.android.library) apply false
    alias(libs.plugins.jetbrains.kotlin.plugin.compose) apply false
    // Compose
    // alias(libs.plugins.jetbrains.kotlin.plugin.compose) apply false
}

subprojects {
    afterEvaluate {
        // Force all modules to use the same Kotlin version to avoid conflicts
        configurations.all {
            resolutionStrategy {
                force("org.jetbrains.kotlin:kotlin-stdlib:${libs.versions.kotlin.get()}")
                force("org.jetbrains.kotlin:kotlin-stdlib-jdk8:${libs.versions.kotlin.get()}")
                force("org.jetbrains.kotlin:kotlin-stdlib-jdk7:${libs.versions.kotlin.get()}")
            }
        }
        extensions.findByType(com.android.build.gradle.BaseExtension::class)?.apply {
            buildTypes {
                getByName("release") {
                    isMinifyEnabled = false
                    proguardFiles(
                        getDefaultProguardFile("proguard-android-optimize.txt"),
                        "proguard-rules.pro"
                    )
                }
            }
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
            val jvmTargetVersion = libs.versions.jvm.target.get()
            extensions.findByType(org.jetbrains.kotlin.gradle.dsl.KotlinJvmOptions::class)?.apply {
                jvmTarget = jvmTargetVersion
            }

            // Compose
            // 在此处配置 Compose 编译器版本
            // composeOptions {
            //     kotlinCompilerExtensionVersion = libs.versions.compose.get() // 从 libs.versions.toml 获取 Compose 版本
            // }

        }
    }
}

