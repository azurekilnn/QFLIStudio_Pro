package com.qflistudio.azure.ui.editor.fragment

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import com.qflistudio.azure.R
import com.qflistudio.azure.callback.OnEditorViewCreatedCallback
import java.io.File

class CodeEditorFragment(private val file: File?) :
    Fragment(R.layout.item_editor_code_editor) {
    private lateinit var codeEditor: Any
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        // 获取传递的 file 数据
        // 在视图创建完成后，进行操作
        codeEditor = view.findViewById<io.github.rosemoe.sora.widget.CodeEditor>(R.id.code_editor)
        // 在此操作视图
        println("CodeEditor view is ready!")
        if (file == null) {
            (requireActivity() as? OnEditorViewCreatedCallback)?.onEditorViewCreated(codeEditor)
        } else {
            (requireActivity() as? OnEditorViewCreatedCallback)?.onEditorViewCreated(
                codeEditor,
                file
            )
        }
    }

    fun getEditorView(): Any? {
        if (::codeEditor.isInitialized) {
            return codeEditor
        }
        return null
    }
}
