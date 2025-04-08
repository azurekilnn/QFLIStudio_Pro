package com.qflistudio.azure.manager

import android.content.Context
import com.qflistudio.azure.util.PathUtils

class PathManager: BaseManager {
    private lateinit var currContext: Context

    override fun init() {
    }

    override fun init(context: Context) {
        currContext = context
    }

    fun getLuaApplicationDir(): String {
        return PathUtils.getLuaApplicationDir(currContext)
    }
}