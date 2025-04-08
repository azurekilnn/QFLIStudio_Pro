package com.qflistudio.azure.util

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import com.luajava.LuaStateFactory
import com.qflistudio.azure.bean.MyLuaAppItem
import java.io.File

class LuaAppUtils {
    private val TAG = "ProjectUtils"
    fun loadAllLuaAppInfo(context: Context, luaAppDir: String): MutableList<MyLuaAppItem> {
        // 创建一个列表来存储 projectItem
        val appItemsList = mutableListOf<MyLuaAppItem>()
        return loadAllLuaAppInfo(context, luaAppDir, appItemsList)
    }


    fun loadAllLuaAppInfo(context: Context, luaAppDir: String, appItemsList: MutableList<MyLuaAppItem>): MutableList<MyLuaAppItem> {
        val luaUtils = LuaUtils()
        val luaState = LuaStateFactory.newLuaState()
        luaState.openLibs()

        // 获取项目列表并排序
        val appList = FileUtils().getFilesList(luaAppDir)

        appList.forEach {
            val appPath = it.path
            val appInitFilePath = "$appPath/init.lua"

            if (File(appPath).isDirectory) {
                if (File(appInitFilePath).exists()) {
                    val appInitInfo = luaUtils.readInitFile(appInitFilePath)
                    Log.i(TAG, appInitFilePath)
                    val activityPath =
                        (appPath + "/" + (appInitInfo?.get("tool_home_activity")?.toString() ?: ""))
                    val luaAppItem = MyLuaAppItem(
                        appInitInfo?.get("tool_name")?.toString() ?: "unknownTool",
                        appInitInfo?.get("tool_name_key")?.toString() ?: "unknown",
                        appInitInfo?.get("tool_home_activity")?.toString() ?: "",
                        activityPath,
                        appInitInfo?.get("tool_introduction")?.toString() ?: "unknown",
                        appInitInfo?.get("tool_packagename")?.toString() ?: "com.luastudio.unknown",
                        appInitInfo?.get("tool_version")?.toString() ?: "1.0",
                        appInitInfo?.get("tool_code")?.toString()?.toInt() ?: 1,
                        appInitInfo?.get("tool_update_time")?.toString() ?: "unknown",
                        appInitInfo?.get("tool_update_log")?.toString() ?: "unknown",
                        appInitInfo?.get("tool_need_data")?.toString()?.toBoolean() ?: false,
                        appInitInfo?.get("tool_status")?.toString()?.toBoolean() ?: true,
                        appInitInfo?.get("debugmode")?.toString()?.toBoolean() ?: false,
                        appInitInfo?.get("support_open_by_dialog")?.toString()?.toBoolean()
                            ?: false,
                        appInitFilePath,
                    )
                    // 将 ProjectItem 添加到列表中
                    appItemsList.add(luaAppItem)
                } else {
                    loadAllLuaAppInfo(context, appPath, appItemsList)
                }
            }
        }
        return appItemsList
    }

    fun getBitmapFromDrawable(context: Context, drawableId: Int): Bitmap {
        return BitmapFactory.decodeResource(context.resources, drawableId)
    }
}