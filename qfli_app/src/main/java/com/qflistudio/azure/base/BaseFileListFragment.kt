package com.qflistudio.azure.base

import FileItem
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.FileListAdapter
import com.qflistudio.azure.common.Dialogs
import com.qflistudio.azure.databinding.FragmentFileListBinding
import com.qflistudio.azure.util.EditorUtils
import com.qflistudio.azure.util.FileUtils
import com.qflistudio.azure.viewmodel.MainViewModel
import java.io.File

// 文件列表 Fragment
abstract class BaseFileListFragment : BaseFragment<FragmentFileListBinding, MainViewModel>() {
    private val TAG = "BaseFileListFragment"
    protected lateinit var relativeDir: String
    protected lateinit var initFullDir: String
    protected lateinit var fullDir: String
    protected lateinit var fileListAdapter: FileListAdapter
    private val dialogs: Dialogs by lazy { Dialogs() }
    private var fileUtils = FileUtils()

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentFileListBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerViewRoot = binding.fileListRvView.binRvGroup
        fileListAdapter = FileListAdapter(requireContext(), themeManager)
        initAllComponents(recyclerViewRoot, fileListAdapter)

        dialogs.setTManager(themeManager)

        tipsTv.text = getString(R.string.no_file_or_dir_tips)
        binding.fileListRvView.fileListBackBtn.setOnClickListener {
            backDir()
        }

        fileListAdapter.setOnItemClick { holder, position ->
            val file = holder.fileItem.file
            if (file.isDirectory) {
                checkPath()
                fullDir = file.absolutePath
                loadNewList()
            } else if (file.isFile) {
                if (EditorUtils().isEditorCanOpen(file)) {
                   val editorDialog = dialogs.createEditorDialog(requireContext(), file.name, file)
                    editorDialog.show()
                }
            }
        }
        swipeRefreshLayout.setOnRefreshListener {
            checkPath()
            if (::fullDir.isInitialized) {
                loadNewList()
            }
            swipeRefreshLayout.isRefreshing = false
        }

        viewModel.projectsListSearchKey.observe(viewLifecycleOwner) { keyWord ->
            fileListAdapter.filterList(keyWord)
        }
    }

    private fun canBack(): Boolean {
        // 如果完整路径已经初始化了
        if (::initFullDir.isInitialized && ::fullDir.isInitialized) {
            if (initFullDir != fullDir) {
                val parentPath = File(fullDir).parentFile?.absolutePath
                // 如果父目录路径不为空   并且  父目录路径等于初始化路径 当前完整路径跟初始化路径一模一样
                if (parentPath != null) {
                    return true
                }
            }
        }
        return false
    }

    private fun backDir() {
        if (canBack()) {
            val fullDirFile = File(fullDir)
            val parentPath = fullDirFile.parentFile?.absolutePath
            if (parentPath != null) {
                fullDir = parentPath
            }
            checkPath()
            loadNewList()
        }
    }

    private fun checkPath() {
        // 初始化路径还未初始化 相对路径已经初始化了
        if (!::initFullDir.isInitialized && ::relativeDir.isInitialized) {
            initFullDir = fileUtils.getBinDir(requireContext(), relativeDir)
            fullDir = initFullDir
        }
        if (canBack()) {
            binding.fileListRvView.fileListBackBtn.visibility = View.VISIBLE
        } else {
            binding.fileListRvView.fileListBackBtn.visibility = View.GONE
        }
    }

    private fun loadNewList() {
        checkPath()
        fileUtils.loadBinListWithView(
            requireContext(),
            viewModel,
            swipeRefreshLayout,
            relativeDir,
            fullDir
        )
    }

    fun updateList(list: MutableList<FileItem>) {
        fileListAdapter.updateList(list)
        if (list.size == 0) {
            tipsTv.visibility = View.VISIBLE
            progressBar.visibility = View.GONE
        } else {
            tipsTv.visibility = View.GONE
            progressBar.visibility = View.GONE
        }
    }
}