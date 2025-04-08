package com.qflistudio.azure.util

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import java.io.File

class DrawableUtils {
    private val TAG = "DrawableUtils"

    fun getBitmapFromDrawable(context: Context, drawableId: Int): Bitmap {
        return BitmapFactory.decodeResource(context.resources, drawableId)
    }

    fun fileToBitmap(file: File): Bitmap? {
        return fileToBitmap(file.absolutePath)
    }

    fun fileToBitmap(filePath: String): Bitmap? {
        return BitmapFactory.decodeFile(filePath)
    }

    // 将 Drawable 转换为 Bitmap
    fun drawableToBitmap(drawable: Drawable): Bitmap {
        val bitmap: Bitmap
        if (drawable is BitmapDrawable) {
            // 如果 Drawable 本身就是 BitmapDrawable，直接获取 Bitmap
            bitmap = drawable.bitmap
        } else {
            // 否则，创建一个新的 Bitmap
            val width = drawable.intrinsicWidth.takeIf { it > 0 } ?: 100
            val height = drawable.intrinsicHeight.takeIf { it > 0 } ?: 100
            bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)

            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
        }
        return bitmap
    }
}