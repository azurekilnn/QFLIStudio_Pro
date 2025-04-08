package com.qflistudio.azure.manager

import com.qflistudio.azure.util.PathUtils
import android.content.Context
import android.util.Log
import com.qflistudio.azure.bean.MyLuaAppItem
import com.qflistudio.azure.common.ktx.runAsync
import com.qflistudio.azure.util.LuaAppUtils
import com.qflistudio.azure.util.LuaUtils
import java.io.File

class LuaAppManager private constructor() {
    private val TAG = "LuaAppManager"
    private var luaAppItemsMap = mutableMapOf<String, MyLuaAppItem>()
    private var luaAppItemsList = mutableListOf<MyLuaAppItem>()
    private lateinit var context: Context

    fun init(initContext: Context) {
        context = initContext
        runAsync { initAllList() }
    }

    fun initAllList() {
        val luaAppDir = PathUtils.getLuaActivityDir(context)
        luaAppItemsList = LuaAppUtils().loadAllLuaAppInfo(context, luaAppDir)
        luaAppItemsMap = list2Map(luaAppItemsList)
    }

    private fun list2Map(list: MutableList<MyLuaAppItem>): MutableMap<String, MyLuaAppItem> {
        val newMap = mutableMapOf<String, MyLuaAppItem>()
        list.forEach { luaAppItem ->
            newMap[luaAppItem.appNameKey] = luaAppItem
        }
        return newMap
    }

    fun skipToActivity(appItem: MyLuaAppItem, args: Array<Any>) {
        Log.i(TAG, appItem.toString())
        if (File(appItem.appPath).exists()) {
            val intent = LuaUtils().newLSActivityIntent(context, appItem.appPath, args, false)
            context.startActivity(intent)
        }
    }

    fun skipToActivity(appItem: MyLuaAppItem) {
        val args = arrayOf<Any>()
        skipToActivity(appItem, args)
    }

    fun skipToActivity(appNameKey: String, args: Array<Any>) {
        if (checkAppExists(appNameKey)) {
            luaAppItemsMap[appNameKey]?.let { skipToActivity(it, args) }
        }
    }

    fun skipToActivity(appNameKey: String) {
        if (checkAppExists(appNameKey)) {
            Log.i(TAG, appNameKey)
            luaAppItemsMap[appNameKey]?.let { skipToActivity(it) }
        }
    }

    fun checkAppExists(appNameKey: String): Boolean {
        return luaAppItemsMap[appNameKey] != null
    }

    fun getLuaAppItemsMap(): MutableMap<String, MyLuaAppItem> = luaAppItemsMap
    fun getLuaAppItemsList(): MutableList<MyLuaAppItem> = luaAppItemsList

    companion object {
        private val instance: LuaAppManager by lazy { LuaAppManager() }
        fun getLAManagerInstance(): LuaAppManager = instance
    }
}