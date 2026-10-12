package com.rev_creations.util;

import java.io.*;
import java.util.zip.*;
import java.sql.*;

/**
  * Class that encapsulates Mime-Parts found by FileUpload class
  *
  *
  @author Daniel Rocha <a href="mailto:daniel@rawsocket.org">daniel@rawsocket.org</a> 
  @version 0.2
  @see com.blogspot.pontoflutuante.FileUpload
  
  */


public class MimeBodyPart {
	
	private String name;
	private String contentType;
	private String fileName;
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	private byte[] data;
	private boolean isFile;
	private String saveDir;
	private boolean overwrite = false;
	private final String tempDir = System.getProperty("java.io.tmpdir");
//	private final String tempDir = "\\images\\";
	private String err = "";
	
	public MimeBodyPart(String name, byte[] b, String fileName, String contentType) {
		this.name = name;
		this.data = b;
		this.contentType = contentType;
		this.fileName = fileName;
		this.isFile = (fileName != null);
  } 
	
	/**
	  Return this object's form Name attribute, the same as HTML input name.
	  
	  @return A String representing this object's name.
	  */
	
	public String getName() {
		return name;
	}
	
	/**
	  Return this object's fileName, if it is a file.
	  
	  @return If this object's a file, returns a String with its fileName; otherwise, returns default string.
	  */
		
	public String getFileName() {
		if(isFile) { 
			return fileName;
		}
		return "Either this is not a file, but a form text field, or it's empty.";
  }	

	/**
	  Return this object's fileSize, if it is a file.
	  
	  @return If this object's a file, returns an int with its fileSize; otherwise, returns 0.
	  */
		
	public int getFileSize() {
		if(isFile && data!=null) { 
			return data.length;
		}
		return 0;
	}			
	
	/**
	  Points if this object is a file or not.
	  
	  @return A boolean value of true if it's file, false otherwise.
	  */
	
	public boolean isFile() { 
		return isFile; 
		}
	
	/**
	  Returns this object's byte array. If it's not a file,
	  you should call getDataAsString, instead. A clone of the original byte array is returned, so it
	  won't get corrupted by direct manipulation of the array.
	  
	  @return A byte[] array, cloned from the orignal byte[] array source.
	  @see com.blogspot.pontoflutuante.MimeBodyPart#getDataAsString
	  */

	public byte[] getBytes() {
		return (byte[])data.clone(); 
	}

	/**
	  Returns this object's data as a String. Use it if this MimeBodyPart is not a file.
	  
	  @return A String representing the form field data.
	  */		
		
	public String getDataAsString() {
		return new String(data,0,data.length);
	}
	 
	/**
	  Sets directory for saving file data, if it's a file.	Creates directory specified by saveDir if it does not exist.
	  
	  @param saveDir : String representing a directory path. (you should escape \ characters)
	  @return void
	  */
	
	public void setSaveDir(String saveDir) {
		this.saveDir = saveDir;
		File f = new File(saveDir);
		if(!f.exists()) { 
			f.mkdirs(); //
		}
	}
	
	/**
	  Returns this object's current path for saving files. Added in version 0.1.1
	  
	  @return A String representing directory path.
	  */		
	
	public String getSaveDir() { 
		return saveDir;
	}

	/**
	  Sets the behavior on case of files with the same name being saved.
	  Set it to true to overwrite existing file with same name, false otherwise.
	  
	  @param boolean : overwrite
	  @return void
	  */
	
	public void setOverwrite(boolean overwrite) {
		this.overwrite = overwrite;
	}	
	
	/**
	  Returns this object's current behavir for overwriting files. Added in version 0.1.1
	  
	  @return true whether overwrite is set to true, false otherwise.
	  */		
	 
	public boolean getOverwrite() {
		return overwrite;
	} 
	
	/**
	  Returns this object's content-type, if it's a file. Otherwise returns null. Added in version 0.1.1
	  
	  @return A String representing content-type, or null if it's not a file.
	  */		
	
	public String getContentType() { 
		if(isFile) {
			return contentType;
		}
		else {
			return null;
		}
	}
	
	/**
	  Saves this object's file data on System's temp directory or on directory
	  specified by setSaveDir method.
	  
	  @return boolean : true if could save. false otherwise.
	  */
	
	public boolean saveFile() { 
    if(isFile) {
			if(fileName != null && data != null) {
				if(saveDir == null || saveDir.equals("")) 
					saveDir = tempDir;
				try {
					File f = new File(saveDir + fileName);
					if( (f.exists() && overwrite) || !f.exists()) {
						OutputStream os = new FileOutputStream(f);
						os.write(data);
						os.close();
          }
					else {
						/*
						err = "There is a file with the same name on this directory, and ";
						err += "current default behavior is not overwrite.";
						return false;
						
						The behavior descibed above is being changed for this 0.2 version.
						Instead of returning an error message, the class generates a new filename
						and sets this object's fileName property to the new generated name, thus
						making sure the file is saved in spite of 'overwrite' flag that has been set.
						
						*/
						/* generates an unique file name and sets fileName property to the new
						   generated name */
						   
						fileName = GeneralUtilities.generateFileName(saveDir,fileName);   
						f = new File(saveDir + fileName);
						OutputStream os = new FileOutputStream(f);
						os.write(data);
						os.close(); 
					}
        }
				catch(IOException e) {
					err = e.toString();
					return false;
				}
      }
    } // isFile
		else {
			err = "This object is not a file and won't be saved.";
			return false;
    }	
		return true;
  } 

	/**
	  Saves this object's file data on System's temp directory or on directory
	  specified by setSaveDir method, compressing it into a Zip file.
	  
	  @return boolean : true if could save. false otherwise.
	  */
	
	public boolean saveAsZipFile() { 

		if(isFile) {
			if(fileName != null && data != null) {
				if(saveDir == null || saveDir.equals("")) 
					saveDir = tempDir;
				try {
					File f = new File(saveDir + fileName + ".zip");
					if( (f.exists() && overwrite) || !f.exists()) {
						ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(f));
						ZipEntry ze = new ZipEntry(saveDir + fileName);
						zos.putNextEntry(ze);						
						zos.write(data);
						zos.closeEntry();						
						zos.close();
						fileName += ".zip";
          }
          else {
						/*
						This class generates a new filename
						and sets this object's fileName property to the new generated name, thus
						making sure the file is saved in spite of 'overwrite' flag that has been set.
						Added in 0.2
						
						*/
						/* generates an unique file name and sets fileName property to the new
						   generated name */
						   
						fileName = GeneralUtilities.generateFileName(saveDir,fileName + ".zip");   
						f = new File(saveDir + fileName);
						ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(f));
						ZipEntry ze = new ZipEntry(saveDir + fileName);
						zos.putNextEntry(ze);						
						zos.write(data);
						zos.closeEntry();						
						zos.close();
          }
        }
				catch(IOException e) {
					err = e.toString();
					return false;
        }
      }
    } // isFile
		else {
			err = "This object is not a file and won't be saved.";
			return false;
    }	
		return true;
		} 

	/**
	  Saves this object's file data on System's temp directory or on directory
	  specified by setSaveDir method, compressing it into a GZip file.
	  
	  @return boolean : true if could save. false otherwise.
	  */
	
	public boolean saveAsGZipFile() { 

		if(isFile) {
			if(fileName != null && data != null) {
				if(saveDir == null || saveDir.equals("")) 
					saveDir = tempDir;
				try {
					File f = new File(saveDir + fileName + ".gz");
					if( (f.exists() && overwrite) || !f.exists()) {
						GZIPOutputStream zos = new GZIPOutputStream(new FileOutputStream(f));
						zos.write(data);
						zos.close();
						fileName += ".gz";
          }
					else {
						/*
						This class generates a new filename
						and sets this object's fileName property to the new generated name, thus
						making sure the file is saved in spite of 'overwrite' flag that has been set.
						Added in 0.2
						
						*/
						/* generates an unique file name and sets fileName property to the new
						   generated name */
						   
						fileName = GeneralUtilities.generateFileName(saveDir,fileName + ".gz");   
						f = new File(saveDir + fileName);
						GZIPOutputStream zos = new GZIPOutputStream(new FileOutputStream(f));						
						zos.write(data);				
						zos.close();
					}
        }
				catch(IOException e) {
					err = e.toString();
					return false;
				}
      }
    } // isFile
		else {
			err = "This object is not a file and won't be saved.";
			return false;
		}	
		return true;
  } 		

	/**
	  Saves file to a database, as a blob field. There are problems with some Mysql configurations,
	  especially when it comes to binary field size. Works fine with other database systems.
	  
	  @param driver : string representing the path to the driver class
	  @param url : the JDBC url for the database
	  @param uid : database user id
	  @param pwd : database password
	  @param command : prepared statement where blob field is the only parameter (e.g.: insert into blobber(blobfield) values (?)
	  @return boolean : true if could save. false otherwise.
	  */
	 
	public boolean saveToDatabaseAsBLOB(String driver, String url, 
										String uid, String pwd, String command){ 
	
		boolean ok = true;
	
		try {
			Class.forName(driver);
			Connection c = DriverManager.getConnection(url,uid,pwd);
			if(c!=null) {
				PreparedStatement ps = c.prepareStatement(command);
				ps.setBytes(1,data);
				ps.execute();
				ps.close();
				c.close();
      }
    }
		catch(SQLException e) {
			err = e.toString();
			ok = false;
		}
		catch(ClassNotFoundException e1) {
			err = e1.toString();
			ok = false;			
		}			
		
		return ok;
		
  }		
	
	/** 
	   This method returns a String object whose value is the last error ocurred, or
	   an empty string in case of no-errors. Call it to find out what happened wrong
	   if any of boolean-type methods return false.
	   
	   @return A String object whose value is the last error ocurred, or
	   an empty string in case of no-errors.
	   
	   */
	
	public String getErrString() {
		return err;
  }
	
} // mimebodypart