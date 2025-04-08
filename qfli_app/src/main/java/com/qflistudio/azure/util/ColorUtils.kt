package com.qflistudio.azure.util

class ColorUtils {
    private val TAG = "ColorUtils"

    fun changeColorStrength(strength: String, color: Int): Int {
        // 获取颜色的十六进制字符串，并去掉前两位"0x"
        val hexColor = Integer.toHexString(color).substring(2)
        // 将strength和修改后的hexColor拼接起来，并转换为十六进制数值
        return "0x$strength$hexColor".toInt(16)
    }
}