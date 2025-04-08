package com.qflistudio.azure.ui.fragment.components

// 插件
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.ProjectFileListAdapter
import com.qflistudio.azure.base.BaseFragment
import com.qflistudio.azure.databinding.FragmentPluginBinding
import com.qflistudio.azure.viewmodel.MainViewModel

// 配置工具
class PluginFragment : BaseFragment<FragmentPluginBinding, MainViewModel>() {
    val TAG = "PluginFragment"
    lateinit var projectListAdapter: ProjectFileListAdapter

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentPluginBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerViewRoot = binding.pluginRvView
        projectListAdapter = ProjectFileListAdapter(requireContext(), themeManager, eventManager, "c")
        initAllComponents(recyclerViewRoot, projectListAdapter)

        swipeRefreshLayout.setOnRefreshListener {
            swipeRefreshLayout.isRefreshing = false
        }
        progressBar.visibility = View.GONE
        showTipsTv(R.string.no_plugins_tips)
    }

}
