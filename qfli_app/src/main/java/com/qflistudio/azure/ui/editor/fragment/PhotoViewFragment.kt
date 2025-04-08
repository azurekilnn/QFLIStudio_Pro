package com.qflistudio.azure.ui.editor.fragment

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.qflistudio.azure.R
import com.qflistudio.azure.callback.OnEditorViewCreatedCallback
import com.qflistudio.azure.ui.editor.EditorViewModel
import java.io.File

class PhotoViewFragment(private val file: File?) : Fragment(R.layout.item_editor_photoview) {
    private lateinit var photoView: Any
    private lateinit var viewModel: EditorViewModel

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(requireActivity())[EditorViewModel::class.java]
        // 在视图创建完成后，进行操作
        photoView = view.findViewById<com.luastudio.azure.widget.PhotoView>(R.id.photo_view)
        // 在此操作视图
        println("PhotoView is ready!")
        if (file == null) {
            (requireActivity() as? OnEditorViewCreatedCallback)?.onEditorViewCreated(photoView)
        } else {
            (requireActivity() as? OnEditorViewCreatedCallback)?.onEditorViewCreated(photoView, file)
        }

        // 恢复保存的状态
       // editorState = viewModel.getFragmentState(getFileKey())
    }
    fun getEditorView(): Any? {
        if (::photoView.isInitialized) {
            return photoView
        }
        return null
    }

    override fun onDestroyView() {
        // 保存当前状态
        val state = Bundle().apply {
         //   putString("content", getEditorText())
            // 保存其他需要持久化的数据...
        }
        viewModel.saveFragmentState(getFileKey(), state)

        super.onDestroyView()
    }

    private fun getFileKey(): String {
        return arguments?.getString("file_path") ?: "default"
    }
}
