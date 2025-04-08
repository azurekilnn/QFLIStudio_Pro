package com.qflistudio.azure.bean

// Lua程序项目
data class MyLuaAppItem(
    // 应用名称
    val appName: String,
    // 应用名称
    val appNameKey: String,
    // 应用路径
    val appHomeActivityPath: String,
    // 应用路径
    val appPath: String,
    // 应用介绍
    val appInfo: String,
    // 应用包名
    val packageName: String,
    // 应用版本
    val versionName: String,
    // 应用版本号
    val versionCode: Int,
    // 更新时间
    val updateTime: String,
    // 应用更新日志
    val updateLog: String,
    // 是否需要传参
    val needData: Boolean,
    // 应用开启状态
    val status: Boolean,
    // 调试模式
    val debugModeStatus: Boolean,
    // 是否支持小窗打开
    val supportOpenByWindow: Boolean,
    val appInitFilePath: String,
)