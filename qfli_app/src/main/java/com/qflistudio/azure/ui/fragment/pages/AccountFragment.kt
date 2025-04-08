package com.qflistudio.azure.ui.fragment.pages

import android.graphics.BitmapFactory
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.constraintlayout.widget.ConstraintSet
import androidx.core.widget.addTextChangedListener
import com.google.gson.Gson
import com.qflistudio.azure.R
import com.qflistudio.azure.base.BaseFragment
import com.qflistudio.azure.bean.AccountResponse
import com.qflistudio.azure.bean.UserInfoItem
import com.qflistudio.azure.callback.OnCodeCallback
import com.qflistudio.azure.common.AzureProgressDialog
import com.qflistudio.azure.common.ktx.setImage
import com.qflistudio.azure.databinding.FragmentMainFifthBinding
import com.qflistudio.azure.manager.HttpManager
import com.qflistudio.azure.util.ResUtils
import com.qflistudio.azure.viewmodel.MainViewModel
import okhttp3.Call
import java.io.IOException
import android.graphics.Rect
import com.qflistudio.azure.common.KeyboardVisibilityMonitor


// 内层主页 第1页
class AccountFragment : BaseFragment<FragmentMainFifthBinding, MainViewModel>() {
    private lateinit var memberCenterRoot: LinearLayoutCompat
    val TAG = "FifthFragment"
    private lateinit var setCookie: List<String>
    private lateinit var currUsername: String
    private lateinit var currPassword: String
    private lateinit var progressDialog: AzureProgressDialog
    private val gson = Gson()
    private lateinit var keyboardMonitor: KeyboardVisibilityMonitor
    override fun getViewBinding(inflater: LayoutInflater, container: ViewGroup?) =
        FragmentMainFifthBinding.inflate(inflater, container, false)

    override fun getViewModelClass() = MainViewModel::class.java

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        getCode()
        autoLogin()
//        setupKeyboardListener() // 监听键盘
        binding.apply {
            loginUsernameTiet.setText("")
            loginPasswordTiet.setText("")
            regEmailTiet.setText("")
            regPasswordTiet.setText("")
            regConfirmPasswordTiet.setText("")
            memberCenter.apply {
                logoutBtn.setOnClickListener {
                    logout()
                }
            }
            loginCodeImgv.setOnClickListener {
                getCode()
            }
            loginCodeImgv.setOnClickListener {
                getCode()
            }
            regCodeImgv.setOnClickListener {
                getCode()
            }
            regCodeImgv.isEnabled = false
            showLoginButton.setOnClickListener {
                showLoginPanel()
                getCode()
            }
            showRegisterButton.setOnClickListener {
                showRegisterPanel()
                getCode()
            }
            loginButton.setOnClickListener {
                currUsername = loginUsernameTiet.text.toString()
                currPassword = loginPasswordTiet.text.toString()
                login(currUsername, currPassword, loginCodeTiet.text.toString())
            }
            sendEmailCodeButton.setOnClickListener {
                val regEmail = regEmailTiet.text.toString()
                if (regEmail != "") {
                    sendEmailCode(regEmail)
                } else {
                    showViewTip(R.string.email_invalid_tip)
                }
            }
            regEmailTiet.addTextChangedListener { s ->
                val inputText = s.toString()
                loginUsernameTiet.setText(inputText)
            }
            regPasswordTiet.addTextChangedListener { s ->
                val inputText = s.toString()
                loginPasswordTiet.setText(inputText)
            }
            regConfirmPasswordTiet.addTextChangedListener { s ->
                val regConfirmPassWord = s.toString()
                val regPassWord = regPasswordTiet.text.toString()
                loginPasswordTiet.setText(regConfirmPassWord)
                if (regPassWord != regConfirmPassWord) {
                    regConfirmPasswordTil.helperText =
                        ResUtils().getString(requireContext(), "confirm_pass_error_tips")
                    regConfirmPasswordTil.setHelperTextColor(themeManager.themeColors.wrongColorStateList)
                } else {
                    loginPasswordTiet.setText(regConfirmPassWord)
                    // 输入合法并且非空
                    regConfirmPasswordTil.helperText = null
                    regConfirmPasswordTil.setHelperTextColor(themeManager.themeColors.rightColorStateList)
                }

            }
            regButton.setOnClickListener {
                val regEmail = regEmailTiet.text.toString()
                val regPassWord = regPasswordTiet.text.toString()
                val regConfirmPassWord = regConfirmPasswordTiet.text.toString()
                val regEmailCode = regEmailCodeTiet.text.toString()
                val regImageCode = regCodeTiet.text.toString()

                if (regEmail != "" && regPassWord != "" && regConfirmPassWord != "") {
                    if (regPassWord == regConfirmPassWord) {
                        register("", regEmail, regPassWord, regImageCode, regEmailCode)
                    } else {
                        showViewTip(R.string.confirm_pass_error_tips)
                    }
                } else {
                    showViewTip(R.string.input_nil)
                }
            }
        }

        if (accountManager.isUserInfoInitialized()) {
            loadUserCenter(accountManager.currUserInfo)
        }

        viewModel.currUserInfo.observe(viewLifecycleOwner) { userInfo ->
            loadUserCenter(userInfo)
        }

    }

    private fun setupKeyboardListener() {
        keyboardMonitor = KeyboardVisibilityMonitor(requireActivity()) { isVisible ->
            if (isVisible) {
                // 键盘显示时的处理
                Log.i(TAG, "adjustInputPosition true")
                adjustInputPosition(true)
                Log.d("Keyboard", "键盘已显示")
            } else {
                // 键盘隐藏时的处理
                adjustInputPosition(false)
                Log.i(TAG, "adjustInputPosition false")
                Log.d("Keyboard", "键盘已隐藏")
            }
        }

    }

    private fun adjustInputPosition(showKeyboard: Boolean) {
        val constraintLayout = binding.accountPageRoot
        val constraintSet = ConstraintSet()
        constraintSet.clone(constraintLayout)

        if (showKeyboard) {
            constraintSet.setMargin(R.id.my_account_root, ConstraintSet.BOTTOM, 300) // 键盘弹出时，向上移动
        } else {
            constraintSet.setMargin(R.id.my_account_root, ConstraintSet.BOTTOM, 0) // 键盘隐藏时，恢复原位
        }
        constraintSet.applyTo(constraintLayout)
    }

    private fun loadUserCenter(userInfo: UserInfoItem) {
        if (checkView()) {
            binding.memberCenter.apply {
                avatarIv.setImage(accountManager.getHeaderUrl(userInfo.photo), context)
                usernameTv.text = userInfo.nickname
                descriptionTv.text = userInfo.description
                roleTv.text = userInfo.role
                emailTv.text = userInfo.email
                ipTv.text = userInfo.ip
            }
            showUserInfoPanel()
        }
    }

    private fun autoLogin() {
        val userInfo = accountManager.getUserInfo()
        if (accountManager.getLoginState() && userInfo != null) {
            Log.i(TAG, "Loading Local UserInfo")
            loadUserCenter(userInfo)
        } else {
            // Cookie 获取用户信息
            val cookies = accountManager.getCookies()
            if (cookies != null) {
                setProgressBarVisibility(true)
                setAllButtonState(false)
                queryUserDetail(cookies)
            }
        }
    }

    // 登录
    private fun login(username: String, password: String, loginCode: String) {
        if (!::setCookie.isInitialized) {
            return
        }
        showProgressDlg(getString(R.string.logining_text), "")
        accountManager.loginAccount(
            username,
            password,
            loginCode,
            setCookie,
            object : HttpManager.RequestCallback {
                override fun onResponse(
                    call: Call?, code: Int, response: okhttp3.Response?,
                ) {
                    setAllButtonState(true)
                    Log.i(TAG, "1.setCookie:" + setCookie.toString())
                    val headers = response?.headers
                    val content = response?.body?.string()
                    setCookie = headers?.values("Set-Cookie")!!
                    content.let {
                        Log.i(TAG, "response：$content")
                        val apiResponse =
                            gson.fromJson(content, AccountResponse::class.java)
                        Log.i(TAG, "apiResponse：${apiResponse}")
                        if (apiResponse.code == 200) {
                            showViewTip(R.string.login_successfully_tip)
                            Log.i(TAG, setCookie.toString())
                            queryUserDetail(setCookie)
                            accountManager.saveCookies(setCookie)
                        } else {
                            showViewTip(apiResponse.message)
                        }
                        closeProgress()
                    }
                }

                override fun onFailure(call: Call?, e: IOException?) {
                    Log.i(TAG, e?.message.toString())
                    setAllButtonState(true)
                    showViewTip(e?.message.toString())
                }
            }
        )
    }

    // 注册
    private fun register(
        username: String,
        mail: String,
        password: String,
        loginCode: String,
        emailCode: String,
    ) {
        if (!::setCookie.isInitialized) {
            return
        }
        showProgressDlg(
            getString(R.string.registering_tips_text),
            getString(R.string.registering_tips_text)
        )
        accountManager.regAccount(
            username,
            mail,
            password,
            loginCode,
            emailCode,
            setCookie,
            object : HttpManager.RequestCallback {
                override fun onResponse(
                    call: Call?, code: Int, response: okhttp3.Response?,
                ) {
                    setAllButtonState(true)
                    Log.i(TAG, "1.setCookie:" + setCookie.toString())
                    val headers = response?.headers
                    val content = response?.body?.string()
                    setCookie = headers?.values("Set-Cookie")!!
                    content.let {
                        val apiResponse = gson.fromJson(content, AccountResponse::class.java)
                        Log.i(TAG, "response：$content  \n $apiResponse")
                        if (apiResponse.code == 200) {
                            showViewTip(R.string.register_successfully_tip)
                            showLoginPanel()
                            Log.i(TAG, setCookie.toString())
                        } else {
                            showViewTip(apiResponse.message)
                        }
                    }
                    closeProgress()
                }

                override fun onFailure(call: Call?, e: IOException?) {
                    Log.i(TAG, e?.message.toString())
                    showViewTip(e?.message.toString())
                    closeProgress()
                    setAllButtonState(true)
                }
            }
        )
    }

    // 退出登录
    private fun logout() {
        showLoginPanel()
        accountManager.deleteCookies()
    }

    // 查询用户信息
    private fun queryUserDetail(cookies: List<String>) {
        accountManager.queryAccountInfo(cookies, object : HttpManager.RequestCallback {
            override fun onResponse(
                call: Call?, code: Int, response: okhttp3.Response?,
            ) {
                setAllButtonState(true)
                val content = response?.body?.string()
                content?.let {
                    val apiResponse = gson.fromJson(content, AccountResponse::class.java)
                    val userInfo = apiResponse.userinfo
                    Log.i(TAG, "queryAccountInfo：${userInfo}")
                    viewModel.setCurrentUserInfo(userInfo)
                    accountManager.setUserInfo(userInfo)
                    accountManager.saveUserInfo()
                }
            }

            override fun onFailure(call: Call?, e: IOException?) {
                showViewTip(e?.message.toString())
                closeProgress()
                setAllButtonState(true)
            }
        })

    }

    // 获取图形验证码
    private fun getCode(callback: OnCodeCallback? = null) {
        accountManager.getCheckCodeImage(object : HttpManager.RequestCallback {
            override fun onResponse(
                call: Call?, code: Int, response: okhttp3.Response?,
            ) {
                if (response != null) {
                    val headers = response.headers
                    setCookie = headers.values("Set-Cookie")
                    val cookie = headers.values("Cookie")
                    Log.i(TAG, "3.Refresh Cookies \n $setCookie \n $cookie")
                    if (response.isSuccessful) {
                        // 获取图片数据（响应体）
                        val imageData = response.body.bytes()
                        // 处理图片数据
                        val bitmap = BitmapFactory.decodeByteArray(imageData, 0, imageData.size)
                        // 你可以将 bitmap 显示到 ImageView 或保存为文件
                        if (checkView()) {
                            binding.loginCodeImgv.setImage(bitmap)
                            binding.regCodeImgv.setImage(bitmap)
                        }
                        callback?.onComplete()
                    } else {
                        // 处理错误响应
                        showViewTip("Error: ${response.code}")
                        closeProgress()
                        callback?.onError()
                    }
                }
            }

            override fun onFailure(call: Call?, e: IOException?) {
                showViewTip(e?.message.toString())
                callback?.onError(e)
                closeProgress()
            }
        })
    }

    // 发送邮件验证码
    private fun sendEmailCode(mail: String) {
        showProgressDlg(
            getString(R.string.send_email_code_text),
            getString(R.string.sending_email_code_text)
        )
        getCode(object : OnCodeCallback {
            override fun onComplete() {
                accountManager.sendEmailCode(mail, setCookie, object : HttpManager.RequestCallback {
                    override fun onResponse(
                        call: Call?, code: Int, response: okhttp3.Response?,
                    ) {
                        val content = response?.body?.string()
                        content?.let {
                            val apiResponse = gson.fromJson(content, AccountResponse::class.java)
                            showViewTip(apiResponse.message)
                        }
                        closeProgress()
                    }

                    override fun onFailure(call: Call?, e: IOException?) {
                        showViewTip(e?.message.toString())
                        closeProgress()
                    }
                })
            }

            override fun onError(e: IOException?) {
                showViewTip(R.string.get_error_tips)
            }

        })
    }

    fun setProgressBarVisibility(state: Boolean) {
        if (state) {
            binding.accountProgressbar.visibility = View.VISIBLE
        } else {
            binding.accountProgressbar.visibility = View.GONE
        }
    }

    // 显示进度对话框
    private fun showProgressDlg(title: String, message: String) {
        // if (!::progressDialog.isInitialized) {
        progressDialog = AzureProgressDialog(requireContext())
        progressDialog.apply {
            setTitle(title)
            setMessage(message)
            setIndeterminate(true)
            setCancelable(false)
        }
        progressDialog.show()
        if (checkView()) {
            setProgressBarVisibility(true)
        }
    }

    // 隐藏进度对话框
    private fun closeProgress() {
        if (::progressDialog.isInitialized) {
            progressDialog.dismiss()
        }
        if (checkView()) {
            setProgressBarVisibility(false)
        }
    }

    // 检查视图是否可用
    private fun checkView(): Boolean {
        return isAdded && view != null
    }

    // 显示用户信息面板
    private fun showUserInfoPanel() {
        if (checkView()) {
            closeProgress()
            getCode()
            binding.loginPanelRoot.visibility = View.GONE
            binding.registerPanelRoot.visibility = View.GONE
            binding.memberCenter.memberCenterRoot.visibility = View.VISIBLE
        }
    }

    // 显示登录面板
    private fun showLoginPanel() {
        if (checkView()) {
            closeProgress()
            getCode()
            binding.loginPanelRoot.visibility = View.VISIBLE
            binding.registerPanelRoot.visibility = View.GONE
            binding.memberCenter.memberCenterRoot.visibility = View.GONE
        }
    }

    // 显示注册面板
    private fun showRegisterPanel() {
        if (checkView()) {
            closeProgress()
            getCode()
            binding.loginPanelRoot.visibility = View.GONE
            binding.registerPanelRoot.visibility = View.VISIBLE
            binding.memberCenter.memberCenterRoot.visibility = View.GONE
        }
    }


    // 设置按钮状态
    private fun setAllButtonState(state: Boolean) {
        if (checkView()) {
            binding.loginButton.isEnabled = state
            binding.regButton.isEnabled = state
            binding.sendEmailCodeButton.isEnabled = state
        }
    }


}
