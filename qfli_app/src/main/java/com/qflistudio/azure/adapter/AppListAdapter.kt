package com.qflistudio.azure.adapter

import AppItem
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView
import com.qflistudio.azure.R
import com.qflistudio.azure.bean.MyLuaAppItem
import com.qflistudio.azure.callback.AppDiffCallback
import com.qflistudio.azure.callback.SourceDiffCallback
import com.qflistudio.azure.common.ktx.searchKeyWord
import com.qflistudio.azure.manager.ThemeManager
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.ResUtils

class AppListAdapter(private val context:Context, private val themeManager: ThemeManager, private val appList: List<AppItem>) :
    RecyclerView.Adapter<AppListAdapter.ViewHolder>() {
    private var filteredList: List<AppItem> = appList

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val appIcon: ImageView = view.findViewById(R.id.app_icon_id)
        val appName: TextView = view.findViewById(R.id.app_name_id)
        val appPackageName: TextView = view.findViewById(R.id.app_packagename_id)
        val appItem: LinearLayoutCompat = view.findViewById(R.id.item)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_mini_cv_rv, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val appItem = filteredList[position]
        holder.appIcon.setImageResource(appItem.iconResId)
        holder.appName.text = appItem.appName
        holder.appPackageName.text = appItem.packageName

        val resUtils = ResUtils()
        holder.appItem.background = resUtils.getRippleDrawable(context, "circular", themeManager.themeColors.rippleColorAccent)

        // 设置点击事件（例如复制文本）
        holder.appName.setOnClickListener {
            AzureUtils().copyToClipboard(it.context, appItem.appName)
        }
        holder.appPackageName.setOnClickListener {
            AzureUtils().copyToClipboard(it.context, appItem.packageName)
        }
        // 点击跳转到详情页面
        holder.itemView.setOnClickListener {
            val intent = Intent(it.context, appItem.targetActivity)
            intent.putExtra("APP_NAME", appItem.appName)
            intent.putExtra("APP_PACKAGE", appItem.packageName)
            it.context.startActivity(intent)
        }
    }

    override fun getItemCount(): Int = filteredList.size


    fun filterList(keyWord: String) {
        val newFilteredList = if (keyWord.isEmpty()) {
            appList
        } else {
            appList.filter { it.appName.searchKeyWord(keyWord) }.toMutableList()
        }
        val diffCallback = AppDiffCallback(filteredList, newFilteredList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        filteredList = newFilteredList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }


}
