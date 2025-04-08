package com.qflistudio.azure.adapter

import ProjectItem
import ProjectOpItem
import android.content.Context
import android.content.Intent
import android.os.Build
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.card.MaterialCardView
import com.qflistudio.azure.R
import com.qflistudio.azure.common.ktx.showTip
import com.qflistudio.azure.manager.EventManager
import com.qflistudio.azure.ui.editor.activity.EditorActivityX
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.util.ResUtils


class ProjectOpAdapter(private val context: Context, private val projectItem: ProjectItem, private val eventManager: EventManager, private val editorMode: String) :
    RecyclerView.Adapter<ProjectOpAdapter.ViewHolder>() {
    private val projectPath = projectItem.projectPath
    private val projectUtils = ProjectUtils()

    // 工程操作按钮
    private val projectOpItems = listOf(
        ProjectOpItem(
            R.drawable.twotone_photo_library_black_24,
            context.getString(R.string.open_by_window),
            "open_by_new_window"
        ),
        ProjectOpItem(
            R.drawable.twotone_star_border_black_24,
            context.getString(R.string.collected_project_text),
            "collected_project"
        ),
        ProjectOpItem(
            R.drawable.twotone_file_copy_black_24,
            context.getString(R.string.clone_project),
            "clone_project"
        ),
        ProjectOpItem(
            R.drawable.twotone_settings_black_24,
            context.getString(R.string.project_info_editor),
            "project_info"
        ),
        ProjectOpItem(
            R.drawable.twotone_build_black_24,
            context.getString(R.string.fix_project),
            "fix_project"
        ),
        ProjectOpItem(
            R.drawable.twotone_save_black_24,
            context.getString(R.string.save_project),
            "save_project"
        ),
        ProjectOpItem(
            R.drawable.twotone_open_in_new_black_24,
            context.getString(R.string.share_project),
            "share_project"
        ),
        ProjectOpItem(
            R.drawable.twotone_delete_black_24,
            context.getString(R.string.delete),
            "delete_project"
        ),
    )



    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val itemIcon: ImageView = view.findViewById(R.id.item_imgv)
        val itemTv: TextView = view.findViewById(R.id.item_tv)
        val appItemParent: MaterialCardView = view.findViewById(R.id.itemParent)
        val appItem: LinearLayoutCompat = view.findViewById(R.id.item)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_project_op_gv_rv, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val projectOpItem = projectOpItems[position]
        val projectOpKey = projectOpItem.opKey

        holder.itemIcon.setImageResource(projectOpItem.iconResId)
        holder.itemTv.text = projectOpItem.title
        val resUtils = ResUtils()
        holder.appItem.background = resUtils.getRippleDrawable(context, "circular", 0x3f000000)

        fun checkCollectedStatus() {
            if (projectOpKey == "collected_project") {
                if (projectUtils.checkLocalProjectCollectedStatus(context, projectPath)) {
                    // 已经是收藏的状态
                    projectOpItem.iconResId = R.drawable.twotone_star_black_24
                    projectOpItem.title = context.getString(R.string.cancel_collection_text)
                    holder.itemIcon.setImageResource(projectOpItem.iconResId)
                    holder.itemTv.text = projectOpItem.title
                    projectItem.projectCollectedStatus = true
                } else {
                    // 不是收藏的状态
                    projectOpItem.iconResId = R.drawable.twotone_star_border_black_24
                    projectOpItem.title = context.getString(R.string.collected_project_text)
                    holder.itemIcon.setImageResource(projectOpItem.iconResId)
                    holder.itemTv.text = projectOpItem.title
                    projectItem.projectCollectedStatus = false
                }
            }
        }

        checkCollectedStatus()
        // 跳转到编辑器
        holder.appItem.setOnClickListener {
            when (projectOpKey) {
                "collected_project" -> {
                    if (!projectUtils.checkLocalProjectCollectedStatus(context, projectPath)) {
                        val collectedStatus = projectUtils.collectLocalProject(context, projectPath)
                        if (collectedStatus) {
                            context.showTip("收藏成功")
                        }
                    } else {
                        val cancelCollectedStatus =
                            projectUtils.cancelCollectLocalProject(context, projectPath)
                        if (cancelCollectedStatus) {
                            context.showTip("取消收藏成功")
                        }
                    }
                    checkCollectedStatus() // 更新UI
                }
                else -> eventManager.triggerEvent(projectOpKey, projectItem)
            }

        }
    }

    override fun getItemCount(): Int = projectOpItems.size


}