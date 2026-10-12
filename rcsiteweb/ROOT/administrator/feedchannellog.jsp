<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
String RecordsetFeedChannelLog__MMColParam = "1";
if (request.getParameter("id") !=null) {RecordsetFeedChannelLog__MMColParam = (String)request.getParameter("id");}
%>

<%
Connection ConnRecordsetFeedChannelLog =  rcsiteDS.getConnection();
PreparedStatement StatementRecordsetFeedChannelLog = ConnRecordsetFeedChannelLog.prepareStatement("SELECT * FROM feed_channel_log WHERE id = " + RecordsetFeedChannelLog__MMColParam + " ORDER BY id DESC");
ResultSet RecordsetFeedChannelLog = StatementRecordsetFeedChannelLog.executeQuery();
boolean RecordsetFeedChannelLog_isEmpty = !RecordsetFeedChannelLog.next();
boolean RecordsetFeedChannelLog_hasData = !RecordsetFeedChannelLog_isEmpty;
Object RecordsetFeedChannelLog_data;
int RecordsetFeedChannelLog_numRows = 0;
%>


<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
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
            <jsp:include page="adminleftnavi.jsp?screen=news" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
  <table align="center" border="1">
  <tr valign="top">
    <td width="50%" align="left">id</td>
    <td width="50%" align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("id"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></td>
  </tr>
  <tr valign="top">
    <td width="50%" align="left">channel_id</td>
    <td width="50%" align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("channel_id"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></td>
  </tr>
  <tr valign="top">
    <td width="50%" align="left">log_time</td>
    <td width="50%" align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("log_time"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></td>
  </tr>
  <tr valign="top">
    <td width="50%" align="left">location</td>
    <td width="50%" align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("location"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></td>
  </tr>
  <tr valign="top">
    <td width="50%" align="left">severity</td>
    <td width="50%" align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("severity"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></td>
  </tr>
  <tr valign="top">
    <td width="50%" align="left">message</td>
    <td width="50%" align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("message"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></td>
  </tr>
  <tr valign="top">
    <td width="50%" align="left">trace</td>
    <td width="50%" align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("trace"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></td>
  </tr>
</table>

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
<%
RecordsetFeedChannelLog.close();
StatementRecordsetFeedChannelLog.close();
ConnRecordsetFeedChannelLog.close();
%>

