package com.qflistudio.azure.util

class StringUtils {

    fun checkSymbols(table: List<String>, key: String): Boolean {
        for (content in table) {
            // 使用 contains 方法检查 key 是否包含 content
            if (key.contains(content)) {
                return true
            }
        }
        return false
    }

    fun checkInvalidSymbol(text: String): Boolean {
        val invalidSymbols =
            listOf("?", "*", ":", "\"", "<", ">", "/", "\\", "|", ",", "!", ";", "'", " ")
        return checkSymbols(invalidSymbols, text)
    }

}