<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%
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
%>
<%
String pageMessage="";
if( request.getParameter("pagemessage") !=null ){
pageMessage =request.getParameter("pagemessage");
}

%>
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
<title>Welcome!</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
</head>

<body>
<jsp:include page="../custom/rcheader.jsp" flush="true" />
<jsp:include page="../custom/memberindex.jsp" flush="true">
<jsp:param name="pagemessage" value="<%=pageMessage%>"/>
</jsp:include>
<jsp:include page="../custom/rcfooter.jsp" flush="true" />
</body>
</html>
