package com.qflistudio.azure.util

import android.graphics.drawable.GradientDrawable
import android.view.View

class ViewUtils {
    fun dialogCorner(view: View, color: Int, radiu: Float) {
        val drawable = GradientDrawable()
        drawable.setShape(GradientDrawable.RECTANGLE)
        drawable.setColor(color)
        drawable.setCornerRadii(floatArrayOf(radiu, radiu, radiu, radiu, 0f, 0f, 0f, 0f))
        view.background = drawable
    }
}