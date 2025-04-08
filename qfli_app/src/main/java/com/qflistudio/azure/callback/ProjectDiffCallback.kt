package com.qflistudio.azure.callback

import ProjectItem
import androidx.recyclerview.widget.DiffUtil

class ProjectDiffCallback(
    private val oldList: List<ProjectItem>,
    private val newList: List<ProjectItem>
) : DiffUtil.Callback() {

    override fun getOldListSize(): Int = oldList.size

    override fun getNewListSize(): Int = newList.size

    override fun areItemsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition].projectPath == newList[newItemPosition].projectPath // 假设 id 唯一标识项目
    }

    override fun areContentsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition] == newList[newItemPosition]
    }
}
