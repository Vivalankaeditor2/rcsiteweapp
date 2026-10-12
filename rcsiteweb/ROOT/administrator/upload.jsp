<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.util.*,com.rev_creations.util.*,java.io.*,com.rev_creations.rcsite.*" errorPage="" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%

String dir = "media2";
String dirString ="custom/media2/";	

if (request.getParameter("dir") !=null) {dir = (String)request.getParameter("dir");}

if(dir!=null && "images".equalsIgnoreCase(dir)){
	dirString ="custom/images/";
}else if(dir!=null && "media".equalsIgnoreCase(dir)){
	dirString ="custom/media/";
}else if(dir!=null && "rcmerchant".equalsIgnoreCase(dir)){
	dirString ="rcmerchant/images/";
}else if(dir!=null && "media3".equalsIgnoreCase(dir)){
	dirString ="custom/media3/";
}else{
	dirString ="custom/media2/";
}

String pageMessage="";
boolean overwrite =false;
String path =  com.rev_creations.rcsite.Config.getValue("upload.imagerealfolder");

 			/* new method for version 0.2 */

boolean saved = false;
String fileURL ="";
String fileName ="";
String fileSize ="";

FileUpload fu = new FileUpload(request);
boolean ok = fu.upload();
HashMap m = fu.getMimeParts();
	
if(!ok){
			//out.println(fu.getErrString());
    }else { 
      		
	  		MimeBodyPart part = (MimeBodyPart)m.get("overwrite");
				   
	   		if(part.getDataAsString() != null && part.getDataAsString().trim().equalsIgnoreCase("yes"))
	   			{	
					overwrite =true;
				}
			//part = (MimeBodyPart)m.get("dir");
			//dir=part.getDataAsString().trim();
			
			//if(part.getDataAsString() != null )
	   		//	{   //String dirString =dir;	
					path=path+"////";
					//while(dirString.indexOf("/")>0){
					//	path = path+dirString.substring(0, dirString.indexOf("/"))+"////";
					//	dirString = dirString.substring(dirString.indexOf("/"));
				//	}
					path = path+dirString.replaceAll("/","////")+"////";
 				//}
		
		 
	 	part = (MimeBodyPart)m.get("file1");
	  	part.setSaveDir(path);
	  	part.setOverwrite(overwrite);
		saved = part.saveFile();
		
		if(!saved) {
			pageMessage =pageMessage+ part.getErrString();	
		}else { 

				fileName =  part.getFileName();
				fileSize= part.getFileSize()+" bytes";
				fileURL = "../"+ dirString+part.getFileName();
				pageMessage =pageMessage+" File successfully saved in "+ dirString+" folder !";
			}
			
	}
//end upload
%>

<html>
<head>
	<title>Upload</title>
</head>


<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<%

  if(saved){
  %>
  <tr> 
    <td><table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#4d99e5">
        <tr> 
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
              <tr> 
                <td width="1%" align="center">&nbsp;</td>
                <td width="2%" class="text"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></font></td>
                <td colspan="2" class="text"><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td nowrap class="text">File Name:</td>
                <td class="text"><input name="textfield" type="text" value="<%=fileName%>"></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td class="text">File Size:</td>
                <td class="text"><%=fileSize%></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td width="11%" class="text">URL:</td>
                <td width="86%" class="text"><a href="<%=fileURL%>"><%=fileURL%></a></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td colspan="2" class="text">&nbsp; </td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
 
  <tr> 
    <td>&nbsp;</td>
  </tr>
    <%
  }
  %>
  
  <!-- Wikipedia Search Form -->
  <tr>
    <td>
    <br>
      <div class="wiki-search">
        <form action="wikiresult.jsp" method="get" accept-charset="UTF-8">
          <label for="searchTerm" style="padding-right: 3px;">Wikipedia Search:</label>
          <input type="text" id="searchTerm" name="searchTerm" size="50">
          <input type="submit" value="Search">
        </form>
      </div>
      <div class="image-download">
        <form method="post" action="ImageDownloadHelper.jsp">
        <label for="imageUrl">Enter Image URL:</label>
        <input type="text" id="imageUrl" name="imageUrl" size="50" />
        <input type="submit" value="Download" />
        </form>
      </div>
      <div class="wiki-search">
        <form action="findImage.jsp" method="get" accept-charset="UTF-8">
          <label for="searchTerm" style="padding-right: 3px;">Search for Local Images:</label>
          <input type="text" id="searchTerm" name="searchTerm" size="50">
          <input type="submit" value="Search">
        </form>
      </div>
       <div class="wiki-search">
        <form action="pixabayresult.jsp" method="get" accept-charset="UTF-8">
          <label for="searchTerm" style="padding-right: 3px;">Pixabay Search:</label>
          <input type="text" id="searchTerm" name="searchTerm" size="50">
          <input type="submit" value="Search">
        </form>
      </div>  
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td><table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#4d99e5">
        <tr> 
          <td height="124"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#4d99e5">
              <tr> 
          <td height="124"> 
            <form action="" method="post" enctype="multipart/form-data">
						  
              <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                <tr> 
                  <td width="0%" >&nbsp; </td>
                  <td width="2%" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></font></td>
                  <td colspan="2" ><strong>Upload file to <%=dirString%> folder</strong></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>Overwrite:</td>
                  <td><input type="radio" name="overwrite" value="yes">
                    Yes</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input name="overwrite" type="radio" value="no" checked>
                    No, change file name, if a file with same name exists.</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>File:</td>
                  <td><input name="file1" type="file" size="50"></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td width="9%"><input name="dir" type="hidden" value="<%=dir%>"></td>
                  <td width="89%"><table width="171" border="0" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td width="69"><input name="upload" type="submit" id="upload2" value="Upload"></td>
                        <td width="52"> <input name="cancel" type="button" id="cancel2" value="Cancel"> <br>
                        </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
            
                </tr>
                <tr> 
                  <td colspan="4" align="right"> 
                  </td>
                </tr>
                <tr> 
                  <td colspan="4" > </td>
                </tr>
              </table>
			</form></td>
        </tr>
      </table></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#4d99e5">
        <tr> 
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
              <tr> 
                <td width="1%" align="center">&nbsp;</td>
                <td width="2%" class="text"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></font></td>
                <td colspan="4" class="text"><strong>Content of <%=dirString%> folder</strong></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td width="7%" class="text"> Name </td>
                <td width="3%" class="text">&nbsp;</td>
                <td class="text"> URL</td>
              </tr>
              <%
			//String path2 = getServletContext().getRealPath("/")+"//"+dirString.replaceAll("/","//");
            String path2 = com.rev_creations.rcsite.Config.getValue("upload.imagerealfolder").replaceAll("/","//")+dirString.replaceAll("/","//");
            
            

			File f1 = new File(path2);
			 String[] fileNames =f1.list();
			 if(fileNames !=null){
			 	for(int i=0; i<fileNames.length; i++){
				 File f2= new File(fileNames[i]);
			//out.println("<a href=\\"+dir+"/"+fileNames[i]+">"+fileNames[i]+"</a>"+f2.lastModified()+"name"+f2.length() +"name"+f2.getName() +"<P>");
			
			 if(fileNames[i] !=null & fileNames[i].contains("tn.")){				 
			%>
              <tr> 
              <td>&nbsp;</td>
              <td class="text">&nbsp;</td>
              <td class="text"><%=i+1%>)&nbsp;&nbsp;</td>
              <td class="text">
              <img src="../<%=dirString%>/<%=fileNames[i]%>" width=200" height="100">
              <%=fileNames[i]%>
              <br>
              &nbsp;
              &nbsp;
              </td>
              <td width="3%" class="text">&nbsp;</td>
              <td width="83%" class="text">
              <input name="textfield2" type="text" value="../<%=dirString%><%=fileNames[i]%>" size="47">
              </td>
              </tr>
            <%
			 }
                 }
                }
             %>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td colspan="3" class="text">&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td width="6%" class="text">&nbsp;</td>
                <td colspan="3" class="text">&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td colspan="4" class="text">&nbsp; </td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>


	 

</body>
</html>