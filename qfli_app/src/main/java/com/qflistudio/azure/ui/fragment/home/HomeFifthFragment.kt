package com.qflistudio.azure.ui.fragment.home

import ApkItem
import com.qflistudio.azure.util.PathUtils
import ProjectItem
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.qflistudio.azure.adapter.ApkListAdapter
import com.qflistudio.azure.base.BaseFragment
import com.qflistudio.azure.databinding.FragmentHomeFifthBinding
import com.qflistudio.azure.util.ApkUtils
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.viewmodel.MainViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
// 内层主页 第1页
class HomeFifthFragment : BaseFragment<FragmentHomeFifthBinding, MainViewModel>() {
    val TAG = "HomeFifthFragment"
    private lateinit var projectsList: MutableList<ProjectItem>
    private var initStatus: Boolean = false
    lateinit var apksListAdapter: ApkListAdapter

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentHomeFifthBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerViewRoot = binding.localProjectsRvView
        apksListAdapter = ApkListAdapter(requireContext(), managerCenter)
        initAllComponents(recyclerViewRoot, apksListAdapter)

        swipeRefreshLayout.setOnRefreshListener {
            apksListAdapter.clear()
            ProjectUtils().reloadLocalProjectsList(requireContext(), viewModel, swipeRefreshLayout, "cpp")
        }

        swipeRefreshLayout.setOnRefreshListener {
            apksListAdapter.clear()
            val apksList = ApkUtils().getApkList(requireContext(), PathUtils.getStudioExtDir())
            viewModel.setApkItems(apksList)
        }

        // 观察 projectItemsList 的变化
        viewModel.apkItemsList.observe(viewLifecycleOwner) { items ->
            // 使用项目列表数据
            swipeRefreshLayout.isRefreshing = true
            val newApksList = mutableListOf<ApkItem>()
            items?.let {
                for (item in it) {
                    newApksList.add(item)
                }
            }
            if (newApksList.isEmpty()) {
                // newProjectsList 为空时的处理逻辑
                // Log.d("Empty List", "No projects to display")
                tipsTv.visibility = View.VISIBLE
                progressBar.visibility = View.GONE
                initStatus = false
            } else {
                // newProjectsList 不为空时的处理逻辑
                apksListAdapter.updateList(newApksList)
                tipsTv.visibility = View.GONE
                progressBar.visibility = View.GONE
            }
            swipeRefreshLayout.isRefreshing = false
        }

        if (!initStatus) {
            // 使用协程加载apk列表
            CoroutineScope(Dispatchers.Main).launch {
                delay(500)
                val apksList = ApkUtils().getApkList(requireContext(), PathUtils.getStudioExtDir())
                viewModel.setApkItems(apksList)
                initStatus = true
            }
        }

        viewModel.projectsListSearchKey.observe(viewLifecycleOwner) { keyWord ->
            apksListAdapter.filterList(keyWord)
        }
    }


}
