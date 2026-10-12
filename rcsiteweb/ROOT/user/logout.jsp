<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%
// *** Logout the current user.
String MM_logoutRedirectPage = "/user/login.jsp?store="+session.getValue("store")+"&dcode="+(String)session.getValue("code");
session.putValue("MM_Username", "");
session.putValue("MM_UserAuthorization", "");
	                session.removeAttribute("username");
					session.removeAttribute("customer");
					session.removeAttribute("memberType");
					session.removeAttribute("dcodechecker");
if (!MM_logoutRedirectPage.equals("")) {
  response.sendRedirect(response.encodeRedirectURL(MM_logoutRedirectPage));
  return;
}
%>
<html lang="en">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
</body>
</html>
