package com.luastudio.azure.system;

import android.annotation.SuppressLint;

import com.luastudio.azure.AzureLibrary;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

public class SystemLibrary {

    public static String getCurrentTime() {
        Date nowData = Calendar.getInstance().getTime();
        @SuppressLint("SimpleDateFormat") SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd_HHmmss");
        return (format.format(nowData));
    }

    //工程备份
    public static boolean backupProject(String projectPath) {
        String outputPath = AzureLibrary.backupsDir;
        return backupProject(projectPath, outputPath);
    }


    public static boolean backupProject(String projectPath,String outputPath) {
        return backupProject(projectPath, outputPath, false);
    }

    public static boolean backupProject(String projectPath,String outputPath, boolean skipBuild) {
        File fileObject = new File(projectPath);
        String fileName = fileObject.getName();
        String backupFileName = fileName + "_" + getCurrentTime() + ".lsz";
        return AzureLibrary.zip(projectPath,outputPath,backupFileName,skipBuild);
    }

    //删除工程
    public static boolean deleteProject(String projectPath) {
     return AzureLibrary.rmDir(projectPath);
    }

    public static HashMap loadProjectList() {
         File projectsDirFile = new File(AzureLibrary.projectsDir);
         File[] projectListFiles = projectsDirFile.listFiles();
         HashMap<String, String> projectsData = new HashMap<String, String>();
         return projectsData;
    }
    /*public static void saveProjectList(String filePath) throws IOException {
        HashMap projectsTable = loadProjectList();
        Object luaDump = AzureUtil.luaDump(projectsTable);
        String saveContent = String.valueOf(luaDump);
        try {
            AzureLibrary.writeFile(filePath,saveContent);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }*/
    /*public static String getProjectList() {
        LuaTable projectsTable = loadProjectList();
        Object luaDump = AzureUtil.luaDump(projectsTable);
        String saveContent = String.valueOf(luaDump);
        return saveContent;
    }*/
}
