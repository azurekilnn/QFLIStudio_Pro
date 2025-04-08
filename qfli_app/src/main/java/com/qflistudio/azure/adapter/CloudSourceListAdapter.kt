package com.qflistudio.azure.adapter


import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Resources
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.card.MaterialCardView
import com.qflistudio.azure.R
import com.qflistudio.azure.bean.CloudSourceItem
import com.qflistudio.azure.callback.ProjectDiffCallback
import com.qflistudio.azure.callback.SourceDiffCallback
import com.qflistudio.azure.common.ktx.dpToPx
import com.qflistudio.azure.common.ktx.searchKeyWord
import com.qflistudio.azure.common.ktx.setImage
import com.qflistudio.azure.manager.EventManager
import com.qflistudio.azure.manager.ManagerCenter
import com.qflistudio.azure.manager.ThemeManager
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.ResUtils

class CloudSourceListAdapter(
    private var context: Context,
    private val managerCenter: ManagerCenter
) :
    RecyclerView.Adapter<CloudSourceListAdapter.ViewHolder>() {
    private var projectsList: MutableList<CloudSourceItem> = mutableListOf()
    private var filteredList: MutableList<CloudSourceItem> = projectsList
    private val themeManager = managerCenter.getThemeManager()
    private val eventManager = managerCenter.getEventManager()

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val appIcon: ImageView = view.findViewById(R.id.app_icon_id)
        val appName: TextView = view.findViewById(R.id.app_name_id)
        val appPackageName: TextView = view.findViewById(R.id.app_packagename_id)
        val projectItem: LinearLayoutCompat = view.findViewById(R.id.item)
        val projectItemParent: MaterialCardView = view.findViewById(R.id.itemParent)
        val projectOpRvRoot: LinearLayoutCompat =
            view.findViewById(R.id.project_operation_list_root)
        val projectOpRv: RecyclerView = view.findViewById(R.id.projectOpRv)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_source_rv, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val appItem = filteredList[position]
        // holder.appIcon.setImageBitmap(appItem.iconBitmap)
        if (appItem.icon != "") {
            holder.appIcon.setImage(appItem.icon)
        } else {
            holder.appIcon.setImage(R.drawable.icon)
        }
        holder.appName.text = appItem.source_name

        if (position == filteredList.size - 1) {
            val layoutParams = holder.projectItemParent.layoutParams as ViewGroup.MarginLayoutParams
            layoutParams.bottomMargin = 60.dpToPx()
        } else {
            val layoutParams = holder.projectItemParent.layoutParams as ViewGroup.MarginLayoutParams
            layoutParams.bottomMargin = 8.dpToPx()
        }

        holder.appPackageName.text = appItem.description

        val resUtils = ResUtils()
        holder.projectItem.background = resUtils.getRippleDrawable(context, "circular", themeManager.themeColors.rippleColorAccent)
        holder.projectItemParent.layoutTransition = resUtils.newLayoutTransition()

        holder.appName.setOnLongClickListener {
            AzureUtils().copyToClipboard(it.context, appItem.source_name)
            true
        }
        holder.appPackageName.setOnLongClickListener {
            AzureUtils().copyToClipboard(it.context, appItem.description)
            true
        }
        // 跳转到编辑器
        holder.itemView.setOnClickListener {
            AzureUtils().skipToSourceDetailActivity(it.context, appItem.sid.toString())
        }
    }

    override fun onViewRecycled(holder: ViewHolder) {
        super.onViewRecycled(holder)
        // 清除控件状态
        holder.projectOpRvRoot.visibility = View.GONE  // 视情况设置默认状态
    }

    override fun getItemCount(): Int = filteredList.size

    fun filterList(keyWord: String) {
        val newFilteredList = if (keyWord.isEmpty()) {
            projectsList
        } else {
            projectsList.filter { it.source_name.searchKeyWord(keyWord) || it.description.searchKeyWord(keyWord) }.toMutableList()
        }
        val diffCallback = SourceDiffCallback(filteredList, newFilteredList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        filteredList = newFilteredList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }


    // 使用 DiffUtil 更新数据
    fun updateList(newList: MutableList<CloudSourceItem>) {
        val diffCallback = SourceDiffCallback(projectsList, newList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        projectsList = newList
        filteredList = projectsList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }

    @SuppressLint("NotifyDataSetChanged")
    fun clear() {
        projectsList.clear()
        filteredList.clear()
        notifyDataSetChanged()
    }

    fun addItem(projectItem: CloudSourceItem) {
        projectsList.add(projectItem)
        filteredList.add(projectItem)
        notifyItemInserted(projectsList.size - 1)
    }


}
