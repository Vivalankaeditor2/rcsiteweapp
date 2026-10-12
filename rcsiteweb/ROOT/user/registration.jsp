<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,com.rev_creations.mail.*,com.rev_creations.rcsite.*,java.io.*" errorPage="" %>
<%
if (session.getValue("store")==null || ((String)session.getValue("store")).equals("")) {
	session.putValue("store", "usa"); 
}
if (request.getParameter("store") !=null && !request.getParameter("store").equals("")) {
	session.putValue("store", (String)request.getParameter("store")); 
}

%>
<%@ include file="../custom/config.jsp" %>
<jsp:include page="../custom/storeconfig.jsp" flush="true" />
<%
 
String messageText="";
String pageMessage="";
if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_update").toString().equals("registrationform")) {
		com.rev_creations.mail.SendMailSMTP MailObject = new com.rev_creations.mail.SendMailSMTP();
		Enumeration en = request.getParameterNames();
		messageText ="Below is the result of the registration form. <p> ";
		
		while(en.hasMoreElements()){
				String paramName = (String)en.nextElement();
				String paramValue = request.getParameter(paramName);
				messageText=  messageText + "<p>"+ paramName + "  :  " +paramValue;

		}
	
     
		String heading = "Data posted to " +webName;
		String fromAddress = Config.getValue("emailaddress1").trim();
		String toAddress = Config.getValue("emailaddress1").trim();
		String[] emailList = {toAddress};
		try{
        	MailObject.SendMail(  messageText, heading, fromAddress, emailList);
			pageMessage="Your information has been successfully sent. Your request will be reviewed and we will respond promptly. ";
		
		}catch(Exception ex){
			
		 pageMessage="Your message could not be sent. Please try again. ";
	
	ex.printStackTrace();
out.println("<!--");
StringWriter sw = new StringWriter();
PrintWriter pw = new PrintWriter(sw);
ex.printStackTrace(pw);
out.print(sw);
sw.close();
pw.close();
out.println(ex.toString());

out.println("-->");

	
		}
		

					
	}
%>
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
<title>Contact Us.</title>
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../news/styles.css" rel="stylesheet" type="text/css">
</head>

<BODY leftMargin=0 topMargin=0 marginwidth="0" marginheight="0">
<jsp:include page="../custom/rcheader.jsp" flush="true" />

 
              
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="text">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="4%">&nbsp;</td>
    <td width="85%" bgcolor="#999999"><strong><font color="#999999">... </font><font color="#FFFFFF">Registration 
      </font></strong></td>
    <td width="11%">&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td><form name="form1" method="post" action="">
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                            <tr> 
                              <td width="29%">&nbsp;</td>
                              <td width="71%"><strong><font color="#FF0000"><%=pageMessage%></font></strong></td>
                            </tr>
                            <tr> 
                              <td colspan="2">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td valign="top" nowrap><strong>E-mail: </strong></td>
                              <td><input name="email" type="text" id="email" size="30"></td>
                            </tr>
                            <tr> 
                              <td><input type="hidden" name="MM_update" value="registrationform"></td>
                              <td><input type="submit" name="Submit" value="Submit"></td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp; </td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                          </table>
      </form></td>
    <td>&nbsp;</td>
  </tr>
</table>
<jsp:include page="../custom/rcfooter.jsp" flush="true" />
</body>
</html>
