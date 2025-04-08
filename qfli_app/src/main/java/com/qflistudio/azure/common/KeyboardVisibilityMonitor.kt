package com.qflistudio.azure.common

import android.app.Activity
import android.graphics.Rect
import android.view.View
import android.view.ViewTreeObserver
import android.view.ViewTreeObserver.OnGlobalLayoutListener

class KeyboardVisibilityMonitor(
    private val activity: Activity,
    private val callback: (isVisible: Boolean) -> Unit
) {
    private val rootView: View = activity.window.decorView.findViewById(android.R.id.content)
    private var lastVisibleHeight = 0
    private val defaultKeyboardHeightDP = 100 // 认为键盘高度至少100dp时才算弹出
    private val rect = Rect()

    private val globalLayoutListener = OnGlobalLayoutListener {
        rootView.getWindowVisibleDisplayFrame(rect)
        val visibleHeight = rect.height()

        if (lastVisibleHeight == 0) {
            lastVisibleHeight = visibleHeight
            return@OnGlobalLayoutListener
        }

        if (lastVisibleHeight == visibleHeight) return@OnGlobalLayoutListener

        val heightDifference = Math.abs(visibleHeight - lastVisibleHeight)
        val density = activity.resources.displayMetrics.density
        val keyboardHeight = heightDifference / density

        if (keyboardHeight > defaultKeyboardHeightDP) {
            callback(visibleHeight < lastVisibleHeight)
        }

        lastVisibleHeight = visibleHeight
    }

    init {
        rootView.viewTreeObserver.addOnGlobalLayoutListener(globalLayoutListener)
    }

    fun detach() {
        rootView.viewTreeObserver.removeOnGlobalLayoutListener(globalLayoutListener)
    }
}