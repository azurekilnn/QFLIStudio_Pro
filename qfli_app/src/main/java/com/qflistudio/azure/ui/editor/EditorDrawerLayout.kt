package com.qflistudio.azure.ui.editor

import android.content.Context
import android.util.AttributeSet
import android.view.MotionEvent
import android.widget.DrawerLayout
import androidx.recyclerview.widget.RecyclerView
import com.qflistudio.azure.R

class EditorDrawerLayout(context: Context, attrs: AttributeSet) : DrawerLayout(context, attrs) {

    override fun onInterceptTouchEvent(ev: MotionEvent): Boolean {
        // 只有在没有滑动列表的情况下才允许 DrawerLayout 响应触摸事件
        val leftRecyclerView = findViewById<RecyclerView>(R.id.editor_file_rv)
        val rightRecyclerView = findViewById<RecyclerView>(R.id.right_sidebar_recycler_view)
        if (leftRecyclerView != null && leftRecyclerView.canScrollVertically(-1)) {
            // 如果 RecyclerView 可以向上滑动，拦截 DrawerLayout 的触摸事件
            return false
        } else if (rightRecyclerView != null && rightRecyclerView.canScrollVertically(-1)) {
            return false
        }
        return super.onInterceptTouchEvent(ev)
    }
}
