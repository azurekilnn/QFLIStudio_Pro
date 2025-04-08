package com.qflistudio.azure.base

import FileItem
import ProjectItem
import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ProgressBar
import androidx.appcompat.widget.AppCompatTextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import androidx.viewbinding.ViewBinding
import com.qflistudio.azure.adapter.ProjectFileListAdapter
import com.qflistudio.azure.common.ktx.showTip
import com.qflistudio.azure.databinding.ViewRecyclerviewGroupBinding
import com.qflistudio.azure.manager.AccountManager
import com.qflistudio.azure.manager.EventManager
import com.qflistudio.azure.manager.HttpManager
import com.qflistudio.azure.manager.ManagerCenter
import com.qflistudio.azure.manager.SettingsManager
import com.qflistudio.azure.manager.ThemeManager
import com.qflistudio.azure.util.ResUtils
import java.io.File

abstract class BaseFragment<VB : ViewBinding, VM : ViewModel> : Fragment() {

    private var _binding: VB? = null
    protected val binding get() = _binding!!

    protected lateinit var viewModel: VM
    protected lateinit var eventManager: EventManager
    protected lateinit var themeManager: ThemeManager
    protected lateinit var httpManager: HttpManager
    protected lateinit var accountManager: AccountManager
    protected lateinit var settingsManager: SettingsManager
    protected lateinit var managerCenter: ManagerCenter

    protected lateinit var swipeRefreshLayout: SwipeRefreshLayout
    protected lateinit var tipsTv: AppCompatTextView
    protected lateinit var progressBar: ProgressBar
    protected lateinit var recyclerView: RecyclerView

    override fun onAttach(context: Context) {
        super.onAttach(context)
        val activity = (requireActivity() as BaseActivity<*, *>)
        eventManager = activity.getEmInstance()
        themeManager = activity.getThmInstance()
        httpManager = activity.getHmInstance()
        accountManager = activity.getAmInstance()
        settingsManager = activity.getSmInstance()
        managerCenter = activity.getMCInstance()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        _binding = getViewBinding(inflater, container)
        viewModel = ViewModelProvider(requireActivity())[getViewModelClass()]
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    abstract fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?): VB
    abstract fun getViewModelClass(): Class<VM>

    fun initAllComponents(groupBinding: ViewRecyclerviewGroupBinding) {
        initAllComponents(groupBinding, null)
    }

    fun initAllComponents(
        groupBinding: ViewRecyclerviewGroupBinding,
        rvAdapter: RecyclerView.Adapter<*>?,
    ) {
        tipsTv = groupBinding.tipsTvRoot.tipsTv
        progressBar = groupBinding.progressbarRoot.progressbar
        swipeRefreshLayout = groupBinding.swipeRefreshLayout
        recyclerView = groupBinding.recyclerView
        groupBinding.viewRoot.layoutTransition = ResUtils().newLayoutTransition()

        tipsTv.visibility = View.GONE
        progressBar.visibility = View.VISIBLE
        swipeRefreshLayout.setColorSchemeColors(themeManager.themeColors.colorPrimary)
        recyclerView.layoutManager = LinearLayoutManager(requireContext())

        if (rvAdapter != null) {
            recyclerView.adapter = rvAdapter
        }
    }


    fun loadCommonProjectsList(
        projectListAdapter: ProjectFileListAdapter,
        projectList: MutableList<ProjectItem>,
    ) {
        // 使用项目列表数据
        swipeRefreshLayout.isRefreshing = true
        val newProjectsList = mutableListOf<FileItem>()
        projectList.let {
            for (item in it) {
                if (item.projectStatus) {
                    val projectFile = File(item.projectPath)
                    val projectItem = FileItem(
                        item.appName,
                        projectFile,
                        projectFile.isDirectory,
                        "project",
                        "project_dir"
                    )
                    newProjectsList.add(projectItem)
                }
            }
        }
        if (newProjectsList.isEmpty()) {
            // newProjectsList 为空时的处理逻辑
            Log.d("Empty List", "No projects to display")
            tipsTv.visibility = View.VISIBLE
            progressBar.visibility = View.GONE
        } else {
            // newProjectsList 不为空时的处理逻辑
            projectListAdapter.updateList(newProjectsList)
            tipsTv.visibility = View.GONE
            progressBar.visibility = View.GONE
        }
        swipeRefreshLayout.isRefreshing = false
    }

    // 显示提示消息
    fun showViewTip(message: Any) {
        if (message is Int) {
            requireContext().showTip(message)
        } else if (message is String) {
            requireContext().showTip(message)
        }
    }

    fun showRecyclerView() {
        tipsTv.visibility = View.GONE
        progressBar.visibility = View.GONE
        recyclerView.visibility = View.VISIBLE
        swipeRefreshLayout.isRefreshing = false
    }

    fun showTipsTv(textResId: Int, subText: String="") {
        showTipsTv(getString(textResId, subText))
    }

    private fun showTipsTv(text: String) {
        tipsTv.text = text
        tipsTv.visibility = View.VISIBLE
        progressBar.visibility = View.GONE
        swipeRefreshLayout.isRefreshing = false
    }

}
