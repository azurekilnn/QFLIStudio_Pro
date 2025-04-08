package com.qflistudio.azure.util

import ApkItem
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import com.qflistudio.azure.R
import java.io.File

class ApkUtils {
    private val TAG = "ApkUtils"


    fun getApkIcon(context: Context, apkFile: File): Drawable? {
        val packageManager = context.packageManager
        val packageInfo = packageManager.getPackageArchiveInfo(apkFile.absolutePath, PackageManager.GET_ACTIVITIES)

        packageInfo?.applicationInfo?.let { appInfo ->
            appInfo.sourceDir = apkFile.absolutePath
            appInfo.publicSourceDir = apkFile.absolutePath
            return appInfo.loadIcon(packageManager)
        }
        return null
    }


    fun getApkIconAsBitmap(context: Context, apkFile: File): Bitmap? {
       val apkIcon = getApkIcon(context, apkFile)
        val bitmap = apkIcon?.let { DrawableUtils().drawableToBitmap(it) }
        return bitmap
    }



    fun getApkList(context: Context, fileDir: String): MutableList<ApkItem> {
        val file = File(fileDir)
        val apksFilesList = FileUtils().listApkFiles(file)
        val apksList = mutableListOf<ApkItem>()

        apksFilesList.forEach { file ->
            val apkIcon =
                getApkIconAsBitmap(context, file) ?: DrawableUtils().getBitmapFromDrawable(
                    context,
                    R.drawable.icon
                )
            val apkPackageName = ""
            val apkSize = FileUtils().getFileSizeWithFormat(context, file.path)
            val apkItem = ApkItem(
                apkIcon,
                file.name,
                apkPackageName,
                file.path,
                apkSize
            )
            apksList.add(apkItem)
        }

        return apksList
    }


}