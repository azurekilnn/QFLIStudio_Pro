package com.qflistudio.azure.ui.fragment.main

import AppItem
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.AppListAdapter
import com.qflistudio.azure.adapter.HelpRosterAdapter
import com.qflistudio.azure.base.BaseFragment
import com.qflistudio.azure.databinding.FragmentMainBinding
import com.qflistudio.azure.ui.HelpRosterActivity
import com.qflistudio.azure.ui.termux.activity.TermuxActivity
import com.qflistudio.azure.viewmodel.MainViewModel

// 内层主页 云端列表
class MainFragment : BaseFragment<FragmentMainBinding, MainViewModel>() {
    lateinit var projectListAdapter: AppListAdapter

    val TAG = "MainFragment"

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentMainBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // 创建数据
        val appList = listOf(
            AppItem(
                R.drawable.twotone_groups_black_24,
                getString(R.string.help_roster),
                "com.qflistudio.help_roster",
                HelpRosterActivity::class.java
            ),
            AppItem(
                R.drawable.twotone_terminal_black_24,
                "termux",
                "com.qflistudio.termux",
                TermuxActivity::class.java
//              com.termux.app.TermuxActivity::class.java
            )
        )
        projectListAdapter = AppListAdapter(requireContext(), themeManager, appList)
        initAllComponents(binding.mainModeRvRoot, projectListAdapter)
        progressBar.visibility = View.GONE
        tipsTv.text = requireContext().getString(R.string.no_data_tips)

        swipeRefreshLayout.setOnRefreshListener {
            swipeRefreshLayout.isRefreshing = false
        }
        viewModel.projectsListSearchKey.observe(viewLifecycleOwner) { keyWord ->
            projectListAdapter.filterList(keyWord)
        }
    }



}


