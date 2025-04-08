package com.qflistudio.azure.ui.fragment.home


import ProjectItem
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.qflistudio.azure.adapter.ProjectFileListAdapter
import com.qflistudio.azure.adapter.ProjectListAdapter
import com.qflistudio.azure.base.BaseFragment
import com.qflistudio.azure.databinding.FragmentHomeThirdBinding
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.viewmodel.MainViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

// 内层主页 第3页
class HomeThirdFragment : BaseFragment<FragmentHomeThirdBinding, MainViewModel>() {
    val TAG = "HomeFirstFragment"
    private lateinit var projectsList: MutableList<ProjectItem>
    lateinit var projectListAdapter: ProjectFileListAdapter

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentHomeThirdBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerViewRoot = binding.collectedProjectsRvView
        val projectListAdapter = ProjectListAdapter(requireContext(), managerCenter, "lua")
        initAllComponents(recyclerViewRoot, projectListAdapter)

        swipeRefreshLayout.setOnRefreshListener {
            projectListAdapter.clear()
            ProjectUtils().reloadLocalProjectsList(
                requireContext(),
                viewModel,
                swipeRefreshLayout,
                "lua"
            )
        }

        fun reloadCollectedProjects(projectList: MutableList<ProjectItem>) {
            // 使用项目列表数据
            swipeRefreshLayout.isRefreshing = true;
            val newProjectsList = mutableListOf<ProjectItem>()
            projectList.let {
                for (item in it) {
                    if (item.projectStatus && item.projectCollectedStatus) {
                        newProjectsList.add(item)
                    }
                }
            }
            if (newProjectsList.isEmpty()) {
                // newProjectsList 为空时的处理逻辑
                tipsTv.visibility = View.VISIBLE
                progressBar.visibility = View.GONE
            } else {
                // newProjectsList 不为空时的处理逻辑
                projectListAdapter.updateList(newProjectsList)
                tipsTv.visibility = View.GONE
                progressBar.visibility = View.GONE
            }
            swipeRefreshLayout.isRefreshing = false;
        }

        // 观察 projectItemsList 的变化
        viewModel.luaProjectItemsList.observe(viewLifecycleOwner) { items ->
            items?.let {
                projectsList = it
                reloadCollectedProjects(it)
            }
        }

        // 观察 listRefreshStatus 的变化
        viewModel.listRefreshStatus.observe(viewLifecycleOwner) { items ->
            // 使用协程加载apk列表
            CoroutineScope(Dispatchers.Main).launch {
                delay(1000)
                reloadCollectedProjects(projectsList)
            }
        }

        viewModel.projectsListSearchKey.observe(viewLifecycleOwner) { keyWord ->
            projectListAdapter.filterList(keyWord)
        }
    }


}