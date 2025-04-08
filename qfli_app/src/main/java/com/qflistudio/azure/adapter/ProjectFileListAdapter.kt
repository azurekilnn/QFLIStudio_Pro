package com.qflistudio.azure.adapter

import FileItem
import ProjectItem
import ProjectProcessCallback
import android.annotation.SuppressLint
import android.content.Context
import android.content.DialogInterface
import android.graphics.Bitmap
import android.graphics.BitmapFactory
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
import com.qflistudio.azure.callback.FilesDiffCallback
import com.qflistudio.azure.common.ktx.dpToPx
import com.qflistudio.azure.common.ktx.searchKeyWord
import com.qflistudio.azure.common.ktx.setImage
import com.qflistudio.azure.manager.EventManager
import com.qflistudio.azure.manager.ThemeManager
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.FileUtils
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.util.ResUtils

class ProjectFileListAdapter(
    private var context: Context,
    private val themeManager: ThemeManager,
    private val eventManager: EventManager,
    private val editorMode: String
) :
    RecyclerView.Adapter<ProjectFileListAdapter.FileViewHolder>() {

    private var items: MutableList<FileItem> = mutableListOf()
    private var filteredList: MutableList<FileItem> = items
    private var onItemClick: ((FileViewHolder, Int) -> Unit)? = null
    private var onItemLongClick: ((FileViewHolder, Int) -> Boolean)? = null
    private val fileUtils: FileUtils by lazy { FileUtils() }
    private val themeColors = themeManager.themeColors
    private val defaultBitmap = BitmapFactory.decodeResource(context.resources, R.drawable.icon)

    inner class FileViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val appIcon: ImageView = view.findViewById(R.id.app_icon_id)
        val appName: TextView = view.findViewById(R.id.app_name_id)
        val appPackageName: TextView = view.findViewById(R.id.app_packagename_id)
        val projectItem: LinearLayoutCompat = view.findViewById(R.id.item)
        val projectItemParent: MaterialCardView = view.findViewById(R.id.itemParent)
        val projectOpRvRoot: LinearLayoutCompat = view.findViewById(R.id.project_operation_list_root)
        val projectOpRv: RecyclerView = view.findViewById(R.id.projectOpRv)
        var fileItem: FileItem? = null
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): FileViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_main_rv, parent, false)
        return FileViewHolder(view)
    }

    override fun onBindViewHolder(holder: FileViewHolder, position: Int) {
        val fileItem = filteredList[position]

        holder.appName.text = fileItem.name
        holder.fileItem = fileItem
        holder.appPackageName.text = fileItem.file.absolutePath

        if (position == filteredList.size - 1) {
            val layoutParams = holder.projectItemParent.layoutParams as ViewGroup.MarginLayoutParams
            layoutParams.bottomMargin = 60.dpToPx()
        } else {
            val layoutParams = holder.projectItemParent.layoutParams as ViewGroup.MarginLayoutParams
            layoutParams.bottomMargin = 8.dpToPx()
        }
        val resUtils = ResUtils()
        holder.projectItem.background = resUtils.getRippleDrawable(context, "circular", themeManager.themeColors.rippleColorAccent)
        holder.projectItemParent.layoutTransition = resUtils.newLayoutTransition()

        if (fileItem.file.isDirectory) {
            holder.appIcon.setColorFilter(themeColors.colorAccent)
            holder.appIcon.setImage(R.drawable.twotone_folder_black_24)
        }

        holder.itemView.setOnClickListener {
            if (holder.fileItem?.file?.isDirectory == true) {
                holder.fileItem?.file?.let {
                    AzureUtils().skipToNewEditorActivity(
                        it.absolutePath,
                        context,
                        editorMode
                    )
                }
            }
        }

        holder.itemView.setOnLongClickListener {
            if (holder.fileItem?.file?.isDirectory == true) {
                holder.fileItem?.file?.let {
                    val tempProjectItem = ProjectItem(defaultBitmap, it.name, it.absolutePath, it.absolutePath, true, false, editorMode)

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
                            functionsKey[which]?.let { it1 -> eventManager.triggerEvent(it1, tempProjectItem) }
                        }
                        .setNegativeButton(android.R.string.cancel, null)
                        .show()
                }
            }
            true
        }

    }

    override fun getItemCount(): Int = filteredList.size

    fun filterList(keyWord: String) {
        val newFilteredList = if (keyWord.isEmpty()) {
            items
        } else {
            items.filter { it.name.searchKeyWord(keyWord) }.toMutableList()
        }
        val diffCallback = FilesDiffCallback(filteredList, newFilteredList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)
        filteredList = newFilteredList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }

    // 使用 DiffUtil 更新数据
    fun updateList(newList: MutableList<FileItem>) {
        val diffCallback = FilesDiffCallback(items, newList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        items = newList
        filteredList = items
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
        notifyItemChanged(filteredList.size - 1)
        notifyItemChanged(filteredList.size - 2)
    }


    @SuppressLint("NotifyDataSetChanged")
    fun clear() {
        items.clear()
        notifyDataSetChanged()
    }
}
