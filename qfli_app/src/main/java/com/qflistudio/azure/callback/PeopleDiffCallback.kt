package com.qflistudio.azure.callback

import ProjectItem
import androidx.recyclerview.widget.DiffUtil
import com.qflistudio.azure.bean.PeopleItem

class PeopleDiffCallback(
    private val oldList: List<PeopleItem>,
    private val newList: List<PeopleItem>
) : DiffUtil.Callback() {

    override fun getOldListSize(): Int = oldList.size

    override fun getNewListSize(): Int = newList.size

    override fun areItemsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition].objectId == newList[newItemPosition].objectId // 假设 id 唯一标识项目
    }

    override fun areContentsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition] == newList[newItemPosition]
    }
}
