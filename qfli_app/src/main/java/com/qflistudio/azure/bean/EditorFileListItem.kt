package com.qflistudio.azure.bean

import android.graphics.Bitmap
import java.io.File

data class EditorFileListItem(
    val name: String,
    val file: File,
    val isDirectory: Boolean,
    val fileType: String,
    var fileSizeText: String,
    val isProjectsDir: Boolean = false,
    val iconBitmap: Bitmap? = null,
    val packageName: String = ""
)
