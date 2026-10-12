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
    <td align="left" bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="timercontrol.jsp"> 
      News</a></font></td>
    <td width="5%">&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td><img src="../images/shim.gif" width="1" height="1"></td>
  </tr>
  <%
   if ((screen!= null)&&(screen.equals("news")))
    {
	%>
  <tr> 
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td colspan="2" bgcolor="#FFFFFF" class=text><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><font face="Tahoma"><a href="timercontrol.jsp">Timer</a></font></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="admaplist.jsp">Ad Map List</a></td>
        </tr>
		<tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><font face="Tahoma"><a href="articlecategorylocation.jsp">Add/Update Local Category</a></font></td>
        </tr>
		<tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><font face="Tahoma"><a href="articlecategorylocationlist.jsp">Local Category List</a></font></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="feedchannellist.jsp">Feed Channel</a></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="feedchannelloglist.jsp">Feed Channel Logs</a></td>
        </tr>
      </table></td>
  </tr>
  <%
     }//end of email menu
   %>
   
</table>
