package com.luastudio.azure.helper;

import android.content.Context;
import android.content.FileProvider;
import android.content.Intent;
import android.net.Uri;

import com.qflistudio.azure.R;

import java.io.File;

public class FileShareHelper {

    public static void shareFile(Context context, String filePath, String mimeType) {
        File file = new File(filePath);
        //Uri fileUri = Uri.parse("file://" + filePath);
        Uri fileUri = FileProvider.getUriForFile(context, "com.luastudio.azure", file);

        String shareTitle = context.getString(R.string.shareto_text);
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType(mimeType);
        intent.putExtra(Intent.EXTRA_STREAM, fileUri);

        Intent chooser = Intent.createChooser(intent, shareTitle);
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            context.startActivity(chooser);
        }
    }
}
