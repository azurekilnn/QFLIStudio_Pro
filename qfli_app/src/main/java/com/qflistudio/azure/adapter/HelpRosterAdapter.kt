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
import com.qflistudio.azure.bean.PeopleItem
import com.qflistudio.azure.callback.PeopleDiffCallback
import com.qflistudio.azure.common.ktx.contactQQ
import com.qflistudio.azure.common.ktx.dpToPx
import com.qflistudio.azure.common.ktx.setImage
import com.qflistudio.azure.manager.HttpManager
import com.qflistudio.azure.util.ResUtils
import android.util.Log

class HelpRosterAdapter(private var context: Context) :
    RecyclerView.Adapter<HelpRosterAdapter.ViewHolder>() {
    private var peopleList: MutableList<PeopleItem> = mutableListOf()
    private var httpManager = HttpManager()
    private var TAG = "HelpRosterAdapter"

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val appIcon: ImageView = view.findViewById(R.id.app_icon_id)
        val appName: TextView = view.findViewById(R.id.app_name_id)
        val appPackageName: TextView = view.findViewById(R.id.app_packagename_id)
        val projectItem: LinearLayoutCompat = view.findViewById(R.id.item)
        val projectItemParent: MaterialCardView = view.findViewById(R.id.itemParent)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_main_rv, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val appItem = peopleList[position]
        val qqHeader = httpManager.getQQHeaderUrl(appItem.qq)
        Log.i(TAG, qqHeader)
        holder.appIcon.setImage(qqHeader, context)
        holder.appName.text = appItem.name

        if (position == peopleList.size - 1) {
            val layoutParams = holder.projectItemParent.layoutParams as ViewGroup.MarginLayoutParams
            layoutParams.bottomMargin = 60.dpToPx()
        } else {
            val layoutParams = holder.projectItemParent.layoutParams as ViewGroup.MarginLayoutParams
            layoutParams.bottomMargin = 8.dpToPx()
        }

        holder.appPackageName.text = appItem.createdAt

        val resUtils = ResUtils()
        holder.projectItem.background = resUtils.getRippleDrawable(context, "circular", 0x3f000000)
        holder.projectItemParent.layoutTransition = resUtils.newLayoutTransition()
        // 跳转到编辑器
        holder.itemView.setOnClickListener {
            context.contactQQ(appItem.qq)
        }
    }

    override fun getItemCount(): Int = peopleList.size

    // 使用 DiffUtil 更新数据
    fun updateList(newList: MutableList<PeopleItem>) {
        val diffCallback = PeopleDiffCallback(peopleList, newList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)
        peopleList = newList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }

    @SuppressLint("NotifyDataSetChanged")
    fun clear() {
        peopleList.clear()
        notifyDataSetChanged()
    }

}
