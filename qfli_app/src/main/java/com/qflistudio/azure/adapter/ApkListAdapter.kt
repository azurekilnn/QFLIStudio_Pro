package com.qflistudio.azure.adapter

import ApkItem
import android.annotation.SuppressLint
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.DialogInterface
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.card.MaterialCardView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.qflistudio.azure.R
import com.qflistudio.azure.callback.ApkDiffCallback
import com.qflistudio.azure.common.ktx.installApk
import com.qflistudio.azure.common.ktx.searchKeyWord
import com.qflistudio.azure.manager.ManagerCenter
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.FileUtils
import com.qflistudio.azure.util.ResUtils

class ApkListAdapter(private val context: Context,
                     private val managerCenter: ManagerCenter) :
    RecyclerView.Adapter<ApkListAdapter.ViewHolder>() {
    private var apksList: MutableList<ApkItem> = mutableListOf()
    private var filteredList = apksList
    private var eventManager = managerCenter.getEventManager()

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
            .inflate(R.layout.item_main_rv, parent, false)
        return ViewHolder(view)
    }

    @SuppressLint("SetTextI18n")
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val appItem = filteredList[position]
        holder.appIcon.setImageBitmap(appItem.iconBitmap)
        holder.appName.text = appItem.appName

        val shortApkPath = FileUtils().removeIdeStoragePath(appItem.apkPath)
        val apkSize = appItem.apkSize
        holder.appPackageName.text = "$shortApkPath $apkSize"

        val resUtils = ResUtils()
        holder.projectItem.background = resUtils.getRippleDrawable(context, "circular", 0x3f000000)
        holder.projectItemParent.layoutTransition = resUtils.newLayoutTransition()

        holder.appName.setOnClickListener {
            AzureUtils().copyToClipboard(it.context, appItem.appName)
        }
        holder.appPackageName.setOnClickListener {
            AzureUtils().copyToClipboard(it.context, appItem.apkPath)
        }
        // 跳转到编辑器
        holder.itemView.setOnClickListener {
            context.installApk(appItem.apkPath)
        }

        holder.itemView.setOnLongClickListener {
            val functions = arrayOf(
                context.getString(R.string.rename_text),
                context.getString(R.string.delete),
                context.getString(R.string.backup_tips),
                context.getString(R.string.share_project),
                context.getString(R.string.clone_project),
            )
            val functionsKey = mapOf(
                0 to "rename_project",
                1 to "delete_project",
                2 to "save_project",
                3 to "share_project",
                4 to "clone_project",
            )
            MaterialAlertDialogBuilder(context)
                .setTitle(R.string.project_operation)
                .setItems(
                    functions
                ) { dialog: DialogInterface, which: Int ->
                    dialog.dismiss()
                    //functionsKey[which]?.let { it1 -> eventManager.triggerEvent(it1, tempProjectItem) }
                }
                .setNegativeButton(android.R.string.cancel, null)
                .show()
            true
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
            apksList
        } else {
            apksList.filter { it.appName.searchKeyWord(keyWord) }.toMutableList()
        }
        val diffCallback = ApkDiffCallback(filteredList, newFilteredList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        filteredList = newFilteredList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }

    // 使用 DiffUtil 更新数据
    fun updateList(newList: MutableList<ApkItem>) {
        val diffCallback = ApkDiffCallback(apksList, newList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        apksList = newList
        filteredList = apksList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }

    @SuppressLint("NotifyDataSetChanged")
    fun clear() {
        apksList.clear()
        filteredList.clear()
        notifyDataSetChanged()
    }

    fun addItem(apkItem: ApkItem) {
        apksList.add(apkItem)
        filteredList.add(apkItem)
        notifyItemInserted(filteredList.size - 1)
    }



}
