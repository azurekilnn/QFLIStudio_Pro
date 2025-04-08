package com.qflistudio.azure.callback

import androidx.recyclerview.widget.DiffUtil
import com.qflistudio.azure.bean.EditorFileListItem

class EditorFilesDiffCallback(
    private val oldList: List<EditorFileListItem>,
    private val newList: List<EditorFileListItem>
) : DiffUtil.Callback() {

    override fun getOldListSize(): Int = oldList.size

    override fun getNewListSize(): Int = newList.size

    override fun areItemsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition].file == newList[newItemPosition].file
    }

    override fun areContentsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition] == newList[newItemPosition]
    }
}
