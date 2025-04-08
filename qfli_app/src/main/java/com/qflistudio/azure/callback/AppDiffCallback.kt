package com.qflistudio.azure.callback

import AppItem

import androidx.recyclerview.widget.DiffUtil

class AppDiffCallback(
    private val oldList: List<AppItem>,
    private val newList: List<AppItem>
) : DiffUtil.Callback() {

    override fun getOldListSize(): Int = oldList.size

    override fun getNewListSize(): Int = newList.size

    override fun areItemsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition].appName == newList[newItemPosition].appName // 假设 id 唯一标识项目
    }

    override fun areContentsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition] == newList[newItemPosition]
    }
}
