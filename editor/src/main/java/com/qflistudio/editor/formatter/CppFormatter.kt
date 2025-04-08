package com.qflistudio.editor.formatter

class CppFormatter : BaseFormatter() {
    override fun format(sourceCode: String, indentSize: Int): String {
        // 使用正则表达式进行基本格式化
        val formatted = sourceCode
            // 运算符空格
            .replace(Regex("([=+\\-*/%&|^<>!])(?!=)"), " $1 ")
            // 逗号后空格
            .replace(Regex(",(?!\\s)"), ", ")
            // 分号后换行
            .replace(Regex(";"), ";\n")
            // 控制语句空格
            .replace(Regex("(if|for|while|switch)\\("), "$1 (")

        // 缩进处理
        val sb = StringBuilder()
        var indentLevel = 0
        for (line in formatted.split("\n")) {
            val trimmedLine = line.trim()
            if (trimmedLine.startsWith("}")) indentLevel--
            sb.append(" ".repeat(indentLevel * indentSize))
                .append(trimmedLine).append("\n")
            if (trimmedLine.endsWith("{")) indentLevel++
        }
        return sb.toString()
    }
}
