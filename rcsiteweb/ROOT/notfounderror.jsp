<%@ page contentType="text/html; charset=UTF-8" language="java"  isErrorPage="true"%>
<%@ page import="org.apache.log4j.Logger,java.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<title>Page Not Found</title>
<meta http-equiv="Content-Type"	content="text/html; charset=UTF-8">
<style type="text/css">
<!--
.whitetitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 13px;
	font-weight: bold;
	color: #FFFFFF;
}
.text {
FONT-SIZE: 12px; LINE-HEIGHT: 19px; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
	color: #000000;
}
-->
</style>
</head>
<body> 
<p>&nbsp;</p><p>&nbsp;</p>
<table width="500" border="0" align="center" cellpadding="1" cellspacing="0"> 
  <tr> 
    <td bgcolor="#c7c7c7"><table width="500" border="0" align="center" cellpadding="5" cellspacing="0" bgcolor="#ffffff" > 
        <tr> 
          <td bgcolor="#c22929" class="whitetitle"> Page not found </td> 
        </tr> 
        <tr> 
          <td class="text"><p>&nbsp; </p>
            <p>The page you've requested has been moved or taken off the site.
              We apologize for the inconvenience.</p>
            <p>There are several ways you can find the information you need:</p>
            <p><strong>Search the website archive</strong></p>
			<form name="form1" action="http://<%=request.getLocalName()%>/rcsite/pagelist.jsp" method="post">
            <p><input id="searchterm" name="searchterm" type="text" />
              <input type="submit" name="Submit" value="Search">
            </p>           
			</form> <p> <strong>Home Page </strong><br>
Return to website <a href="http://<%=request.getLocalName()%>/">home page. </a></p>
			<p><br>
		    </p></td> 
        </tr> 
      </table></td> 
  </tr> 
</table> 
<%
		String params = "";
		String ParameterName = "";
		for (Enumeration e = request.getParameterNames();e.hasMoreElements();) {
			ParameterName = (String) e.nextElement();
			params = params + ParameterName + "="+ request.getParameter(ParameterName);
		}
		Logger lgErr = Logger.getLogger("notfounderror");
		lgErr.error("remote ip: "+request.getRemoteAddr()+" page: "+request.getLocalName()+pageContext.getErrorData().getRequestURI() + "?"+ params, exception);

	%> 
</body>
</html>
