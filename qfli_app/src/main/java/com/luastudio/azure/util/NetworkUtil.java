package com.luastudio.azure.util;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.net.NetworkInterface;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Iterator;

public class NetworkUtil {

    public static boolean isVpnUsed() {
        try {
            Enumeration networkInterfaces = NetworkInterface.getNetworkInterfaces();
            if (networkInterfaces != null) {
                Iterator it = Collections.list(networkInterfaces).iterator();
                while (it.hasNext()) {
                    NetworkInterface networkInterface = (NetworkInterface) it.next();
                    if (networkInterface.isUp() && networkInterface.getInterfaceAddresses().size() != 0) {
                        if ("tun0".equals(networkInterface.getName()) || "ppp0".equals(networkInterface.getName())) {
                            return true;
                        }
                    }
                }
            }
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        }
        return false;
    }

    /*
    这段代码的目的是检查当前设备是否正在使用 VPN 连接。代码逐个迭代网络接口，检查每个接口是否处于活动状态并具有非零的接口地址。如果接口的名称是 "tun0" 或 "ppp0"，则认为设备正在使用 VPN 连接，并返回 `true`。

在代码中，存在一些潜在的问题和需要注意的地方：

1. `Enumeration networkInterfaces = NetworkInterface.getNetworkInterfaces();` 这一行获取了设备上的网络接口列表。在 Java 中，`Enumeration` 接口不直接支持泛型，这可能导致编译器警告。你可以在代码中添加泛型类型声明，如 `Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();`，以避免编译器警告。

2. `Throwable th` 这个变量名没有提供明确的含义。建议使用更有意义的变量名，例如 `Throwable throwable`。

3. `th.printStackTrace();` 这行代码在发生异常时打印异常堆栈轨迹，但只是简单地将其打印到标准错误流中，并没有进行其他处理。建议在实际应用程序中，采取适当的日志记录或错误处理机制，而不仅仅是打印异常信息。

总体而言，该代码片段可以作为一种简单的检测当前设备是否使用 VPN 连接的方法。然而，需要注意的是，这只是一种简单的检查方式，并不能保证适用于所有设备和网络环境。此外，代码没有涉及到 VPN 连接的详细信息或安全性方面的考虑。对于需要更高安全性的应用程序，可能需要采用更全面和复杂的方法来检测和保护 VPN 连接。
     */

    @RequiresApi(api = Build.VERSION_CODES.M)
    public static boolean isVPNConnected(Context context) {
        // 获取连接管理器
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        // 检查当前活动的网络连接
        Network activeNetwork = connectivityManager.getActiveNetwork();
        // 检查网络连接是否是 VPN 连接
        if (activeNetwork != null) {
            NetworkCapabilities networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork);
            if (networkCapabilities != null) {
                return networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN);
            }
        }

        return false;
    }


}
