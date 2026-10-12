<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
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
// *** Edit Operations: declare variables

// set the form action variable
String MM_editAction = request.getRequestURI();
if (request.getQueryString() != null && request.getQueryString().length() > 0) {
  MM_editAction += "?" + request.getQueryString();
}

// connection information
String MM_editDriver = null, MM_editConnection = null, MM_editUserName = null, MM_editPassword = null;

// redirect information
String MM_editRedirectUrl = null;

// query string to execute
StringBuffer MM_editQuery = null;

// boolean to abort record edit
boolean MM_abortEdit = false;

// table information
String MM_editTable = null, MM_editColumn = null, MM_recordId = null;

// form field information
String[] MM_fields = null, MM_columns = null;
%>
<%
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "articles";
  MM_editRedirectUrl = "../user/welcome.jsp?pagemessage=article has been successfully submited.";
  String MM_fieldsStr = "title|value|description|value|details|value|author_name|value|author_intro|value|aproval_status|value|editor_name|value|editor_email|value|categoryid|value'|dcode|',none,'|entry_date|value|url|value|";
 // String MM_columnsStr = "title|',none,''|description|',none,''|details|',none,''|author_name|',none,''|author_intro|',none,''|aproval_status|',none,''|editor_name|',none,''|editor_email|',none,''";
  String MM_columnsStr = "title|',none,''|description|',none,''|details|',none,''|author_name|',none,''|author_intro|',none,''|aproval_status|',none,''|editor_name|',none,''|editor_email|',none,''|categoryid|none,none,NULL'|dcode|',none,''|entry_date|',none,none'|url|',none,''";
 
  // create the MM_fields and MM_columns arrays
  java.util.StringTokenizer tokens = new java.util.StringTokenizer(MM_fieldsStr,"|");
  MM_fields = new String[tokens.countTokens()];
  for (int i=0; tokens.hasMoreTokens(); i++) MM_fields[i] = tokens.nextToken();

  tokens = new java.util.StringTokenizer(MM_columnsStr,"|");
  MM_columns = new String[tokens.countTokens()];
  for (int i=0; tokens.hasMoreTokens(); i++) MM_columns[i] = tokens.nextToken();

  // set the form values
  for (int i=0; i+1 < MM_fields.length; i+=2) {
    MM_fields[i+1] = ((request.getParameter(MM_fields[i])!=null)?(String)request.getParameter(MM_fields[i]):"");
  }
 
  // append the query string to the redirect URL
  if (MM_editRedirectUrl.length() != 0 && request.getQueryString() != null) {
    MM_editRedirectUrl += ((MM_editRedirectUrl.indexOf('?') == -1)?"?":"&") + request.getQueryString();
  }
}
%>
<%System.out.println(request.getParameter("entry_date"));%>
<%
// *** Insert Record: construct a sql insert statement and execute it

if (request.getParameter("MM_insert") != null) {

  // create the insert sql statement
  StringBuffer MM_tableValues = new StringBuffer(), MM_dbValues = new StringBuffer();
  for (int i=0; i+1 < MM_fields.length; i+=2) {
    String formVal = MM_fields[i+1];
    String elem;
    java.util.StringTokenizer tokens = new java.util.StringTokenizer(MM_columns[i+1],",");
    String delim    = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    String altVal   = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    String emptyVal = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    if (formVal.length() == 0) {
      formVal = emptyVal;
    } else {
      if (altVal.length() != 0) {
        formVal = altVal;
      } else if (delim.compareTo("'") == 0) {  // escape quotes
        StringBuffer escQuotes = new StringBuffer(formVal);
        for (int j=0; j < escQuotes.length(); j++)
          if (escQuotes.charAt(j) == '\'') escQuotes.insert(j++,'\'');
        formVal = "'" + escQuotes + "'";
      } else {
        formVal = delim + formVal + delim;
      }
    }
    MM_tableValues.append((i!=0)?",":"").append(MM_columns[i]);
    MM_dbValues.append((i!=0)?",":"").append(formVal);
  }
  MM_editQuery = new StringBuffer("insert into " + MM_editTable);
  MM_editQuery.append(" (").append(MM_tableValues.toString()).append(") values (");
  MM_editQuery.append(MM_dbValues.toString()).append(")");
  
  if (!MM_abortEdit) {
    // finish the sql and execute it
    Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
    Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(MM_editQuery.toString());
    MM_editStatement.executeUpdate();
    MM_connection.close();

    // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0) {
      response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl));
      return;
    }
  }
}
%>
<%
String ArtiCatRecordset__MMColParam = "main";
//if (request.getParameter("level") !=null) {ArtiCatRecordset__MMColParam = (String)request.getParameter("level");}
String adsflag = "";
if (request.getParameter("adsflag") !=null) {adsflag = (String)request.getParameter("adsflag");}
String parentIds = "2, 3";
String title = "Submit News Items";
if(adsflag!=null && adsflag.length()>0){
parentIds =  " 5";
title = "Submit Advertisements";
}

%>
<%
Driver DriverArtiCatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
Connection ConnArtiCatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
PreparedStatement StatementArtiCatRecordset = ConnArtiCatRecordset.prepareStatement("SELECT categoryid, category_name FROM article_category WHERE parentid in ( "+parentIds+" ) AND active ='yes' AND level <> '" + ArtiCatRecordset__MMColParam + "' ORDER BY priority DESC");
ResultSet ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
boolean ArtiCatRecordset_isEmpty = !ArtiCatRecordset.next();
boolean ArtiCatRecordset_hasData = !ArtiCatRecordset_isEmpty;
Object ArtiCatRecordset_data;
int ArtiCatRecordset_numRows = 0;
%>
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
<title><%=title%></title>
 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript" src="../jscripts/fulleditor.js"></script>
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>

</head>

<body>
<jsp:include page="../custom/rcheader.jsp" flush="true" />
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table border="0" align="center" cellpadding="0" cellspacing="0" class="text">
                <tr valign="baseline">
                  <td align="right" nowrap>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td><strong><%=title%></strong></td>
                </tr>
				                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
				<%if(adsflag!=null && adsflag.length()>0){ %>
				 <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td>When do you want to start running your ad? </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td> <input name="RadioGroup1" type="radio" value="radio" checked> 
                    Run my ad continuously starting today                   </td>
                </tr>
				                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td>  <input type="radio" name="RadioGroup1" value="radio">Run my ad only during specified dates: 
				   <br> <div style="padding-left:30px ">Form: 
				     <select class="" id="start_time_month" name="start_time_month">
    <option value="1">Jan</option>
    <option value="2">Feb</option>
    <option value="3">Mar</option>
    <option value="4">Apr</option>
    <option value="5">May</option>
    <option value="6">Jun</option>
    <option value="7">Jul</option>
    <option value="8">Aug</option>
    <option value="9">Sep</option>
    <option value="10">Oct</option>
    <option value="11">Nov</option>
    <option value="12">Dec</option>
  </select>  
  <select name="start_time_day" id="start_time_day">
    <option value="1">1</option>
    <option value="2">2</option>
    <option value="3">3</option>
    <option value="4">4</option>
    <option value="5">5</option>
    <option value="6">6</option>
    <option value="7">7</option>
    <option value="8">8</option>
    <option value="9">9</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24" >24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>
  ,
  <select name="start_time_year" id="start_time_year" >
    <option value="-1">Year:</option>
    <option value="2010" selected="selected">2010</option>
	<option value="2011" >2011</option>
	<option value="2012" >2012</option>
  </select>
  &nbsp;To:  
  <select class="" id="end_time_month" name="end_time_month" >
    <option value="1">Jan</option>
    <option value="2">Feb</option>
    <option value="3">Mar</option>
    <option value="4">Apr</option>
    <option value="5">May</option>
    <option value="6">Jun</option>
    <option value="7">Jul</option>
    <option value="8">Aug</option>
    <option value="9">Sep</option>
    <option value="10">Oct</option>
    <option value="11">Nov</option>
    <option value="12">Dec</option>
  </select>  
  <select name="end_time_day" id="end_time_day" >
    <option value="1">1</option>
    <option value="2">2</option>
    <option value="3">3</option>
    <option value="4">4</option>
    <option value="5">5</option>
    <option value="6">6</option>
    <option value="7">7</option>
    <option value="8">8</option>
    <option value="9">9</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>
  ,  
  <select name="end_time_year" id="end_time_year" >
    <option value="-1">Year:</option>
    <option value="2010" selected="selected">2010</option>
		<option value="2011" >2011</option>
	<option value="2012" >2012</option>
  </select></div> </td>
                </tr>
				                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
				<%}%>
				                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td><strong>Title:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td width="10" align="right" nowrap><div align="left"></div></td>
                  <td width="497"> <input type="text" name="title" value="" size="50"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Description:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="description" cols="60" rows="5" mce_editable="false"></textarea> 
                  </td>
                </tr>
				
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Details: </strong><div align="right" style="padding-right:80px "><a href="javascript:;" onClick="MM_openBrWindow('upload.jsp','images','toolbar=yes,scrollbars=yes,width=650,height=700')">upload images </a></div></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> 
                      <textarea name="details"  cols="70" rows="40" mce_editable="true"></textarea>
                      </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Author Name:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="author_name" value="" size="32"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Author Introduction:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="author_intro" cols="60" rows="5" mce_editable="false"></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Category:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td> <select name="categoryid">
                      <%
while (ArtiCatRecordset_hasData) {
%>
                      <option value="<%=((ArtiCatRecordset.getObject("categoryid")!=null)?ArtiCatRecordset.getObject("categoryid"):"")%>"><%=((ArtiCatRecordset.getObject("category_name")!=null)?ArtiCatRecordset.getObject("category_name"):"")%></option>
                      <%
  ArtiCatRecordset_hasData = ArtiCatRecordset.next();
}
ArtiCatRecordset.close();
ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
ArtiCatRecordset_hasData = ArtiCatRecordset.next();
ArtiCatRecordset_isEmpty = !ArtiCatRecordset_hasData;
%>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Editor Name:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td><%=session.getValue("MM_Username")%> <input type="hidden" name="editor_name" value="<%=session.getValue("MM_Username")%>" > 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Editor Email:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="editor_email" value="" size="32"> 
                  </td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>URL:</strong></td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td><input type="text" name="url" value="" size="50"></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="submit" value="Submit" > 
                  </td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> VivaLanka.com reserves the right to refuse or edit all submitted news items/advertisement. If accepted, your news item/advertisement will be published on the VivaLanka.com website immediately.

 
                  </td>
                </tr>
              </table>
			  <input name="aproval_status" type="hidden" value="0">
<input name="dcode" type="hidden" id="dcode" value="preferred">
<input name="entry_date" type="hidden" id="entry_date" value="<%= (new java.text.SimpleDateFormat("yy-MM-dd hh:mm:ss")).format((new java.util.Date()))%>">
  <input type="hidden" name="MM_insert" value="form1">
</form>
<jsp:include page="../custom/rcfooter.jsp" flush="true"/>
</body>
</html>
<%
ArtiCatRecordset.close();
StatementArtiCatRecordset.close();
ConnArtiCatRecordset.close();
%>
