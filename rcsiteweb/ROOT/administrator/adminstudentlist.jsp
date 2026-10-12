<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
Driver DriverStudentRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
Connection ConnStudentRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
PreparedStatement StatementStudentRecordset = ConnStudentRecordset.prepareStatement("SELECT * FROM ijts_student");
ResultSet StudentRecordset = StatementStudentRecordset.executeQuery();
boolean StudentRecordset_isEmpty = !StudentRecordset.next();
boolean StudentRecordset_hasData = !StudentRecordset_isEmpty;
Object StudentRecordset_data;
int StudentRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 40;
int Repeat1__index = 0;
StudentRecordset_numRows += Repeat1__numRows;
%>
<%
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int StudentRecordset_first = 1;
int StudentRecordset_last  = 1;
int StudentRecordset_total = -1;

if (StudentRecordset_isEmpty) {
  StudentRecordset_total = StudentRecordset_first = StudentRecordset_last = 0;
}

//set the number of rows displayed on this page
if (StudentRecordset_numRows == 0) {
  StudentRecordset_numRows = 1;
}
%>
<%
// *** Recordset Stats: if we don't know the record count, manually count them

if (StudentRecordset_total == -1) {

  // count the total records by iterating through the recordset
    for (StudentRecordset_total = 1; StudentRecordset.next(); StudentRecordset_total++);

  // reset the cursor to the beginning
  StudentRecordset.close();
  StudentRecordset = StatementStudentRecordset.executeQuery();
  StudentRecordset_hasData = StudentRecordset.next();

  // set the number of rows displayed on this page
  if (StudentRecordset_numRows < 0 || StudentRecordset_numRows > StudentRecordset_total) {
    StudentRecordset_numRows = StudentRecordset_total;
  }

  // set the first and last displayed record
  StudentRecordset_first = Math.min(StudentRecordset_first, StudentRecordset_total);
  StudentRecordset_last  = Math.min(StudentRecordset_first + StudentRecordset_numRows - 1, StudentRecordset_total);
}
%>
<% String MM_paramName = ""; %>
<%
// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = StudentRecordset;
int       MM_rsCount = StudentRecordset_total;
int       MM_size = StudentRecordset_numRows;
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
  for (i=0; StudentRecordset_hasData && (i < MM_offset || MM_offset == -1); i++) {
    StudentRecordset_hasData = MM_rs.next();
  }
  if (!StudentRecordset_hasData) MM_offset = i;  // set MM_offset to the last possible record
}
%>
<%
// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; StudentRecordset_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    StudentRecordset_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!StudentRecordset_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!StudentRecordset_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  StudentRecordset.close();
  StudentRecordset = StatementStudentRecordset.executeQuery();
  StudentRecordset_hasData = StudentRecordset.next();
  MM_rs = StudentRecordset;

  // move the cursor to the selected record
  for (i=0; StudentRecordset_hasData && i < MM_offset; i++) {
    StudentRecordset_hasData = MM_rs.next();
  }
}
%>
<%
// *** Move To Record: update recordset stats

// set the first and last displayed record
StudentRecordset_first = MM_offset + 1;
StudentRecordset_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  StudentRecordset_first = Math.min(StudentRecordset_first, MM_rsCount);
  StudentRecordset_last  = Math.min(StudentRecordset_last, MM_rsCount);
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
            <jsp:include page="/administrator/adminleftnavi.jsp?screen=edu" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
            <table border="0" cellpadding="2" cellspacing="2">
              
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>id</td>
                <td>login</td>
                <td>surname</td>
                <td>first_name</td>
                <td>&nbsp;</td>
                <td>address_city</td>
                <td>email</td>
              </tr>
              <% while ((StudentRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <tr <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"C8E4FF\" ");}%>> 
                <td><%=(((StudentRecordset_data = StudentRecordset.getObject("id"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%></td>
                <td><a href="adminuserupdate.jsp?login=<%=(((StudentRecordset_data = StudentRecordset.getObject("login"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>"><%=(((StudentRecordset_data = StudentRecordset.getObject("login"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%></a></td>
                <td><%=(((StudentRecordset_data = StudentRecordset.getObject("surname"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%></td>
                <td><%=(((StudentRecordset_data = StudentRecordset.getObject("first_name"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%></td>
                <td>&nbsp;</td>
                <td><%=(((StudentRecordset_data = StudentRecordset.getObject("address_city"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%></td>
                <td><%=(((StudentRecordset_data = StudentRecordset.getObject("email"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%></td>
              </tr>
              <%
  Repeat1__index++;
  StudentRecordset_hasData = StudentRecordset.next();
}
%>
            </table>

            <p>&nbsp; Records <%=(StudentRecordset_first)%> to <%=(StudentRecordset_last)%> of <%=(StudentRecordset_total)%></p>
            <p>&nbsp; </p>
            
            <table border="0" width="50%" align="center">
              <tr> 
                <td width="23%" align="center"> <% if (MM_offset !=0) { %>
                  <a href="<%=MM_moveFirst%>">First</a> 
                  <% } /* end MM_offset != 0 */ %> </td>
                <td width="31%" align="center"> <% if (MM_offset !=0) { %>
                  <a href="<%=MM_movePrev%>">Previous</a> 
                  <% } /* end MM_offset != 0 */ %> </td>
                <td width="23%" align="center"> <% if (!MM_atTotal) { %>
                  <a href="<%=MM_moveNext%>">Next</a> 
                  <% } /* end !MM_atTotal */ %> </td>
                <td width="23%" align="center"> <% if (!MM_atTotal) { %>
                  <a href="<%=MM_moveLast%>">Last</a> 
                  <% } /* end !MM_atTotal */ %> </td>
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
StudentRecordset.close();
StatementStudentRecordset.close();
ConnStudentRecordset.close();
%>
