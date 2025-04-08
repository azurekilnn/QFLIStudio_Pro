import java.io.File

data class FileItem(
    val name: String,
    val file: File,
    val isDirectory: Boolean,
    val fileType: String,
    var fileSizeText: String
)
