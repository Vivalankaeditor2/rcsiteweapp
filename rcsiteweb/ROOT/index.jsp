<%
if(!(request.getHeader("host").startsWith("dev.")||request.getHeader("host").startsWith("qa.")||request.getHeader("host").startsWith("www.")|| request.getHeader("host").startsWith("rcsiteweb"))){
   		String referrer =request.getServletPath();
  	 	if (request.getQueryString() != null) {
  	 		referrer = referrer + "?" + request.getQueryString();
  	 		}
  	 	System.out.println(referrer);
		response.setStatus(301);
		response.setHeader( "Location", "http://www."+request.getHeader("host") );
		response.setHeader( "Connection", "close" );
	}
%>
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<jsp:include page="/news/index.jsp"  />