<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@page import="com.rev_creations.rcsite.Config,java.util.*,com.rev_creations.persistence.dao.*"%>
<%@page import="com.rev_creations.util.DBUtil"%>
<!--%@ include file="../custom/config.jsp" %-->
<%@ include file="checkadminlogin.jsp" %>
<%
/*
// *** Restrict Access To Page: Grant or deny access to this page
String MM_authorizedUsers="admin,Editor,CONSULTANT,ADMINISTRATOR";
String MM_authFailedURL="../login.jsp";
boolean MM_grantAccess=false;
if (session.getValue("MM_Username") != null && !session.getValue("MM_Username").equals("")) {
  if (false || (session.getValue("MM_UserAuthorization")=="") || 
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
*/
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>

<body>
<table width="100%" border="0" cellpadding="2"  cellspacing="0" bgcolor="e8ad03">
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
        <tr bgcolor="e8ad03"> 
          <td width="13%">&nbsp;</td>
          <td width="67%">&nbsp;<!--%=bannerCode%--></td>
          <td width="20%">&nbsp;</td>
  </tr>
  <tr valign="top"> 
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --> 
              <jsp:include page="adminleftnavi.jsp?screen=" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" --> 
             <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="5%">&nbsp;</td>
                <td width="42%" valign="top">&nbsp;</td>
                <td width="9%" valign="top">&nbsp;</td>
                <td width="35%" valign="top">&nbsp;</td>
                <td width="9%">&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td valign="top">
<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="e8ad03">
                    <tr> 
                      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                          <tr> 
                            <td width="12%">&nbsp;</td>
                            <td width="76%"><strong>Emaill Campaigner</strong></td>
                            <td width="12%">&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>Email Campaigner is a tremendous tool for sending 
                              out formatted emails to lists of multiple recipients 
                              and tracking their success.</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
                <td valign="top">&nbsp;</td>
                <td valign="top">
<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="e8ad03">
                    <tr> 
                      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                          <tr> 
                            <td width="12%">&nbsp;</td>
                            <td width="76%"><strong>RC Site</strong></td>
                            <td width="12%">&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>add more pages to selected sections of your site</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td valign="top">
<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="e8ad03">
                    <tr> 
                      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                          <tr> 
                            <td width="12%">&nbsp;</td>
                            <td width="76%"><strong>Web Directory</strong></td>
                            <td width="12%">&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>promote your website by reciprocating links with 
                              other websites.</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
                <td valign="top">&nbsp;</td>
                <td valign="top">
<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="e8ad03">
                    <tr> 
                      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                          <tr> 
                            <td width="12%">&nbsp;</td>
                            <td width="76%"><strong>RC Commerce </strong></td>
                            <td width="12%">&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>manage your products, including pricing and detail 
                              information about each item. </td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td valign="top">
<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="e8ad03">
                    <tr> 
                      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                          <tr> 
                            <td width="12%">&nbsp;</td>
                            <td width="76%"><strong>Forum</strong></td>
                            <td width="12%">&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
                <td valign="top">&nbsp;</td>
                <td valign="top">
<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="e8ad03">
                    <tr> 
                      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                          <tr> 
                            <td width="12%">&nbsp;</td>
                            <td width="76%"><strong>Webmail</strong></td>
                            <td width="12%">&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr bgcolor="#FFFFFF"> 
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td valign="top">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>

            <!-- InstanceEndEditable --></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td height="84">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table></td>
  </tr>
</table>

</body>
<!-- InstanceEnd --></html>
