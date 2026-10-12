<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
// *** Edit Operations: declare variables

// set the form action variable
String MM_editAction = request.getRequestURI();
if (request.getQueryString() != null && request.getQueryString().length() > 0) {
  String queryString = request.getQueryString();
  String tempStr = "";
  for (int i=0; i < queryString.length(); i++) {
    if (queryString.charAt(i) == '<') tempStr = tempStr + "&lt;";
    else if (queryString.charAt(i) == '>') tempStr = tempStr + "&gt;";
    else if (queryString.charAt(i) == '"') tempStr = tempStr +  "&quot;";
    else tempStr = tempStr + queryString.charAt(i);
  }
  MM_editAction += "?" + tempStr;
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
// *** Update Record: set variables

if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_update").toString().equals("form1") &&
    request.getParameter("MM_recordId") != null) {


  MM_editTable  = "rcsite_config";
  MM_editColumn = "config_key";
  MM_recordId   = "'" + request.getParameter("MM_recordId") + "'";
  MM_editRedirectUrl = "";
  String MM_fieldsStr = "value|value|description|value|site_area|value|active|value|hot_configurable|value";
  String MM_columnsStr = "value|',none,''|description|',none,''|site_area|',none,''|active|none,1,0|hot_configurable|none,1,0";

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
<%
// *** Update Record: construct a sql update statement and execute it

if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_recordId") != null) {

  // create the update sql statement
  MM_editQuery = new StringBuffer("update ").append(MM_editTable).append(" set ");
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
    MM_editQuery.append((i!=0)?",":"").append(MM_columns[i]).append(" = ").append(formVal);
  }
  MM_editQuery.append(" where ").append(MM_editColumn).append(" = ").append(MM_recordId);
  
  if (!MM_abortEdit) {
    // finish the sql and execute it
    Connection MM_connection =  rcsiteDS.getConnection();
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
String RecordsetConfig__MMColParam = "1";
if (request.getParameter("key") !=null) {RecordsetConfig__MMColParam = (String)request.getParameter("key");}
%>
<%

Connection ConnRecordsetConfig =   rcsiteDS.getConnection(); 
PreparedStatement StatementRecordsetConfig = ConnRecordsetConfig.prepareStatement("SELECT * FROM rcsite_config WHERE config_key = '" + RecordsetConfig__MMColParam + "'");
ResultSet RecordsetConfig = StatementRecordsetConfig.executeQuery();
boolean RecordsetConfig_isEmpty = !RecordsetConfig.next();
boolean RecordsetConfig_hasData = !RecordsetConfig_isEmpty;
Object RecordsetConfig_data;
int RecordsetConfig_numRows = 0;
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
            <jsp:include page="adminleftnavi.jsp?screen=system" flush="true" /> <!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
  <table align="center">
    <tr valign="baseline">
      <td nowrap align="right">Config_key:</td>
      <td><%=(((RecordsetConfig_data = RecordsetConfig.getObject("config_key"))==null || RecordsetConfig.wasNull())?"":RecordsetConfig_data)%></td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Value:</td>
      <td><textarea type="text" name="value" cols="50" rows="5"><%=(((RecordsetConfig_data = RecordsetConfig.getObject("value"))==null || RecordsetConfig.wasNull())?"":RecordsetConfig_data)%></textarea>
      </td>
    </tr>
    <tr>
      <td nowrap align="right" valign="top">Description:</td>
      <td valign="baseline"><textarea name="description" cols="50" rows="5"><%=(((RecordsetConfig_data = RecordsetConfig.getObject("description"))==null || RecordsetConfig.wasNull())?"":RecordsetConfig_data)%></textarea>
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Site_area:</td>
      <td><input type="text" name="site_area" value="<%=(((RecordsetConfig_data = RecordsetConfig.getObject("site_area"))==null || RecordsetConfig.wasNull())?"":RecordsetConfig_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Active:</td>
      <td><input <%=(((((RecordsetConfig_data = RecordsetConfig.getObject("active"))==null || RecordsetConfig.wasNull())?"":RecordsetConfig_data).toString().equals(("1").toString()))?"checked":"")%> type="checkbox" name="active" value=1 >
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Hot_configurable:</td>
      <td><input <%=(((((RecordsetConfig_data = RecordsetConfig.getObject("hot_configurable"))==null || RecordsetConfig.wasNull())?"":RecordsetConfig_data).toString().equals(("1").toString()))?"checked":"")%> type="checkbox" name="hot_configurable" value=1 >
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">&nbsp;</td>
      <td><input type="submit" value="Update record">
      </td>
    </tr>
  </table>
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((RecordsetConfig_data = RecordsetConfig.getObject("config_key"))==null || RecordsetConfig.wasNull())?"":RecordsetConfig_data)%>">
</form>
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
RecordsetConfig.close();
StatementRecordsetConfig.close();
ConnRecordsetConfig.close();
%>
