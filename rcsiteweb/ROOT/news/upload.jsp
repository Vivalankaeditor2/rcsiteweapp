<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.util.*,com.rev_creations.util.*,java.io.*" errorPage="" %>
<%@ include file="../custom/config.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%
String username = "user1";
// *** Restrict Access To Page: Grant or deny access to this page

String MM_authorizedUsers="";
String MM_authFailedURL="../user/login.jsp";
boolean MM_grantAccess=false;
if (session.getValue("MM_Username") != null && !session.getValue("MM_Username").equals("")) {
  if (true || (session.getValue("MM_UserAuthorization")=="") || 
          (MM_authorizedUsers.indexOf((String)session.getValue("MM_UserAuthorization")) >=0)) {
    MM_grantAccess = true;
  }
}
if (!MM_grantAccess) {
  String MM_qsChar = "?";
  if (MM_authFailedURL.indexOf("?") >= 0) MM_qsChar = "&";
  String MM_referrer = request.getRequestURI();
  if (request.getQueryString() != null) MM_referrer = MM_referrer + "?" + request.getQueryString();
  MM_authFailedURL = MM_authFailedURL + MM_qsChar + "accessdenied=" + java.net.URLEncoder.encode(MM_referrer);
  response.sendRedirect(response.encodeRedirectURL(MM_authFailedURL));
  return;
}
username = (String)session.getValue("MM_Username");
%>
<%

String dir = "custom/media2/";
String allowedContentTypes = "image";

//if (request.getParameter("dir") !=null) {dir = (String)request.getParameter("dir");}
String pageMessage="";
boolean overwrite =false;
int maxFileSize = 200000;
List uploadedFiles = (ArrayList)session.getAttribute("uploadedFiles");
if(uploadedFiles== null){
uploadedFiles = new ArrayList();
}

String path = getServletContext().getRealPath("/");
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
      		
	  		MimeBodyPart part ;//= (MimeBodyPart)m.get("overwrite");
		/*	   
	   		if(part.getDataAsString() != null && part.getDataAsString().trim().equalsIgnoreCase("yes"))
	   			{	
					overwrite =true;
				}
			part = (MimeBodyPart)m.get("dir");
			dir=part.getDataAsString().trim();
			
			if(part.getDataAsString() != null )
	   			{   String dirString =dir;	
					path=path+"////";
					while(dirString.indexOf("/")>0){
						path = path+dirString.substring(0, dirString.indexOf("/"))+"////";
						dirString = dirString.substring(dirString.indexOf("/"));
					}
					path = path+dirString+"////";
 				}
		*/
		path = path+"////"+dir+"////";
		
	 	part = (MimeBodyPart)m.get("file1");
	 	if(part.getFileSize()>maxFileSize){
	 		pageMessage =pageMessage+" File too large!";
	 	}else if(!part.isFile() || !part.getContentType().contains(allowedContentTypes)){
	 		pageMessage =pageMessage+" File not allowed/invalid";
	 	}else{
	 	    part.setFileName(username+part.getFileName());
	  		part.setSaveDir(path);
	  		part.setOverwrite(overwrite);
			saved = part.saveFile();
		}
		if(!saved) {
			pageMessage =pageMessage+ part.getErrString();	
		}else { 
        
				fileName =  part.getFileName();
				fileSize= part.getFileSize()+" bytes";
				fileURL = wwwUrl+"/"+ dir+part.getFileName();
				uploadedFiles.add(fileURL);
				session.setAttribute("uploadedFiles",uploadedFiles);
				pageMessage =pageMessage+" File successfully uploaded!";
			}
			
	}
//end upload
%>
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
	<title>Upload</title>
</head>


<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="2" class="text"><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
  </tr>

  <tr>
    <td><table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#4d99e5">
        <tr> 
          <td height="100"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#4d99e5">
              <tr> 
          <td height="100"> 
            <form action="" method="post" enctype="multipart/form-data">
						  
              <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                <tr> 
                  <td width="0%" >&nbsp; </td>
                  <td width="2%" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><img src="../custom/images/nav_rightarrow_off.gif" width="6" height="10"></font></td>
                  <td colspan="2" ><strong>Image Upload</strong></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td> Max. File Size : <%=maxFileSize/1000%> kB </td>
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
                  <td width="10%"><input name="dir" type="hidden" value="<%=dir%>"></td>
                  <td width="88%"><table width="171" border="0" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td width="69"><input name="upload" type="submit" id="upload2" value="Upload"></td>
                        <td width="52"> <input name="cancel" type="button" id="cancel2" value="Cancel"> 
                        </td>
                      </tr>
                    </table></td>
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
  <%
if(!uploadedFiles.isEmpty()){
  %>
  <tr> 
    <td><table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#4d99e5">
        <tr> 
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
              <tr> 
                <td width="1%" align="center">&nbsp;</td>
                <td width="2%" class="text"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><img src="../custom/images/nav_rightarrow_off.gif" width="6" height="10"></font></td>
                <td colspan="2" class="text"><strong>Images uploaded in this session.</strong></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td width="2%" class="text">&nbsp;</td>
                <td  class="text">Drag image to Details text area or use <img src="../jscripts/tiny_mce/themes/advanced/images/image.gif" width="20" height="20"> (insert/edit image) button to add image to the article</td>

              </tr>
              <%
			String path2 = getServletContext().getRealPath("/")+"//"+dir+"//";

			//File f1 = new File(path2);
			// String[] fileNames =f1.list();
			 Iterator iter = uploadedFiles.iterator();
		 	//for(int i=0; i<fileNames.length; i++){
		 	int i =1;
		 	while(iter.hasNext()){
		 	
		 	fileName = iter.next().toString();
			

			%>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td class="text"><%=i++%>&nbsp;&nbsp;</td>
                
                
                <td width="95%" class="text">
                  <input name="textfield2" type="text" value="<%=fileName%>" size="60"></td>
              </tr>
             <tr> 
             <td width="1%" align="center">&nbsp;</td>
                <td colspan="3"><img src="<%=fileName%>" ></td>

              </tr>
              <%
			  }
			  %>
              <tr> 
                <td>&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td class="text">&nbsp;</td>
                <td  class="text">&nbsp;</td>
              </tr>
            
            </table></td>
        </tr>
      </table></td>
  </tr>
  <%} %>
</table>


	 

</body>
</html>