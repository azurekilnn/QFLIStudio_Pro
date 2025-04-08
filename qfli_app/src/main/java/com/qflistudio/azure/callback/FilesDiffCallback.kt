package com.qflistudio.azure.callback

import FileItem
import androidx.recyclerview.widget.DiffUtil

class FilesDiffCallback(
    private val oldList: List<FileItem>,
    private val newList: List<FileItem>
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
