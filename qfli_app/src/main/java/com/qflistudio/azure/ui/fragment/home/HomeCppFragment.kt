package com.qflistudio.azure.ui.fragment.home

import ProjectItem
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.qflistudio.azure.adapter.ProjectFileListAdapter
import com.qflistudio.azure.base.BaseFragment
import com.qflistudio.azure.databinding.FragmentHomeCppBinding
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.viewmodel.MainViewModel

// 内层主页 第1页
class HomeCppFragment : BaseFragment<FragmentHomeCppBinding, MainViewModel>() {
    val TAG = "HomeCppFragment"
    private lateinit var projectsList: MutableList<ProjectItem>
    lateinit var projectListAdapter: ProjectFileListAdapter

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentHomeCppBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerViewRoot = binding.cppProjectsRvView
        projectListAdapter = ProjectFileListAdapter(requireContext(), themeManager, eventManager, "cpp")
        initAllComponents(recyclerViewRoot, projectListAdapter)

        swipeRefreshLayout.setOnRefreshListener {
            projectListAdapter.clear()
            ProjectUtils().reloadLocalProjectsList(requireContext(), viewModel, swipeRefreshLayout, "cpp")
        }

        viewModel.cppProjectItemsList.observe(viewLifecycleOwner) { items ->
            items?.let {
                projectsList = it
                loadCommonProjectsList(projectListAdapter, it)
            }
        }

        viewModel.projectsListSearchKey.observe(viewLifecycleOwner) { keyWord ->
            projectListAdapter.filterList(keyWord)
        }
    }


}