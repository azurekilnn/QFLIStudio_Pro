package com.qflistudio.azure.util
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.Locale

object MD5Utils {
    fun encrypt(input: String): String {
        return try {
            val md = MessageDigest.getInstance("MD5")
            val byteArray = md.digest(input.toByteArray())
            val hexString = StringBuilder()
            for (byte in byteArray) {
                val hex = Integer.toHexString(0xFF and byte.toInt())
                if (hex.length == 1) {
                    hexString.append('0')
                }
                hexString.append(hex)
            }
            hexString.toString().uppercase(Locale.getDefault())
        } catch (e: NoSuchAlgorithmException) {
            e.printStackTrace()
            ""
        }
    }
}
