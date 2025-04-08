package com.qflistudio.azure.util

import FileCopyProgressCallback
import ProgressCallback
import ProjectItem
import ProjectProcessCallback
import TemplateManager
import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.androlua.LuaUtil
import com.luajava.LuaStateFactory
import com.qflistudio.azure.R
import com.qflistudio.azure.bean.EditorFileListItem
import com.qflistudio.azure.manager.CollectionManager
import com.qflistudio.azure.manager.LuaAppManager
import com.qflistudio.azure.viewmodel.MainViewModel
import java.io.File

class ProjectUtils {
    private val TAG = "ProjectUtils"
    private val unknownPackageName = "com.luastudio.unknown"

    private val luaProjectsDir = PathUtils.getLuaProjectsDir()
    private val pyProjectsDir = PathUtils.getProjectsDir("python")
    private val cProjectsDir = PathUtils.getProjectsDir("c")
    private val cppProjectsDir = PathUtils.getProjectsDir("cpp")
    private val projectsDir = PathUtils.getProjectsDir()
    val projectZipENames = mapOf(
        "common_lua" to "lsz",
        "lua_java" to "lsz",
        "lua" to "lsz",
        "java" to "qsjavaz",
        "python" to "qspyz",
        "c" to "qscz",
        "cpp" to "qscppz",
    )

    val zipENamesToProject = mapOf(
        "lsz" to "lua",
        "qsjavaz" to "java",
        "qspyz" to "python",
        "qscz" to "c",
        "qscppz" to "cpp",
    )

    private fun isLuaProject(projectType: String): Boolean {
        return (projectType == "common_lua" || projectType == "lua_java" || projectType == "lua")
    }

    fun getDefaultProjectIcon(context: Context): Bitmap {
        val iconBitmap = DrawableUtils().getBitmapFromDrawable(context, R.drawable.icon)
        return iconBitmap
    }

    fun createProjectItem(
        context: Context,
        projectName: String,
        projectPath: String,
        editorMode: String
    ): ProjectItem {
        return ProjectItem(
            getDefaultProjectIcon(context),
            projectName,
            projectName,
            projectPath,
            true,
            false,
            editorMode,
            editorMode
        )
    }

    // 加载单个本地工程信息
    fun loadLuaProjectInfo(context: Context, projectPath: String): ProjectItem {
        val iconBitmap = getDefaultProjectIcon(context)
        if (File(projectPath).isDirectory && File("$projectPath/build.lsinfo").exists()) {
            val buildInfo = LuaUtils().loadBuildInfo(projectPath)
            return ProjectItem(
                iconBitmap,
                buildInfo?.get("appname")?.toString() ?: "unknown",
                buildInfo?.get("packagename")?.toString() ?: unknownPackageName,
                projectPath,
                true,
                getLPCollectedStatus(context, projectPath),
                buildInfo?.get("template")?.toString() ?: "common_lua",
                "lua"
            )
        } else {
            return ProjectItem(
                iconBitmap,
                "unknown",
                unknownPackageName,
                projectPath,
                false,
                getLPCollectedStatus(context, projectPath),
                "unknown",
                "lua"
            )
        }
    }

    fun loadProjectInfo(context: Context, projectPath: String, projectType: String): ProjectItem {
        val iconBitmap =
            DrawableUtils().getBitmapFromDrawable(context, R.drawable.twotone_folder_black_24)
        val file = File(projectPath)
        return ProjectItem(
            iconBitmap,
            file.name,
            file.absolutePath,
            file.absolutePath,
            true,
            getLPCollectedStatus(context, projectPath),
            projectType,
            projectType
        )
    }

    fun loadLocalProjectInfoAsFileItem(context: Context, projectPath: String): EditorFileListItem {
        val iconBitmap = DrawableUtils().getBitmapFromDrawable(context, R.drawable.icon)
        val projectDirFile = File(projectPath)
        if (projectDirFile.isDirectory && File("$projectPath/build.lsinfo").exists()) {
            val buildInfo = LuaUtils().loadBuildInfo(projectPath)

            return EditorFileListItem(
                buildInfo?.get("appname")?.toString() ?: "unknown",
                projectDirFile,
                projectDirFile.isDirectory,
                "folder",
                "folder",
                true,
                iconBitmap,
                buildInfo?.get("packagename")?.toString() ?: unknownPackageName,
            )
        } else {
            return EditorFileListItem(
                "unknown",
                projectDirFile,
                projectDirFile.isDirectory,
                "folder",
                "folder",
                true,
                iconBitmap,
                unknownPackageName,
            )
        }
    }

    // 加载所有工程信息
    fun loadAllLocalProjectsInfo(
        context: Context,
        dir: String,
        projectType: String
    ): MutableList<ProjectItem> {
        if (isLuaProject(projectType)) {
            val luaState = LuaStateFactory.newLuaState()
            luaState.openLibs()
        }

        if (File(dir).exists()) {
            val fileUtils = FileUtils()
            val projList = fileUtils.getFilesList(dir)
            val projectItemsList = mutableListOf<ProjectItem>()

            projList.forEach {
                // 将 ProjectItem 添加到列表中
                if (it.isDirectory) {
                    if (isLuaProject(projectType)) {
                        val projectItem = loadLuaProjectInfo(context, it.path)
                        projectItemsList.add(projectItem)
                    } else {
                        val projectItem = loadProjectInfo(context, it.path, projectType)
                        projectItemsList.add(projectItem)
                    }
                }
            }
            return projectItemsList
        }
        return mutableListOf()
    }

    fun loadAllLocalProjectsInfo(context: Context, projectType: String): MutableList<ProjectItem> {
        val projectDir: String
        if (isLuaProject(projectType)) {
            projectDir = luaProjectsDir
        } else {
            projectDir = PathUtils.getProjectsDir(projectType)
        }
        return loadAllLocalProjectsInfo(context, projectDir, projectType)
    }

    fun reloadLocalProjectsList(context: Context, viewModel: MainViewModel, projectType: String) {
        val projectItemsList = loadAllLocalProjectsInfo(context, projectType)
        if (isLuaProject(projectType)) {
            viewModel.setLuaProjectItems(projectItemsList)
        } else if (projectType == "python") {
            viewModel.setPyProjectItems(projectItemsList)
        } else if (projectType == "c") {
            viewModel.setCProjectItems(projectItemsList)
        } else if (projectType == "cpp") {
            viewModel.setCppProjectItems(projectItemsList)
        } else if (projectType == "java") {
            viewModel.setJavaProjectItems(projectItemsList)
        } else {
            viewModel.setProjectItems(projectItemsList)
        }
    }

    fun reloadLocalProjectsList(
        context: Context,
        viewModel: MainViewModel,
        swipeRefreshLayout: SwipeRefreshLayout,
        projectType: String
    ) {
        reloadLocalProjectsList(context, viewModel, projectType)
        swipeRefreshLayout.isRefreshing = false
    }



    fun getLuaProjectsInfoAsFileItem(context: Context): MutableList<EditorFileListItem> {
        val luaState = LuaStateFactory.newLuaState()
        luaState.openLibs()

        if (File(luaProjectsDir).exists()) {
            val fileUtils = FileUtils()
            // 获取项目列表并排序
            val projList = fileUtils.getFilesList(luaProjectsDir)
            // 创建一个列表来存储 projectItem
            val projectItemsList = mutableListOf<EditorFileListItem>()

            projList.forEach {
                // 将 ProjectItem 添加到列表中
                if (it.isDirectory) {
                    val projectItem = loadLocalProjectInfoAsFileItem(context, it.path)
                    projectItemsList.add(projectItem)
                }
            }
            return projectItemsList
        }
        return mutableListOf()
    }


    // 工程收藏
    private fun getLPCollectedStatus(context: Context, projectPath: String): Boolean {
        return checkLocalProjectCollectedStatus(context, projectPath)
    }

    fun checkLocalProjectCollectedStatus(context: Context, projectPath: String): Boolean {
        val collectionManager = CollectionManager(context)
        return collectionManager.isValueInArray(projectPath)
    }

    fun collectLocalProject(context: Context, projectPath: String): Boolean {
        val collectionManager = CollectionManager(context)
        return collectionManager.addAndSaveNewCollection(projectPath)
    }

    fun cancelCollectLocalProject(context: Context, projectPath: String): Boolean {
        val collectionManager = CollectionManager(context)
        return collectionManager.removeAndSaveCollection(projectPath)
    }


    fun getProjectAppAssetsDir(newAppDir: String): String {
        val newAppAssetsDir = "$newAppDir/app/src/main/assets"
        return newAppAssetsDir
    }

    fun createLocalProject(
        context: Context,
        appName: String,
        appPackageName: String,
        projectType: String
    ): Boolean {
        val newProjectDir: String
        if (projectType == "common_lua" || projectType == "lua_java") {
            newProjectDir = luaProjectsDir
        } else {
            newProjectDir = PathUtils.getProjectsDir(projectType)
        }

        val templateManager = TemplateManager()
        val newAppDir = "$newProjectDir/$appName"
        val newInfoDir = "%$newAppDir/.qfli"

        if (File(newAppDir).exists()) {
            return false
        }
        File(newAppDir).mkdirs()
        File(newInfoDir).mkdirs()
        val mainDefaultContent = templateManager.getMainTemplate(projectType)

        if (projectType == "common_lua" || projectType == "lua_java") {
            val newAppAssetsDir = getProjectAppAssetsDir(newAppDir)
            val luaStudioDir =
                context.getDir("luastudio", Context.MODE_PRIVATE).getAbsolutePath()
            val mixProjectRes = "$luaStudioDir/Template_LuaJavaMix.zip"
            Log.i(TAG, "createLocalProject: $appName $appPackageName $projectType $newAppAssetsDir")
            File(newAppAssetsDir).mkdirs()
            val buildContent =
                templateManager.getBuildLsInfoTemplate(appName, appPackageName, projectType)
            val initContent = templateManager.getInitLuaTemplate(appName)
            val mainContent = templateManager.getMainContentTemplate(appName)
            val alyContent = templateManager.getAlyTemplate(appName)

            // 写入 build.lsinfo 文件
            File("$newAppDir/build.lsinfo").writeText(buildContent)
            // 写入 init.lua 文件
            File("$newAppAssetsDir/init.lua").writeText(initContent)
            // 写入 main.lua 文件
            File("$newAppAssetsDir/main.lua").writeText(mainContent)
            // 写入 layout.aly 文件
            File("$newAppAssetsDir/layout.aly").writeText(alyContent)

            if (projectType == "lua_java") {
                val stringsContent = templateManager.getStringsTemplate(appName)
                val mainjavaSubpath = appPackageName.replace(".", "/")
                val mainActivityJavaContent = templateManager.getMainJavaTemplate(appPackageName)
                val androidManifest = templateManager.getAndroidManifestTemplate(appPackageName)
                LuaUtil.unZip(mixProjectRes, newAppDir)
                File("$newAppDir/app/src/main/").mkdirs()
                File("$newAppDir/app/src/main/res/values/").mkdirs()
                File("$newAppDir/app/src/main/java/$mainjavaSubpath/").mkdirs()
                File("$newAppDir/app/src/main/res/values/strings.xml").writeText(stringsContent)
                File("$newAppDir/app/src/main/AndroidManifest.xml").writeText(androidManifest)
                File("$newAppDir/app/src/main/java/$mainjavaSubpath/MainActivity.java").writeText(
                    mainActivityJavaContent
                )
            }
        } else if (projectType == "python") {
            File("$newAppDir/main.py").writeText(mainDefaultContent)
        } else if (projectType == "java") {
            File("$newAppDir/Main.java").writeText(mainDefaultContent)
        } else {
            File("$newAppDir/main.${projectType}").writeText(mainDefaultContent)
        }
        return true
    }

    // 备份工程
    fun backupProject(
        context: Context,
        projectPath: String,
        projectType: String,
        backupDir: String,
        callback: ProjectProcessCallback
    ) {


        val projectDir = projectPath
        val projectFile = File(projectDir)
        val projectDirName = projectFile.name

        val backupTime = System.currentTimeMillis().toString()
        val backupFileExtensionName = projectZipENames[projectType] ?: "qsz"
        val backupFileName = "${projectDirName}_${backupTime}.${backupFileExtensionName}"
        val backupPath = "$backupDir/$backupFileName"

        FileUtils().zipFolderWithProgress(
            context,
            projectFile,
            File(backupPath),
            object : ProgressCallback {
                override fun onProgressUpdate(
                    progress: Int,
                    fileName: String,
                    speed: String,
                    sourceFolder: String,
                    destinationFolder: String
                ) {

                }

                override fun onComplete() {
                    callback.onComplete(backupPath)
                }

                override fun onError(exception: Exception) {
                    callback.onError(exception)
                }
            })
    }

    fun backupProject(
        context: Context,
        projectItem: ProjectItem,
        callback: ProjectProcessCallback
    ) {
        val backupDir = PathUtils.getStudioExtDir("backup/projectBackup")
        backupProject(
            context,
            projectItem.projectPath,
            projectItem.projectType,
            backupDir,
            callback
        )
    }

    fun backupProject(
        context: Context,
        projectPath: String,
        projectType: String,
        callback: ProjectProcessCallback
    ) {
        val backupDir = PathUtils.getStudioExtDir("backup/projectBackup")
        backupProject(context, projectPath, projectType, backupDir, callback)
    }

    fun shareProject(
        context: Context,
        projectPath: String,
        projectType: String,
        callback: ProjectProcessCallback
    ) {
        val backupDir = PathUtils.getStudioExtDir("cache/share_cache")
        backupProject(
            context,
            projectPath,
            projectType,
            backupDir,
            object : ProjectProcessCallback {
                override fun onComplete(result: String) {
                   FileUtils().shareFile(context, File(result))
                    callback.onComplete(result)
                }

                override fun onError(exception: Exception) {
                    callback.onError(exception)
                }
            })
    }

    fun shareProject(
        context: Context,
        projectItem: ProjectItem,
        callback: ProjectProcessCallback
    ) {
        shareProject(context, projectItem.projectPath, projectItem.projectType, callback)
    }

    fun deleteProject(
        context: Context,
        projectPath: String,
        projectType: String,
        isBackup: Boolean,
        callback: ProjectProcessCallback
    ) {
        if (isBackup) {
            val backupDir = PathUtils.getBackupSubDir(context, "bin/projects_bin")
            backupProject(
                context,
                projectPath,
                projectType,
                backupDir,
                object : ProjectProcessCallback {
                    override fun onComplete(result: String) {
                        LuaUtil.rmDir(File(projectPath))
                        callback.onComplete(result)
                    }

                    override fun onError(exception: Exception) {
                        callback.onError(exception)
                    }
                }
            )
        } else {
            LuaUtil.rmDir(File(projectPath))
            callback.onComplete("succeed")
        }

    }

    fun deleteProject(context: Context, projectPath: String, projectType: String, callback: ProjectProcessCallback) {
    }

    fun deleteProject(
        context: Context,
        projectItem: ProjectItem,
        isBackup: Boolean,
        callback: ProjectProcessCallback
    ) {
        deleteProject(context, projectItem.projectPath, projectItem.projectType, isBackup, callback)
    }

    // 默认不备份
    fun deleteProject(
        context: Context,
        projectItem: ProjectItem,
        callback: ProjectProcessCallback
    ) {
        deleteProject(context, projectItem.projectPath, projectItem.projectType, true, callback)
    }


    fun renameProject(
        context: Context,
        projectPath: String,
        projectType: String,
        callback: ProjectProcessCallback
    ) {

    }

    // 克隆本地工程
    fun cloneProject(
        context: Context,
        projectItem: ProjectItem,
        callback: ProjectProcessCallback
    ) {
        val originalProjectDir = projectItem.projectPath
        var suffix = "_clone"
        var newProjectDir = "${projectItem.projectPath}${suffix}"
        val currentTimeMillis = System.currentTimeMillis()

        val originalProjectDirFile = File(originalProjectDir)
        var newProjectDirFile = File(newProjectDir)
        if (originalProjectDirFile.exists()) {
            if (originalProjectDirFile.exists() && newProjectDirFile.exists()) {
                suffix = "_${currentTimeMillis}"
                newProjectDir = "${newProjectDir}${suffix}"
                newProjectDirFile = File(newProjectDir)
            }

            FileUtils().copyFolderWithProgress(
                context,
                originalProjectDirFile,
                newProjectDirFile,
                object : FileCopyProgressCallback {
                    override fun onProgressUpdate(
                        progress: Int,
                        fileName: String,
                        speed: String,
                        sourceFolder: String,
                        destinationFolder: String
                    ) {
                        Log.d(
                            "CopyProgress",
                            "Progress: $progress%, File: $fileName, Speed: $speed"
                        )
                    }

                    override fun onComplete() {
                        Log.d("CopyProgress", "Copy complete!")

                        if (isLuaProject(projectItem.projectType)) {


                            val originalProjectInfo =
                                LuaUtils().loadBuildInfo(originalProjectDir) // Map
                            val originalAppName = originalProjectInfo?.get("appname")?.toString()
                                ?: originalProjectDirFile.name
                            val templateManager = TemplateManager()

                            val initContent = templateManager.getInitLuaTemplate(originalAppName)

                            val newAppAssetsDir = getProjectAppAssetsDir(newProjectDir)

                            // 写入 build.lsinfo 文件
                            val projectBuildFile = File("$newProjectDir/build.lsinfo")
                            // File("$newProjectDir/build.lsinfo").writeText(buildContent)
                            FileUtils().replaceTextInFile(
                                projectBuildFile,
                                originalAppName,
                                "${originalAppName}${suffix}"
                            )

                            // 写入 init.lua 文件
                            File("$newAppAssetsDir/init.lua").writeText(initContent)
                        }

                        callback.onComplete(newProjectDirFile.path)
                    }

                    override fun onError(exception: Exception) {
                        callback.onError(exception)
                        Log.e("CopyProgress", "Error occurred: ${exception.message}")
                    }
                })
        } else {
            callback.onError(Exception("originalProject folder does not exist"))
        }
    }

    // 工程属性编辑
    fun editLuaProjectInfo(luaAppManager: LuaAppManager, projectItem: ProjectItem) {
        val projectPath = projectItem.projectPath
        val args = arrayOf<Any>(projectPath)
        luaAppManager.skipToActivity("project_info", args)
    }


}