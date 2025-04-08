package com.luastudio.azure.util;
import java.util.*;

public class LuaString
{
	
	
	/**
     * 查找某个字符在字符串中出现的位置信息
     *
     * @param str  待被查找的字符串
     * @param need 待查找的字符
     * @return 位置信息的一个二维数组
     */
    public static int[][] gfind(String str, String need) {
        if (str == null || need == null) {
            return null;
        }
        char strArr[] = str.toCharArray();
        int needLen = need.length();
        int strLen = str.length();
        if (needLen > strLen) {
            return null;
        }
        int count = 0;
        boolean flag = true;
        List<Integer> start = new ArrayList<Integer>();
        for (int i = 0; i < strArr.length; i++) {
            StringBuilder builder = new StringBuilder();
            for (int j = 0; j < needLen; j++) {
                if ((i + j) >= strLen) {
                    flag=false;
                    break;
                }
                builder.append(strArr[i + j]);
            }
            if (!flag) {
                break;
            }
            if (builder.toString().equals(need)) {
                count++;
                start.add(i);
            }
        }
        int[][] index = new int[count][2];
        for (int i = 0; i < start.size(); i++) {
            index[i][0] = start.get(i);
            index[i][1] = start.get(i) + (needLen - 1);
        }
        return index;
    }
	public static int[][] 查找字符串位置(String str,String need) {
        return gfind(str,need);
    }


	/**
	 * 判断字符串是否为空
	 * 
	 * @param str
	 * @return 
	 */
	public static boolean isEmpty(String str)
	{
		// 如果字符串不为null，去除空格后值不与空字符串相等的话，证明字符串有实质性的内容
		if (str != null && !str.trim().isEmpty())
		{
			return false;// 不为空
		}
		return true;// 为空
	}
	public static boolean 是否为空(String str) {
        return isEmpty(str);
    }
	
	

	/**
	 * 返回字符串的长度
	 * 
	 * @param str
	 * @return int
	 */
	public static int length(CharSequence str) {
        return str == null ? 0 : str.length();
    }
	
	/**
	 * 返回字符串的长度
	 * 
	 * @param str
	 * @return int
	 */
	public static int size(CharSequence str) {
        return str == null ? 0 : str.length();
    }
	public static int 长度(String str) {
        return length(str);
    }
	
	
	
	
	/**
	 * 首字母大写
	 * 
	 * @param str
	 * @return string 
	 */
	public static String capitalizeFirstLetter(String str) {
        if (isEmpty(str)) {
            return str;
        }
        char c = str.charAt(0);
        return (!Character.isLetter(c) || Character.isUpperCase(c)) ? str : new StringBuilder(str.length())
			.append(Character.toUpperCase(c)).append(str.substring(1)).toString();
    }
	public static String 首字母大写(String str) {
        return capitalizeFirstLetter(str);
    }
	
	
	
	
	
	
}
