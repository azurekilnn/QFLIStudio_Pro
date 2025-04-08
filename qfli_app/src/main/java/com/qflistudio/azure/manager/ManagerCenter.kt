package com.qflistudio.azure.manager

import android.content.Context
import com.qflistudio.azure.common.ktx.isTablet

class ManagerCenter: BaseManager  {
    private lateinit var currEventManager: EventManager
    private lateinit var currThemeManager: ThemeManager
    private lateinit var currContext: Context

    override fun init() {

    }

    override fun init(context: Context) {
        currContext = context
    }

    fun isTablet() {
        currContext.isTablet()
    }

    fun setThemeManager(tm: ThemeManager) {
        currThemeManager = tm
    }

    fun getThemeManager(): ThemeManager {
        return currThemeManager
    }

    fun setEventManager(em: EventManager) {
        currEventManager = em
    }

    fun getEventManager(): EventManager {
        return currEventManager
    }

}