package com.qflistudio.azure.callback

import ApkItem
import androidx.recyclerview.widget.DiffUtil

class ApkDiffCallback(
    private val oldList: List<ApkItem>,
    private val newList: List<ApkItem>
) : DiffUtil.Callback() {

    override fun getOldListSize(): Int = oldList.size

    override fun getNewListSize(): Int = newList.size

    override fun areItemsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition].apkPath == newList[newItemPosition].apkPath // 假设 id 唯一标识项目
    }

    override fun areContentsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition] == newList[newItemPosition]
    }
}
