package com.qflistudio.azure.bean

import com.qflistudio.azure.editor.CodeEditor
import io.github.rosemoe.sora.lang.Language
import java.io.File

data class EditorInfo(
    var editorLanguage: Language,
    var editorMode: String,
    var file: File? = null
)

