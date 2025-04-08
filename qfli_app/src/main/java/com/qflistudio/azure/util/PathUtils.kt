package com.qflistudio.azure.util

import android.content.Context
import android.os.Environment
import java.io.File

object PathUtils {
    var internalStorage: String = Environment.getExternalStorageDirectory().absolutePath

    // 获取应用内部存储的文件路径
    fun getFilesDir(context: Context): String {
        return context.filesDir.absolutePath
    }

    // 获取应用的缓存目录路径
    fun getCacheDir(context: Context): String {
        return context.cacheDir.absolutePath
    }

    fun getAppDir(context: Context, key: String): String {
        return context.getDir(key, Context.MODE_PRIVATE).absolutePath
    }

    // 获取外部存储目录路径
    fun getExternalFilesDir(context: Context): String {
        return getExternalFilesDir(context, null)
    }

    fun getExternalFilesDir(context: Context, type: String?): String {
        return context.getExternalFilesDir(type)?.absolutePath ?: ""
    }

    fun getBackupDir(context: Context): String {
        return getExternalFilesDir(context, "backup")
    }

    fun getBackupSubDir(context: Context, type: String): String {
        val backupSubDir = getBackupDir(context) + "/backup_" + type
        val backupSubDirFile = File(backupSubDir)
        if (!backupSubDirFile.exists()) {
            backupSubDirFile.mkdirs()
        }
        return backupSubDir
    }

    fun getStudioExtDir(): String {
        return "$internalStorage/QFLIStudio_Pro"
    }

    fun getStudioExtDir(subDir: String): String {
        val path = "${getStudioExtDir()}/$subDir"
        val file = File(path)
        if (!file.exists()) {
            file.mkdirs()
        }
        return path
    }

    fun getStudioENVDir(): String {
        val studioExtDir = getStudioExtDir()
        return "$studioExtDir/Environment"
    }


    fun getStudioENVDir(dir: String): String {
        val studioEnvDir = getStudioENVDir()
        return "$studioEnvDir/$dir"
    }


    fun getLuaStudioExtDir(): String {
        val studioExtDir = getStudioExtDir()
        return "$studioExtDir/LuaStudio_Pro"
    }

    fun getLuaStudioExtDir(dir: String): String {
        val studioExtDir = getLuaStudioExtDir()
        val lsDir = "$studioExtDir/$dir"
        if (!File(lsDir).exists()) {
            File(lsDir).mkdirs()
        }
        return lsDir
    }

    fun getLuaCustomDir(dir: String): String {
        val envDir = getLuaStudioExtDir("luastudio_custom")
        val lsDir = "$envDir/$dir"
        if (!File(lsDir).exists()) {
            File(lsDir).mkdirs()
        }
        return lsDir
    }

    fun getLuaEnvDir(dir: String): String {
        val envDir = getLuaStudioExtDir(".environment")
        val lsDir = "$envDir/$dir"
        if (!File(lsDir).exists()) {
            File(lsDir).mkdirs()
        }
        return lsDir
    }

    fun getLuaProjectsDir(): String {
        val luaStudioExtDir = getLuaStudioExtDir()
        val luaProjectsDir = "$luaStudioExtDir/projects"
        if (!File(luaProjectsDir).exists()) {
            File(luaProjectsDir).mkdirs()
        }
        return luaProjectsDir
    }

    fun getProjectsDir(mode: String): String {
        if (mode == "lua") {
            return getLuaProjectsDir()
        } else {
            val studioExtDir = getStudioExtDir()
            val projectDir = "$studioExtDir/${mode}Projects"
            if (!File(projectDir).exists()) {
                File(projectDir).mkdirs()
            }
            return projectDir
        }
    }


    fun getProjectsDir(): String {
        val studioExtDir = getStudioExtDir()
        return "$studioExtDir/projects"
    }

    fun getLuaApplicationDir(context: Context): String {
        return getAppDir(context, "luastudio")
    }

    fun getLuaApplicationDir(context: Context, relativePath: String): String {
        return getLuaApplicationDir(context) + "/" + relativePath
    }


    fun getLuaActivityDir(context: Context): String {
        val luaApplicationDir = getLuaApplicationDir(context)
        return "$luaApplicationDir/activity"
    }

    fun outputMainDir(projectPath: String, lang: String): String {
        return if (lang == "lua") {
            "$projectPath/app/src/main/assets"
        } else {
            projectPath
        }
    }

    fun outputMainFilePath(projectPath: String, lang: String): String {
        val mainDir = outputMainDir(projectPath, lang)
        return if (lang == "python") {
            "$mainDir/main.py"
        } else {
            "$mainDir/main.$lang"
        }
    }


}