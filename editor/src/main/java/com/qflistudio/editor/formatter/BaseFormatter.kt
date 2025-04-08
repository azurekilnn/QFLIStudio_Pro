package com.qflistudio.editor.formatter

abstract class BaseFormatter : CodeFormatter {
    protected val DEFAULT_INDENT = 4

    protected fun normalizeLineEndings(input: String): String {
        return input.replace(Regex("\\r\\n?"), "\n")
    }

    protected fun handleBraces(code: String): String {
        // 通用的大括号处理逻辑
        return code.replace(Regex("\\s*\\n\\s*\\{"), " {")
    }
}