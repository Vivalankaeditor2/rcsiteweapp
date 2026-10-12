<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<%
String screen = "email";
if (request.getParameter("screen") !=null) {screen = (String)request.getParameter("screen");}
%>
<table width="184" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td><img src="../images/shim.gif" width="1" height="1"></td>
  </tr>
  <tr> 
    <td width="6" bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
    <td align="left" bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="emailintro.jsp">Email 
      Campaigner</a></font></td>
    <td width="5%">&nbsp;</td>
  </tr>
  <%
   if ((screen!= null)&&(screen.equals("email")))
    {
	%>
  <tr> 
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td colspan="2" bgcolor="#FFFFFF" class=text><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><font face="Tahoma"><a href="emailcompose.jsp">Compose 
            New Email.</a></font></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><font face="Tahoma"><a href="emaillist.jsp?folder=send">Sent 
            Emails.</a></font></td>
        </tr>
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><font face="Tahoma"><a href="emaillist.jsp?folder=save">Email 
            Drafts.</a></font></td>
        </tr>
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="emaillist.jsp?folder=template">Email Templates.</a></td>
        </tr>
		        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="editheader.jsp?ui_id=1">Email 
            Header/Footer.</a></td>
        </tr>
		<tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="javascript:;" onClick="MM_openBrWindow('upload.jsp?dir=media2','images','toolbar=yes,scrollbars=yes,width=500,height=500')">images/files 
            upload</a>.</td>
        </tr>
      </table></td>
  </tr>
  <%
     }//end of email menu
   %>
   
</table>
