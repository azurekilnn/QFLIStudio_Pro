package com.qflistudio.azure.common.ktx

import android.animation.LayoutTransition
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.res.Resources
import android.graphics.Bitmap
import android.util.Log
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.view.animation.RotateAnimation
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.widget.TooltipCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.model.GlideUrl
import com.bumptech.glide.load.model.LazyHeaders
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.google.android.material.snackbar.Snackbar
import com.qflistudio.azure.util.AzureUtils
import com.qflistudio.azure.util.DrawableUtils
import java.io.File

private val TAG = "Views"

fun ViewGroup.addLayoutTransition() {
    layoutTransition = LayoutTransition().apply {
        enableTransitionType(LayoutTransition.CHANGING)
        enableTransitionType(LayoutTransition.APPEARING)
        enableTransitionType(LayoutTransition.CHANGE_APPEARING)
        enableTransitionType(LayoutTransition.CHANGE_DISAPPEARING)
        enableTransitionType(LayoutTransition.DISAPPEARING)
    }
}

fun ViewGroup.addAllLayoutTransition() {
    layoutTransition = LayoutTransition().apply {
        enableTransitionType(LayoutTransition.CHANGING)
        enableTransitionType(LayoutTransition.APPEARING)
        enableTransitionType(LayoutTransition.CHANGE_APPEARING)
        enableTransitionType(LayoutTransition.CHANGE_DISAPPEARING)
        enableTransitionType(LayoutTransition.DISAPPEARING)
    }
}

// 顺时针旋转动画
fun View.startRotateStraightAnim() {
    val rotateStraight = RotateAnimation(
        0f, 180f,
        Animation.RELATIVE_TO_SELF, 0.5f,
        Animation.RELATIVE_TO_SELF, 0.5f
    ).apply {
        duration = 256
        fillAfter = true
    }
    this.startAnimation(rotateStraight)
}

// 创建逆时针旋转动画
fun View.startRotateInvertedAnim() {
    val rotateInverted = RotateAnimation(
        180f, 0f,
        Animation.RELATIVE_TO_SELF, 0.5f,
        Animation.RELATIVE_TO_SELF, 0.5f
    ).apply {
        duration = 256 // 动画持续时间
        fillAfter = true // 动画结束后保持状态
    }
    this.startAnimation(rotateInverted)
}


// SnackBar
fun View.showSnackBar(resId: Int) {
    this.showSnackBar(this.resources.getText(resId).toString())
}

fun View.showSnackBar(resId: Int, anchor: Boolean?) {
    this.showSnackBar(this.resources.getText(resId).toString(), anchor)
}

fun View.showSnackBar(message: String) {
    this.showSnackBar(message, null)
}

fun Context.showSnackBar(resId: Int) {
    val activity = this as Activity
    val rootView = activity.window.decorView.findViewById<View>(android.R.id.content)
    val message = this.resources.getText(resId).toString()
    rootView.showSnackBar(message, null)
}

fun Context.showSnackBar(message: String) {
    val activity = this as Activity
    val rootView = activity.window.decorView.findViewById<View>(android.R.id.content)
    rootView.showSnackBar(message, null)
}

fun View.showSnackBar(message: String, anchor: Boolean?) {
    val snackBar = Snackbar.make(this, message, Snackbar.LENGTH_LONG)
        .apply {
            animationMode = Snackbar.ANIMATION_MODE_SLIDE
        }
    if (anchor == true) {
        snackBar.anchorView = this
    }
    snackBar.show()
}

fun Context.showToast(resId: Int) {
    // 加载自定义布局
    //val customView = LayoutInflater.from(activity).inflate(R.layout.layout_system_print, null)
    Toast.makeText(this, resId, Toast.LENGTH_LONG).show()
}

fun Context.showToast(message: String) {
    // 加载自定义布局
    //val customView = LayoutInflater.from(activity).inflate(R.layout.layout_system_print, null)
    Toast.makeText(this, message, Toast.LENGTH_LONG).show()
}

fun Any?.showTip(resId: Int) {
    when (this) {
        is View -> {
            val message = this.resources.getText(resId).toString()
            this.showSnackBar(message)
        }

        is Context -> {
            // 如果 Context 是 Activity，获取其根视图
            val activity = this as? Activity
            if (activity != null) {
                this.showSnackBar(resId)
            } else {
                this.showToast(resId)
            }
        }

        else -> {
            Log.w("showTip", "Unsupported type: $this")
        }
    }
}

fun Any?.showTip(message: String) {
    when (this) {
        is View -> {
            Log.i(TAG, "showTipByView:$message")
            this.showSnackBar(message)
        }

        is Context -> {
            Log.i(TAG, "showTipByContext:$message")
            // 如果 Context 是 Activity，获取其根视图
            val activity = this as? Activity
            if (activity != null) {
                val rootView = activity.window.decorView.findViewById<View>(android.R.id.content)
                rootView.showSnackBar(message)
            } else {
                this.showToast(message)
            }
        }

        else -> {
            Log.w("showTip", "Unsupported type: $this")
        }
    }
}

fun TextView.copyText() {
    AzureUtils().copyToClipboard(context, this.text.toString())
}

fun View.setToolTip(message: String) {
    TooltipCompat.setTooltipText(this, message)
}

fun View.setToolTip(resId: Int) {
    val message = this.context.getText(resId).toString()
    this.setToolTip(message)
}

fun ImageView.setImage(image: Any, context: Context? = null) {
    when (image) {
        is Int -> {
            this.setImageResource(image)
        }

        is Bitmap -> {
            if (context != null) {
                Glide
                    .with(context)
                    .load(image)
                    .into(this)
            } else {
                this.setImageBitmap(image)
            }
        }

        is File -> {
            val imageBitmap = DrawableUtils().fileToBitmap(image)
            this.setImageBitmap(imageBitmap)
        }

        is String -> {
            Log.i(TAG, image)
            val glideUrl = GlideUrl(
                image, LazyHeaders.Builder()
                    .addHeader(
                        "User-Agent",
                        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
                    )
                    .build()
            )

            context?.let {
                Glide
                    .with(it)
                    .load(glideUrl)
                    .transform(RoundedCorners(15))
                    .into(this)
            }
        }
    }
}

@SuppressLint("ClickableViewAccessibility")
fun RecyclerView.autoLockDrawerLayout(drawerLayout: DrawerLayout) {
    this.setOnTouchListener { v, event ->
        when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                // 当手指按下时，锁定 DrawerLayout
                drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED)
            }

            MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                // 当手指松开或取消时，解锁 DrawerLayout
                drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED)
                // 如果是点击事件，调用 performClick
                v.performClick()
            }
        }
        // 返回 false 表示不消耗事件，继续传递给 RecyclerView
        false
    }
}

fun Int.dpToPx(): Int {
    return (this * Resources.getSystem().displayMetrics.density).toInt()
}
