package com.qflistudio.azure.ui

import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ProgressBar
import androidx.appcompat.widget.AppCompatTextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.google.gson.Gson
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.HelpRosterAdapter
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.bean.ApiResponse
import com.qflistudio.azure.bean.PeopleItem
import com.qflistudio.azure.common.ktx.getJavaClass
import com.qflistudio.azure.databinding.ActivityHelpRosterBinding
import com.qflistudio.azure.manager.HttpManager
import com.qflistudio.azure.viewmodel.MainViewModel
import okhttp3.Call
import java.io.IOException

class HelpRosterActivity : BaseActivity<ActivityHelpRosterBinding, MainViewModel>() {
    private lateinit var helpRosterAdapter: HelpRosterAdapter
    private lateinit var tipsTv: AppCompatTextView
    private lateinit var progressBar: ProgressBar
    private lateinit var swipeRefreshLayout: SwipeRefreshLayout

    override fun getViewModelClass(): Class<MainViewModel> {
        return getJavaClass()
    }

    override fun getViewBindingInstance(): ActivityHelpRosterBinding {
        return ActivityHelpRosterBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initActionBar(viewBinding.toolbarInclude.toolbar, R.string.help_roster)

        val localProjectsRvView = viewBinding.localProjectsRvView
        val localProjectRv = localProjectsRvView.recyclerView
        swipeRefreshLayout = localProjectsRvView.swipeRefreshLayout

        tipsTv = localProjectsRvView.tipsTvRoot.tipsTv
        progressBar = localProjectsRvView.progressbarRoot.progressbar

        tipsTv.visibility = View.GONE
        progressBar.visibility = View.GONE

        helpRosterAdapter = HelpRosterAdapter(this)
        // 设置LayoutManager
        localProjectRv.layoutManager = LinearLayoutManager(this)
        localProjectRv.adapter = helpRosterAdapter

        swipeRefreshLayout.setColorSchemeColors(themeColors.colorPrimary)
        swipeRefreshLayout.setOnRefreshListener {
            helpRosterAdapter.clear()
            loadHelpRoster()
        }
        loadHelpRoster()
    }

    private fun loadHelpRoster() {
        swipeRefreshLayout.isRefreshing = true
        val peopleItemsList = mutableListOf<PeopleItem>()
        httpManager.requestApi(
            "action=help_roster",
            object : HttpManager.RequestCallback {
                override fun onResponse(
                    call: Call?,
                    code: Int,
                    response: okhttp3.Response?
                ) {
                    val content = response?.body?.string()
                    content?.let {
                        val gson = Gson()
                        val apiResponse = gson.fromJson(content, ApiResponse::class.java)

                        apiResponse.results.forEach { item ->
                            val people = PeopleItem(
                                item["name"].toString(),
                                item["qq"].toString(),
                                item["objectId"].toString(),
                                item["createdAt"].toString(),
                                item["updatedAt"].toString()
                            )
                            Log.i(TAG, people.toString())
                            peopleItemsList.add(people)
                        }
                        helpRosterAdapter.updateList(peopleItemsList)
                        swipeRefreshLayout.isRefreshing = false
                    }
                }

                override fun onFailure(call: Call?, e: IOException?) {
                    Log.e(TAG, e?.message.toString())
                    tipsTv.visibility = View.VISIBLE
                    tipsTv.text = e?.message.toString()
                    swipeRefreshLayout.isRefreshing = false
                }
            })
    }

}