<%
String pageMessage="";
if( request.getParameter("pagemessage") !=null ){
pageMessage =request.getParameter("pagemessage");
}

%>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="text">
  <tr>
    <td width="7%">&nbsp;</td>
    <td width="59%">&nbsp;</td>
    <td width="34%">&nbsp;</td>
  </tr>
    <tr>
    <td width="7%">&nbsp;</td>
    <td width="59%" class="red1" ><strong><%=pageMessage%></strong></td>
    <td width="34%">&nbsp;</td>
  </tr>
  <tr>
    <td width="7%">&nbsp;</td>
    <td width="59%"><strong>My Account</strong></td>
    <td width="34%">&nbsp;</td>
  </tr>
    <tr>
    <td>&nbsp;</td>
    <td><a href="../news/submitarticles.jsp">Submit News Items</a></td>
    <td>&nbsp;</td>
  </tr>
      <tr>
    <td>&nbsp;</td>
    <td><a href="../news/submitarticles.jsp?adsflag=1">Submit Free Advertisements</a></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><a href="../user/passwordupdate.jsp">Change Password</a></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><a href="../user/logout.jsp">Logout</a></td>
    <td>&nbsp;</td>
  </tr>
</table>
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>

