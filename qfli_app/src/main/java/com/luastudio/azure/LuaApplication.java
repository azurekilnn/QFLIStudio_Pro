package com.luastudio.azure;

import android.content.Context;
import android.os.Environment;

import com.androlua.CrashHandler;
import com.androlua.LuaContext;
import com.termux.shared.logger.Logger;
import com.termux.shared.termux.TermuxBootstrap;
import com.termux.shared.termux.TermuxConstants;
import com.termux.shared.termux.crash.TermuxCrashUtils;
import com.termux.shared.termux.file.TermuxFileUtils;
import com.termux.shared.termux.settings.preferences.TermuxAppSharedPreferences;
import com.termux.shared.termux.settings.properties.TermuxAppSharedProperties;
import com.termux.shared.termux.shell.TermuxShellManager;
import com.termux.shared.termux.shell.am.TermuxAmSocketServer;
import com.termux.shared.termux.shell.command.environment.TermuxShellEnvironment;
import com.termux.shared.termux.theme.TermuxThemeUtils;
import com.qflistudio.azure.handler.GlobalExceptionHandler;
import java.io.File;

public class LuaApplication extends com.androlua.LuaApplication implements LuaContext {
    private static final String LOG_TAG = "TermuxApplication";


    @Override
    public void onCreate() {
        super.onCreate();

        Context context = getApplicationContext();

        // Set crash handler for the app
        TermuxCrashUtils.setDefaultCrashHandler(this);

        // Set log config for the app
        //setLogConfig(context);
        Logger.logDebug("Starting Application");

        // Set TermuxBootstrap.TERMUX_APP_PACKAGE_MANAGER and TermuxBootstrap.TERMUX_APP_PACKAGE_VARIANT
//        TermuxBootstrap.setTermuxPackageManagerAndVariant(BuildConfig.TERMUX_PACKAGE_VARIANT);
        TermuxBootstrap.setTermuxPackageManagerAndVariant("apt-android-7");

        // Init app wide SharedProperties loaded from termux.properties
        TermuxAppSharedProperties properties = TermuxAppSharedProperties.init(context);

        // Init app wide shell manager
        TermuxShellManager shellManager = TermuxShellManager.init(context);

        // Set NightMode.APP_NIGHT_MODE
        TermuxThemeUtils.setAppNightMode(properties.getNightMode());

        // Check and create termux files directory. If failed to access it like in case of secondary
        // user or external sd card installation, then don't run files directory related code
        com.termux.shared.errors.Error error = TermuxFileUtils.isTermuxFilesDirectoryAccessible(this, true, true);
        boolean isTermuxFilesDirectoryAccessible = error == null;
        if (isTermuxFilesDirectoryAccessible) {
            Logger.logInfo(LOG_TAG, "Termux files directory is accessible");

            error = TermuxFileUtils.isAppsTermuxAppDirectoryAccessible(true, true);
            if (error != null) {
                Logger.logErrorExtended(LOG_TAG, "Create apps/termux-app directory failed\n" + error);
                return;
            }

            // Setup termux-am-socket server
            TermuxAmSocketServer.setupTermuxAmSocketServer(context);
        } else {
            Logger.logErrorExtended(LOG_TAG, "Termux files directory is not accessible\n" + error);
        }

        // Init TermuxShellEnvironment constants and caches after everything has been setup including termux-am-socket server
        TermuxShellEnvironment.init(this);

        if (isTermuxFilesDirectoryAccessible) {
            TermuxShellEnvironment.writeEnvironmentToFile(this);
        }

        // 设置全局未捕获异常处理器
        Thread.setDefaultUncaughtExceptionHandler(new GlobalExceptionHandler(this));
    }


    public static void setLogConfig(Context context) {
        Logger.setDefaultLogTag(TermuxConstants.TERMUX_APP_NAME);

        // Load the log level from shared preferences and set it to the {@link Logger.CURRENT_LOG_LEVEL}
        TermuxAppSharedPreferences preferences = TermuxAppSharedPreferences.build(context);
        if (preferences == null) return;
        preferences.setLogLevel(null, preferences.getLogLevel());
    }

}