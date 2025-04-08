package com.qflistudio.azure.util

import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import org.apache.commons.compress.archivers.tar.TarArchiveEntry
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream
import org.apache.commons.compress.compressors.xz.XZCompressorInputStream
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.nio.file.Files
import java.nio.file.Paths

class ZipUtils {
    private val TAG = "ZipUtils"

    @RequiresApi(Build.VERSION_CODES.O)
    fun unTarXz(filePath: String, outputDir: String): Boolean {
        try {
            val sourceFile = File(filePath)
            val destinationDir = File(outputDir)
            FileInputStream(sourceFile).use { fis ->
                XZCompressorInputStream(fis).use { xzInputStream ->
                    TarArchiveInputStream(xzInputStream).use { tarInputStream ->
                        tarInputStream.nextTarEntry.also { firstEntry ->
                            if (firstEntry != null && firstEntry.isDirectory) {
                                destinationDir.mkdir()
                            }
                        }

                        var entry: TarArchiveEntry?
                        while (true) {
                            entry = tarInputStream.nextTarEntry
                            if (entry == null) {
                                break
                            }

                            val entryFile = File(destinationDir, entry.name)
                            if (entry.isSymbolicLink) {
                                // 创建符号链接
                                val linkTarget = entry.linkName
                                val linkPath = Paths.get(entryFile.absolutePath)
                                Files.createSymbolicLink(linkPath, Paths.get(linkTarget))
                            } else  if (entry.isDirectory) {
                                entryFile.mkdir()
                            } else {
                                val parent = entryFile.parentFile
                                if (parent?.exists() != true) {
                                    parent?.mkdirs()
                                }
                                entryFile.outputStream().use { out ->
                                    tarInputStream.copyTo(out, 2048)
                                }
                            }
                        }
                    }
                }
            }
            Log.e(TAG, "解压成功")
            return true
        } catch (e: IOException) {
            Log.e(TAG, "解压失败：" + e.message.toString())
            return false
        }
    }
}