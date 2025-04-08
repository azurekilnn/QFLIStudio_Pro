package com.luastudio.azure.util;

import java.io.*;




/**
 * @author: OpenEyez
 * @className: LuaFile
 * @packageName: com.androlua
 * @data: 2020.4.22
 * @description: 这个类是一个关于文件操作方面的工具类,
 集成了很多方法,让
 **/



public class LuaFile
{

	
	/*
	
	*/
	public boolean fileIsExists(String strFile)
    {
        try
        {
            File f=new File(strFile);
            if(!f.exists())
            {
                return false;
            }

        }
        catch (Exception e)
        {
            return false;
        }

        return true;
    }
	
	
	
	
	
	

	//获得文件或者文件夹的上级目录
	public static String getParent(String nowPath)
	{
		File dir = new File(nowPath);
		return dir.getParent();
	}

	//判断路径是否是文件夹
	public static Boolean isDir(String nowPath)
	{
		File f = new File(nowPath);
		return f.isDirectory();
	}

    //判断路径是否是文本文件
	public static Boolean isFile(String nowPath)
	{
		File f = new File(nowPath);
		return f.isFile();
	}
	
	
	public static String write(String path,String str) throws Exception{
		String sourceString = str;//待写入字符串
		byte[] sourceByte = sourceString.getBytes();
		if(null != sourceByte){
			try {
				File file = new File(path);		//文件路径（路径+文件名）
				if (!file.exists()) {	//文件不存在则创建文件，先创建目录
					File dir = new File(file.getParent());
					dir.mkdirs();
					file.createNewFile();
				}
				FileOutputStream outStream = new FileOutputStream(file);	//文件输出流用于将数据写入文件
				outStream.write(sourceByte);
				outStream.close();	//关闭文件输出流
				return str;
			} catch (Exception e) {
			   throw new Exception(e);
			}
		}
		return "";
	}
	
	
	/**

     * 删除文件，可以是单个文件或文件夹

     * 

     * @param fileName

     *            待删除的文件名

     * @return 文件删除成功返回true,否则返回false

     */

    public static boolean delete(String fileName) {

        File file = new File(fileName);

        if (!file.exists()) {

            System.out.println("删除文件失败：" + fileName + "文件不存在");

            return false;

        } else {

            if (file.isFile()) {



                return deleteFile(fileName);

            } else {

                return deleteDirectory(fileName);

            }

        }

    }


	
	public static String read(String fileName) {  
        String encoding = "UTF-8";  
        File file = new File(fileName);  
        Long filelength = file.length();  
        byte[] filecontent = new byte[filelength.intValue()];  
        try {  
            FileInputStream in = new FileInputStream(file);  
            in.read(filecontent); 
			in.close();
            return new String(filecontent, encoding);
        } catch (Exception e) {  
            e.printStackTrace();  
			return null;
        } finally {
			
        }  
    }  
	
	
	
	
	
	
	
	
	

    /**

     * 删除单个文件

     * 

     * @param fileName

     *            被删除文件的文件名

     * @return 单个文件删除成功返回true,否则返回false

     */

    public static boolean deleteFile(String fileName) {

        File file = new File(fileName);

        if (file.isFile() && file.exists()) {

            file.delete();

            System.out.println("删除单个文件" + fileName + "成功！");

            return true;

        } else {

            System.out.println("删除单个文件" + fileName + "失败！");

            return false;

        }

    }



    /**

     * 删除目录（文件夹）以及目录下的文件

     * 

     * @param dir

     *            被删除目录的文件路径

     * @return 目录删除成功返回true,否则返回false

     */

    public static boolean deleteDirectory(String dir) {

        // 如果dir不以文件分隔符结尾，自动添加文件分隔符

        if (!dir.endsWith(File.separator)) {

            dir = dir + File.separator;

        }

        File dirFile = new File(dir);

        // 如果dir对应的文件不存在，或者不是一个目录，则退出

        if (!dirFile.exists() || !dirFile.isDirectory()) {

            System.out.println("删除目录失败" + dir + "目录不存在！");

            return false;

        }

        boolean flag = true;

        // 删除文件夹下的所有文件(包括子目录)

        File[] files = dirFile.listFiles();

        for (int i = 0; i < files.length; i++) {

            // 删除子文件

            if (files[i].isFile()) {

                flag = deleteFile(files[i].getAbsolutePath());

                if (!flag) {

                    break;

                }

            }

            // 删除子目录

            else {

                flag = deleteDirectory(files[i].getAbsolutePath());

                if (!flag) {

                    break;

                }

            }

        }



        if (!flag) {

            System.out.println("删除目录失败");

            return false;

        }



        // 删除当前目录

        if (dirFile.delete()) {

            System.out.println("删除目录" + dir + "成功！");

            return true;

        } else {

            System.out.println("删除目录" + dir + "失败！");

            return false;

        }

    }

    // 删除文件夹

    // param folderPath 文件夹完整绝对路径



    public static void delFolder(String folderPath) {

        try {

            delAllFile(folderPath); // 删除完里面所有内容

            String filePath = folderPath;

            filePath = filePath.toString();

            java.io.File myFilePath = new java.io.File(filePath);

            myFilePath.delete(); // 删除空文件夹

        } catch (Exception e) {

            e.printStackTrace();

        }

    }



    // 删除指定文件夹下所有文件

    // param path 文件夹完整绝对路径

    public static boolean delAllFile(String path) {

        boolean flag = false;

        File file = new File(path);

        if (!file.exists()) {

            return flag;

        }

        if (!file.isDirectory()) {

            return flag;

        }

        String[] tempList = file.list();

        File temp = null;

        for (int i = 0; i < tempList.length; i++) {

            if (path.endsWith(File.separator)) {

                temp = new File(path + tempList[i]);

            } else {

                temp = new File(path + File.separator + tempList[i]);

            }

            if (temp.isFile()) {

                temp.delete();

            }

            if (temp.isDirectory()) {

                delAllFile(path + "/" + tempList[i]);// 先删除文件夹里面的文件

                delFolder(path + "/" + tempList[i]);// 再删除空文件夹

                flag = true;

            }

        }

        return flag;

    }



    
	
	
	



}
