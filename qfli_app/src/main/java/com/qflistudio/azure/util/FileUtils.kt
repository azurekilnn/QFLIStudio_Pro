package com.qflistudio.azure.util

import FileCopyProgressCallback
import FileItem
import ProgressCallback
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.text.format.Formatter
import android.util.Log
import androidx.core.content.FileProvider
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.luastudio.azure.AzureLibrary
import com.qflistudio.azure.R
import com.qflistudio.azure.common.AzureProgressDialog
import com.qflistudio.azure.viewmodel.MainViewModel
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

class FileUtils {
    private val TAG = "FileUtils"

    private var openFolderPath: String? = null

    private val fileTypeMap = mapOf(
        "image" to setOf(
            "jpg",
            "jpeg",
            "png",
            "gif",
            "bmp",
            "tif",
            "tiff",
            "svg",
            "webp",
            "heif",
            "heic"
        ),
        "lua" to setOf("lua", "aly"),
        "java" to setOf("java", "kt", "kts", "groovy", "gradle")
    )


    private val editorTypeMap = mapOf(
        "image" to setOf(
            "jpg",
            "jpeg",
            "png",
            "gif",
            "bmp",
            "tif",
            "tiff",
            "svg",
            "webp",
            "heif",
            "heic"
        ),
        "code" to setOf(
            // 前端相关
            "html", "htm", "css", "scss", "sass", "less", "js", "jsx", "ts", "tsx",

            // C/C++ 相关
            "c", "h", "cpp", "cxx", "cc", "hpp", "hxx", "hh",

            // Java/Kotlin 相关
            "java", "kt", "kts", "groovy", "gradle",

            // Python 相关
            "py", "pyw", "ipynb",

            // Swift & Objective-C
            "swift", "m", "mm",

            // C# / .NET 相关
            "cs", "fs", "vb",

            // PHP / Ruby / Go
            "php", "phtml", "rb", "erb", "go",

            // Shell / 批处理
            "sh", "bash", "zsh", "bat", "cmd", "ps1",

            // Rust / Dart / TypeScript / SQL
            "rs", "dart", "ts", "sql",

            // Lua / LuaStudio+ / Lisp / Scheme / Prolog
            "lua", "aly", "lsinfo", "lisp", "clj", "rkt", "pro",

            // YAML / JSON / XML / TOML 配置文件
            "yml", "yaml", "json", "xml", "toml",

            // 其他常见语言
            "perl", "pl", "r", "scala", "sas", "f90", "for", "f", "pas", "lsp", "asm"
        )
    )


    fun isImageFile(file: File): Boolean {
        val fileExtension = getFileExtension(file.absolutePath)
        return if (fileExtension != null) {
            isImageFile(fileExtension)
        } else {
            false
        }
    }

    fun isImageFile(fileExtension: String): Boolean {
        val imageType = setOf(
            "jpg",
            "jpeg",
            "png",
            "gif",
            "bmp",
            "tif",
            "tiff",
            "svg",
            "webp",
            "heif",
            "heic"
        )
        return imageType.contains(fileExtension)
    }

    fun getFileTypeImageResId(file: File): Int {
        val filePath = file.absolutePath
        val fileExtension = getFileExtension(filePath)

        val fileImages = mapOf(
            "java" to R.drawable.twotone_code_black_24,
            "kt" to R.drawable.twotone_code_black_24,
            "kts" to R.drawable.twotone_code_black_24,
            "js" to R.drawable.twotone_code_black_24,
            "lua" to R.drawable.twotone_code_black_24,
            "aly" to R.drawable.twotone_image_black_24,
            "c" to R.drawable.twotone_code_black_24,
            "cpp" to R.drawable.twotone_code_black_24,

            "html" to R.drawable.twotone_code_black_24,
            "css" to R.drawable.twotone_code_black_24,

            "md" to R.drawable.twotone_insert_drive_file_black_24,

            "dex" to R.drawable.twotone_insert_drive_file_black_24,
            "apk" to R.drawable.twotone_adb_black_24,
            "zip" to R.drawable.twotone_folder_zip_black_24,
        )

        return fileImages[fileExtension] ?: R.drawable.twotone_insert_drive_file_24
    }

    fun replaceTextInFile(file: File, oldText: String, newText: String) {
        if (!file.exists()) {
            throw IllegalArgumentException("File does not exist: ${file.absolutePath}")
        }

        // 读取文件内容
        val fileContent = file.readText()

        // 替换文本
        val updatedContent = fileContent.replace(oldText, newText)

        // 将替换后的内容写回文件
        file.writeText(updatedContent)

        println("Text replaced successfully!")
    }


    // 遍历目录获取所有apk文件
    fun listApkFiles(directory: File): List<File> {
        val apkFiles = mutableListOf<File>()

        // 检查目录是否存在且是一个目录
        if (directory.exists() && directory.isDirectory) {
            // 获取目录下的所有文件和文件夹
            val files = directory.listFiles()

            // 如果存在文件
            files?.forEach { file ->
                // 如果是文件且是 APK 文件
                if (file.isFile && ((file.name.endsWith(
                        ".apk",
                        ignoreCase = true
                    )) || (file.name.endsWith(".apk.1", ignoreCase = true)))
                ) {
                    apkFiles.add(file)
                }
                // 如果是文件夹，则递归调用
                else if (file.isDirectory) {
                    apkFiles.addAll(listApkFiles(file))  // 递归查找子目录
                }
            }
        }
        return apkFiles
    }


    // 压缩文件夹
    fun zipFolderWithProgress(
        context: Context,
        folder: File,
        outputZip: File,
        callback: ProgressCallback,
    ) {
        val progressDialog = AzureProgressDialog(context).apply {
            setTitle("正在压缩文件")
            setMessage("准备中...")
            setIndeterminate(false)
            setCancelable(false)
            show()
        }

        // 记录开始时间
        val startTime = System.currentTimeMillis()
        // 创建一个 Handler 以便在子线程中更新 UI
        val handler = Handler(Looper.getMainLooper())

        // 开始复制
        Thread {
            try {
                FileOutputStream(outputZip).use { fos ->
                    ZipOutputStream(BufferedOutputStream(fos)).use { zos ->
                        val files = folder.walk().filter { it.isFile }.toList()
                        val totalSize = files.sumOf { it.length() }
                        var compressedSize = 0L

                        files.forEachIndexed { index, file ->
                            val entry = ZipEntry(file.relativeTo(folder).path.replace("\\", "/"))
                            zos.putNextEntry(entry)

                            FileInputStream(file).use { fis ->
                                val buffer = ByteArray(1024)
                                var bytesRead: Int
                                while (fis.read(buffer).also { bytesRead = it } != -1) {
                                    zos.write(buffer, 0, bytesRead)
                                    compressedSize += bytesRead
                                    val progress = (compressedSize * 100 / totalSize).toInt()
                                    handler.post {
                                        progressDialog.setProgress(progress)
                                        progressDialog.setMessage("正在压缩: ${file.name}")
                                    }
                                }
                            }
                            zos.closeEntry()
                        }
                    }
                }
            } catch (e: IOException) {
                Log.e(TAG, e.message.toString())

                handler.post {
                    progressDialog.dismiss()
                    callback.onError(e) // 调用回调通知发生错误
                }
            } finally {
                // 复制完成
                handler.post {
                    progressDialog.dismiss()
                    callback.onComplete() // 调用回调通知复制完成
                }
            }

        }.start()


    }

    /**
     * 复制文件夹并实时回调复制的文件名和进度。
     *
     * @param context 上下文，用于显示 ProgressDialog
     * @param sourceFolder 源文件夹
     * @param destinationFolder 目标文件夹
     */
    fun copyFolderWithProgress(
        context: Context,
        sourceFolder: File,
        destinationFolder: File,
        callback: FileCopyProgressCallback,
    ) {
        if (!sourceFolder.exists()) {
            callback.onError(IOException("Source folder does not exist: ${sourceFolder.absolutePath}")) // 调用回调通知发生错误
            Log.e(TAG, "Source folder does not exist: ${sourceFolder.absolutePath}")
        }

        // 创建 ProgressDialog
//        val progressDialog = ProgressDialog(context).apply {
//            setTitle("正在复制文件")
//            setMessage("准备中...")
//            setProgressStyle(ProgressDialog.STYLE_HORIZONTAL)
//            isIndeterminate = false
//            setCancelable(false)
//            show()
//        }

        val progressDialog = AzureProgressDialog(context).apply {
            setTitle("正在复制文件")
            setMessage("准备中...")
            setIndeterminate(false)
            setCancelable(false)
            show()
        }

        // 获取所有需要复制的文件（包括子目录中的文件）
        val allFiles = sourceFolder.walkTopDown().filter { it.isFile || it.isDirectory }.toList()
        val totalFiles = allFiles.size

        // 创建目标目录
        allFiles.forEach { sourceFile ->
            val relativePath = sourceFile.relativeTo(sourceFolder).path
            val destFile = File(destinationFolder, relativePath)
            destFile.parentFile?.mkdirs() // 仅创建目录
            // 如果是目录且不存在，则创建目录
            if (sourceFile.isDirectory && !destFile.exists()) {
                destFile.mkdirs()
            }
        }

        // 记录开始时间
        val startTime = System.currentTimeMillis()
        // 创建一个 Handler 以便在子线程中更新 UI
        val handler = Handler(Looper.getMainLooper())

        // 开始复制
        Thread {
            try {
                var copiedFiles = 0
                var totalBytesCopied: Long = 0

                Log.i(TAG, "allFiles: " + allFiles.toString())
                allFiles.forEach { sourceFile ->
                    // 仅复制文件，跳过目录
                    if (sourceFile.isFile) {
                        val relativePath = sourceFile.relativeTo(sourceFolder).path
                        val destFile = File(destinationFolder, relativePath)

                        // 使用 FileChannel 进行更高效的文件复制
                        copyFileUsingChannel(sourceFile, destFile)
                        // 确保目标文件夹存在
                        // destFile.parentFile?.mkdirs()
                        // 复制文件
                        // sourceFile.copyTo(destFile, overwrite = true)

                        // 更新进度
                        copiedFiles++
                        totalBytesCopied += sourceFile.length()

                        // 计算进度百分比
                        val progress = (copiedFiles * 100 / totalFiles)

                        // 计算已复制的速度（字节/秒）
                        val elapsedTime = System.currentTimeMillis() - startTime // 已经过的时间（毫秒）
                        val speed =
                            if (elapsedTime > 0) totalBytesCopied / (elapsedTime / 1000.0) else 0.0 // 计算字节/秒


                        handler.post {
                            // 更新进度条
                            progressDialog.setProgress(progress)
                            // 设置消息（包括复制速度）
                            progressDialog.setMessage(
                                "名称: ${sourceFile.name}\n从：${sourceFolder.name}\n到：${destinationFolder.parentFile?.name}\n速度: ${
                                    formatSpeed(
                                        speed
                                    )
                                }"
                            )

                        }
                    }
                }

                // 复制完成
                handler.post {
                    progressDialog.dismiss()
                    callback.onComplete() // 调用回调通知复制完成
                }
            } catch (e: Exception) {
                Log.e(TAG, e.message.toString())

                handler.post {
                    progressDialog.dismiss()
                    callback.onError(e) // 调用回调通知发生错误
                }
            }
        }.start()
    }

    // 使用缓冲区复制文件
    fun copyFileUsingChannel(sourceFile: File, destFile: File) {
        // 确保目标文件的父目录存在
        destFile.parentFile?.mkdirs()
        // 使用缓冲区更高效地复制文件
        FileInputStream(sourceFile).use { inputStream ->
            FileOutputStream(destFile).use { outputStream ->
                val buffer = ByteArray(8192) // 设置 8KB 的缓冲区
                var bytesRead: Int
                while (inputStream.read(buffer).also { bytesRead = it } != -1) {
                    outputStream.write(buffer, 0, bytesRead)
                }
            }
        }
    }

    fun removeIdeStoragePath(apkPath: String): String {
        // 内部存储路径（通常以这个路径开头）
        val ideStoragePath = AzureLibrary.luaExtDir

        // 检查 apkPath 是否包含内部存储路径，若包含，则去掉该部分
        return if (apkPath.startsWith(ideStoragePath)) {
            apkPath.replace(ideStoragePath, "")  // 去掉内部存储路径部分
        } else {
            apkPath  // 如果路径不包含内部存储路径，直接返回原路径
        }
    }

    // 获取文件大小
    fun getFileSize(filePath: String): Long {
        val file = File(filePath)
        return getFileSize(file)
    }

    fun getFileSize(file: File): Long {
        val fileSize = file.length()
        return fileSize
    }

    fun getFileSizeWithFormat(context: Context, filePath: String): String {
        val file = File(filePath)
        return getFileSizeWithFormat(context, file)
    }

    fun getFileSizeWithFormat(context: Context, file: File): String {
        val fileSize = getFileSize(file)
        return Formatter.formatFileSize(context, fileSize)
    }

    fun getFileExtension(filePath: String): String? {
        // 找到最后一个点的位置
        val lastDotIndex = filePath.lastIndexOf('.')
        // 确保点存在且不是第一个字符
        return if (lastDotIndex > 0 && lastDotIndex < filePath.length - 1) {
            // 提取后缀名
            filePath.substring(lastDotIndex + 1)
        } else {
            null // 没有后缀名
        }
    }

    fun isLuaFile(filePath: String): Boolean {
        val extension = getFileExtension(filePath)
        val luaTypes = setOf("lua", "aly")
        if (extension != null) {
            return (extension in luaTypes)
        }
        return false
    }

    fun outputType(filePath: String): String {
        val extension = getFileExtension(filePath)
        return ((fileTypeMap.entries.firstOrNull { extension in it.value }?.key) ?: "unknown")
    }

    fun outputEditorType(filePath: String): String? {
        val fileType = getFileExtension(filePath)
        Log.i(TAG, "fileType: $fileType")
        return (editorTypeMap.entries.firstOrNull { fileType in it.value }?.key)
    }

    fun isAlyFile(file: File): Boolean {
        val fileType = getFileExtension(file.absolutePath)
        Log.i(TAG, "fileType: $fileType")
        return (fileType == "aly")
    }

    // 设置文件夹路径的方法
    fun setFolderPath(path: String) {
        openFolderPath = path
    }

    // 获取相对路径
    fun getRelativePath(file: File): String {
        Log.i(TAG, "openFolderPath: $openFolderPath")
        openFolderPath?.let { path ->
            return getRelativePath(file, path)
        }
        return file.name // 如果 folderPath 为空，输出文件名
    }

    // 获取相对路径
    fun getRelativePath(file: File, prefix: String): String {
        val absolutePath = file.absolutePath
        return if (absolutePath.contains(prefix)) {
            // 去除 folderPath
            absolutePath.removePrefix("$prefix/")
        } else {
            // 输出文件名
            file.name
        }
    }


    fun sortDirectoryFiles(directoryPath: String): List<File> {
        val directory = File(directoryPath)

        if (!directory.isDirectory) {
            throw IllegalArgumentException("The specified path is not a directory: $directoryPath")
        }

        // 获取文件列表并转换为可变列表
        val fileList = directory.listFiles()?.toMutableList() ?: mutableListOf()

        // 对文件列表进行排序：先目录，后文件；同类按名称排序
        fileList.sortWith { a2, b2 ->
            when {
                a2.isDirectory && !b2.isDirectory -> -1
                !a2.isDirectory && b2.isDirectory -> 1
                else -> a2.name.compareTo(b2.name, ignoreCase = true)
            }
        }
        return fileList
    }

    fun getFilesList(directoryPath: String): List<File> {
        return sortDirectoryFiles(directoryPath)
    }

    // 解压文件到目标目录
    fun extractAssetToFile(context: Context, assetName: String, outputPath: String): Boolean {
        try {
            // 获取 assets 目录中的文件输入流
            val assetInputStream = context.assets.open(assetName)
            val outputFile = File(outputPath)

            if (outputFile.exists()) {
                outputFile.delete()
            }

            // 创建目标目录
            val parentDir = outputFile.parentFile
            if (parentDir?.exists() != true) {
                parentDir?.mkdirs()
            }

            // 文件输出流
            val fileOutputStream = FileOutputStream(outputFile)

            // 复制文件
            val buffer = ByteArray(1024)
            var length: Int
            while (assetInputStream.read(buffer).also { length = it } != -1) {
                fileOutputStream.write(buffer, 0, length)
            }

            assetInputStream.close()
            fileOutputStream.close()

            return true
        } catch (e: IOException) {
            Log.e(TAG, "extractAssetToFile: " + e.message.toString())
            return false
        }
    }

    // 创建符号链接
    fun createSymlink(targetPath: String, symlinkPath: String): Boolean {
        try {
            val targetFile = File(targetPath)
            val symlinkFile = File(symlinkPath)

            if (symlinkFile.exists()) {
                symlinkFile.delete()
            }
            // 创建符号链接
            val process = ProcessBuilder(
                "ln",
                "-s",
                targetFile.absolutePath,
                symlinkFile.absolutePath
            ).start()
            process.waitFor()
            return true
        } catch (e: Exception) {
            Log.e(TAG, "createSymlink: " + e.message.toString())
            return false
        }
    }

    // 修改文件权限
    fun setFilePermissions(file: File): Boolean {
        return setFilePermissions(file, "755")
    }

    fun setFilePermissions(file: File, permission: String): Boolean {
        try {
            // 执行 chmod 命令
            val process = ProcessBuilder("chmod", permission, file.absolutePath).start()
            process.waitFor()
            return true
        } catch (e: Exception) {
            Log.e(TAG, "setFilePermissions: " + e.message.toString())
            return false
        }
    }

    // 格式化速度为可读的字符串（例如：1.2 MB/s, 250 KB/s）
    fun formatSpeed(speed: Double): String {
        return when {
            speed >= 1_000_000 -> String.format("%.2f MB/s", speed / 1_000_000.0)
            speed >= 1_000 -> String.format("%.2f KB/s", speed / 1_000.0)
            else -> "$speed B/s"
        }
    }


    private fun loadFilesList(context: Context, fileDir: String): MutableList<FileItem> {
        val filesList = getFilesList(fileDir)
        // 创建一个列表来存储 projectItem
        val fileItemsList = mutableListOf<FileItem>()

        filesList.forEach {
            val fileSizeText: String = if (it.isDirectory) {
                context.getString(R.string.folder)
            } else {
                getFileSizeWithFormat(context, it)
            }
            val fileItem = FileItem(
                it.name,
                it,
                it.isDirectory,
                getFileExtension(it.absolutePath) ?: "text",
                fileSizeText
            )
            fileItemsList.add(fileItem)
        }
        return fileItemsList
    }

    fun getBinDir(context: Context, relativeDir: String, relativePath: String = ""): String {
        return PathUtils.getBackupSubDir(context, relativeDir + relativePath)
    }

    private fun loadBinList(context: Context, fullPath: String): MutableList<FileItem> {
        return loadFilesList(context, fullPath)
    }


    fun loadBinListWithView(
        context: Context,
        viewModel: MainViewModel,
        relativeDir: String,
    ) {
        val fullPath = getBinDir(context, relativeDir)
        loadBinListWithView(context, viewModel, null, relativeDir, fullPath)
    }

    fun loadBinListWithView(
        context: Context,
        viewModel: MainViewModel,
        swipeRefreshLayout: SwipeRefreshLayout?,
        relativeDir: String,
        fullPath: String,
    ) {
        val binFilesList = loadBinList(context, fullPath)
        viewModel.setBinFilesList(binFilesList, relativeDir)
        swipeRefreshLayout?.isRefreshing = false
    }

    fun shareFile(context: Context, file: File) {
        if (!file.exists()) {
            Log.e("FileShare", "文件不存在: ${file.absolutePath}")
            return
        }

        try {
            // 获取 FileProvider 的 authority (需与 AndroidManifest.xml 中配置一致)
            val authority = "${context.packageName}.fileprovider"
            val uri: Uri = FileProvider.getUriForFile(context, authority, file)

            // 创建分享 Intent
            val intent = Intent(Intent.ACTION_SEND).apply {
                type = "*/*"  // 你可以根据文件类型修改，如 "image/*" 或 "application/pdf"
                putExtra(Intent.EXTRA_STREAM, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION) // 允许临时访问
            }

            // 启动分享选择器
            context.startActivity(Intent.createChooser(intent, "分享文件"))

        } catch (e: Exception) {
            Log.e("FileShare", "分享文件失败: ${e.message}", e)
        }
    }

    fun renameFile(originalFile: File, destinationFile: File): Boolean {
        return originalFile.renameTo(destinationFile)
    }

    fun deleteFile(file: File) {
        file.delete()
    }




}