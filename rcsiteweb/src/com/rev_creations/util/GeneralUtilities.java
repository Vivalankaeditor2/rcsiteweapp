package com.rev_creations.util;

import java.io.*;

/**
  * Class with some utility methods
  *
  *
  @author Daniel Rocha <a href="mailto:daniel@rawsocket.org">daniel@rawsocket.org</a> 
  @version 0.1.1
  @see com.blogspot.pontoflutuante.MimeBodyPart
  
  */
 

public class GeneralUtilities {
	/**
	
	Generates a unique file name within a given directory.
	
	@return a String containing generated file name.
	
	*/
	public static String generateFileName(String dir,String fileName) { 
		File f = new File(dir + fileName);
		while(f.exists()) { 
			fileName = Math.round(Math.random()*100) + "_" + fileName;
			f = new File(dir + fileName);
    }
		return fileName;
  } 
} // GeneralUtilities