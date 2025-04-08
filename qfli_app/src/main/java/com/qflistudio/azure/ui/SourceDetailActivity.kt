package com.qflistudio.azure.ui


import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ProgressBar
import androidx.appcompat.widget.AppCompatTextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.HorizontalImageAdapter
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.bean.SourceResponse
import com.qflistudio.azure.common.ktx.getJavaClass
import com.qflistudio.azure.common.ktx.setImage
import com.qflistudio.azure.databinding.ActivitySourceDetailBinding
import com.qflistudio.azure.manager.HttpManager
import com.qflistudio.azure.viewmodel.MainViewModel
import okhttp3.Call
import java.io.IOException

class SourceDetailActivity : BaseActivity<ActivitySourceDetailBinding, MainViewModel>() {
    override val TAG = "SourceDetailActivity"
    private lateinit var sourceSidString: String
    private lateinit var tipsTv: AppCompatTextView
    private lateinit var progressBar: ProgressBar
    private lateinit var swipeRefreshLayout: SwipeRefreshLayout
    private lateinit var recyclerView: RecyclerView
    private lateinit var picsRvAdapter: HorizontalImageAdapter
    private lateinit var context: Context

    override fun getViewModelClass(): Class<MainViewModel> {
        return getJavaClass()
    }

    override fun getViewBindingInstance(): ActivitySourceDetailBinding {
        return ActivitySourceDetailBinding.inflate(layoutInflater)
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        context = this
        initActionBar(viewBinding.toolbarInclude.toolbar, R.string.source_detail)
        tipsTv = viewBinding.tipsTvRoot.tipsTv
        progressBar = viewBinding.progressbarRoot.progressbar
        swipeRefreshLayout = viewBinding.swipeRefreshLayout
        sourceSidString = intent.getStringExtra("sid") ?: "1"

        picsRvAdapter = HorizontalImageAdapter(this)
        viewBinding.sourceDetailPicsRv.layoutManager =
            LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false)
        viewBinding.sourceDetailPicsRv.adapter = picsRvAdapter
        swipeRefreshLayout.setColorSchemeColors(themeColors.colorPrimary)

        loadSourceDetail(sourceSidString)
    }

    private fun loadSourceDetail(sid: String) {
        httpManager.requestContent(
            "action=query&sid=$sid",
            object : HttpManager.RequestCallback {
                override fun onResponse(
                    call: Call?,
                    code: Int,
                    response: okhttp3.Response?
                ) {
                    val content = response?.body?.string()
                    content?.let {
                        Log.i(TAG, content)
                        val gson = Gson()
                        val apiResponse = gson.fromJson(content, SourceResponse::class.java)
                        val sourceItem = apiResponse.results
                        val icon = apiResponse.results.icon
                        Log.i(TAG, apiResponse.results.toString())
                        val picUrls = apiResponse.results.photos
                        Log.i(TAG, "picUrls: $picUrls")
                        // 解析 JSON 为 List<String>
                        val listType = object : TypeToken<List<String>>() {}.type
                        val picUrlsList: List<String> = gson.fromJson(picUrls, listType)

                        if (icon != "") {
                            viewBinding.sourceIconImgv.setImage(icon, context)
                        } else {
                            viewBinding.sourceIconImgv.setImage(R.drawable.icon)
                        }

                        picUrlsList.forEach{ url ->
                            Log.i(TAG, url)
                            picsRvAdapter.addItem(url)
                        }
                        viewBinding.sourceNameTv.text = sourceItem.source_name
                        viewBinding.sourceDesTv.text = sourceItem.description
                        tipsTv.visibility = View.GONE
                        progressBar.visibility = View.GONE
                        swipeRefreshLayout.isRefreshing = false
                    }
                }

                override fun onFailure(call: Call?, e: IOException?) {
                    tipsTv.visibility = View.VISIBLE
                    tipsTv.text = e?.message.toString()
                    swipeRefreshLayout.isRefreshing = false
                }
            }
        )

    }

}