package com.mythoi.androluaj.util;
import java.io.*;

public class FileUtil
{

public static void write(String data, String toFile)
	{
		new File(toFile).getParentFile().mkdirs();
		try
		{
			FileOutputStream out=new FileOutputStream(toFile);
			byte[] b=data.getBytes();
			out.write(b, 0, b.length);
			out.close();
		}
		catch (Exception e)
		{
			
		}

	}

}