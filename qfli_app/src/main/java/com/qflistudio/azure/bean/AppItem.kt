data class AppItem(
    val iconResId: Int,
    val appName: String,
    val packageName: String,
    val targetActivity: Class<*>
)