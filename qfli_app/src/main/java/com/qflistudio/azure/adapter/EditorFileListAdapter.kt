package com.qflistudio.azure.adapter

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
import com.qflistudio.azure.callback.EditorFilesDiffCallback
import com.qflistudio.azure.common.ktx.setImage
import com.qflistudio.azure.manager.ThemeManager
import com.qflistudio.azure.util.FileUtils

class EditorFileListAdapter(private val themeManager: ThemeManager) :
    RecyclerView.Adapter<EditorFileListAdapter.FileViewHolder>() {

    private var items: MutableList<EditorFileListItem> = mutableListOf()
    private var onItemClick: ((FileViewHolder, Int) -> Unit)? = null
    private var onItemLongClick: ((FileViewHolder, Int) -> Boolean)? = null
    private val fileUtils: FileUtils by lazy { FileUtils() }
    private val themeColors = themeManager.themeColors

    inner class FileViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val fileNameTv: TextView = view.findViewById(R.id.file_name_tv)
        val fileSizeTv: TextView = view.findViewById(R.id.file_size_tv)
        val fileImgv: ImageView = view.findViewById(R.id.file_imgv)
        val fileCheckboxRoot: FrameLayout = view.findViewById(R.id.file_checkbox_root)
        lateinit var fileItem: EditorFileListItem
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): FileViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_file_list, parent, false)
        return FileViewHolder(view)
    }

    override fun onBindViewHolder(holder: FileViewHolder, position: Int) {
        val fileItem = items[position]

        holder.fileItem = fileItem
        holder.fileNameTv.text = fileItem.name

        if (fileItem.isProjectsDir) {
            holder.fileImgv.setColorFilter(themeColors.transparentColor)
            holder.fileImgv.setImage(fileItem.iconBitmap ?: R.drawable.icon)
            holder.fileSizeTv.text = fileItem.packageName
        } else {
            holder.fileSizeTv.text = fileItem.fileSizeText
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
        }

        holder.itemView.setOnClickListener {
            onItemClick?.invoke(holder, position)
        }

        holder.itemView.setOnLongClickListener {
            onItemLongClick?.invoke(holder, position) ?: false
        }

    }

    override fun getItemCount(): Int = items.size


    // 使用 DiffUtil 更新数据
    fun updateList(newList: MutableList<EditorFileListItem>) {
        val diffCallback = EditorFilesDiffCallback(items, newList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        items = newList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }

    fun setAdapterData(data: MutableList<EditorFileListItem>) {
        items = data
        notifyDataSetChanged()
    }

    fun setOnItemClick(itemClick: ((FileViewHolder, Int) -> Unit)) {
        onItemClick = itemClick
    }

    fun setOnItemLongClick(itemLongClick: ((FileViewHolder, Int) -> Boolean)) {
        onItemLongClick = itemLongClick
    }

}
