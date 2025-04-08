package com.qflistudio.azure.callback

import java.io.IOException

interface OnCodeCallback {
    fun onComplete()
    fun onError(exception: IOException? = null)
}