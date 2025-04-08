import java.io.File

data class FileNode(
    val name: String,
    val isDirectory: Boolean,
    val children: MutableList<FileItem> = mutableListOf()
)