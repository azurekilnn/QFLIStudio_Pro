package com.qflistudio.azure.callback

import java.io.File

interface OnEditorViewCreatedCallback {
    fun onEditorViewCreated(view: Any, file: File)
    fun onEditorViewCreated(view: Any)
}