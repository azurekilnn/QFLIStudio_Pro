package com.qflistudio.editor.formatter

interface CodeFormatter {
    fun format(sourceCode: String, indentSize: Int): String
}