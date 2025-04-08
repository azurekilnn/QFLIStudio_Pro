package com.qflistudio.azure.network

import android.util.Log
import okhttp3.Cookie
import okhttp3.CookieJar
import okhttp3.HttpUrl

class MyCookieJar : CookieJar {
    private val cookieStore = mutableListOf<Cookie>()
    private val TAG = "MyCookieJar"

    override fun saveFromResponse(url: HttpUrl, cookies: List<Cookie>) {
        cookies.forEach { cookie ->
            cookieStore.add(cookie)  // 保存每个 cookie
        }
    }

    override fun loadForRequest(url: HttpUrl): List<Cookie> {
        val cookies = cookieStore.filter { it.matches(url) } // 根据 URL 过滤返回 cookies
        Log.i(TAG, "loadForRequest$cookies")
        return cookies
    }

    fun deleteCookies(url: HttpUrl) {
        val iterator = cookieStore.iterator()
        while (iterator.hasNext()) {
            val cookie = iterator.next()
            if (cookie.matches(url)) {
                iterator.remove() // 移除匹配的 cookie
                Log.i(TAG, "Deleted cookie: $cookie")
            }
        }
    }
}
