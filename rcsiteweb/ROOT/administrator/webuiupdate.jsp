<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*, javax.servlet.*,javax.activation.*,java.io.*,java.text.*,java.lang.*"%>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String header= "";

String footer= "";
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
// *** Update Record: set variables

if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_update").toString().equals("form1") &&
    request.getParameter("MM_recordId") != null) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "webui";
  MM_editColumn = "ui_id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "webuiupdate.jsp";
  String MM_fieldsStr = "ui_id|value|email_header|value|email_footer|value";
  String MM_columnsStr = "ui_id|none,none,NULL|email_header|',none,''|email_footer|',none,''";

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
   //Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
   // Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection = rcsiteDS.getConnection();
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
String HeaderRecordset__MMColParam = "1";
if (request.getParameter("ui_id") !=null) {HeaderRecordset__MMColParam = (String)request.getParameter("ui_id");}
%>
<%


//Driver DriverHeaderRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnHeaderRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnHeaderRecordset = rcsiteDS.getConnection();
PreparedStatement StatementHeaderRecordset = ConnHeaderRecordset.prepareStatement("SELECT * FROM webui WHERE ui_id = " + HeaderRecordset__MMColParam + "");
ResultSet HeaderRecordset = StatementHeaderRecordset.executeQuery();
boolean HeaderRecordset_isEmpty = !HeaderRecordset.next();
boolean HeaderRecordset_hasData = !HeaderRecordset_isEmpty;
Object HeaderRecordset_data;
int HeaderRecordset_numRows = 0;
%>

<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- tinyMCE -->
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript">
	tinyMCE.init({
		mode : "textareas",
		theme : "advanced",
		plugins : "table,save,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,zoom,flash,searchreplace,print,contextmenu",
		theme_advanced_buttons1_add_before : "save,separator",
		theme_advanced_buttons1_add : "fontselect,fontsizeselect",
		theme_advanced_buttons2_add : "separator,insertdate,inserttime,preview,zoom,separator,forecolor,backcolor",
		theme_advanced_buttons2_add_before: "cut,copy,paste,separator,search,replace,separator",
		theme_advanced_buttons3_add_before : "tablecontrols,separator",
		theme_advanced_buttons3_add : "emotions,iespell,flash,advhr,separator,print",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_path_location : "bottom",
		content_css : "example_full.css",
	    plugin_insertdate_dateFormat : "%Y-%m-%d",
	    plugin_insertdate_timeFormat : "%H:%M:%S",
		extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
		external_link_list_url : "example_link_list.js",
		external_image_list_url : "example_image_list.js",
		flash_external_list_url : "example_flash_list.js",
		file_browser_callback : "fileBrowserCallBack"
	});

	function fileBrowserCallBack(field_name, url, type) {
		// This is where you insert your custom filebrowser logic
		alert("Filebrowser callback: " + field_name + "," + url + "," + type);
	}
</script>
<!-- /tinyMCE -->
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
            <jsp:include page="adminleftnavi.jsp?screen=email" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
  <table align="center">
    <tr> 
      <td nowrap align="right" valign="top">&nbsp;</td>
      <td valign="baseline">&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap align="right" valign="top">&nbsp;</td>
      <td valign="baseline">Header:</td>
    </tr>
    <tr> 
      <td nowrap align="right" valign="top">&nbsp;</td>
      <td valign="baseline"> 
        <!-- <textarea name="email_header" cols="75" rows="10"></textarea>-->
          
                   
                      <textarea name="email_header" id="email_header" cols="75" rows="20" ><%=(((HeaderRecordset_data = HeaderRecordset.getObject("email_header"))==null || HeaderRecordset.wasNull())?"":HeaderRecordset_data)%></textarea>

					
      </td>
    </tr>
    <tr>
      <td nowrap align="right" valign="top">&nbsp;</td>
      <td valign="baseline">Footer:</td>
    </tr>
    <tr> 
      <td nowrap align="right" valign="top">&nbsp;</td>
      <td valign="baseline"> <textarea name="email_footer" cols="75" rows="10"><%=(((HeaderRecordset_data = HeaderRecordset.getObject("email_footer"))==null || HeaderRecordset.wasNull())?"":HeaderRecordset_data)%></textarea> 
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">&nbsp;</td>
      <td> <input type="submit" value="Update Record" > 
      </td>
    </tr>
  </table>
  <input type="hidden" name="ui_id" value="<%=(((HeaderRecordset_data = HeaderRecordset.getObject("ui_id"))==null || HeaderRecordset.wasNull())?"":HeaderRecordset_data)%>" size="32">
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((HeaderRecordset_data = HeaderRecordset.getObject("ui_id"))==null || HeaderRecordset.wasNull())?"":HeaderRecordset_data)%>">
  	<input type="hidden" name="RTEbgcolor" value="" ID="Hidden1">
  <input type="hidden" name="sigflag" value="y">
  <input type="hidden" name="plaintext">
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
HeaderRecordset.close();
StatementHeaderRecordset.close();
ConnHeaderRecordset.close();
%>
