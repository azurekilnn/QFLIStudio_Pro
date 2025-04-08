package com.luastudio.azure.util;

import com.duy.dex.Dex;
import com.duy.dx.merge.CollisionPolicy;
import com.duy.dx.merge.DexMerger;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class DexUtil {

    // 合并多个DEX文件的方法
    public static String mergeDex(ArrayList<String> dexFilePaths, String outputFilePath) {
        ArrayList<Dex> dexList = new ArrayList<>();

        // 遍历传入的DEX文件路径列表
        for (String dexPath : dexFilePaths) {
            try {
                // 读取每个DEX文件，并转换为Dex对象
                File dexFile = new File(dexPath);
                Dex dex = new Dex(dexFile);
                dexList.add(dex);
            } catch (IOException e) {
                return e.getMessage();
                // 如果读取DEX文件时出现异常，这里将异常忽略，不处理
            }
        }

        // 将Dex对象列表转换为Dex数组
        Dex[] dexArray = dexList.toArray(new Dex[0]);

        try {
            // 创建DexMerger对象，并使用KEEP_FIRST策略合并DEX文件
            DexMerger merger = new DexMerger(dexArray, CollisionPolicy.KEEP_FIRST);
            // 合并后的DEX对象
            Dex mergedDex = merger.merge();
            // 将合并后的DEX写入输出文件
            File outputFile = new File(outputFilePath);
            mergedDex.writeTo(outputFile);
        } catch (Exception e) {
            return e.getMessage();
            // 如果合并过程中出现异常，这里将异常忽略，不处理
        }
        return outputFilePath;
    }
}
