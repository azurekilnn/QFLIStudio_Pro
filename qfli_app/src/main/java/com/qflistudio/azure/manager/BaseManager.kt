package com.qflistudio.azure.manager

import android.content.Context

interface BaseManager {
    fun init() {}
    fun init(context: Context)
}