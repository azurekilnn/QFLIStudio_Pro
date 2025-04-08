package com.qflistudio.azure.ui.fragment.home

import ProjectItem
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.qflistudio.azure.adapter.ProjectListAdapter
import com.qflistudio.azure.databinding.FragmentHomeFirstBinding
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.viewmodel.MainViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

// 内层主页 第1页
import com.qflistudio.azure.adapter.ProjectFileListAdapter
import com.qflistudio.azure.base.BaseFragment

// 内层主页 第1页
class HomeFirstFragment : BaseFragment<FragmentHomeFirstBinding, MainViewModel>() {
    val TAG = "HomeFirstFragment"
    private lateinit var projectsList: MutableList<ProjectItem>
    lateinit var projectListAdapter: ProjectFileListAdapter

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentHomeFirstBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerViewRoot = binding.localProjectsRvView
        val projectListAdapter = ProjectListAdapter(requireContext(), managerCenter, "lua")
        initAllComponents(recyclerViewRoot, projectListAdapter)

        swipeRefreshLayout.setOnRefreshListener {
            projectListAdapter.clear()
            ProjectUtils().reloadLocalProjectsList(requireContext(), viewModel, swipeRefreshLayout, "lua")
        }

        fun reloadLocalProjects(projectList: MutableList<ProjectItem>) {
            // 使用项目列表数据
            swipeRefreshLayout.isRefreshing = true;
            val newProjectsList = mutableListOf<ProjectItem>()
            projectList.let {
                for (item in it) {
                    if (item.projectStatus) {
                        newProjectsList.add(item)
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

        // 观察 projectItemsList 的变化
        viewModel.luaProjectItemsList.observe(viewLifecycleOwner) { items ->
            items?.let {
                projectsList = it
                reloadLocalProjects(it)
                projectListAdapter.reloadContext(requireContext())
            }
        }

        // 观察 listRefreshStatus 的变化
        viewModel.listRefreshStatus.observe(viewLifecycleOwner) { items ->
            CoroutineScope(Dispatchers.Main).launch {
                delay(1000)
                reloadLocalProjects(projectsList)
                projectListAdapter.reloadContext(requireContext())
            }
        }

        viewModel.projectsListSearchKey.observe(viewLifecycleOwner) { keyWord ->
            projectListAdapter.filterList(keyWord)
        }
    }


}