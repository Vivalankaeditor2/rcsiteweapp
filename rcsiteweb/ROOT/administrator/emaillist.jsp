<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String EmailRecordset__MMColParam = "send";
if (request.getParameter("folder") !=null) {EmailRecordset__MMColParam = (String)request.getParameter("folder");}
%>
<%
//Driver DriverEmailRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnEmailRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnEmailRecordset = rcsiteDS.getConnection();
PreparedStatement StatementEmailRecordset = ConnEmailRecordset.prepareStatement("SELECT *  FROM email  WHERE folder = '" + EmailRecordset__MMColParam + "' AND user='"+(String)session.getValue("dcode")+"'  ORDER BY entered_date DESC");
ResultSet EmailRecordset = StatementEmailRecordset.executeQuery();
boolean EmailRecordset_isEmpty = !EmailRecordset.next();
boolean EmailRecordset_hasData = !EmailRecordset_isEmpty;
Object EmailRecordset_data;
int EmailRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 40;
int Repeat1__index = 0;
EmailRecordset_numRows += Repeat1__numRows;
%>
<%
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int EmailRecordset_first = 1;
int EmailRecordset_last  = 1;
int EmailRecordset_total = -1;

if (EmailRecordset_isEmpty) {
  EmailRecordset_total = EmailRecordset_first = EmailRecordset_last = 0;
}

//set the number of rows displayed on this page
if (EmailRecordset_numRows == 0) {
  EmailRecordset_numRows = 1;
}
%>
<%
// *** Recordset Stats: if we don't know the record count, manually count them

if (EmailRecordset_total == -1) {

  // count the total records by iterating through the recordset
    for (EmailRecordset_total = 1; EmailRecordset.next(); EmailRecordset_total++);

  // reset the cursor to the beginning
  EmailRecordset.close();
  EmailRecordset = StatementEmailRecordset.executeQuery();
  EmailRecordset_hasData = EmailRecordset.next();

  // set the number of rows displayed on this page
  if (EmailRecordset_numRows < 0 || EmailRecordset_numRows > EmailRecordset_total) {
    EmailRecordset_numRows = EmailRecordset_total;
  }

  // set the first and last displayed record
  EmailRecordset_first = Math.min(EmailRecordset_first, EmailRecordset_total);
  EmailRecordset_last  = Math.min(EmailRecordset_first + EmailRecordset_numRows - 1, EmailRecordset_total);
}
%>
<% String MM_paramName = ""; %>
<%
// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = EmailRecordset;
int       MM_rsCount = EmailRecordset_total;
int       MM_size = EmailRecordset_numRows;
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
  for (i=0; EmailRecordset_hasData && (i < MM_offset || MM_offset == -1); i++) {
    EmailRecordset_hasData = MM_rs.next();
  }
  if (!EmailRecordset_hasData) MM_offset = i;  // set MM_offset to the last possible record
}
%>
<%
// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; EmailRecordset_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    EmailRecordset_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!EmailRecordset_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!EmailRecordset_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  EmailRecordset.close();
  EmailRecordset = StatementEmailRecordset.executeQuery();
  EmailRecordset_hasData = EmailRecordset.next();
  MM_rs = EmailRecordset;

  // move the cursor to the selected record
  for (i=0; EmailRecordset_hasData && i < MM_offset; i++) {
    EmailRecordset_hasData = MM_rs.next();
  }
}
%>
<%
// *** Move To Record: update recordset stats

// set the first and last displayed record
EmailRecordset_first = MM_offset + 1;
EmailRecordset_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  EmailRecordset_first = Math.min(EmailRecordset_first, MM_rsCount);
  EmailRecordset_last  = Math.min(EmailRecordset_last, MM_rsCount);
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
<%!
public String DoDateTime(java.lang.Object aObject,int nNamedFormat,java.util.Locale aLocale) throws Exception{	
if ((aObject != null) && (aObject instanceof java.util.Date)){
   if (aLocale!=null){
		java.text.DateFormat df = java.text.DateFormat.getDateInstance(nNamedFormat,aLocale);
			return df.format(aObject);
	}
	else{
		java.text.DateFormat df = java.text.DateFormat.getDateInstance(nNamedFormat);
			return df.format(aObject);
	 }
 }
return "";
}
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->


<link href="../css/styles.css" rel="stylesheet" type="text/css">
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
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --><jsp:include page="adminleftnavi.jsp?screen=email" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="8%">&nbsp;</td>
    <td width="92%"><%=EmailRecordset__MMColParam%></td>
    <td width="0%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><table width="100%" border="0" align="center" cellpadding="2" cellspacing="2">
                    <tr class="title"> 
                      <td width="5%" align="default">&nbsp;</td>
                      <td width="100" align="default"> To</td>
                      <td align="default"> Subject </td>
                      <td width="50" align="default"> Date</td>
                      <td width="10%" align="default">View</td>
                      <td width="10%" align="default">Retrive</td>
                      <td width="20" align="default">&nbsp; </td>
                    </tr>
                    <% while ((EmailRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
                    <tr <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"C8E4FF\" ");}%> class="text"> 
                      <td width="5%" align="default"><%=Repeat1__index+1%></td>
                      <td width="100" align="default"> <%=(((EmailRecordset_data = EmailRecordset.getObject("to_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%> </td>
                      <td align="default"> <%=(((EmailRecordset_data = EmailRecordset.getObject("subject"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%> </td>
                      <td width="50" align="default"> <%= DoDateTime((((EmailRecordset_data = EmailRecordset.getObject("entered_date"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data), java.text.DateFormat.SHORT, java.util.Locale.US) %> </td>
                      <td width="10%" align="default"> 
                        <a href="emaildetails.jsp?<%= MM_keepBoth + ((MM_keepBoth!="")?"&":"") + "emailid=" + (((EmailRecordset_data = EmailRecordset.getObject("emailid"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data) %>">View</a> 
                      </td>
                      <td width="10%" align="default"><a href="emailcompose.jsp?<%="emailid=" + (((EmailRecordset_data = EmailRecordset.getObject("emailid"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data) %>">Retrieve</a></td>
                      <%
					  if(!EmailRecordset__MMColParam.equals("send")){
					  %>
                      <td width="20" align="default"><div align="center"><a href="emailedit.jsp?<%="emailid="+ (((EmailRecordset_data = EmailRecordset.getObject("emailid"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">Edit</a></div></td>
                      <%
					  }else{
					  %>
					  <td width="20" align="default"><div align="center"><a href="emailreport.jsp?<%="emailid="+ (((EmailRecordset_data = EmailRecordset.getObject("emailid"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">Report</a></div></td>
					  <%
					  }
					  %>
                    </tr>
                    <%
  Repeat1__index++;
  EmailRecordset_hasData = EmailRecordset.next();
}
%>
                  </table>
<br>
<table border="0" width="50%" align="center">
  <tr class="text"> 
    <td width="23%" align="center"> 
      <% if (MM_offset !=0) { %>
      <a href="<%=MM_moveFirst%>">First</a> 
      <% } /* end MM_offset != 0 */ %> </td>
    <td width="31%" align="center"> 
      <% if (MM_offset !=0) { %>
      <a href="<%=MM_movePrev%>">Previous</a> 
      <% } /* end MM_offset != 0 */ %> </td>
    <td width="23%" align="center"> 
      <% if (!MM_atTotal) { %>
      <a href="<%=MM_moveNext%>">Next</a> 
      <% } /* end !MM_atTotal */ %> </td>
    <td width="23%" align="center"> 
      <% if (!MM_atTotal) { %>
      <a href="<%=MM_moveLast%>">Last</a> 
      <% } /* end !MM_atTotal */ %> </td>
  </tr>
</table>
<span class="text">Records <%=(EmailRecordset_first)%> to <%=(EmailRecordset_last)%> of <%=(EmailRecordset_total)%></span> 
</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
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
EmailRecordset.close();
StatementEmailRecordset.close();
ConnEmailRecordset.close();
%>
