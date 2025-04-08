package com.qflistudio.azure.util

import android.animation.LayoutTransition
import android.annotation.SuppressLint
import android.content.Context
import android.content.res.ColorStateList
import android.graphics.drawable.Drawable
import android.graphics.drawable.RippleDrawable
import android.util.TypedValue
import android.view.View
import androidx.core.content.ContextCompat

class ResUtils {

    fun getString(context: Context, key: String): String? {
        // 获取资源 ID
        val resId = context.resources.getIdentifier(key, "string", context.packageName)
        // 如果资源ID存在，返回对应的字符串，否则返回null
        return if (resId != 0) context.getString(resId) else null
    }

    fun getRippleId(context: Context, attr: Int): Int? {
        val outValue = TypedValue()
        context.theme.resolveAttribute(attr, outValue, true)
        return outValue.resourceId
    }

    fun getRippleId(context: Context, type: String): Int? {
        var attr: Int
        when (type) {
            "circular" -> {
                attr = android.R.attr.selectableItemBackgroundBorderless
            }

            "square" -> {
                // 对应 android.R.attr.selectableItemBackground
                attr = android.R.attr.selectableItemBackground
            }

            else -> attr = android.R.attr.selectableItemBackground
        }
        return getRippleId(context, attr)
    }


    fun getRippleDrawable(context: Context): Drawable? {
        return getRippleDrawable(context, "circular", 0x3f000000)
    }

    fun getRippleDrawable(context: Context, color: Int): Drawable? {
        return getRippleDrawable(context, "circular", color)
    }

    fun getRippleDrawable(context: Context, type: String, color: Int): Drawable? {
        val states = arrayOf(intArrayOf()) // 空状态数组，表示所有状态
        val colors = intArrayOf(color)
        val colorStateList = ColorStateList(states, colors)
        val ripple = getRippleId(context, type)
        val drawable = ContextCompat.getDrawable(context, ripple!!)
        if (drawable is RippleDrawable) {
            drawable.setColor(colorStateList) // 使用 setColor 来改变 RippleDrawable 的颜色
        }
        return drawable
    }


    fun setRippleDrawable(context: Context, view: View) {
        val rippleDrawable = getRippleDrawable(context)
        view.background = rippleDrawable
    }

    fun setRippleDrawable(context: Context, views: List<View>, color: Int?) {
        views.forEach { view ->
            val rippleDrawable: Drawable?
            if (color != null) {
                rippleDrawable = getRippleDrawable(context, color)
            } else {
                rippleDrawable = getRippleDrawable(context)
            }
            view.background = rippleDrawable
        }
    }

    fun setRippleDrawable(context: Context, views: List<View>) {
        setRippleDrawable(context, views, null)
    }

    fun newLayoutTransition(): LayoutTransition {
        // 创建 LayoutTransition
        val layoutTransition = LayoutTransition()
        layoutTransition.enableTransitionType(LayoutTransition.CHANGING)
        return layoutTransition
    }


}