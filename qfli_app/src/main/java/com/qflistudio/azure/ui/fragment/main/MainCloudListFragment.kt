package com.qflistudio.azure.ui.fragment.main

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.google.gson.Gson
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.CloudSourceListAdapter
import com.qflistudio.azure.base.BaseFragment
import com.qflistudio.azure.bean.CloudSourceItem
import com.qflistudio.azure.bean.ContentResponse
import com.qflistudio.azure.databinding.FragmentMainCloudBinding
import com.qflistudio.azure.manager.HttpManager
import com.qflistudio.azure.viewmodel.MainViewModel
import okhttp3.Call
import java.io.IOException
import android.util.Log

// 内层主页 云端列表
class MainCloudListFragment : BaseFragment<FragmentMainCloudBinding, MainViewModel>() {
    lateinit var projectListAdapter: CloudSourceListAdapter

    val TAG = "MainCloudList"

    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentMainCloudBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        projectListAdapter = CloudSourceListAdapter(requireContext(), managerCenter)
        initAllComponents(binding.mainCloudList, projectListAdapter)

        swipeRefreshLayout.setOnRefreshListener {
            projectListAdapter.clear()
            loadCloudSourceList()
        }

        loadCloudSourceList()

        viewModel.projectsListSearchKey.observe(viewLifecycleOwner) { keyWord ->
            projectListAdapter.filterList(keyWord)
        }
    }

    private fun loadCloudSourceList() {
        httpManager.requestContent(
            "action=query&page=1&page_size=30&mode=1",
            object : HttpManager.RequestCallback {
                override fun onResponse(
                    call: Call?,
                    code: Int,
                    response: okhttp3.Response?,
                ) {
                    val content = response?.body?.string()
                    content?.let {
                        val gson = Gson()
                        val sourceList = mutableListOf<CloudSourceItem>()
                        val apiResponse = gson.fromJson(content, ContentResponse::class.java)

                        if (apiResponse.results.isNotEmpty()) {
                            apiResponse.results.forEach { item ->
                                sourceList.add(item)
                            }
                            showRecyclerView()
                        } else {
                            showTipsTv(R.string.no_data_tips)
                        }
                        projectListAdapter.updateList(sourceList)
                    }
                }

                override fun onFailure(call: Call?, e: IOException?) {
                    showTipsTv(R.string.no_data_tips, e?.message.toString())
                }
            }
        )

    }


}