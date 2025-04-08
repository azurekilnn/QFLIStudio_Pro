package com.qflistudio.azure.adapter

import OperationItem
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.recyclerview.widget.RecyclerView
import com.qflistudio.azure.R
import com.qflistudio.azure.util.ResUtils

class OperationsAdapter(
    private val context: Context,
    private val operationItems: MutableList<OperationItem>
) :
    RecyclerView.Adapter<OperationsAdapter.ViewHolder>() {
    private var onItemClick: ((OperationItem, Int) -> Unit)? = null
    private var onItemLongClick: ((OperationItem, Int) -> Boolean)? = null

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val itemIcon: ImageView = view.findViewById(R.id.item_imgv)
        val itemTv: TextView = view.findViewById(R.id.item_tv)
        val appItem: LinearLayoutCompat = view.findViewById(R.id.item)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_project_op_gv_rv, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        // holder.setIsRecyclable(false)
        val operationItem = operationItems[position]
        val operationTitle = context.getString(operationItem.titleId)

        holder.itemIcon.setImageResource(operationItem.iconResId)

        holder.itemTv.text = operationTitle
        val resUtils = ResUtils()
        holder.appItem.background = resUtils.getRippleDrawable(context)

        holder.appItem.setOnClickListener {
            onItemClick?.invoke(operationItem, position)
        }

        holder.appItem.setOnLongClickListener {
            onItemLongClick?.invoke(operationItem, position) ?: false
        }
    }

    override fun getItemCount(): Int = operationItems.size

    fun setOnItemClick(itemClick: ((OperationItem, Int) -> Unit)) {
        onItemClick = itemClick
    }

    fun setOnItemLongClick(itemLongClick: ((OperationItem, Int) -> Boolean)) {
        onItemLongClick = itemLongClick
    }
}