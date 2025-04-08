package com.qflistudio.azure.common.ktx

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.view.WindowMetrics
import androidx.core.net.toUri
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.qflistudio.azure.manager.SettingsManager
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.FileUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File

private val TAG = "AzureKiln"
private val azureUtils = AzureUtils()
private lateinit var settingsManager: SettingsManager

fun setGlobalSettingsManager(sm: SettingsManager) {
    settingsManager = sm
}

fun runAsync(block: suspend CoroutineScope.() -> Unit) {
    CoroutineScope(Dispatchers.Main).launch {
        block()
    }
}

fun CoroutineScope.runAsync(block: suspend CoroutineScope.() -> Unit) {
    this.launch {
        block()
    }
}

fun Context.contactQQ(qqNumber: String) {
    val url = "mqqwpa://im/chat?chat_type=wpa&uin=$qqNumber"
    this.startActivity(Intent(Intent.ACTION_VIEW, url.toUri()))
}

fun Context.skipToActivity(activityClass: Class<out Activity>) {
    val intent = Intent(this, activityClass)
    this.startActivity(intent)
}

fun String.searchKeyWord(keyWord: String): Boolean {
    if (keyWord != "") {
        var isIgnoreCase = false
        if (::settingsManager.isInitialized) {
            isIgnoreCase = settingsManager.getSetting("ignoreCaseWhenSearch") as Boolean
        }
        Log.i(TAG, "isIgnoreCase: $isIgnoreCase")
        return this.contains(keyWord, isIgnoreCase)
    } else {
        return true
    }
}

fun String.isLuaIDE(): Boolean {
    return (this == "lua" || this == "common_lua" || this == "lua_java")
}

fun File?.isLuaFile(): Boolean {
    if (this != null) {
        val extension = FileUtils().getFileExtension(this.absolutePath)
        val luaTypes = setOf("lua", "aly")
        if (extension != null) {
            return (extension in luaTypes)
        }
    }
    return false
}

/**
 * 扩展函数，判断字节是否是可打印字符
 */
fun Byte.isPrintable(): Boolean {
    val c = toChar()
    return c.isWhitespace() || c.isISOControl() || c.isLetterOrDigit() || c in listOf(
        '!',
        '\"',
        '#',
        '$',
        '%',
        '&',
        '\'',
        '(',
        ')',
        '*',
        '+',
        ',',
        '-',
        '.',
        '/',
        ':',
        ';',
        '<',
        '=',
        '>',
        '?',
        '@',
        '[',
        '\\',
        ']',
        '^',
        '_',
        '`',
        '{',
        '|',
        '}',
        '~'
    )
}


fun Context.isTablet(): Boolean {
    return (this.resources.configuration.screenLayout and
            Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE
}

fun Context.installApk(path: String) {
    azureUtils.installApk(this, path)
}

// 获取一行可操作项个数
fun Context.getProjOpItemsCount(): Int {
    return if (this.isTablet()) {
        8
    } else {
        4
    }
}

// 判断颜色是否为浅色（亮色）
fun Int.isColorLight(): Boolean {
    val red = Color.red(this)
    val green = Color.green(this)
    val blue = Color.blue(this)

    // 计算感知亮度（Luminance）
    val luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255
    return luminance > 0.5 // 亮度 > 0.5 认为是亮色
}

fun BottomSheetDialog.setFullScreenBottomSheetDlg() {
    this.setOnShowListener { dialog ->
        val bottomSheet = (dialog as BottomSheetDialog)
            .findViewById<View>(com.google.android.material.R.id.design_bottom_sheet)

        bottomSheet?.let { sheet ->
            val context = this.context
            val screenHeight = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val windowMetrics: WindowMetrics =
                    context.getSystemService(WindowManager::class.java).currentWindowMetrics
                windowMetrics.bounds.height()
            } else {
                val displayMetrics = context.resources.displayMetrics
                @Suppress("DEPRECATION")
                context.getSystemService(Context.WINDOW_SERVICE)
                    .let { it as WindowManager }
                    .defaultDisplay.getMetrics(displayMetrics)
                displayMetrics.heightPixels
            }

            // 设置 BottomSheetDialog 高度
            val layoutParams = sheet.layoutParams
            layoutParams.height = screenHeight
            sheet.layoutParams = layoutParams

            // 获取 BottomSheetBehavior 并设置为展开状态
            val bottomSheetBehavior = BottomSheetBehavior.from(sheet)
            bottomSheetBehavior.peekHeight = screenHeight
            bottomSheetBehavior.state = BottomSheetBehavior.STATE_EXPANDED
        }
    }
}