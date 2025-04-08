package com.qflistudio.azure.callback

import ProjectItem
import androidx.recyclerview.widget.DiffUtil
import com.qflistudio.azure.bean.CloudSourceItem

class SourceDiffCallback(
    private val oldList: List<CloudSourceItem>,
    private val newList: List<CloudSourceItem>
) : DiffUtil.Callback() {

    override fun getOldListSize(): Int = oldList.size

    override fun getNewListSize(): Int = newList.size

    override fun areItemsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition].sid == newList[newItemPosition].sid // 假设 id 唯一标识项目
    }

    override fun areContentsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition] == newList[newItemPosition]
    }
}
