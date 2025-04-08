package com.qflistudio.azure.manager

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.core.content.edit
import com.qflistudio.azure.bean.HistoryProjectItem
import com.qflistudio.azure.util.AzureUtils

class HistoryManager {
    private val historyList = mutableListOf<HistoryProjectItem>()
    private lateinit var historySP: SharedPreferences
    private lateinit var context: Context

    fun init(thisContext: Context) {
        context = thisContext
        historySP = context.getSharedPreferences("appHistory", Context.MODE_PRIVATE)
    }

    fun saveLastOpenedProject(path: String, projectType: String) {
        historySP.edit {
            putString("last_opened_project", path)
            putString("last_opened_project_type", projectType)
            putBoolean("auto_open_last_opened_proj", true)
        }
    }

    fun saveAutoOpen(boolean: Boolean) {
        historySP.edit {
            putBoolean("auto_open_last_opened_proj", boolean)
        }
    }

    fun openLastOpenedProject() {
        val projectPath = historySP.getString("last_opened_project", "") ?: ""
        val projectType = historySP.getString("last_opened_project_type", "") ?: ""
        val isAutoOpen = historySP.getBoolean("auto_open_last_opened_proj", false) ?: false
        if (projectPath != "" && projectType != "" && isAutoOpen) {
            AzureUtils().skipToNewEditorActivity(projectPath, context, projectType)
        }
        return
    }

    fun setLastOpenedProject(intent: Intent) {
        val projectPath = intent.getStringExtra("projectPath") ?: ""
        val projectType = intent.getStringExtra("editorMode") ?: ""
        saveLastOpenedProject(projectPath, projectType)
    }

}