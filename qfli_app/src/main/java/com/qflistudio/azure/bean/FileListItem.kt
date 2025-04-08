data class FileListItem(
    val name: String,
    val isDirectory: Boolean,
    val children: List<FileListItem>,
    var isExpanded: Boolean = false // 用于管理展开状态
)
