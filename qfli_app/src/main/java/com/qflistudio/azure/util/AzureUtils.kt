package com.qflistudio.azure.util

import ProjectItem
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
import com.luastudio.azure.AzureLibrary
import com.qflistudio.azure.R
import com.qflistudio.azure.common.ktx.showTip
import com.qflistudio.azure.ui.SourceDetailActivity
import com.qflistudio.azure.ui.editor.activity.EditorActivity
import com.qflistudio.azure.ui.editor.activity.EditorActivityX
import java.io.File

class AzureUtils {

    fun skipToNewEditorActivityX(context: Context, appItem: ProjectItem) {
        skipToNewEditorActivityX(context, appItem, appItem.editorMode)
    }

    fun skipToNewEditorActivityX(context: Context, appItem: ProjectItem, editorMode: String) {
        val intent = Intent(context, EditorActivityX::class.java)
        intent.putExtra("projectPath", appItem.projectPath)
        intent.putExtra("editorMode", editorMode)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_DOCUMENT)
        intent.addFlags(Intent.FLAG_ACTIVITY_MULTIPLE_TASK)
        context.startActivity(intent)
    }

    fun copyToClipboard(context: Context, text: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("Copied Text", text)
        clipboard.setPrimaryClip(clip)
        context.showTip(R.string.copy_tip)
    }

    fun skipToNewEditorActivity(projectPath: String, context: Context, editorMode: String) {
        val intent = Intent(context, EditorActivity::class.java)
        intent.putExtra("projectPath", projectPath)
        intent.putExtra("editorMode", editorMode)
        context.startActivity(intent)
    }

    fun generateKey(body: String): String {
        val secret = AzureLibrary.MySecret
        return MD5Utils.encrypt(secret + body)
    }

    fun skipToSourceDetailActivity(context: Context, sid: String) {
        val intent = Intent(context, SourceDetailActivity::class.java)
        intent.putExtra("sid", sid)
        context.startActivity(intent)
    }

    fun installApk(context: Context, path: String) {
        val file = File(path)
        val uri = getUriForFile(context, file)
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, getType(file))
            flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK
        }
        context.startActivity(Intent.createChooser(intent, file.name))
    }

    private fun getUriForFile(context: Context, file: File): Uri {
        return FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", file)
    }

    private fun getType(file: File): String {
        return MimeTypeMap.getSingleton().getMimeTypeFromExtension(file.extension) ?: "application/vnd.android.package-archive"
    }


}