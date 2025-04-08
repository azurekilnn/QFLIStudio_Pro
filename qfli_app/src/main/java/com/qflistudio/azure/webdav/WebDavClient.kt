package com.qflistudio.azure.webdav

import android.os.Build
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.util.Base64


typealias ProgressCallback = (totalBytes: Long, transferredBytes: Long) -> Unit

class WebDavClient(
    private val username: String,
    private val appPassword: String,
    private val baseUrl: String = "https://dav.jianguoyun.com/dav/"
) {
    private val authHeader: String by lazy {
        val auth = "$username:$appPassword"
        "Basic ${Base64.getEncoder().encodeToString(auth.toByteArray())}"
    }

    // 上传文件（带进度回调）
    fun uploadFile(
        localFilePath: String,
        remotePath: String,
        progress: ProgressCallback? = null
    ): Boolean {
        val file = File(localFilePath)
        if (!file.exists()) {
            println("本地文件不存在")
            return false
        }

        val url = URL("${baseUrl}${remotePath}")
        val conn = url.openConnection() as HttpURLConnection
        conn.requestMethod = "PUT"
        conn.setRequestProperty("Authorization", authHeader)
        conn.setRequestProperty("Content-Type", "application/octet-stream")
        conn.doOutput = true

        return try {
            val totalSize = file.length()
            var transferred = 0L

            file.inputStream().use { input ->
                conn.outputStream.use { output ->
                    val buffer = ByteArray(8 * 1024) // 8KB buffer
                    var bytesRead: Int

                    while (input.read(buffer).also { bytesRead = it } != -1) {
                        output.write(buffer, 0, bytesRead)
                        transferred += bytesRead
                        progress?.invoke(totalSize, transferred)
                    }
                }
            }
            conn.responseCode in 200..299
        } catch (e: Exception) {
            e.printStackTrace()
            false
        } finally {
            conn.disconnect()
        }
    }

    // 下载文件（带进度回调）
    fun downloadFile(
        remotePath: String,
        localFilePath: String,
        progress: ProgressCallback? = null
    ): Boolean {
        val url = URL("${baseUrl}${remotePath}")
        val conn = url.openConnection() as HttpURLConnection
        conn.requestMethod = "GET"
        conn.setRequestProperty("Authorization", authHeader)

        return try {
            if (conn.responseCode == HttpURLConnection.HTTP_OK) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    val totalSize = conn.contentLengthLong
                    var transferred = 0L

                    File(localFilePath).outputStream().use { output ->
                        conn.inputStream.use { input ->
                            val buffer = ByteArray(8 * 1024)
                            var bytesRead: Int

                            while (input.read(buffer).also { bytesRead = it } != -1) {
                                output.write(buffer, 0, bytesRead)
                                transferred += bytesRead
                                progress?.invoke(totalSize, transferred)
                            }
                        }
                    }
                } else {
                    File(localFilePath).outputStream().use { output ->
                        conn.inputStream.use { input ->
                            input.copyTo(output)
                        }
                    }
                }
                true
            } else {
                false
            }
        } catch (e: Exception) {
            e.printStackTrace()
            false
        } finally {
            conn.disconnect()
        }
    }

    // 删除文件/目录
    fun delete(remotePath: String): Boolean {
        val url = URL("${baseUrl}${remotePath}")
        val conn = url.openConnection() as HttpURLConnection
        conn.requestMethod = "DELETE"
        conn.setRequestProperty("Authorization", authHeader)

        return try {
            conn.responseCode == HttpURLConnection.HTTP_NO_CONTENT
        } catch (e: Exception) {
            e.printStackTrace()
            false
        } finally {
            conn.disconnect()
        }
    }
}
