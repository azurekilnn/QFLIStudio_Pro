import android.graphics.Bitmap

data class ProjectItem(
    var iconBitmap: Bitmap,
    var appName: String,
    var packageName: String,
    var projectPath: String,
    var projectStatus: Boolean,
    var projectCollectedStatus: Boolean,
    var projectType: String,
    var editorMode: String = projectType,
)