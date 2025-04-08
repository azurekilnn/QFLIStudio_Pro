package com.qflistudio.azure.common

import android.os.Environment
import com.qflistudio.azure.common.datastore.PreferenceType

object SettingsData {

    // 创建一个包含数据类型和默认值的 Map
    private val settingsData = mapOf(
        // 侧滑手势锁定
        "systemTheme" to Pair(PreferenceType.STRING, "Theme_LuaStudio"),
        "drawerLockStatus" to Pair(PreferenceType.BOOLEAN, false),
        "drawerTitle" to Pair(PreferenceType.STRING, "Test"),
    )

    // 定义一个 operator 函数，使得可以通过索引访问数据
    operator fun get(key: String): Pair<PreferenceType, Any>? {
        return settingsData[key]
    }


}