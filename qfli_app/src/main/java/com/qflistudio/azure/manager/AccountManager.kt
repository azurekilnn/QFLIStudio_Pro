package com.qflistudio.azure.manager

import com.qflistudio.azure.util.PathUtils
import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit
import com.google.gson.Gson
import com.qflistudio.azure.bean.UserInfoItem
import com.qflistudio.azure.manager.HttpManager.RequestCallback
import com.qflistudio.azure.util.JsonUtils
import java.io.File

class AccountManager : BaseManager {
    private lateinit var httpManager: HttpManager
    private lateinit var accountApi: String
    private lateinit var currContext: Context
    private var jsonUtils = JsonUtils()
    private var gson = Gson()
    private lateinit var cookieFilePath: String
    private lateinit var checkCodeApi: String
    lateinit var currUserInfo: UserInfoItem
    lateinit var sharedPreferences: SharedPreferences
    var isLogin = false

    override fun init(thisContext: Context) {
        currContext = thisContext
        sharedPreferences = currContext.getSharedPreferences("userStorage", Context.MODE_PRIVATE)
        // 初始化cookie文件
        cookieFilePath = PathUtils.getFilesDir(currContext) + "/cookies"
    }

    // 初始化用户信息管理器
    fun init(thisContext: Context, thisManager: HttpManager) {
        init(thisContext)
        httpManager = thisManager
        accountApi = httpManager.getV2Api("account.php")
        checkCodeApi = httpManager.getApiUrl("include/lib/checkcode.php")
        getUserInfo()
    }


    // 请求用户API接口
    fun requestAccountApi(postBody: String, cookie: List<String>, callback: RequestCallback?) {
        if (::httpManager.isInitialized && ::accountApi.isInitialized) {
            httpManager.requestApi(accountApi, postBody, cookie, callback)
        }
    }

    fun queryAccountInfo(cookies: List<String>, callback: RequestCallback?) {
        val postBody = "action=userinfo"
        requestAccountApi(postBody, cookies, callback)
    }

    fun loginAccount(
        username: String,
        password: String,
        loginCode: String,
        cookies: List<String>,
        callback: RequestCallback?,
    ) {
        val postBody = "action=dosignin&user=$username&pw=$password&login_code=$loginCode"
        requestAccountApi(postBody, cookies, callback)
    }

    fun regAccount(
        username: String,
        mail: String,
        password: String,
        loginCode: String,
        mailCode: String,
        cookies: List<String>,
        callback: RequestCallback?,
    ) {
        val postBody =
            "action=dosignup&username=$username&mail=$mail&passwd=$password&login_code=$loginCode&mail_code=$mailCode"
        requestAccountApi(postBody, cookies, callback)
    }

    fun sendEmailCode(mail: String, cookies: List<String>, callback: RequestCallback?) {
        val postBody = "action=send_email_code&mail=$mail"
        requestAccountApi(postBody, cookies, callback)
    }

    fun getCheckCodeImage(callback: RequestCallback?) {
        httpManager.deleteCookies(checkCodeApi)
        httpManager.getUrl(checkCodeApi, callback)
    }

    fun getHeaderUrl(url: String): String {
        return httpManager.getFullUrl(url)
    }


    private fun isCookiesExists(): Boolean {
        return File(cookieFilePath).exists()
    }

    fun getCookies(): List<String>? {
        if (isCookiesExists()) {
            val cookies = jsonUtils.loadArrayFromJsonFile(File(cookieFilePath))
            val cookiesList: List<String>? = cookies?.toList()
            return cookiesList
        }
        return null
    }

    fun saveCookies(cookies: List<String>) {
        jsonUtils.saveArrayToJsonFile(cookies.toMutableList(), File(cookieFilePath))
    }

    fun deleteCookies() {
        httpManager.deleteCookies(checkCodeApi)
        httpManager.deleteCookies(accountApi)
        if (isCookiesExists()) {
            File(cookieFilePath).delete()
        }
    }


    // 判断用户信息是否存在
    fun isUserInfoInitialized(): Boolean {
        return this::currUserInfo.isInitialized
    }

    fun getLoginState(): Boolean {
        return isLogin
    }

    fun setUserInfo(userInfoItem: UserInfoItem) {
        isLogin = true
        currUserInfo = userInfoItem
    }

    fun saveUserInfo(userInfoItem: UserInfoItem) {
        setUserInfo(userInfoItem)
        val infoJson = gson.toJson(userInfoItem)
        sharedPreferences.edit {
            putString("userInfo", infoJson)
        }
    }

    fun saveUserInfo() {
        if (::currUserInfo.isInitialized) {
            saveUserInfo(currUserInfo)
        }
    }

    fun getUserInfo(): UserInfoItem? {
        if (!::currUserInfo.isInitialized) {
            // 读取用户信息
            val userInfoJson = sharedPreferences.getString("userInfo", null)
            if (userInfoJson != null) {
                currUserInfo = gson.fromJson(userInfoJson, UserInfoItem::class.java)
                isLogin = true
                return currUserInfo
            }
        } else {
            return currUserInfo
        }
        return null
    }

}