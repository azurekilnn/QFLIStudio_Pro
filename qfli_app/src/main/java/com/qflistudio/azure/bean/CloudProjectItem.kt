package com.qflistudio.azure.bean

import android.graphics.Bitmap

data class CloudProjectItem(
    var iconBitmap: Bitmap,
    var appName: String,
    var packageName: String,
    var projectPath: String,
    var projectStatus: Boolean,
    var projectCollectedStatus: Boolean,
    var projectType: String,
    var editorMode: String
)