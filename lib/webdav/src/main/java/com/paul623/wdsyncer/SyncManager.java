package com.paul623.wdsyncer;

import android.content.Context;
import android.util.Log;

import com.paul623.wdsyncer.api.Encryption;
import com.paul623.wdsyncer.api.OnListFileListener;
import com.paul623.wdsyncer.api.OnSyncResultListener;
import com.paul623.wdsyncer.api.SyncApi;
import com.paul623.wdsyncer.model.DavData;
import com.paul623.wdsyncer.utils.FileUtils;
import com.thegrizzlylabs.sardineandroid.DavResource;
import com.thegrizzlylabs.sardineandroid.Sardine;
import com.thegrizzlylabs.sardineandroid.impl.OkHttpSardine;

import org.jetbrains.annotations.NotNull;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class SyncManager implements SyncApi {
    private Context context;
    private Sardine sardine;
    private SyncConfig syncConfig;
    public SyncManager(Context context) {
        this.context=context;
        sardine=new OkHttpSardine();
        if(SyncConfig.getDiyEncryption(context)){
            throw new RuntimeException("请配置Encryotion");
        }
        syncConfig =new SyncConfig(context);
    }
    public SyncManager(Context context, @NotNull Encryption encryption){
        this.context=context;
        sardine=new OkHttpSardine();
        if(!SyncConfig.getDiyEncryption(context)){
            throw new RuntimeException("Config中未配置Encryotion");
        }
        syncConfig =new SyncConfig(context, encryption);
    }

    @Override
    public void uploadFile(final String fileName, final String fileLoc, final File f, final OnSyncResultListener listener) {
        if(syncConfig.canLogin()){
            Thread T=new Thread(new Runnable() {
                @Override
                public void run() {
                    sardine.setCredentials(syncConfig.getUserAccount(), syncConfig.getPassWord());
                    try {
                        String[] splitLoc = fileLoc.split("/");
                        StringBuilder fullPath= new StringBuilder();
                        for(int i=1;i< splitLoc.length;i++){
                            fullPath.append(splitLoc[i]).append("/");
                            if(!sardine.exists(syncConfig.getServerUrl()+"/"+fullPath)){
                                //若不存在需要创建目录
                                sardine.createDirectory(syncConfig.getServerUrl()+"/"+fullPath);
                            }
                        }
                        byte[] data = FileUtils.File2byte(f);
                        sardine.put(syncConfig.getServerUrl()+fileLoc+"/"+fileName, data);
                        listener.onSuccess(fileLoc+"/"+fileName+",上传成功");
                    } catch (IOException e) {
                        e.printStackTrace();
                        listener.onError("出错了,"+e);
                    }
                }
            });
            T.start();
        }else {
            listener.onError("请先配置账户和服务器地址！");
        }

    }

    @Override
    public void uploadString(final String fileName, final String fileLoc, final String content, final OnSyncResultListener listener) {
        if(syncConfig.canLogin()){
            Thread T=new Thread(new Runnable() {
                @Override
                public void run() {
                    sardine.setCredentials(syncConfig.getUserAccount(), syncConfig.getPassWord());
                    try {
                        if(!sardine.exists(syncConfig.getServerUrl()+fileLoc+"/")){
                            //若不存在需要创建目录
                            sardine.createDirectory(syncConfig.getServerUrl()+fileLoc+"/");
                        }
                        byte[] data = content.getBytes();
                        sardine.put(syncConfig.getServerUrl()+fileLoc+"/"+fileName, data);
                        listener.onSuccess(fileLoc+"/"+fileName+",上传成功");
                    } catch (IOException e) {
                        e.printStackTrace();
                        listener.onError("出错了"+e);
                    }
                }
            });
            T.start();
        }else {
            listener.onError("请先配置账户和服务器地址！");
        }
    }

    @Override
    public void downloadFile(final String fileName, final String fileLoc, final OnSyncResultListener listener) {
        if(syncConfig.canLogin()){
            Thread T=new Thread(new Runnable() {
                @Override
                public void run() {
                    sardine.setCredentials(syncConfig.getUserAccount(), syncConfig.getPassWord());
                    try {
                        InputStream is = sardine.get(syncConfig.getServerUrl()+fileLoc+"/"+fileName);
                        final File[] dirs = context.getExternalFilesDirs("Documents");
                        File primaryDir = null;
                        if (dirs != null && dirs.length > 0) {
                            primaryDir = dirs[0];
                        }
                        if(primaryDir==null){
                            listener.onError("读取文件异常");
                            return;
                        }
                        int index;
                        byte[] bytes = new byte[1024];
                        FileOutputStream downloadFile = new FileOutputStream(primaryDir+"/"+fileName);
                        while ((index = is.read(bytes)) != -1) {
                            downloadFile.write(bytes, 0, index);
                            downloadFile.flush();
                        }
                        downloadFile.close();
                        is.close();
                        listener.onSuccess(primaryDir+"/"+fileName);
                    } catch (IOException e) {
                        e.printStackTrace();
                        listener.onError("出错了，"+e);
                    }
                }
            });
            T.start();
        }else {
            listener.onError("请先配置账户和服务器地址！");
        }
    }

    @Override
    public void downloadString(final String fileName, final String fileLoc, final OnSyncResultListener listener) {
        if(syncConfig.canLogin()){
            Thread T=new Thread(new Runnable() {
                @Override
                public void run() {
                    sardine.setCredentials(syncConfig.getUserAccount(), syncConfig.getPassWord());
                    InputStream inputStream;
                    try {
                        inputStream = sardine.get(syncConfig.getServerUrl()+fileLoc+"/"+fileName);
                        //设置输入缓冲区
                        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8)); // 实例化输入流，并获取网页代
                        String s; // 依次循环，至到读的值为空
                        StringBuilder sb = new StringBuilder();
                        while ((s = reader.readLine()) != null) {
                            sb.append(s);
                        }
                        reader.close();
                        inputStream.close();
                        String str = sb.toString();
                        listener.onSuccess(str);
                    } catch (IOException e) {
                        e.printStackTrace();
                        listener.onError("出错了,"+e);
                    }

                }
            });
            T.start();
        }else {
            listener.onError("请先配置账户和服务器地址！");
        }
    }

    @Override
    public void listAllFile(final String dir, final OnListFileListener listFileListener) {
        if(syncConfig.canLogin()){
            Thread T=new Thread(new Runnable() {
                @Override
                public void run() {
                    sardine.setCredentials(syncConfig.getUserAccount(), syncConfig.getPassWord());
                    try {
                        List<DavResource> resources = sardine.list(syncConfig.getServerUrl()+dir);//如果是目录一定别忘记在后面加上一个斜杠
                        List<DavData> davData=new ArrayList<>();
                        for(DavResource i:resources){
                            davData.add(new DavData(i));
                        }
                        listFileListener.listAll(davData);
                    } catch (IOException e) {
                        e.printStackTrace();
                        listFileListener.onError("出错了，"+e);
                    } catch (URISyntaxException e) {
                        e.printStackTrace();
                    }
                }
            });
            T.start();
        }else {
            listFileListener.onError("请先配置账户和服务器地址！");
        }
    }

    @Override
    public void deleteFile(final String fileDir, final OnSyncResultListener listener) {
        if(syncConfig.canLogin()){
            Thread T=new Thread(new Runnable() {
                @Override
                public void run() {
                    sardine.setCredentials(syncConfig.getUserAccount(), syncConfig.getPassWord());
                    try {
                        sardine.delete(syncConfig.getServerUrl()+fileDir);
                        listener.onSuccess("删除成功！");
                    } catch (IOException e) {
                        e.printStackTrace();
                        listener.onError("出错了,"+e);
                    }

                }
            });
            T.start();
        }else {
            listener.onError("请先配置账户和服务器地址！");
        }
    }


}
