package com.rev_creations.util;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

/**
  * Just a test servlet to debug FileUpload class. Use it for testing and
  * to see how to use FileUpload and MimeBodyPart classes.
  *
  *
  @author Daniel Rocha <a href="mailto:daniel@rawsocket.org">daniel@rawsocket.org</a> 
  @version 0.2
  @see com.blogspot.pontoflutuante.FileUpload
  
  */

public class FileUploadServlet extends HttpServlet {

	public void doPost(HttpServletRequest request,HttpServletResponse response) 
		throws IOException,ServletException {
		
		PrintWriter out = response.getWriter();
		FileUpload fu = new FileUpload(request);
		response.setContentType("text/html");
		response.setHeader("Cache-control","no-cache");
		long tempo1 = new Date().getTime();
		boolean ok = fu.upload();
		
		out.println("<html><head><title>Testing File Upload Class</title></head>");
		out.println("<body>\n");
		
		if(!ok)	{
			out.println(fu.getErrString());
    }
		else { 
      HashMap m = fu.getMimeParts();
			// testing for a simple form text field called name
			MimeBodyPart part = (MimeBodyPart)m.get("name");
			out.println(part.getName() + "=" + part.getDataAsString());
			out.println("<br>");
			// testing for another form field called email
			part = (MimeBodyPart)m.get("email");
  		out.println(part.getName() + "=" + part.getDataAsString());
  		out.println("<br>");
			// testing for a select multiple (or multiple text fields with the same name, as well)
			Vector v = (Vector)m.get("languages");
			for(int i=0;i<v.size();i++) {
			 	part = (MimeBodyPart)v.get(i);
			 	out.println(part.getName() + "=" + part.getDataAsString());
				out.println("br>");
      }
			// testing for uploaded (or not) file
			out.println("<hr>");
			part = (MimeBodyPart)m.get("file1");
			/* you should not call getFileName() until file has been saved,
				 because it could get a machine-generated name and right now
				 you would be with a wrong fileName */
			out.println(part.getName() + "=" + part.getFileName());
			out.println("File Size = " + part.getFileSize());
			out.println("<br>");
			out.println("It's a file = " + part.isFile());
			out.println("<br>");
			boolean saved = part.saveFile();
			out.println("Saved to default directory = " + saved);
			if(!saved) out.println("<br>" + part.getErrString());
			else { 
			  /* now is the correct time to call getFileName(); */
			 	out.println("<br> " + part.getName() + "=" + part.getFileName());
				/* 3 new methods by version 0.1.1 */
			 	out.println("<br> " + part.getName() + "- Overwrite = " + part.getOverwrite());				
			 	out.println("<br> " + part.getName() + "- SaveDir = " + part.getSaveDir());
			 	out.println("<br> " + part.getName() + "- Content-Type = " + part.getContentType());
				out.println("<br>");
			}
				
			/* testing for FileUpload.setSaveDir, which sets the path for saving files
			   for the entire collection */
			// all files will be saved to servlet context root/uploads from now on/
			String path = getServletContext().getRealPath("/") + "uploads////";
 			/* new method for version 0.2 */
			fu.setSaveDir(path);
			 
			for(int i=2;i<4;i++) {
	  	  out.println("<hr>");
			  part = (MimeBodyPart)m.get("file" + i) ;
			  /* you should not call getFileName() until file has been saved,
			  	 because it could get a machine-generated name and right now
				 you would be with a wrong fileName */
			  out.println(part.getName() + "=" + part.getFileName());
			  out.println("File Size = " + part.getFileSize());
			  out.println("<br>");
			  out.println("It's a file = " + part.isFile());
			  out.println("<br>");
			  saved = part.saveFile();
			  out.println("Saved to " + path + " directory = " + saved);
			  if(!saved) out.println("<br>" + part.getErrString());
			  else { 
			    /* now is the correct time to call getFileName(); */
			  	out.println("<br> " + part.getName() + "=" + part.getFileName());
          /* 3 new methods by version 0.1.1 */
			  	out.println("<br> " + part.getName() + "- Overwrite = " + part.getOverwrite());				
				 	out.println("<br> " + part.getName() + "- SaveDir = " + part.getSaveDir());
				 	out.println("<br> " + part.getName() + "- Content-Type = " + part.getContentType());
					out.println("<br> ");
        }
      } // for
				
			//zip file test
			out.println("<hr>");
			part = (MimeBodyPart)m.get("file4") ;
			  /* you should not call getFileName() until file has been saved,
			  	 because it could get a machine-generated name and right now
					 you would be with a wrong fileName */
			out.println(part.getName() + "=" + part.getFileName());
			out.println("File Size = " + part.getFileSize());
			out.println("<br>");
			out.println("It's a file = " + part.isFile());
			out.println("<br>");
			/* new method for version 0.2 */
			saved = part.saveAsZipFile();
			out.println("Saved to " + path + " directory = " + saved);
			if(!saved) out.println("<br>" + part.getErrString());
			else { 
			  /* now is the correct time to call getFileName(); */
			  out.println("<br> " + part.getName() + "=" + part.getFileName());
				/* 3 new methods by version 0.1.1 */
				out.println("<br> " + part.getName() + "- Overwrite = " + part.getOverwrite());				
			 	out.println("<br> " + part.getName() + "- SaveDir = " + part.getSaveDir());
			 	out.println("<br> " + part.getName() + "- Content-Type = " + part.getContentType());
				out.println("<br> ");
			}
					
			//Gzip file test
			out.println("<hr>");
			part = (MimeBodyPart)m.get("file5") ;
			 /* you should not call getFileName() until file has been saved,
			  	 because it could get a machine-generated name and right now
					 you would be with a wrong fileName */
			out.println(part.getName() + "=" + part.getFileName());
			out.println("File Size = " + part.getFileSize());
			out.println("<br>");
			out.println("It's a file = " + part.isFile());
			out.println("<br>");
			/* new method for version 0.2 */
			saved = part.saveAsGZipFile();
			out.println("Saved to " + path + " directory = " + saved);
			if(!saved) out.println("<br>" + part.getErrString());
			else { 
			  /* now is the correct time to call getFileName(); */
			  out.println("<br> " + part.getName() + "=" + part.getFileName());
				/* 3 new methods by version 0.1.1 */
			 	out.println("<br> " + part.getName() + "- Overwrite = " + part.getOverwrite());				
			 	out.println("<br> " + part.getName() + "- SaveDir = " + part.getSaveDir());
			 	out.println("<br> " + part.getName() + "- Content-Type = " + part.getContentType());
        out.println("<br> ");
			}

			//Database upload test
			out.println("<hr>");
			part = (MimeBodyPart)m.get("file6") ;
			out.println(part.getName() + "=" + part.getFileName());
			out.println("File Size = " + part.getFileSize());
			out.println("<br>");
			out.println("It's a file = " + part.isFile());
			out.println("<br>");
			/* new method for version 0.2 */
				
			String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
			String url = "jdbc:odbc:mysql";
			String uid = "";
			String pwd = "";
			String insert = "INSERT INTO BLOBBER(Bobject) VALUES (?)";
			saved = part.saveToDatabaseAsBLOB(driver, url, uid, pwd, insert);
				
			out.println("Saved to " + path + " directory = " + saved);
			if(!saved) out.println("<br>" + part.getErrString());
			else { 
			  /* now is the correct time to call getFileName(); */
			  out.println("<br> " + part.getName() + "=" + part.getFileName());
				/* 3 new methods by version 0.1.1 */
				out.println("<br> " + part.getName() + "- Overwrite = " + part.getOverwrite());				
			 	out.println("<br> " + part.getName() + "- SaveDir = " + part.getSaveDir());
			 	out.println("<br> " + part.getName() + "- Content-Type = " + part.getContentType());
				out.println("<br> ");
			}					
					
			long tempo2 = new Date().getTime();
			out.println("It took " + (double)(tempo2 - tempo1)/1000 + " seconds to perform the upload.");
		}
		out.println("</body></html>");
		}		
	public void doGet(HttpServletRequest request,HttpServletResponse response) 
		throws IOException,ServletException {
		//doPost(request,response);
		response.sendRedirect("error.html");
  }		

}
