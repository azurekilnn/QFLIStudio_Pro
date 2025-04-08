import android.graphics.Bitmap

data class ApkItem(
    val iconBitmap: Bitmap,
    val appName: String,
    val packageName: String,
    val apkPath: String,
    val apkSize: String
)