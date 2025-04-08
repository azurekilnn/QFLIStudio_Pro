package com.qflistudio.azure.manager

import android.annotation.SuppressLint
import android.content.Context
import android.content.SharedPreferences
import android.content.res.ColorStateList
import android.graphics.Color
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.withStyledAttributes
import com.qflistudio.azure.R
import kotlin.properties.Delegates

class ThemeManager {
    private val TAG = "ThemeManager"
    var themeColors by Delegates.notNull<ThemeColors>()

    val defaultThemeResId = R.style.Theme_LuaStudio_NoActionBar

    lateinit var sharedPreferences: SharedPreferences

    // 存储主题名称和对应的 style ID 的 Map
    private val themeMap = mapOf(
        // Regular themes
        "Theme_LuaStudio" to R.style.Theme_LuaStudio,
        "Theme_LuaStudio.Red" to R.style.Theme_LuaStudio_Red,
        "Theme_LuaStudio.Pink" to R.style.Theme_LuaStudio_Pink,
        "Theme_LuaStudio.Purple" to R.style.Theme_LuaStudio_Purple,
        "Theme_LuaStudio.Indigo" to R.style.Theme_LuaStudio_Indigo,
        "Theme_LuaStudio.LightBlue" to R.style.Theme_LuaStudio_LightBlue,
        "Theme_LuaStudio.Cyan" to R.style.Theme_LuaStudio_Cyan,
        "Theme_LuaStudio.Teal" to R.style.Theme_LuaStudio_Teal,
        "Theme_LuaStudio.Green" to R.style.Theme_LuaStudio_Green,
        "Theme_LuaStudio.LightGreen" to R.style.Theme_LuaStudio_LightGreen,
        "Theme_LuaStudio.Lime" to R.style.Theme_LuaStudio_Lime,
        "Theme_LuaStudio.Yellow" to R.style.Theme_LuaStudio_Yellow,
        "Theme_LuaStudio.Amber" to R.style.Theme_LuaStudio_Amber,
        "Theme_LuaStudio.Orange" to R.style.Theme_LuaStudio_Orange,
        "Theme_LuaStudio.DeepOrange" to R.style.Theme_LuaStudio_DeepOrange,
        "Theme_LuaStudio.Brown" to R.style.Theme_LuaStudio_Brown,
        "Theme_LuaStudio.Grey" to R.style.Theme_LuaStudio_Grey,
        "Theme_LuaStudio.BlueGrey" to R.style.Theme_LuaStudio_BlueGrey,
        "Theme_LuaStudio.White" to R.style.Theme_LuaStudio_White,

        // No Action Bar themes
        "Theme_LuaStudio.NoActionBar" to R.style.Theme_LuaStudio_NoActionBar,
        "Theme_LuaStudio.Red.NoActionBar" to R.style.Theme_LuaStudio_Red_NoActionBar,
        "Theme_LuaStudio.Pink.NoActionBar" to R.style.Theme_LuaStudio_Pink_NoActionBar,
        "Theme_LuaStudio.Purple.NoActionBar" to R.style.Theme_LuaStudio_Purple_NoActionBar,
        "Theme_LuaStudio.Indigo.NoActionBar" to R.style.Theme_LuaStudio_Indigo_NoActionBar,
        "Theme_LuaStudio.LightBlue.NoActionBar" to R.style.Theme_LuaStudio_LightBlue_NoActionBar,
        "Theme_LuaStudio.Cyan.NoActionBar" to R.style.Theme_LuaStudio_Cyan_NoActionBar,
        "Theme_LuaStudio.Teal.NoActionBar" to R.style.Theme_LuaStudio_Teal_NoActionBar,
        "Theme_LuaStudio.Green.NoActionBar" to R.style.Theme_LuaStudio_Green_NoActionBar,
        "Theme_LuaStudio.LightGreen.NoActionBar" to R.style.Theme_LuaStudio_LightGreen_NoActionBar,
        "Theme_LuaStudio.Lime.NoActionBar" to R.style.Theme_LuaStudio_Lime_NoActionBar,
        "Theme_LuaStudio.Yellow.NoActionBar" to R.style.Theme_LuaStudio_Yellow_NoActionBar,
        "Theme_LuaStudio.Amber.NoActionBar" to R.style.Theme_LuaStudio_Amber_NoActionBar,
        "Theme_LuaStudio.Orange.NoActionBar" to R.style.Theme_LuaStudio_Orange_NoActionBar,
        "Theme_LuaStudio.DeepOrange.NoActionBar" to R.style.Theme_LuaStudio_DeepOrange_NoActionBar,
        "Theme_LuaStudio.Brown.NoActionBar" to R.style.Theme_LuaStudio_Brown_NoActionBar,
        "Theme_LuaStudio.Grey.NoActionBar" to R.style.Theme_LuaStudio_Grey_NoActionBar,
        "Theme_LuaStudio.BlueGrey.NoActionBar" to R.style.Theme_LuaStudio_BlueGrey_NoActionBar,
        "Theme_LuaStudio.White.NoActionBar" to R.style.Theme_LuaStudio_White_NoActionBar
    )

    fun init(context: AppCompatActivity) {
        // 获取 SharedPreferences 实例
        sharedPreferences = context.getSharedPreferences("appSettings", Context.MODE_PRIVATE)
        // 主题配色
        val themeName = sharedPreferences.getString("themeName", "Theme_LuaStudio")
        Log.i(TAG, themeName.toString())
        apply(context, themeName.toString())
    }


    fun init(context: AppCompatActivity, useActionBar: Boolean) {
        // 获取 SharedPreferences 实例
        sharedPreferences = context.getSharedPreferences("appSettings", Context.MODE_PRIVATE)
        // 主题配色
        val themeName = sharedPreferences.getString("themeName", "Theme_LuaStudio")
        Log.i(TAG, themeName.toString())
        apply(context, themeName.toString(), useActionBar)
    }

    // 应用主题
    fun apply(context: AppCompatActivity, themeName: String) {
        apply(context, themeName, false)
    }

    fun apply(context: AppCompatActivity, themeName: String, useActionBar: Boolean) {
        var realThemeName: String = themeName
        if (!useActionBar) {
            realThemeName = "${themeName}.NoActionBar"
        }
        val themeResId = themeMap[realThemeName] ?: defaultThemeResId

        context.setTheme(themeResId)
        themeColors = ThemeColors(context)
    }

    fun apply(context: AppCompatActivity, noActionBarMode: Boolean) {
        context.setTheme(defaultThemeResId)
        themeColors = ThemeColors(context)
    }

    fun apply(context: AppCompatActivity) {
        context.setTheme(defaultThemeResId)
        themeColors = ThemeColors(context)
    }

    @SuppressLint("ResourceType")
    inner class ThemeColors(activity: AppCompatActivity) {
        var backgroundColor by Delegates.notNull<Int>()
        var colorPrimary by Delegates.notNull<Int>()
        var colorAccent by Delegates.notNull<Int>()
        var bottomBarTextColor by Delegates.notNull<Int>()
        var toolBarTitleColor by Delegates.notNull<Int>()
        var rippleColorAccent by Delegates.notNull<Int>()
        var textColor by Delegates.notNull<Int>()
        var wrongColorStateList by Delegates.notNull<ColorStateList>()
        var rightColorStateList by Delegates.notNull<ColorStateList>()
        var transparentColor by Delegates.notNull<Int>()

        init {
            transparentColor = 0x00000000

            activity.withStyledAttributes(
                attrs = intArrayOf(
                    R.attr.backgroundColor,
                    R.attr.colorPrimary,
                    R.attr.bottomBarTextColor,
                    R.attr.toolBarTitleColor,
                    R.attr.rippleColorAccent,
                    R.attr.textColor
                )
            ) {
                backgroundColor = getColor(0, Color.TRANSPARENT)
                colorPrimary = getColor(1, Color.BLACK)
                colorAccent = colorPrimary
                bottomBarTextColor = getColor(2, Color.BLACK)
                toolBarTitleColor = getColor(3, Color.BLACK)
                rippleColorAccent = getColor(4, Color.BLACK)
                textColor = getColor(5, Color.BLACK)
            }
            wrongColorStateList = ColorStateList.valueOf(0xffff0000.toInt())
            rightColorStateList = ColorStateList.valueOf(textColor)
        }
    }

    fun getColorPrimary(): Int {
        return themeColors.colorPrimary
    }

    fun getColorAccent(): Int {
        return themeColors.colorAccent
    }

}
