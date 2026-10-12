<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String RecordsetFeedChannelLog__MMColParam = "1";
if (request.getParameter("channel_id") !=null) {RecordsetFeedChannelLog__MMColParam = (String)request.getParameter("channel_id");}
%>
<%

Connection ConnRecordsetFeedChannelLog = rcsiteDS.getConnection();
PreparedStatement StatementRecordsetFeedChannelLog = ConnRecordsetFeedChannelLog.prepareStatement("SELECT * FROM feed_channel_log l left join feed_channel c on l.channel_id = c.id ORDER BY l.id DESC");
ResultSet RecordsetFeedChannelLog = StatementRecordsetFeedChannelLog.executeQuery();
boolean RecordsetFeedChannelLog_isEmpty = !RecordsetFeedChannelLog.next();
boolean RecordsetFeedChannelLog_hasData = !RecordsetFeedChannelLog_isEmpty;
Object RecordsetFeedChannelLog_data;
int RecordsetFeedChannelLog_numRows = 0;
%>
<%
int Repeat1__numRows = 100;
int Repeat1__index = 0;
RecordsetFeedChannelLog_numRows += Repeat1__numRows;
%>
<%
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int RecordsetFeedChannelLog_first = 1;
int RecordsetFeedChannelLog_last  = 1;
int RecordsetFeedChannelLog_total = -1;

if (RecordsetFeedChannelLog_isEmpty) {
  RecordsetFeedChannelLog_total = RecordsetFeedChannelLog_first = RecordsetFeedChannelLog_last = 0;
}

//set the number of rows displayed on this page
if (RecordsetFeedChannelLog_numRows == 0) {
  RecordsetFeedChannelLog_numRows = 1;
}
%>
<%
// *** Recordset Stats: if we don't know the record count, manually count them

if (RecordsetFeedChannelLog_total == -1) {

  // count the total records by iterating through the recordset
    for (RecordsetFeedChannelLog_total = 1; RecordsetFeedChannelLog.next(); RecordsetFeedChannelLog_total++);

  // reset the cursor to the beginning
  RecordsetFeedChannelLog.close();
  RecordsetFeedChannelLog = StatementRecordsetFeedChannelLog.executeQuery();
  RecordsetFeedChannelLog_hasData = RecordsetFeedChannelLog.next();

  // set the number of rows displayed on this page
  if (RecordsetFeedChannelLog_numRows < 0 || RecordsetFeedChannelLog_numRows > RecordsetFeedChannelLog_total) {
    RecordsetFeedChannelLog_numRows = RecordsetFeedChannelLog_total;
  }

  // set the first and last displayed record
  RecordsetFeedChannelLog_first = Math.min(RecordsetFeedChannelLog_first, RecordsetFeedChannelLog_total);
  RecordsetFeedChannelLog_last  = Math.min(RecordsetFeedChannelLog_first + RecordsetFeedChannelLog_numRows - 1, RecordsetFeedChannelLog_total);
}
%>
<% String MM_paramName = ""; %>
<%
// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = RecordsetFeedChannelLog;
int       MM_rsCount = RecordsetFeedChannelLog_total;
int       MM_size = RecordsetFeedChannelLog_numRows;
String    MM_uniqueCol = "";
          MM_paramName = "";
int       MM_offset = 0;
boolean   MM_atTotal = false;
boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);
%>
<%
// *** Move To Record: handle 'index' or 'offset' parameter

if (!MM_paramIsDefined && MM_rsCount != 0) {

  //use index parameter if defined, otherwise use offset parameter
  String r = request.getParameter("index");
  if (r==null) r = request.getParameter("offset");
  if (r!=null) MM_offset = Integer.parseInt(r);

  // if we have a record count, check if we are past the end of the recordset
  if (MM_rsCount != -1) {
    if (MM_offset >= MM_rsCount || MM_offset == -1) {  // past end or move last
      if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  //move the cursor to the selected record
  int i;
  for (i=0; RecordsetFeedChannelLog_hasData && (i < MM_offset || MM_offset == -1); i++) {
    RecordsetFeedChannelLog_hasData = MM_rs.next();
  }
  if (!RecordsetFeedChannelLog_hasData) MM_offset = i;  // set MM_offset to the last possible record
}
%>
<%
// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; RecordsetFeedChannelLog_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    RecordsetFeedChannelLog_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!RecordsetFeedChannelLog_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!RecordsetFeedChannelLog_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  RecordsetFeedChannelLog.close();
  RecordsetFeedChannelLog = StatementRecordsetFeedChannelLog.executeQuery();
  RecordsetFeedChannelLog_hasData = RecordsetFeedChannelLog.next();
  MM_rs = RecordsetFeedChannelLog;

  // move the cursor to the selected record
  for (i=0; RecordsetFeedChannelLog_hasData && i < MM_offset; i++) {
    RecordsetFeedChannelLog_hasData = MM_rs.next();
  }
}
%>
<%
// *** Move To Record: update recordset stats

// set the first and last displayed record
RecordsetFeedChannelLog_first = MM_offset + 1;
RecordsetFeedChannelLog_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  RecordsetFeedChannelLog_first = Math.min(RecordsetFeedChannelLog_first, MM_rsCount);
  RecordsetFeedChannelLog_last  = Math.min(RecordsetFeedChannelLog_last, MM_rsCount);
}

// set the boolean used by hide region to check if we are on the last record
MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
%>
<%
// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
String[] MM_removeList = { "index", MM_paramName };

// create the MM_keepURL string
if (request.getQueryString() != null) {
  MM_keepURL = '&' + request.getQueryString();
  for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) {
  int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    if (start >= 0 && MM_keepURL.charAt(start) == '&' &&
        MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') {
      int stop = MM_keepURL.indexOf('&', start + 1);
      if (stop == -1) stop = MM_keepURL.length();
      MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    }
  }
}

// add the Form variables to the MM_keepForm string
if (request.getParameterNames().hasMoreElements()) {
  java.util.Enumeration items = request.getParameterNames();
  while (items.hasMoreElements()) {
    String nextItem = (String)items.nextElement();
    boolean found = false;
    for (int i=0; !found && i < MM_removeList.length; i++) {
      if (MM_removeList[i].equals(nextItem)) found = true;
    }
    if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) {
      MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
    }
  }
}

String tempStr = "";
for (int i=0; i < MM_keepURL.length(); i++) {
  if (MM_keepURL.charAt(i) == '<') tempStr = tempStr + "&lt;";
  else if (MM_keepURL.charAt(i) == '>') tempStr = tempStr + "&gt;";
  else if (MM_keepURL.charAt(i) == '"') tempStr = tempStr +  "&quot;";
  else tempStr = tempStr + MM_keepURL.charAt(i);
}
MM_keepURL = tempStr;

tempStr = "";
for (int i=0; i < MM_keepForm.length(); i++) {
  if (MM_keepForm.charAt(i) == '<') tempStr = tempStr + "&lt;";
  else if (MM_keepForm.charAt(i) == '>') tempStr = tempStr + "&gt;";
  else if (MM_keepForm.charAt(i) == '"') tempStr = tempStr +  "&quot;";
  else tempStr = tempStr + MM_keepForm.charAt(i);
}
MM_keepForm = tempStr;

// create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL + MM_keepForm;
if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);
%>
<%
// *** Move To Record: set the strings for the first, last, next, and previous links

String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
{
  String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
  String MM_moveParam = "index=";

  // if the page has a repeated region, remove 'offset' from the maintained parameters
  if (MM_size > 1) {
    MM_moveParam = "offset=";
    int start = MM_keepMove.indexOf(MM_moveParam);
    if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) {
      int stop = MM_keepMove.indexOf('&', start);
      if (start == 0 && stop != -1) stop++;
      if (stop == -1) stop = MM_keepMove.length();
      if (start > 0) start--;
      MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
    }
  }

  // set the strings for the move to links
  StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
  if (MM_keepMove.length() > 0) urlStr.append('&');
  urlStr.append(MM_moveParam);
  MM_moveFirst = urlStr + "0";
  MM_moveLast  = urlStr + "-1";
  MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
  MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
}
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
  <tr>
    <td align="left" width="16%"> id </td>
    <td align="left" width="16%"> channel_id </td>
	<td align="left" width="16%"> channel_id </td>
    <td align="left" width="16%"> log_time </td>
    <td align="left" width="16%"> location </td>
    <td align="left" width="16%"> severity </td>
    <td align="left" width="16%"> message </td>
  </tr>
  <% while ((RecordsetFeedChannelLog_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr>
    <td align="left" width="16%"><a href="feedchannellog.jsp?id=<%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("l.id"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%>"><%=(((RecordsetFeedChannelLog_data /* = RecordsetFeedChannelLog.getObject("id")*/)==null /* || RecordsetFeedChannelLog.wasNull() */ )?"":RecordsetFeedChannelLog_data)%></a> </td>
    <td align="left" width="16%"><a href="feedchannelupdate.jsp?id=<%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("channel_id"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%>"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("channel_id"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></a> </td>
	 <td align="left" width="16%"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("name"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%> </td>
    <td align="left" width="16%"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("log_time"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%> </td>
    <td align="left" width="16%"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("location"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%> </td>
    <td align="left" width="16%"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("severity"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%> </td>
    <td align="left" width="16%"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("message"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%> </td>
  </tr>
  <%
  Repeat1__index++;
  RecordsetFeedChannelLog_hasData = RecordsetFeedChannelLog.next();
}
%>
</table>
<br>
<table border="0" width="50%" align="center">
  <tr>
    <td width="23%" align="center"><% if (MM_offset !=0) { %>
        <a href="<%=MM_moveFirst%>">First</a>
        <% } /* end MM_offset != 0 */ %>
    </td>
    <td width="31%" align="center"><% if (MM_offset !=0) { %>
        <a href="<%=MM_movePrev%>">Previous</a>
        <% } /* end MM_offset != 0 */ %>
    </td>
    <td width="23%" align="center"><% if (!MM_atTotal) { %>
        <a href="<%=MM_moveNext%>">Next</a>
        <% } /* end !MM_atTotal */ %>
    </td>
    <td width="23%" align="center"><% if (!MM_atTotal) { %>
        <a href="<%=MM_moveLast%>">Last</a>
        <% } /* end !MM_atTotal */ %>
    </td>
  </tr>
</table>
Records <%=(RecordsetFeedChannelLog_first)%> to <%=(RecordsetFeedChannelLog_last)%> of <%=(RecordsetFeedChannelLog_total)%>
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
