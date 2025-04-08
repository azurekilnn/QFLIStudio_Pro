package com.qflistudio.azure.adapter

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.qflistudio.azure.R
import com.qflistudio.azure.bean.MyLuaAppItem
import com.qflistudio.azure.callback.LuaAppDiffCallback
import com.qflistudio.azure.manager.LuaAppManager
import com.qflistudio.azure.util.ResUtils
import java.io.File

class LuaAppListAdapter(private val context: Context, private val luaAppManager: LuaAppManager) :
    RecyclerView.Adapter<LuaAppListAdapter.ViewHolder>() {
    private var myLuaAppItems: MutableList<MyLuaAppItem> = mutableListOf()

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val appNameTv: TextView = view.findViewById(R.id.app_name_tv)
        val appInfoTv: TextView = view.findViewById(R.id.app_info_tv)
        val appItem: LinearLayoutCompat = view.findViewById(R.id.item)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_app_cv_rv, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val appItem = myLuaAppItems[position]
        val appNameKey = appItem.appNameKey
        holder.appInfoTv.text = appItem.appInfo

        val resUtils = ResUtils()

        if (appNameKey == "unknown") {
            holder.appNameTv.text = File(appItem.appPath).name
        } else {
            holder.appNameTv.text = resUtils.getString(context, appNameKey)
        }
        holder.appItem.background = resUtils.getRippleDrawable(context)

        // 点击跳转到详情页面
        holder.itemView.setOnClickListener {
            var dialogMessage =
                context.getString(
                    R.string.activity_info_dlg_message,
                    appItem.appInfo,
                    appItem.versionName,
                    (appItem.versionCode).toString(),
                    appItem.updateLog,
                    appItem.updateTime,
                    appItem.appInitFilePath
                )
            if (appItem.needData) {
                val expandedMessage = "该页面需要传入参数才能正常使用"
                dialogMessage += expandedMessage
            }
            val activityInfoDialog = MaterialAlertDialogBuilder(context, R.style.AlertDialogTheme)
            activityInfoDialog.setTitle(appNameKey)
            activityInfoDialog.setMessage(dialogMessage)
            activityInfoDialog.setCancelable(false)
//            activityInfoDialog.setPositiveButton(context.getString(R.string.skip_text)) { _, _ ->
//                luaAppManager.skipToActivity(appItem)
//            }
            activityInfoDialog.setNegativeButton(context.getString(R.string.cancel_button)) { _, _ ->
            }
            activityInfoDialog.show()
        }

    }

    override fun getItemCount(): Int = myLuaAppItems.size


    // 使用 DiffUtil 更新数据
    fun updateList(newList: MutableList<MyLuaAppItem>) {
        val diffCallback = LuaAppDiffCallback(myLuaAppItems, newList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        myLuaAppItems = newList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }


    @SuppressLint("NotifyDataSetChanged")
    fun clear() {
        myLuaAppItems.clear()
        notifyDataSetChanged()
    }

    fun addItem(appItem: MyLuaAppItem) {
        myLuaAppItems.add(appItem)
        notifyItemInserted(myLuaAppItems.size - 1)
    }
}
