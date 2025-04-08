package com.luastudio.azure.util;


import java.util.Arrays;

public class LuaRC4
{

	
	
	/**
     * 利用RC4算法用来加密字符串
     *
     * @param str  待被加密的字符串
     * @param need 密匙
     * @return 加密后的字符串
     */
	public static String encode(String aInput, String aKey)   
    {   
        int[] iS = new int[256];   
        byte[] iK = new byte[256];   

        for (int i=0;i < 256;i++)   
            iS[i] = i;   

        int j = 1;   

        for (short i= 0;i < 256;i++)   
        {   
            iK[i] = (byte)aKey.charAt((i % aKey.length()));   
        }   

        j = 0;   

        for (int i=0;i < 255;i++)   
        {   
            j = (j + iS[i] + iK[i]) % 256;   
            int temp = iS[i];   
            iS[i] = iS[j];   
            iS[j] = temp;   
        }   


        int i=0;   
        j = 0;   
        char[] iInputChar = aInput.toCharArray();   
        char[] iOutputChar = new char[iInputChar.length];   
        for (short x = 0;x < iInputChar.length;x++)   
        {   
            i = (i + 1) % 256;   
            j = (j + iS[i]) % 256;   
            int temp = iS[i];   
            iS[i] = iS[j];   
            iS[j] = temp;   
            int t = (iS[i] + (iS[j] % 256)) % 256;   
            int iY = iS[t];   
            char iCY = (char)iY;   
            iOutputChar[x] = (char)(iInputChar[x] ^ iCY) ;      
        }   

        return new String(iOutputChar);   
    } 



	/**
     * 利用RC4算法用来解密字符串,和加密方法相同,会自动解密
     *
     * @param str  待被解密的字符串
     * @param need 密匙
     * @return 解密后的字符串
     */
	public static String decode(String aInput, String aKey)   
    {   
		return encode(aInput, aKey);
	}

}
   
