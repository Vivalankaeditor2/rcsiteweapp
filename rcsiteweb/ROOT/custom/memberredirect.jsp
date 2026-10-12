<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>

<%

Enumeration en = request.getAttributeNames();
//Enumeration en = request.getParameterNames();
String str = "";
//String redirectURL="../news/login.jsp";
String redirectURL="../forum/";

RequestDispatcher dispatch = request.getRequestDispatcher(redirectURL);

while(en.hasMoreElements()){
String paramName = (String)en.nextElement();
String paramValue = request.getParameter(paramName);

request.setAttribute(paramName,paramValue);
//str = str + "&" + paramName + "=" + URLEncoder.encode(paramValue);

}
request.setAttribute("MemberName", request.getParameter("username"));
//dispatch.forward(request, response);
/*

while(en.hasMoreElements()){
String paramName = (String)en.nextElement();
String paramValue = request.getParameter(paramName);
str = str + "&" + paramName + "=" + URLEncoder.encode(paramValue);

}
str = str+"&MemberName="+request.getParameter("username");

URL u = new URL("http://www.paypal.com/cgi-bin/webscr");
URLConnection uc = u.openConnection();
uc.setDoOutput(true);
uc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
PrintWriter pw = new PrintWriter(uc.getOutputStream());
pw.println(str);
pw.close();

*/
%>

<html lang="en">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
getPathInfo():<%=request.getPathInfo()%>
<p></p>getRequestURI()  <%=request.getRequestURI() %>
<p>getRequestURL() <%=request.getRequestURL() %>
<p>getServletPath() <%=request.getServletPath()%>
<p>getQueryString()<%=request.getQueryString()%>
<p>getPathTranslated() <%=request.getPathTranslated() %>
<p>getRemoteUser() <%=request.getRemoteUser() %>
<p>getMethod()<%=request.getMethod() %>
<p>getServerName <%=request.getServerName() %>

String:<%=str%>
</body>
</html>
