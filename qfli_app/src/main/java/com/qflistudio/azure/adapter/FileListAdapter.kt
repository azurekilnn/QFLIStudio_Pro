package com.qflistudio.azure.adapter

import FileItem
import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView
import com.qflistudio.azure.R
import com.qflistudio.azure.bean.EditorFileListItem
import com.qflistudio.azure.callback.FilesDiffCallback
import com.qflistudio.azure.common.ktx.searchKeyWord
import com.qflistudio.azure.common.ktx.setImage
import com.qflistudio.azure.manager.ThemeManager
import com.qflistudio.azure.util.FileUtils

class FileListAdapter(
    private var context: Context,
    private val themeManager: ThemeManager,
) :
    RecyclerView.Adapter<FileListAdapter.FileViewHolder>() {

    private var items: MutableList<FileItem> = mutableListOf()
    private var filteredList: MutableList<FileItem> = items
    private var onItemClick: ((FileViewHolder, Int) -> Unit)? = null
    private var onItemLongClick: ((FileViewHolder, Int) -> Boolean)? = null
    private val fileUtils: FileUtils by lazy { FileUtils() }
    private val themeColors = themeManager.themeColors

    inner class FileViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val fileNameTv: TextView = view.findViewById(R.id.file_name_tv)
        val fileSizeTv: TextView = view.findViewById(R.id.file_size_tv)
        val fileImgv: ImageView = view.findViewById(R.id.file_imgv)
        val fileCheckboxRoot: FrameLayout = view.findViewById(R.id.file_checkbox_root)
        lateinit var fileItem: FileItem
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): FileViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_file_list, parent, false)
        return FileViewHolder(view)
    }

    override fun onBindViewHolder(holder: FileViewHolder, position: Int) {
        val fileItem = filteredList[position]

        holder.fileNameTv.text = fileItem.name
        holder.fileItem = fileItem

        holder.fileSizeTv.text = fileItem.file.absolutePath
        if (fileItem.file.isDirectory) {
            holder.fileImgv.setColorFilter(themeColors.colorAccent)
            holder.fileImgv.setImage(R.drawable.twotone_folder_black_24)
        } else {
            if (fileUtils.isImageFile(fileItem.file)) {
                holder.fileImgv.setColorFilter(themeColors.transparentColor)
                holder.fileImgv.setImage(fileItem.file)
            } else {
                holder.fileImgv.setColorFilter(themeColors.colorAccent)
                holder.fileImgv.setImage(fileUtils.getFileTypeImageResId(fileItem.file))
            }
        }

        holder.itemView.setOnClickListener {
            onItemClick?.invoke(holder, position)
        }

        holder.itemView.setOnLongClickListener {
            onItemLongClick?.invoke(holder, position) ?: false
        }

    }

    override fun getItemCount(): Int = filteredList.size


    // 使用 DiffUtil 更新数据
    fun updateList(newList: MutableList<FileItem>) {
        val diffCallback = FilesDiffCallback(items, newList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        items = newList
        filteredList = items
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }

    fun setAdapterData(data: MutableList<FileItem>) {
        items = data
        notifyDataSetChanged()
    }

    fun setOnItemClick(itemClick: ((FileViewHolder, Int) -> Unit)) {
        onItemClick = itemClick
    }

    fun setOnItemLongClick(itemLongClick: ((FileViewHolder, Int) -> Boolean)) {
        onItemLongClick = itemLongClick
    }

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

    @SuppressLint("NotifyDataSetChanged")
    fun clear() {
        items.clear()
        notifyDataSetChanged()
    }
}