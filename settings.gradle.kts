pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
        maven(url = "https://jitpack.io")
    }
}


dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        //jcenter()
        google()
        mavenCentral()
        maven(url = "https://jitpack.io")
        maven(url = "https://repo.eclipse.org/content/groups/releases/")
        maven(url = "https://maven.aliyun.com/nexus/content/groups/public/")
    }
}

rootProject.name = "qflistudio_pro"
include(":qfli_app", ":androlua")
include(":qfli_luastudio_pro")
include(":qfli_luastudio_demo")
include(":lib")
include(":editor")
include(":lib:androidsvg")
include(":lib:webdav")
include(":lib:libastyle")
include(":lib:sora-editor", ":lib:language-textmate")
include(":lib:libp7zip", ":lib:utilcode")
include(":lib:termux:terminal-emulator", "lib:termux:terminal-view", "lib:termux:termux-shared")
include(":lib:termux:terminal-app")
include(":lib:androidx-window")
