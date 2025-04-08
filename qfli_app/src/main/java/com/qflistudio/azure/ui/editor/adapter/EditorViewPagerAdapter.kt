package com.qflistudio.azure.ui.editor.adapter

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.qflistudio.azure.ui.editor.fragment.CodeEditorFragment
import com.qflistudio.azure.ui.editor.fragment.PhotoViewFragment
import com.qflistudio.azure.util.FileUtils
import java.io.File
import android.util.Log

class EditorViewPagerAdapter(
    activity: FragmentActivity,
    private val fileUtils: FileUtils,
) : FragmentStateAdapter(activity) {
    private val TAG = "EditorViewPagerAdapter"
    private val editorTypes: MutableList<String> = mutableListOf()
    private val editorFragments: MutableList<Fragment> = mutableListOf()
    private val editorTitles: MutableList<String> = mutableListOf()
    private val editorFiles: MutableList<File> = mutableListOf()
    private val editorInitStatus: MutableList<Boolean> = mutableListOf()
    override fun getItemCount(): Int {
        return editorTypes.size
    }

    override fun createFragment(position: Int): Fragment {
        val type = editorTypes.getOrNull(position)
        val file = editorFiles.getOrNull(position)  // 获取文件，若越界则返回 null
        return when (type) {
            "code" -> CodeEditorFragment(file)
            "image" -> PhotoViewFragment(file)
            else -> CodeEditorFragment(file)
        }.also { fragment ->
            editorFragments.add(fragment)
        }
    }

    fun addEditor(editorTitle: String, editorType: String) {
        editorTypes.add(editorType)
        editorTitles.add(editorTitle)
        notifyItemInserted(editorTypes.size - 1)
        // 获取并回调新添加的编辑器视图
    }

    fun addEditor(file: File) {
        editorFiles.add(file)
        val editorType = (fileUtils.outputEditorType(file.path) ?: "code")
        val editorTitle = (fileUtils.getRelativePath(file))
        addEditor(editorTitle, editorType)
    }

    fun addEditor(filePath: String) {
        val file = File(filePath)
        addEditor(file)
    }

    fun removeEditor(position: Int) {
        Log.i(TAG, "removeEditor: $position")
        if (position in 0 until editorTypes.size) {
            editorTypes.removeAt(position)
            editorTitles.removeAt(position)
            editorFragments.removeAt(position)
            editorFiles.removeAt(position)
            notifyItemRemoved(position) // 通知 ViewPager2 这个位置被删除了
            notifyItemRangeChanged(position, editorFiles.size) // 更新剩余项的索引
        }
    }

    fun removeAllEditor(mainFile: File, secondFile: File? = null) {
        val checkList = setOfNotNull(mainFile.absolutePath, secondFile?.absolutePath)
        for (index in editorFiles.indices.reversed()) {
            // 如果不等于两个文件
            if (!checkList.contains(editorFiles[index].absolutePath)) {
                // item.absolutePath 既不等于 mainFile.absolutePath，也不等于 secondFile.absolutePath
                removeEditor(index)
            }
        }
    }


    fun getTitle(position: Int): String {
        return editorTitles.getOrNull(position) ?: "unknown"
    }

    fun getEditorFragment(position: Int): Any? {
        val fragment = editorFragments.getOrNull(position)
        return fragment
    }

    fun getEditorView(position: Int): Any? {
        val fragment = getEditorFragment(position)
        return when (fragment) {
            is CodeEditorFragment -> fragment.getEditorView()
            is PhotoViewFragment -> fragment.getEditorView()
            else -> null
        }

//        return when (fragment) {
//            is CodeEditorFragment -> fragment.view?.findViewById<io.github.rosemoe.sora.widget.CodeEditor>(R.id.code_editor)
//            is PhotoViewFragment -> fragment.view?.findViewById<com.luastudio.azure.widget.PhotoView>(R.id.photo_view)
//            else -> null
//        }
    }


    fun getEditorFile(position: Int): File? {
        return editorFiles.getOrNull(position)
    }

    fun setEditorInitStatus(position: Int) {
        setEditorInitStatus(position, true)
    }

    fun setEditorInitStatus(position: Int, status: Boolean) {
        editorInitStatus[position] = status
    }

    fun getEditorInitStatus(position: Int): Boolean? {
        return editorInitStatus.getOrNull(position)
    }

    fun checkFileExists(file: File): Int {
        var position = -1
        if (file.exists()) {
            editorFiles.forEachIndexed { index, item ->
                if (file.absolutePath == item.absolutePath) {
                    position = index
                    return@forEachIndexed // 找到后退出循环
                }
            }
        }
        return position
    }

    fun getEditorCount(): Int {
        return editorFiles.size
    }


}
