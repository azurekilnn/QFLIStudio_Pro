package com.luastudio.azure.util;

import android.util.Log;
import com.android.apksigner.ApkSignerTool;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class ApkSigner {
    private static final String TAG = "ApkSigner";

    public static boolean sign(String unsignedApkPath, String signedApkPath, String keyPath, String certPath) {
       return sign(unsignedApkPath, signedApkPath, keyPath, certPath, true, true, true, true);
    }

    public static boolean sign(String unsignedApkPath, String signedApkPath, String keyPath, String certPath, boolean v1Enabled, boolean v2Enabled, boolean v3Enabled, boolean v4Enabled) {
        try {
            ArrayList<String> args = new ArrayList<>();
            args.add("sign");
            args.add("--v1-signing-enabled");
            args.add(String.valueOf(v1Enabled));

            args.add("--v2-signing-enabled");
            args.add(String.valueOf(v2Enabled));

            args.add("--v3-signing-enabled");
            args.add(String.valueOf(v3Enabled));

            args.add("--v4-signing-enabled");
            args.add(String.valueOf(v4Enabled));

            args.add("--key");
            args.add(keyPath);
            args.add("--cert");
            args.add(certPath);

            args.add("--in");
            args.add(unsignedApkPath);
            args.add("--out");
            args.add(signedApkPath);

            String[] argsString = (String[])args.toArray(new String[args.size()]);
            ApkSignerTool.main(argsString);
            Log.e(TAG, "Completed.");
            return true;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            return false;
        }
    }

    public static void sign(String unsignedApkPath, String signedApkPath, String keystorePath, String keystoreAlias, String keystorePassword, String keyPassword) {
        try {
            ArrayList<String> args = new ArrayList<>();
            args.add("sign");

            args.add("--ks");
            args.add(keystorePath);

            args.add("--in");
            args.add(unsignedApkPath);
            args.add("--out");
            args.add(signedApkPath);

            args.add("--key-pass");
            args.add("pass:" + keyPassword);

            args.add("--ks-key-alias");
            args.add(keystoreAlias);

            args.add("--ks-pass");
            args.add("pass:" + keystorePassword);

            String[] argsString = (String[])args.toArray(new String[args.size()]);
            ApkSignerTool.main(argsString);
            Log.e(TAG, "Completed.");
        } catch (Exception e) {
            Log.e(TAG, "Failed to sign APK: " + e.getMessage());
            e.printStackTrace();
        }
    }



    private static void writeSignedApk(byte[] apkBytes, byte[] v1SignatureBytes, byte[] v2SignatureBytes,
                                       byte[] v3SignatureBytes, String outputFilePath) throws IOException {
        FileOutputStream output = new FileOutputStream(outputFilePath);
        output.write(apkBytes);
        output.write(v1SignatureBytes);
        output.write(v2SignatureBytes);
        output.write(v3SignatureBytes);
        output.close();
    }
}
