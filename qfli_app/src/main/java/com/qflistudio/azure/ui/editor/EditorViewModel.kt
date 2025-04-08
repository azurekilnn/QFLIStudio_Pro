package com.qflistudio.azure.ui.editor

import FileItem
import android.os.Bundle
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.qflistudio.azure.bean.EditorFileListItem

class EditorViewModel : ViewModel() {

    val fileItemsList = MutableLiveData<MutableList<EditorFileListItem>>()
    private val fragmentData = mutableMapOf<String, Bundle>()
    private val editorFragmentData = mutableMapOf<String, Bundle>()

    fun setFileItems(items: MutableList<EditorFileListItem>) {
        fileItemsList.value = items
    }

    fun saveFragmentState(key: String, state: Bundle) {
        fragmentData[key] = state
    }

    fun getFragmentState(key: String): Bundle? {
        return fragmentData[key]
    }

    fun saveEditorFragmentData(key: String, state: Bundle) {
        editorFragmentData[key] = state
    }

    fun getEditorFragmentState(key: String): Bundle? {
        return editorFragmentData[key]
    }
}