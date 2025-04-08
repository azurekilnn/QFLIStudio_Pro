package com.qflistudio.azure.ui.termux.activity

import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.KeyEvent
import android.view.MotionEvent
import android.view.View
import androidx.activity.addCallback
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.res.ResourcesCompat
import com.blankj.utilcode.util.ClipboardUtils
import com.blankj.utilcode.util.KeyboardUtils
import com.qflistudio.azure.R
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.common.Commands
import com.qflistudio.azure.common.Keys
import com.qflistudio.azure.common.ktx.getJavaClass
import com.qflistudio.azure.databinding.ActivitySourceDetailBinding
import com.qflistudio.azure.databinding.ActivityTermuxBinding
import com.qflistudio.azure.viewmodel.MainViewModel
import com.termux.terminal.TerminalEmulator
import com.termux.terminal.TerminalSession
import com.termux.terminal.TerminalSessionClient
import com.termux.view.TerminalRenderer
import com.termux.view.TerminalView
import com.termux.view.TerminalViewClient
import java.io.File
import java.lang.ref.WeakReference

class TermuxActivity : BaseActivity<ActivityTermuxBinding, MainViewModel>(), TerminalViewClient {
    private lateinit var mTermView: TerminalView
    private lateinit var binding: ActivityTermuxBinding

    override fun getViewModelClass(): Class<MainViewModel> {
        return getJavaClass()
    }

    override fun getViewBindingInstance(): ActivityTermuxBinding {
        return ActivityTermuxBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityTermuxBinding.inflate(layoutInflater)
        setSupportActionBar(binding.toolbarInclude.toolbar)
        // 顶栏
        supportActionBar?.apply {
            title = getString(R.string.termux_title)
        }
        setContentView(binding.root)

        mTermView = binding.terminalView
        Log.d(TAG, "Terminal has been created")
        mTermView.attachSession(getTerminalSession())
        mTermView.setTerminalViewClient(this)
        mTermView.mRenderer = TerminalRenderer(
            30,
            ResourcesCompat.getFont(this, R.font.jetbrainsmono_medium)!!
        )
        val fileName = intent.getStringExtra(Keys.KEY_FILE_PATH)
        if (fileName != null) {
            val command = fileName.let { Commands.getInterpreterCommand(this, it) }
            Log.d(TAG, "Command is $command")
            Handler(Looper.getMainLooper()).post {
                mTermView.mTermSession.write("$command\r")
            }
        } else if (intent.getBooleanExtra(Keys.IS_SHELL_MODE_KEY, false)) {
            Handler(Looper.getMainLooper()).post {
                mTermView.mTermSession.write("${Commands.getPythonShellCommand(this)}\r")
            }
        } else {
            Handler(Looper.getMainLooper()).post {
                mTermView.mTermSession.write("${Commands.getBasicCommand(this)}\r")
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            mTermView.setBackgroundColor(this.getColor(R.color.terminalColor))
        }
        onBackPressedDispatcher.addCallback(this, true) {
            mTermView.mTermSession.finishIfRunning()
            finish()
        }
    }


    private fun getTerminalSession(): TerminalSession {
        val cwd = filesDir.absolutePath
        var shell = "/bin/sh"
        if (File("/bin/sh").exists().not()) {
            shell = "/system/bin/sh"
        }
        return TerminalSession(
            shell,
            cwd, arrayOf<String>(),
            arrayOf(),
            TerminalEmulator.DEFAULT_TERMINAL_TRANSCRIPT_ROWS,
            getTermSessionClient()
        )
    }

    override fun logError(tag: String?, message: String?) {
        if (message != null) {
            Log.e(tag, message)
        }
    }

    override fun logWarn(tag: String?, message: String?) {
        if (message != null) {
            Log.w(tag, message)
        }
    }

    override fun logInfo(tag: String?, message: String?) {
        if (message != null) {
            Log.i(tag, message)
        }
    }

    override fun logDebug(tag: String?, message: String?) {
        if (message != null) {
            Log.d(tag, message)
        }
    }

    override fun logVerbose(tag: String?, message: String?) {
        if (message != null) {
            Log.v(tag, message)
        }
    }

    override fun logStackTraceWithMessage(
        tag: String?,
        message: String?,
        e: Exception?
    ) {
        Log.e(tag, message + "\n" + Log.getStackTraceString(e))
    }

    override fun logStackTrace(tag: String?, e: Exception?) {
        Log.e(tag, Log.getStackTraceString(e))
    }

    override fun onScale(scale: Float): Float {
        return scale
    }

    override fun onSingleTapUp(e: MotionEvent?) {
        if (mTermView.mTermSession.isRunning) {
            mTermView.requestFocus()
            KeyboardUtils.showSoftInput(mTermView)
        }
    }

    override fun shouldBackButtonBeMappedToEscape(): Boolean {
        return false
    }

    override fun shouldEnforceCharBasedInput(): Boolean {
        return true
    }

    override fun shouldUseCtrlSpaceWorkaround(): Boolean {
        return false
    }

    override fun isTerminalViewSelected(): Boolean {
        return true
    }

    override fun copyModeChanged(copyMode: Boolean) {}

    override fun onKeyDown(keyCode: Int, e: KeyEvent?, session: TerminalSession?): Boolean {
        return false
    }

    override fun onKeyUp(keyCode: Int, e: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (mTermView.mTermSession.isRunning) {
                mTermView.mTermSession.finishIfRunning()
                finish()
            }
            return true
        }
        return false
    }

    override fun onLongPress(event: MotionEvent?): Boolean {
        return false
    }

    override fun readControlKey(): Boolean {
        return false
    }

    override fun readAltKey(): Boolean {
        return false
    }

    override fun readShiftKey(): Boolean {
        return false
    }

    override fun readFnKey(): Boolean {
        return false
    }

    override fun onCodePoint(
        codePoint: Int,
        ctrlDown: Boolean,
        session: TerminalSession?
    ): Boolean {
        return false
    }

    private fun getTermSessionClient(): TerminalSessionClient {
        val weakActivityReference = WeakReference(this)
        return object : TerminalSessionClient {
            override fun onTextChanged(changedSession: TerminalSession) {
                runOnUiThread {
                    weakActivityReference.get()?.mTermView?.onScreenUpdated()
                }
            }

            override fun onTitleChanged(updatedSession: TerminalSession) {}

            override fun onSessionFinished(finishedSession: TerminalSession) {
                runOnUiThread {
                    weakActivityReference.get()?.mTermView?.let {
                        KeyboardUtils.hideSoftInput(it)
                        it.mTermSession?.finishIfRunning()
                    }
                    finish()
                }
            }

            override fun onCopyTextToClipboard(session: TerminalSession, text: String?) {
                ClipboardUtils.copyText(text)
            }


            override fun onPasteTextFromClipboard(session: TerminalSession?) {
                runOnUiThread {
                    val clip = ClipboardUtils.getText().toString()
                    if (clip.trim { it <= ' ' }
                            .isNotEmpty() && weakActivityReference.get()?.mTermView?.mEmulator != null) {
                        weakActivityReference.get()?.mTermView?.mEmulator?.paste(clip)
                    }
                }
            }

            override fun onBell(session: TerminalSession) {}

            override fun onColorsChanged(changedSession: TerminalSession) {}

            override fun onTerminalCursorStateChange(state: Boolean) {}
            override fun setTerminalShellPid(session: TerminalSession, pid: Int) {
//                val service: TermuxService = mActivity.getTermuxService() ?: return
//
//                val termuxSession: TermuxSession = service.getTermuxSessionForTerminalSession(session)
//                if (termuxSession != null) termuxSession.executionCommand.mPid = pid
            }

            override fun getTerminalCursorStyle(): Int {
                return TerminalEmulator.TERMINAL_CURSOR_STYLE_UNDERLINE
            }

            override fun logError(tag: String?, message: String?) {
                if (message != null) {
                    Log.e(tag, message)
                }
            }

            override fun logWarn(tag: String?, message: String?) {
                message?.let { Log.w(tag, it) }
            }

            override fun logInfo(tag: String?, message: String?) {
                message?.let { Log.i(tag, it) }
            }

            override fun logDebug(tag: String?, message: String?) {
                message?.let { Log.d(tag, it) }
            }

            override fun logVerbose(tag: String?, message: String?) {
                message?.let { Log.v(tag, it) }
            }

            override fun logStackTraceWithMessage(
                tag: String?,
                message: String?,
                e: Exception?
            ) {
                Log.e(tag, message + "\n" + Log.getStackTraceString(e))
            }

            override fun logStackTrace(tag: String?, e: Exception?) {
                Log.e(tag, Log.getStackTraceString(e))
            }

        }
    }

    override fun onEmulatorSet() {}

    companion object {
        private const val TAG = "TermActivity"
    }
}