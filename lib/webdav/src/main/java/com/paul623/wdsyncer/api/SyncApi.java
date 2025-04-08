package com.paul623.wdsyncer.api;

import java.io.File;

public interface SyncApi {
    /**
     * 上传文件
     * @param fileName 文件名 包含后缀名
     * @param fileLoc 文件目录 如：homeLoc/
     * @param listener 返回信息为 文件路径，上传成功
     * */
    public void uploadFile(String fileName, String fileLoc, File f, OnSyncResultListener listener);
    /**
     * 上传String类型数据
     * 你可以直接把文件格式设置为txt即可
     * @param fileName 文件名 包含后缀名
     * @param fileLoc 文件目录 如：homeLoc/
     * @param listener 返回信息为 文件路径，上传成功
     * */
    public void uploadString(String fileName, String fileLoc, String content, OnSyncResultListener listener);

   /**
    * 下载文件
    * @param listener 返回的是文件保存路径
    * 默认保存路径在：应用的私有路径下
    * */
    public void downloadFile(String fileName, String fileLoc, OnSyncResultListener listener);
    /**
     * 下载文件
     * @param listener 返回的是内容
     * */
    public void downloadString(String fileName, String fileLoc, OnSyncResultListener listener);

    /**
     * 列出所有文件信息
     * @param listFileListener 具体参看DavData
     * */
    public void listAllFile(String dir, OnListFileListener listFileListener);

    /**
     * 删除文件
     * @param fileDir 文件目录
     * */
    public void deleteFile(String fileDir, OnSyncResultListener listener);
}
