<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
String UrlListRecordset__MMColParam = "null";
if (request.getParameter("searchterm") !=null) {UrlListRecordset__MMColParam = (String)request.getParameter("searchterm");}

String UrlListRecordset__MMColParam1 = "null";
if (request.getParameter("category1") !=null) {UrlListRecordset__MMColParam1 = (String)request.getParameter("category1");}
%>
<%
String UrlListRecordset__MMColParam2 = "1";
if (request.getParameter("category2") !=null) {UrlListRecordset__MMColParam2 = (String)request.getParameter("category2");}
%>
<%
String UrlListRecordset__MMColParam3 = "null";
if (request.getParameter("aproval_status") !=null) {UrlListRecordset__MMColParam3 = (String)request.getParameter("aproval_status");}
String whereClue ="WHERE dcode ='"+(String)session.getValue("dcode")+"' ";
//if((UrlListRecordset__MMColParam1 != "null" )|| (UrlListRecordset__MMColParam2 != "null") ||(UrlListRecordset__MMColParam3 != "null")){
if((UrlListRecordset__MMColParam1 != "null" )|| (UrlListRecordset__MMColParam2 != "null")||(UrlListRecordset__MMColParam3 != "null")){
whereClue = "WHERE (category1 = '" + UrlListRecordset__MMColParam1 + "'  OR category2 = '" + UrlListRecordset__MMColParam2 + "' OR aproval_status = '" + UrlListRecordset__MMColParam3 + "' ) AND dcode ='"+(String)session.getValue("dcode")+"' ";
   }
if(UrlListRecordset__MMColParam != "null" ){
whereClue = "WHERE (url LIKE '%" + UrlListRecordset__MMColParam + "%' OR title LIKE '%" + UrlListRecordset__MMColParam + "%') AND dcode ='"+(String)session.getValue("dcode")+"' ";
}
%>
<%
//Driver DriverUrlListRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnUrlListRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnUrlListRecordset= rcsiteDS.getConnection();
PreparedStatement StatementUrlListRecordset = ConnUrlListRecordset.prepareStatement("SELECT *  FROM directory "+whereClue +" or dcode = 'dmoz' ORDER BY aproval_status DESC");
ResultSet UrlListRecordset = StatementUrlListRecordset.executeQuery();
boolean UrlListRecordset_isEmpty = !UrlListRecordset.next();
boolean UrlListRecordset_hasData = !UrlListRecordset_isEmpty;
Object UrlListRecordset_data;
int UrlListRecordset_numRows = 0;
%>
<%
//Driver DriverCategoryRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCategoryRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCategoryRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCategoryRecordset = ConnCategoryRecordset.prepareStatement("SELECT * FROM rc_category ORDER BY category_name ASC");
ResultSet CategoryRecordset = StatementCategoryRecordset.executeQuery();
boolean CategoryRecordset_isEmpty = !CategoryRecordset.next();
boolean CategoryRecordset_hasData = !CategoryRecordset_isEmpty;
Object CategoryRecordset_data;
int CategoryRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
UrlListRecordset_numRows += Repeat1__numRows;
%>
<%
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int UrlListRecordset_first = 1;
int UrlListRecordset_last  = 1;
int UrlListRecordset_total = -1;

if (UrlListRecordset_isEmpty) {
  UrlListRecordset_total = UrlListRecordset_first = UrlListRecordset_last = 0;
}

//set the number of rows displayed on this page
if (UrlListRecordset_numRows == 0) {
  UrlListRecordset_numRows = 1;
}
%>
<% String MM_paramName = ""; %>
<%
// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = UrlListRecordset;
int       MM_rsCount = UrlListRecordset_total;
int       MM_size = UrlListRecordset_numRows;
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
  for (i=0; UrlListRecordset_hasData && (i < MM_offset || MM_offset == -1); i++) {
    UrlListRecordset_hasData = MM_rs.next();
  }
  if (!UrlListRecordset_hasData) MM_offset = i;  // set MM_offset to the last possible record
}
%>
<%
// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; UrlListRecordset_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    UrlListRecordset_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!UrlListRecordset_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!UrlListRecordset_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  UrlListRecordset.close();
  UrlListRecordset = StatementUrlListRecordset.executeQuery();
  UrlListRecordset_hasData = UrlListRecordset.next();
  MM_rs = UrlListRecordset;

  // move the cursor to the selected record
  for (i=0; UrlListRecordset_hasData && i < MM_offset; i++) {
    UrlListRecordset_hasData = MM_rs.next();
  }
}
%>
<%
// *** Move To Record: update recordset stats

// set the first and last displayed record
UrlListRecordset_first = MM_offset + 1;
UrlListRecordset_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  UrlListRecordset_first = Math.min(UrlListRecordset_first, MM_rsCount);
  UrlListRecordset_last  = Math.min(UrlListRecordset_last, MM_rsCount);
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

<%@ include file="../custom/config.jsp" %>
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
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --><jsp:include page="adminleftnavi.jsp?screen=directory" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->

            <table width="100%" border="0">
              <tr class="title"> 
                <td>&nbsp;</td>
                <td colspan="6"><table width="79%" border="0" class="text">
                    <tr> 
                      <td width="35%" class="title"> <div align="left"></div></td>
                      <td width="27%">&nbsp;</td>
                      <td width="38%">&nbsp;</td>
                    </tr>
                    <form name="form1" method="post" action="urllist.jsp">
                      <tr> 
                        <td nowrap class="title"> <div align="left">Select Index:</div></td>
                        <td nowrap> <select name="category1" id="select2">
                            <option value="0-9">0-9</option>
                            <option value="A" selected>A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                            <option value="E">E</option>
                            <option value="F">F</option>
                            <option value="G">G</option>
                            <option value="H">H</option>
                            <option value="I">I</option>
                            <option value="J">J</option>
                            <option value="K">K</option>
                            <option value="L">L</option>
                            <option value="M">M</option>
                            <option value="N">N</option>
                            <option value="O">O</option>
                            <option value="P">P</option>
                            <option value="Q">Q</option>
                            <option value="R">R</option>
                            <option value="S">S</option>
                            <option value="T">T</option>
                            <option value="U">U</option>
                            <option value="V">V</option>
                            <option value="W">W</option>
                            <option value="X">X</option>
                            <option value="Y">Y</option>
                            <option value="Z">Z</option>
                          </select></td>
                        <td nowrap> <input type="submit" name="Submit3" value="Go"></td>
                      </tr>
                    </form>
                    <form name="form4" method="post" action="urllist.jsp">
                      <tr> 
                        <td nowrap class="title"> <div align="left">Select category:</div></td>
                        <td nowrap> <select name="category2" id="select3">
                            <%
while (CategoryRecordset_hasData) {
%>
                            <option value="<%=((CategoryRecordset.getObject("category_id")!=null)?CategoryRecordset.getObject("category_id"):"")%>"><%=((CategoryRecordset.getObject("category_name")!=null)?CategoryRecordset.getObject("category_name"):"")%></option>
                            <%
  CategoryRecordset_hasData = CategoryRecordset.next();
}
CategoryRecordset.close();
CategoryRecordset = StatementCategoryRecordset.executeQuery();
CategoryRecordset_hasData = CategoryRecordset.next();
CategoryRecordset_isEmpty = !CategoryRecordset_hasData;
%>
                          </select></td>
                        <td nowrap> <input type="submit" name="Submit32" value="Go"></td>
                      </tr>
                    </form>
                    <form name="form5" method="post" action="urllist.jsp">
                      <tr> 
                        <td nowrap class="title"> <div align="left">Select Approval 
                            Status:</div></td>
                        <td nowrap> <select name="aproval_status" id="select4">
                            <option value="Approved" selected>Approved</option>
                            <option value="Pending">Pending</option>
                            <option value="Rejected">Rejected</option>
                          </select></td>
                        <td nowrap> <input type="submit" name="Submit33" value="Go"></td>
                      </tr>
                    </form>
                    <tr> 
                      <td height="25" colspan="3" nowrap class="title"> <form name="form8" method="post" action="urllist.jsp">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="35%" align="right" class="title"><div align="left">Search 
                                  in URL or Title</div></td>
                              <td width="24%"><input name="searchterm" type="text" id="searchterm3"></td>
                              <td width="41%"> <input type="submit" name="Submit3" value="Search URL"></td>
                            </tr>
                          </table>
                        </form></td>
                    </tr>
                  </table></td>
                <td>&nbsp;</td>
              <td>&nbsp;</td>
              </tr>
              <tr valign="top" class="title"> 
                <td width="0%">&nbsp;</td>
                <td width="46%">Title </td>
                <td width="6%">Index </td>
                <td width="14%">Category</td>
                <td width="21%">Approval Status</td>
                <td width="13%">Edit</td>
                <td width="13%">Email</td>
                <td width="13%">Reciprocal page</td>
              <td width="13%">dcode</td>
              </tr>
              <% while ((UrlListRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <tr class="text" <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"C8E4FF\" ");}%>> 
                <td><%=Repeat1__index+1%></td>
                <td><a href="http://<%=(((UrlListRecordset_data = UrlListRecordset.getObject("url"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%>" target="_blank"><%=(((UrlListRecordset_data = UrlListRecordset.getObject("title"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%></a></td>
                <td><%=(((UrlListRecordset_data = UrlListRecordset.getObject("category1"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%></td>
                <td><%=(((UrlListRecordset_data = UrlListRecordset.getObject("category2"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%></td>
                <td><%=(((UrlListRecordset_data = UrlListRecordset.getObject("aproval_status"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%></td>
                <td><a href="updateurl.jsp?link_id=<%=(((UrlListRecordset_data = UrlListRecordset.getObject("link_id"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%>">Edit</a></td>
                <td><a href="../emailselector.jsp?singleaddress=<%=(((UrlListRecordset_data = UrlListRecordset.getObject("owner_email"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%>"><%=(((UrlListRecordset_data = UrlListRecordset.getObject("owner_email"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%></a></td>
                <td><a href="http://<%=(((UrlListRecordset_data = UrlListRecordset.getObject("reciprocal_url"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%>" target="_blank"><%=(((UrlListRecordset_data = UrlListRecordset.getObject("reciprocal_url"))==null || UrlListRecordset.wasNull())?"":UrlListRecordset_data)%></a></td>
              <td><%=(((UrlListRecordset_data = UrlListRecordset.getObject("dcode"))==null || UrlListRecordset.wasNull())?"null":UrlListRecordset_data)%></td>
              </tr>
              <%
  Repeat1__index++;
  UrlListRecordset_hasData = UrlListRecordset.next();
}
%>
              <tr class="text"> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp; <table width="97%" border="0" align="center" class="title">
                    <tr> 
                      <td width="23%" height="53" align="center"> <% if (MM_offset !=0) { %>
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
                  </table></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              <td>&nbsp;</td>
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
UrlListRecordset.close();
StatementUrlListRecordset.close();
ConnUrlListRecordset.close();
%>
<%
CategoryRecordset.close();
StatementCategoryRecordset.close();
ConnCategoryRecordset.close();
%>
