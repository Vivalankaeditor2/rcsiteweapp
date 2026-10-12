<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../custom/config.jsp" %>
<%
String store = "us";
String redirectUrl="";


if (request.getParameter("store") !=null && !request.getParameter("store").equals("")) {
store = (String)request.getParameter("store");
}

redirectUrl= "rcorders.jsp?store="+store;
session.putValue("store", store);

response.sendRedirect(response.encodeRedirectURL(redirectUrl));
//return;
%>


