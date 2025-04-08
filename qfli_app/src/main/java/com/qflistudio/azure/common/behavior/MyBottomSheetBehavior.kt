package com.qflistudio.azure.common.behavior

import android.view.MotionEvent
import android.view.View
import androidx.coordinatorlayout.widget.CoordinatorLayout
import com.google.android.material.bottomsheet.BottomSheetBehavior


class MyBottomSheetBehavior<V : View> : BottomSheetBehavior<V>() {

    private var isListScrollable = true

    fun setListScrollable(scrollable: Boolean) {
        isListScrollable = scrollable
    }

    override fun onInterceptTouchEvent(parent: CoordinatorLayout, child: V, event: MotionEvent): Boolean {
        // 如果列表可滑动，则让列表处理事件，否则由 BottomSheet 处理
        return if (!isListScrollable) {
            super.onInterceptTouchEvent(parent, child, event)
        } else {
            false // 不拦截事件，交由子视图处理
        }
    }
}