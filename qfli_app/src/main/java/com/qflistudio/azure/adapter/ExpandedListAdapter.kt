package com.qflistudio.azure.adapter

import OpGroupItem
import OperationItem
import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import com.qflistudio.azure.R
import com.qflistudio.azure.common.ktx.addLayoutTransition
import com.qflistudio.azure.common.ktx.getProjOpItemsCount
import com.qflistudio.azure.common.ktx.startRotateInvertedAnim
import com.qflistudio.azure.common.ktx.startRotateStraightAnim
import com.qflistudio.azure.util.ResUtils
import androidx.core.view.isGone
import androidx.core.view.isVisible


class ExpandedListAdapter(private val context: Context) :
    RecyclerView.Adapter<ExpandedListAdapter.ViewHolder>() {

    private val TAG = "ExpandedListAdapter"
    private var groupItems: MutableList<OpGroupItem> = mutableListOf()
    private var onItemClick: ((OperationItem, Int) -> Unit)? = null
    private var onItemLongClick: ((OperationItem, Int) -> Boolean)? = null

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val opRecyclerViewRoot: LinearLayoutCompat = view.findViewById(R.id.expanded_list_root)
        val groupImgv: AppCompatImageView = view.findViewById(R.id.op_imgv)
        val groupNameTv: AppCompatTextView = view.findViewById(R.id.op_tv)
        val opRecyclerView: RecyclerView = view.findViewById(R.id.op_recycler_view)
        val opExpandBtn: LinearLayoutCompat = view.findViewById(R.id.op_expand_btn)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_expanded_list, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        Log.i(TAG, "onBindViewHolder")
        // 关闭复用
        // holder.setIsRecyclable(false)
        val groupItem = groupItems[position]
        val groupName = context.getString(groupItem.groupNameId)

        val opRecyclerView = holder.opRecyclerView
        val opExpandBtn = holder.opExpandBtn
        val groupImgv = holder.groupImgv

        holder.groupNameTv.text = groupName
        holder.opExpandBtn.background = ResUtils().getRippleDrawable(context)
        //holder.opRecyclerViewRoot.addLayoutTransition()

        val projectOpAdapter = OperationsAdapter(context, groupItem.operations)
        projectOpAdapter.setOnItemClick(onItemClick ?: groupItem.operationsItemClick)
        projectOpAdapter.setOnItemLongClick(onItemLongClick ?: groupItem.operationsItemLongClick)

        opRecyclerView.layoutManager =
            StaggeredGridLayoutManager(context.getProjOpItemsCount(), StaggeredGridLayoutManager.VERTICAL)
        opRecyclerView.adapter = projectOpAdapter

        // 设置展开按钮点击事件
        if (groupItem.isExpanded) {
            holder.opRecyclerView.visibility = View.VISIBLE
            groupImgv.rotation = 180f
        } else {
            holder.opRecyclerView.visibility = View.GONE
            groupImgv.rotation = 0f
        }

        opExpandBtn.setOnClickListener {
            if (opRecyclerView.isGone) {
                // 添加淡入淡出的简单动画
                opRecyclerView.alpha = 0f
                opRecyclerView.animate().alpha(1f).setDuration(300).start()
                opRecyclerView.visibility = View.VISIBLE
                groupImgv.startRotateStraightAnim()
            } else {
                // 添加淡入淡出的简单动画
                opRecyclerView.alpha = 0f
                opRecyclerView.animate().alpha(1f).setDuration(300).start()
                opRecyclerView.visibility = View.GONE
                groupImgv.startRotateInvertedAnim()
            }
            groupItem.isExpanded = (opRecyclerView.isVisible)
        }
    }

    override fun getItemCount(): Int = groupItems.size


    fun setGlobalChildOnItemClick(itemClick: ((OperationItem, Int) -> Unit)) {
        onItemClick = itemClick
    }

    fun setGlobalChildOnItemLongClick(itemLongClick: ((OperationItem, Int) -> Boolean)) {
        onItemLongClick = itemLongClick
    }

    fun addOpGroup(item: OpGroupItem) {
        groupItems.add(item)
    }

    fun setOpGroups(items: MutableList<OpGroupItem>) {
        groupItems = items
    }
}