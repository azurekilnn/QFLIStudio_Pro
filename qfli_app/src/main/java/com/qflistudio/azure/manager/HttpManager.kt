package com.qflistudio.azure.manager


import android.os.Handler
import android.os.Looper
import android.util.Log
import com.qflistudio.azure.network.MyCookieJar
import com.qflistudio.azure.util.AzureUtils
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Dispatcher
import okhttp3.HttpUrl
import okhttp3.HttpUrl.Companion.toHttpUrl
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.Response
import java.io.IOException
import java.net.CookieManager
import java.net.CookiePolicy
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

class HttpManager {
    private val TAG = "HttpManager"
    private val myDomainName = "https://lqsxm666.top"
    private val mainApi = "$myDomainName/api"
    private val v2Api = "$mainApi/v2"
    private val handler = Handler(Looper.getMainLooper())
    private val okHttpClientBuilder: OkHttpClient.Builder? = null
    var okHttpClient: OkHttpClient? = null
    private lateinit var cookieJar: MyCookieJar

    fun getApiUrl(path: String): String {
        return "$myDomainName/$path"
    }

    fun getV2Api(api: String): String {
        val fullApi = "$v2Api/$api"
        Log.d(TAG, fullApi)
        return fullApi
    }

    fun getApi(api: String): String {
        return "$mainApi/$api"
    }

    fun init(threadCount: Int) {
        val cookieManager = CookieManager()
        cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ALL)

        cookieJar = MyCookieJar()

        okHttpClient = OkHttpClient.Builder()
            .cookieJar(cookieJar)
            .dispatcher(Dispatcher(Executors.newFixedThreadPool(threadCount)))
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build()
    }

    fun getClient(): OkHttpClient? {
        return okHttpClient
    }

    fun getCookieJar(): MyCookieJar? {
        if (::cookieJar.isInitialized) {
            return cookieJar
        }
        return null
    }

    fun deleteCookies(url: String) {
        val urlToDelete = url.toHttpUrl()
        deleteCookies(urlToDelete)
    }

    fun deleteCookies(url: HttpUrl) {
        cookieJar.deleteCookies(url)
    }

    private fun enqueue(request: Request, callback: RequestCallback?) {
        okHttpClient?.newCall(request)?.enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                handler.post {
                    callback?.onFailure(call, e)
                }
            }

            override fun onResponse(call: Call, response: Response) {
                handler.post {
                    callback?.onResponse(call, response.code, response)
                }
            }
        })
    }

    interface RequestCallback {
        fun onResponse(call: Call?, code: Int, response: Response?)

        fun onFailure(call: Call?, e: IOException?)
    }

    private fun get(url: String, callback: RequestCallback?) {
        val request = Request.Builder()
            .url(url)
            .get()
            .build()
        enqueue(request, callback)
    }

    private fun post(url: String, requestBody: RequestBody, cookies: List<String>?, callback: RequestCallback?) {
        val requestBuilder = Request.Builder()
        cookies?.forEach{ cookie ->
            requestBuilder.addHeader("Cookie", cookie)
        }
        requestBuilder.url(url)
        requestBuilder.post(requestBody)
        val request = requestBuilder.build()
        enqueue(request, callback)
    }

    private fun post(url: String, requestBody: RequestBody, callback: RequestCallback?) {
        post(url, requestBody, null, callback)
    }

    fun getUrl(url: String, callback: RequestCallback?) {
        get(url, callback)
    }

    fun postUrl(url: String, postBody: String, cookies: List<String>?, callback: RequestCallback?) {
        val requestMediaType =
            "application/x-www-form-urlencoded; charset=UTF-8".toMediaTypeOrNull()

        val requestBody = RequestBody.create(
            requestMediaType,
            postBody
        )
        post(url, requestBody, cookies, callback)
    }

    fun postUrl(url: String, postBody: String, callback: RequestCallback?) {
        postUrl(url, postBody, null, callback)
    }

    fun requestApi(postBody: String, callback: RequestCallback?) {
        requestApi("${mainApi}/api.php", postBody, callback)
    }

    fun requestApi(api: String, postBody: String, callback: RequestCallback?) {
        requestApi(api, postBody, null, callback)
    }

    fun requestApi(api: String, postBody: String, cookie: List<String>?, callback: RequestCallback?) {
        val currentTime = System.currentTimeMillis().toString()
        val localKey = AzureUtils().generateKey(currentTime)
        val realPostBody = "${postBody}&time=${currentTime}&key=${localKey}"

        if (cookie !=null) {
            postUrl(api, realPostBody, cookie, callback)
        } else {
            postUrl(api, realPostBody, callback)
        }
    }

    fun requestContent(postBody: String, callback: RequestCallback?) {
        requestApi("${mainApi}/content.php", postBody, callback)
    }

    fun getQQHeaderUrl(qq: String): String {
        //return "http://q.qlogo.cn/headimg_dl?dst_uin=$qq&spec=640&img_type=jpg"
        return "${mainApi}/api.php?action=qq_image&uid=$qq"
    }

    fun getFullUrl(url: String): String {
        return url.replace("../", "$myDomainName/")
    }


}