package com.qflistudio.azure.common

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.View.generateViewId
import android.widget.ProgressBar
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet
import com.google.android.material.dialog.MaterialAlertDialogBuilder

class AzureProgressDialog(context: Context) : MaterialAlertDialogBuilder(context) {
    private val TAG = "AzureProgressDialog"

    private var message: String? = null
    private var isIndeterminate: Boolean = true
    private var progress: Int = 0
    private var max: Int = 100

    private lateinit var progressBar: ProgressBar
    private lateinit var messageView: TextView

    private val dialogView: ConstraintLayout = ConstraintLayout(context).apply {
        id = generateViewId()
        layoutParams = ConstraintLayout.LayoutParams(
            ConstraintLayout.LayoutParams.MATCH_PARENT,
            ConstraintLayout.LayoutParams.WRAP_CONTENT
        )
        setPadding(32, 32, 32, 32)
    }

    private var alertDialog: androidx.appcompat.app.AlertDialog? = null

    init {
        setView(dialogView)
    }

    override fun create(): androidx.appcompat.app.AlertDialog {
        val dialog = super.create()
        alertDialog = dialog
        dialog.setOnShowListener {
            Log.i(TAG, "setOnShowListener")
            setupContent()
        }
        return dialog
    }

    private fun setupContent() {
        // Add Message TextView
        messageView = TextView(context).apply {
            text = this@AzureProgressDialog.message
            id = generateViewId()
            // Make the text wrap if needed
            layoutParams = ConstraintLayout.LayoutParams(
                ConstraintLayout.LayoutParams.MATCH_PARENT,
                ConstraintLayout.LayoutParams.WRAP_CONTENT
            )
            setPadding(16, 16, 16, 16)
            gravity = android.view.Gravity.START // Left-align text
            textAlignment = View.TEXT_ALIGNMENT_VIEW_START
        }
        dialogView.addView(messageView)

        // Add ProgressBar
        progressBar = ProgressBar(context, null, android.R.attr.progressBarStyleHorizontal).apply {
            isIndeterminate = this@AzureProgressDialog.isIndeterminate
            max = this@AzureProgressDialog.max
            progress = this@AzureProgressDialog.progress
            id = generateViewId()
            // Set progress bar width to MATCH_PARENT
            layoutParams = ConstraintLayout.LayoutParams(
                ConstraintLayout.LayoutParams.MATCH_PARENT,
                ConstraintLayout.LayoutParams.WRAP_CONTENT
            )
            setPadding(16, 16, 16, 16)
        }
        dialogView.addView(progressBar)

        // Setup Layout Constraints
        val constraintSet = ConstraintSet()
        constraintSet.clone(dialogView)

        // Message TextView constraints (Above the ProgressBar)
        constraintSet.connect(messageView.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP)
        constraintSet.connect(messageView.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START)
        constraintSet.connect(messageView.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END)

        // ProgressBar constraints (Below the Message TextView)
        constraintSet.connect(progressBar.id, ConstraintSet.TOP, messageView.id, ConstraintSet.BOTTOM, 16)
        constraintSet.connect(progressBar.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START)
        constraintSet.connect(progressBar.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END)

        constraintSet.applyTo(dialogView)
    }

    fun setMessage(message: String): AzureProgressDialog {
        this.message = message
        if (::messageView.isInitialized) {
            messageView.text = message
        }
        return this
    }


    fun setIndeterminate(indeterminate: Boolean): AzureProgressDialog {
        this.isIndeterminate = indeterminate
        if (::progressBar.isInitialized) {
            progressBar.isIndeterminate = indeterminate
        }
        return this
    }

    fun setProgress(progress: Int): AzureProgressDialog {
        this.progress = progress
        if (::progressBar.isInitialized) {
            progressBar.progress = progress
        }
        return this
    }

    fun setMax(max: Int): AzureProgressDialog {
        this.max = max
        if (::progressBar.isInitialized) {
            progressBar.max = max
        }
        return this
    }

    fun getProgress(): Int {
        return progress
    }

    fun getMax(): Int {
        return max
    }

    fun dismiss() {
        alertDialog?.dismiss()
    }
}
