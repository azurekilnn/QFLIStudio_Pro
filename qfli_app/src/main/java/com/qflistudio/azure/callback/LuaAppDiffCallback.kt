package com.qflistudio.azure.callback

import androidx.recyclerview.widget.DiffUtil
import com.qflistudio.azure.bean.MyLuaAppItem

class LuaAppDiffCallback(
    private val oldList: List<MyLuaAppItem>,
    private val newList: List<MyLuaAppItem>
) : DiffUtil.Callback() {

    override fun getOldListSize(): Int = oldList.size

    override fun getNewListSize(): Int = newList.size

    override fun areItemsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition].appInitFilePath == newList[newItemPosition].appInitFilePath
    }

    override fun areContentsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        return oldList[oldItemPosition] == newList[newItemPosition]
    }
}
