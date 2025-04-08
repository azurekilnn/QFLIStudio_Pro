package com.qflistudio.azure.adapter


import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.recyclerview.widget.RecyclerView
import com.qflistudio.azure.R
import com.qflistudio.azure.ui.editor.activity.EditorActivity
import com.qflistudio.azure.util.LuaUtils
import com.qflistudio.azure.util.ResUtils
import ProjectItem
import android.annotation.SuppressLint
import android.content.res.Resources
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import com.google.android.material.card.MaterialCardView
import com.qflistudio.azure.callback.ProjectDiffCallback
import com.qflistudio.azure.common.ktx.setImage
import com.qflistudio.azure.manager.EventManager
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.viewmodel.MainViewModel

class CloudProjectListAdapter(private var context: Context, private val eventManager: EventManager, private val editorMode: String) :
    RecyclerView.Adapter<CloudProjectListAdapter.ViewHolder>() {
    private var projectsList: MutableList<ProjectItem> = mutableListOf()

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val appIcon: ImageView = view.findViewById(R.id.app_icon_id)
        val appName: TextView = view.findViewById(R.id.app_name_id)
        val appPackageName: TextView = view.findViewById(R.id.app_packagename_id)
        val projectItem: LinearLayoutCompat = view.findViewById(R.id.item)
        val projectItemParent: MaterialCardView = view.findViewById(R.id.itemParent)
        val projectOpRvRoot: LinearLayoutCompat = view.findViewById(R.id.project_operation_list_root)
        val projectOpRv: RecyclerView = view.findViewById(R.id.projectOpRv)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_main_rv, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val appItem = projectsList[position]
        // holder.appIcon.setImageBitmap(appItem.iconBitmap)
        holder.appIcon.setImage(appItem.iconBitmap)
        holder.appName.text = appItem.appName

        if (position == projectsList.size - 1) {
            val layoutParams = holder.projectItemParent.layoutParams as ViewGroup.MarginLayoutParams
            layoutParams.bottomMargin = 60.dpToPx()
        } else {
            val layoutParams = holder.projectItemParent.layoutParams as ViewGroup.MarginLayoutParams
            layoutParams.bottomMargin = 8.dpToPx()
        }

        if (editorMode != "unknown") {
            holder.appPackageName.text = appItem.packageName
        } else {
            holder.appPackageName.text = appItem.projectPath
        }

        val resUtils = ResUtils()
        holder.projectItem.background = resUtils.getRippleDrawable(context, "circular", 0x3f000000)
        holder.projectItemParent.layoutTransition = resUtils.newLayoutTransition()

        holder.appName.setOnClickListener {
            AzureUtils().copyToClipboard(it.context, appItem.appName)
        }
        holder.appPackageName.setOnClickListener {
            AzureUtils().copyToClipboard(it.context, appItem.packageName)
        }
        // 跳转到编辑器
        holder.itemView.setOnClickListener {
            AzureUtils().skipToNewEditorActivity(appItem.projectPath, it.context, editorMode)
        }

        if (editorMode != "unknown") {
            val projectOpAdapter = ProjectOpAdapter(context, appItem, eventManager, editorMode)
            holder.projectOpRv.layoutManager =
                StaggeredGridLayoutManager(4, StaggeredGridLayoutManager.VERTICAL)
            holder.projectOpRv.adapter = projectOpAdapter

            // 跳转到编辑器
            holder.itemView.setOnLongClickListener {
                if (holder.projectOpRvRoot.visibility != View.VISIBLE) {
                    holder.projectOpRvRoot.visibility = View.VISIBLE
                } else {
                    holder.projectOpRvRoot.visibility = View.GONE
                }
                true
            }
        }
    }

    override fun onViewRecycled(holder: ViewHolder) {
        super.onViewRecycled(holder)
        // 清除控件状态
        holder.projectOpRvRoot.visibility = View.GONE  // 视情况设置默认状态
    }

    override fun getItemCount(): Int = projectsList.size



    // 使用 DiffUtil 更新数据
    fun updateList(newList: MutableList<ProjectItem>) {
        val diffCallback = ProjectDiffCallback(projectsList, newList)
        val diffResult = DiffUtil.calculateDiff(diffCallback)

        projectsList = newList
        diffResult.dispatchUpdatesTo(this) // 通知适配器数据已更新
    }

    @SuppressLint("NotifyDataSetChanged")
    fun clear() {
        projectsList.clear()
        notifyDataSetChanged()
    }

    fun addItem(projectItem: ProjectItem) {
        projectsList.add(projectItem)
        notifyItemInserted(projectsList.size - 1)
    }

    fun skipToLuaActivity(appItem: ProjectItem, context: Context) {
        val args = arrayOf<Any>(appItem.projectPath)
        val intent = LuaUtils().newLSActivityIntent(context, "editor_activity", args, false)
        context.startActivity(intent)
    }


    fun reloadContext(mContext: Context) {
        context = mContext
    }

    fun Int.dpToPx(): Int {
        return (this * Resources.getSystem().displayMetrics.density).toInt()
    }

}
