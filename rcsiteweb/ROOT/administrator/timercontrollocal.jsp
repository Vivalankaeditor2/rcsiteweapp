<%@ page contentType="text/html; charset=UTF-8" language="java"
	import="java.sql.*,javax.naming.*,com.rev_creations.feed.interfaces.*"
	errorPage=""%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@ page import="com.rev_creations.rcsite.*" %>

<%@ include file="../Connections/dbconnection.jsp"%>
<%@ include file="checkadminlogin.jsp"%>
<%
String responseString="";
String inputLine="";
	if (request.getParameter("MM_insert") != null
			&& request.getParameter("MM_insert").toString().equals(
					"form1")) {
		

		String timeraction = "";
		if (request.getParameter("timeraction") != null) {
			timeraction = (String) request.getParameter("timeraction");
		}
		if("searchupdatetimercreate".equals(timeraction)){
			SearchUpdater.start();
			System.out.println("searchupdatetimercreate - searchUpdaterPeriod: "+SearchUpdater.searchUpdaterPeriod);
		}else if("searchupdatetimercancel".equals(timeraction)){
			SearchUpdater.stop();
			System.out.println("searchupdatetimercancel - searchUpdaterPeriod: "+SearchUpdater.searchUpdaterPeriod);
		}

	}
%>


<%@ include file="../custom/config.jsp"%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
		<title>Untitled Document</title>
		<link href="../css/styles.css" rel="stylesheet" type="text/css">
		<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->


		<!-- InstanceEndEditable -->
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
								<jsp:include page="adminleftnavi.jsp?screen=news"
									flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
								<form action="" method="post" name="form1">
									<table align="center" class="text">
										<tr valign="baseline">
											<td nowrap align="left">&nbsp;
												
											</td>
											<td>&nbsp;
												
											</td>
										</tr>
										<tr valign="baseline">
											<td nowrap align="left">&nbsp;
												
											</td>
											<td>
												<%=responseString %>
											</td>
										</tr>
										<tr valign="baseline">
											<td nowrap align="left">
												<strong>Local Timer Control:</strong>
											</td>
											<td>
												<select name="timeraction">
													<option value="searchupdatetimercreate" selected>
														Search Update timer Create
													</option>
													<option value="searchupdatetimercancel">
														Search Update timer Cancel
													</option>
												</select>
											</td>
										</tr>
										<tr valign="baseline">
											<td nowrap align="left">&nbsp;
												
											</td>
											<td>
												<input type="submit" value="Submit">
											</td>
										</tr>
									</table>
									<input type="hidden" name="MM_insert" value="form1">
								</form>
								<p>&nbsp;
									
								</p>
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
