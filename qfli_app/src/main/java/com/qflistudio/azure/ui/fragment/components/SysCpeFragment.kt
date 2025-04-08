package com.qflistudio.azure.ui.fragment.components

// 系统组件

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.qflistudio.azure.adapter.LuaAppListAdapter
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.base.BaseFragment
import com.qflistudio.azure.bean.MyLuaAppItem
import com.qflistudio.azure.databinding.FragmentSyscpeBinding
import com.qflistudio.azure.manager.LuaAppManager
import com.qflistudio.azure.viewmodel.MainViewModel

// 配置工具
class SysCpeFragment : BaseFragment<FragmentSyscpeBinding, MainViewModel>() {
    val TAG = "SysCpeFragment"
    lateinit var appListAdapter: LuaAppListAdapter
    private lateinit var luaAppManager: LuaAppManager

    override fun onAttach(context: Context) {
        super.onAttach(context)
        // 获取 MainActivity 中的 luaAppManager 实例
        luaAppManager = (requireActivity() as BaseActivity<*, *>).getLAmInstance()
        luaAppManager.init(requireContext())
    }

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentSyscpeBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerViewRoot = binding.syscpeRvView

        appListAdapter = LuaAppListAdapter(requireContext(), luaAppManager)
        initAllComponents(recyclerViewRoot, appListAdapter)
        recyclerView.layoutManager =
            StaggeredGridLayoutManager(2, StaggeredGridLayoutManager.VERTICAL)
        swipeRefreshLayout.setOnRefreshListener {
            appListAdapter.clear()
            reloadMyLuaAppList(swipeRefreshLayout)
        }
        // 观察 luaAppItemsList 的变化
        viewModel.luaAppItemsList.observe(viewLifecycleOwner) { items ->
            // 使用项目列表数据
            swipeRefreshLayout.isRefreshing = true
            val newLuaAppItemsList = mutableListOf<MyLuaAppItem>()
            items?.let {
                for (item in it) {
                    newLuaAppItemsList.add(item)
                }
            }
            appListAdapter.updateList(newLuaAppItemsList)
            swipeRefreshLayout.isRefreshing = false
            progressBar.visibility = View.GONE
        }
    }

    private fun reloadMyLuaAppList(swipeRefreshLayout: SwipeRefreshLayout) {
        reloadMyLuaAppList()
        swipeRefreshLayout.isRefreshing = false
        progressBar.visibility = View.GONE
    }

    private fun reloadMyLuaAppList() {
        luaAppManager.init(requireContext())
        // 设置项目列表到 ViewModel
        viewModel.setMyLuaAppItems(luaAppManager.getLuaAppItemsList())
    }
}
