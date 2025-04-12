package com.luastudio.azure;

import static java.io.File.separator;

import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore.Audio;
import android.provider.MediaStore.Images.Media;
import android.provider.MediaStore.Video;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.google.android.material.snackbar.Snackbar;
import com.luajava.LuaException;
import com.luajava.LuaFunction;
import com.luajava.LuaObject;
import com.luajava.LuaState;
import com.luajava.LuaStateFactory;
import com.luajava.LuaTable;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.logging.Logger;
import java.util.zip.Adler32;
import java.util.zip.CheckedOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

public class AzureLibrary {
    public static String internal_storage = Environment.getExternalStorageDirectory().getAbsolutePath();
    public static String luaExtDir = internal_storage + "/LuaStudio_Pro";
    public static String studioExtDir = internal_storage + "/QFLIStudio_Pro";

    public static String environment_root_path = luaExtDir + "/.environment";
    public static String cachesDir = luaExtDir + "/cache";
    public static String luaCustomDir = luaExtDir + "/luastudio_custom";
    public static String pluginsDir = luaExtDir + "/plugin";
    public static String projectsDir = luaExtDir + "/projects";
    public static String backupsDir = luaExtDir + "/backup";
    public static File ls_proj_file = new File(AzureLibrary.projectsDir);
    public static File[] proj_listFiles = ls_proj_file.listFiles();
    public static String MySignature = "3082037f30820267a00302010202047e45750e300d06092a864886f70d01010b0500306f310b300906035504061302383631123010060355040813094775616e67646f6e673110300e060355040713074a696579616e6731123010060355040a13094c756153747564696f31123010060355040b13094c756153747564696f31123010060355040313094c696368656e6779753020170d3232303731333034333433375a180f32303732303633303034333433375a306f310b300906035504061302383631123010060355040813094775616e67646f6e673110300e060355040713074a696579616e6731123010060355040a13094c756153747564696f31123010060355040b13094c756153747564696f31123010060355040313094c696368656e67797530820122300d06092a864886f70d01010105000382010f003082010a0282010100a4889d42b1d7ee5797812fb39804f5ed1303c543484fd701b2a0573c80de56defe88f440dac8bba2036ee038ec376b97dc51cd68f4efa46fc86339ef686a1bb66c277a4c704688615790643f55975d1b6bd39f7e6f559f94b254e2a5372a928faac7bf828a7f32a9f51df1f06858b2e5975800138090888815b5dc4783d0604e6ba608e4bc95fc1e80bf9e7d0242a8fc7626917c12ac93e0647ca77e38f164858133dc0cc1cc26306a00247500548fa5af240217d46981b22a429686292cb932fbf2c3e640118664e5649d5234e6e4b4fd7fc9ea1c4eef90d7d1b978330b1ede228ac86832db26df905d3d4f00acdb15c23ce84fe19ddbf4fcafee48b9ef5c430203010001a321301f301d0603551d0e041604149b9b643daf440b6d5cc93dee7ac24d07e2b4a0ae300d06092a864886f70d01010b05000382010100480bf03d413426a05c2b9e5d6dc2699a5af8af2c7d6364fff3a1a38eab63b61f27e4a380c4c5d3e8a86be19c03c8cacbb2a18c7a2b2a79a3734d639856f2a69cc0ae693c5dc8d993b97d077af3b88cd28e81017ec5f84ce92c07d9ba81af60e5620b5959322aff6b6fcf1b46b0cd4ae6597791065661c071dca8a4d8298d9379eea495ff7a32f16cf97c1615e11642641adae1efd6cee1f5f46a14852c25f735239e6099ad7792f23079689895093fd7214325d0c1968af197b4d7f35fbb4b02d7203c389b329b948a2e80b137d6e67237297a2d7593732b3480788b4786c62cc246ebab33266ec8f1d378e28aa00ef2a9f0f7a11a13ee28f0156a2f238442b8";
    public static String MySecret = "azure";

    private static final byte[] BUFFER = new byte[4096];

    private final static Logger logger = Logger.getLogger(AzureLibrary.class.getName());



    public static void toast(Context context, String tip_content) {
        Toast.makeText(context, tip_content, Toast.LENGTH_SHORT).show();
    }

    public static void Snackbar(View view, String string) {
        Snackbar.make(view, string, Snackbar.LENGTH_SHORT).setAction("Action", null).show();
    }

    public static View loadlayout1(LuaTable luaLayout) {
        LuaState luaState = LuaStateFactory.newLuaState();
        luaState.openLibs();
        LuaFunction<View> loadlayout = (LuaFunction<View>) luaState.getLuaObject("loadlayout").getFunction();
        luaState.newTable();
        return loadlayout.call(luaLayout, luaState.getLuaObject(-1), ViewGroup.class);
    }

    public static View loadlayout2(LuaObject luaLayout) {
        LuaState luaState = LuaStateFactory.newLuaState();
        luaState.openLibs();
        LuaFunction<View> loadlayout = (LuaFunction<View>) luaState.getLuaObject("loadlayout").getFunction();
        luaState.newTable();
        return loadlayout.call(luaLayout, luaState.getLuaObject(-1), ViewGroup.class);
    }

    public static View loadlayout3(LuaObject luaLayout, LuaObject env) throws LuaException {
        LuaState luaState = LuaStateFactory.newLuaState();
        luaState.openLibs();
        // TODO: Implement this method
        LuaObject loadlayout = luaState.getLuaObject("loadlayout");
        View view = null;
        if (luaLayout.isString())
            view = (View) loadlayout.call(luaLayout.getString(), env);
        else if (luaLayout.isTable())
            view = (View) loadlayout.call(luaLayout, env);
        else
            throw new LuaException("layout may be table or string.");
        return view;
    }

    public static View loadlayout3(LuaObject luaLayout) throws LuaException {
        return loadlayout3(luaLayout, null);
    }

    public static View loadlayout4(LuaTable luaLayout) {
        LuaState luaState = LuaStateFactory.newLuaState();
        luaState.openLibs();
        LuaObject loadlayout = luaState.getLuaObject("loadlayout");
        return (View) loadlayout.call(luaLayout, null);
    }

    public static View loadlayout5(LuaTable luaLayout) {
        LuaState luaState = LuaStateFactory.newLuaState();
        luaState.openLibs();
        LuaObject loadlayout = luaState.getLuaObject("loadlayout");
        return (View) loadlayout.call(luaLayout, null);
    }

    public static void writeFile(String path, String content) throws IOException {
        File file = new File(path);
        // 创建文件
        file.createNewFile();
        // creates a FileWriter Object
        FileWriter writer = new FileWriter(file);
        // 向文件写入内容
        writer.write(content);
        writer.flush();
        writer.close();
    }

    public static boolean rmDir(File dir) {
        if (dir.isDirectory()) {
            File[] fs = dir.listFiles();
            for (File f : fs)
                rmDir(f);
        }
        return dir.delete();
    }

    public static boolean rmDir(String dir) {
        File fileObject = new File(dir);
        if (fileObject.isDirectory()) {
            File[] fs = fileObject.listFiles();
            for (File f : fs)
                rmDir(f);
        }
        return fileObject.delete();
    }

    //删除文件/文件夹
    public static void rmDir(File dir, String ext) {
        if (dir.isDirectory()) {
            File[] fs = dir.listFiles();
            for (File f : fs)
                rmDir(f, ext);
            dir.delete();
        }
        if (dir.getName().endsWith(ext))
            dir.delete();
    }


    public static boolean zip(String sourceFilePath) {
        return zip(sourceFilePath, new File(sourceFilePath).getParent());
    }

    public static boolean zip(String sourceFilePath, String zipFilePath) {
        File f = new File(sourceFilePath);
        return zip(sourceFilePath, zipFilePath, f.getName() + ".zip", false);
    }

    public static boolean zip(String sourceFilePath, String zipFilePath, String zipFileName) {
        return zip(sourceFilePath, zipFilePath, zipFileName, false);
    }


    public static boolean zip(String sourceFilePath, String zipFilePath, String zipFileName, boolean skipBuild) {
        boolean result = false;
        File source = new File(sourceFilePath);
        File zipFile = new File(zipFilePath, zipFileName);
        if (!zipFile.getParentFile().exists()) {
            if (!zipFile.getParentFile().mkdirs()) {
                return result;
            }
        }
        if (zipFile.exists()) {
            try {
                zipFile.createNewFile();
            } catch (IOException e) {
                return result;
            }
        }

        FileOutputStream dest = null;
        ZipOutputStream out = null;
        try {
            dest = new FileOutputStream(zipFile);
            CheckedOutputStream checksum = new CheckedOutputStream(dest, new Adler32());
            out = new ZipOutputStream(new BufferedOutputStream(checksum));
            //out.setMethod(ZipOutputStream.DEFLATED);
            compress(source, out, "", skipBuild);
            checksum.getChecksum().getValue();
            result = true;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                try {
                    out.closeEntry();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    private static void compress(File file, ZipOutputStream out, String mainFileName, boolean skipBuild) {
        if (file.isFile()) {
            FileInputStream fi = null;
            BufferedInputStream origin = null;
            try {
                fi = new FileInputStream(file);
                origin = new BufferedInputStream(fi, BUFFER.length);
                //int index=file.getAbsolutePath().indexOf(mainFileName);
                String entryName = mainFileName + file.getName();
                System.out.println(entryName);
                ZipEntry entry = new ZipEntry(entryName);
                out.putNextEntry(entry);
                //			byte[] data = new byte[BUFFER];
                int count;
                while ((count = origin.read(BUFFER, 0, BUFFER.length)) != -1) {
                    out.write(BUFFER, 0, count);
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (origin != null) {
                    try {
                        origin.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        } else if (file.isDirectory()) {
            File[] fs = file.listFiles();
            if (fs != null && fs.length > 0) {
                for (File f : fs) {
                    if (f.isFile())
                        compress(f, out, mainFileName);
                    else if (skipBuild && (f.getName()).equals("build")) {

                    } else {
                        compress(f, out, mainFileName + f.getName() + "/");
                    }

                }
            }
        }
    }

    private static void compress(File file, ZipOutputStream out, String mainFileName) {
        compress(file, out, mainFileName, false);
    }

    // 解压文件
    public static void unZip(String SourceDir) throws IOException {
        unZip(SourceDir, new File(SourceDir).getParent(), "");
    }

    public static void unZip(String SourceDir, boolean bool) throws IOException {
        if (!bool) {
            unZip(SourceDir);
            return;
        }
        String name = new File(SourceDir).getName();
        int i = name.lastIndexOf(".");
        if (i > 0) {
            name = name.substring(0, i);
        }
        i = name.indexOf("_");
        if (i > 0) {
            name = name.substring(0, i);
        }
        i = name.indexOf("(");
        if (i > 0) {
            name = name.substring(0, i);
        }
        unZip(SourceDir, new File(SourceDir).getParent() + separator + name, "");
    }

    public static void unZip(String SourceDir, String extDir) throws IOException {
        unZip(SourceDir, extDir, "");
    }

    public static void unZip(String SourceDir, String extDir, String fileExt) throws IOException {
        ZipFile zip = new ZipFile(SourceDir);
        Enumeration<? extends ZipEntry> entries = zip.entries();
        while (entries.hasMoreElements()) {
            ZipEntry entry = entries.nextElement();
            String name = entry.getName();
            if (!name.startsWith(fileExt))
                continue;
            String path = name;
            if (entry.isDirectory()) {
                File f = new File(extDir + separator + path);
                if (!f.exists())
                    f.mkdirs();
            } else {
                String fname = extDir + separator + path;
                File temp = new File(fname).getParentFile();
                if (!temp.exists()) {
                    if (!temp.mkdirs()) {
                        throw new RuntimeException("create file " + temp.getName() + " fail");
                    }
                }

                FileOutputStream out = new FileOutputStream(extDir + separator + path);
                InputStream in = zip.getInputStream(entry);
                byte[] buf = new byte[4096];
                int count = 0;
                while ((count = in.read(buf)) != -1) {
                    out.write(buf, 0, count);
                }
                out.close();
                in.close();
            }
        }
        zip.close();
    }


    public static String UriToFilePath(Context context, Uri uri) {
        if (!DocumentsContract.isDocumentUri(context, uri)) {
            return "content".equalsIgnoreCase(uri.getScheme()) ? getDataColumn(context, uri, null, null) : "file".equalsIgnoreCase(uri.getScheme()) ? uri.getPath() : null;
        } else {
            String document_id;
            String[] split;
            if (isExternalStorageDocument(uri)) {
                document_id = DocumentsContract.getDocumentId(uri);
                Log.d("getPath", document_id);
                split = document_id.split(":");
                return "primary".equalsIgnoreCase(split[0]) ? Environment.getExternalStorageDirectory() + "/" + split[1] : null;
            } else if (isDownloadsDocument(uri)) {
                document_id = DocumentsContract.getDocumentId(uri);
                Log.d("getPath", document_id);
                return getDataColumn(context, ContentUris.withAppendedId(Uri.parse("content://downloads/public_downloads"), Long.valueOf(document_id).longValue()), null, null);
            } else if (!isMediaDocument(uri)) {
                return null;
            } else {
                document_id = DocumentsContract.getDocumentId(uri);
                split = document_id.split(":");
                Log.d("getPath", document_id);
                Object obj = split[0];
                Uri uri_2 = null;
                if ("image".equals(obj)) {
                    uri_2 = Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(obj)) {
                    uri_2 = Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(obj)) {
                    uri_2 = Audio.Media.EXTERNAL_CONTENT_URI;
                }
                return getDataColumn(context, uri_2, "_id=?", new String[]{split[1]});
            }
        }
    }

    public static String getDataColumn(Context context, Uri uri, String str, String[] str_arr) {
        Cursor cursor = null;
        try {
            cursor = context.getContentResolver().query(uri, new String[]{"_data"}, str, str_arr, null);
            if (cursor == null || !cursor.moveToFirst()) {
                if (cursor != null) {
                    cursor.close();
                }
                return null;
            }
            String string = cursor.getString(cursor.getColumnIndexOrThrow("_data"));
            return string;
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
    }

    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }
}
