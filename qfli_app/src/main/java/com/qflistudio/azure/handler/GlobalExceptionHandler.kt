package com.qflistudio.azure.handler

import android.content.Context
import android.content.Intent
import android.os.Process
import android.util.Log
import com.qflistudio.azure.ui.MainActivity
import kotlin.system.exitProcess

class GlobalExceptionHandler(private val context: Context) : Thread.UncaughtExceptionHandler {
    private val defaultHandler: Thread.UncaughtExceptionHandler? =
        Thread.getDefaultUncaughtExceptionHandler()

    override fun uncaughtException(thread: Thread, throwable: Throwable) {

        val restartIntent = Intent(context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            putExtra("EXCEPTION_MESSAGE", throwable.message)
            putExtra("EXCEPTION_STACKTRACE", Log.getStackTraceString(throwable))
        }

        context.startActivity(restartIntent)

        Process.killProcess(Process.myPid())
        exitProcess(0)
    }
}