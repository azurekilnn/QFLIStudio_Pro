package com.luastudio.azure.util;

import android.content.Context;
import android.content.FileProvider;
import android.content.Intent;
import android.content.res.AssetManager;
import android.net.Uri;
import android.util.Log;

import com.bumptech.glide.Glide;
import com.bumptech.glide.RequestManager;
import com.luastudio.azure.AzureLibrary;
import com.qflistudio.azure.R;
import com.luastudio.azure.markwon.GifGlideStore;
import com.luastudio.azure.textwarrior.common.AutoIndent;
import com.mythoi.developerApp.build.DexUtil;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import io.github.rosemoe.sora.util.ArrayList;
import io.noties.markwon.image.glide.GlideImagesPlugin;

public class AzureUtil {

    public static void mergeDex(ArrayList arrayList,String path) {
        DexUtil.mergeDex(arrayList,path);
    }

    public static GlideImagesPlugin createGifGlideImagesPlugin(Context context) {
        RequestManager glide = Glide.with(context);
        GifGlideStore gif = new GifGlideStore(glide);
       return GlideImagesPlugin.create(gif);
    }
    public static CharSequence formatLuaContent(CharSequence text){
        CharSequence formattedText = AutoIndent.format(text, 2);
     return formattedText;
    }

    public static void unZipAssetsFile(Context context,String OriginPath, String ToPath) throws IOException {
        AssetManager assetManager = context.getAssets();
        InputStream is = assetManager.open(OriginPath);
        File newFile = new File(ToPath, OriginPath);
        FileOutputStream fos = new FileOutputStream(newFile);

        int len = -1;
        byte[] buffer = new byte[1024];
        while ((len = is.read(buffer)) != -1) {
            fos.write(buffer, 0, len);
        }
        fos.close();
        is.close();
    }

    public static void unZipIcons(Context context) {
        String custom_path = AzureLibrary.luaCustomDir;

        File icons_res = new File(custom_path + "/res");
        if (!icons_res.exists() || icons_res.listFiles() == null) {
            //若本地目录不存在
            if (!icons_res.mkdirs()) {
                throw new RuntimeException("create file " + icons_res.getName() + " fail");
            } else {
                try {
                    unZipAssetsFile(context, "res.zip", custom_path + "/");
                    File origin_icons_res = new File(custom_path + "/res.zip");
                    if (origin_icons_res.exists()) {
                        AzureLibrary.unZip(custom_path + "/res.zip", custom_path + "/res/");
                    }
                } catch (IOException e) {
                    //logger.error("unZip",e);
                    Log.e("AzureUtil", "unZipError", e);
                }

            }
        }
    }

    public static void shareFile(Context context, String filePath) {
        shareFile(context, filePath, "*/*");
    }

    public static void shareFile(Context context, String filePath, String mimeType) {
        shareFile(context, filePath, mimeType, context.getString(R.string.shareto_text));
    }

    public static void shareFile(Context context, String filePath, String mimeType, String shareTitle) {
        File file = new File(filePath);
        //Uri fileUri = Uri.parse("file://" + filePath);
        Uri fileUri = FileProvider.getUriForFile(context, context.getPackageName(), file);

        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType(mimeType);
        intent.putExtra(Intent.EXTRA_STREAM, fileUri);

        Intent chooser = Intent.createChooser(intent, shareTitle);
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            context.startActivity(chooser);
        }
    }

}
