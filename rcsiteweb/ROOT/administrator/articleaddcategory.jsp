<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,com.rev_creations.rcsite.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
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


  MM_editTable  = "article_category";
  MM_editRedirectUrl = "index.jsp";
	if(Config.getValue("newsenabled")!=null &&
			"1".equals(Config.getValue("newsenabled").trim()) &&
			"2".equals(request.getParameter("parentid"))){
		MM_editRedirectUrl = "articlecategorylocation.jsp";
	}
  String MM_fieldsStr = "parentid|value|category_name|value|title|value|description|value|level|value|priority|value|active|value";
  String MM_columnsStr = "parentid|none,none,NULL|category_name|',none,''|title|',none,''|description|',none,''|level|',none,''|priority|none,none,NULL|active|',none,''";

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
   // Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
    //Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
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
String ArtiCatRecordset__MMColParam = "main";
if (request.getParameter("level") !=null) {ArtiCatRecordset__MMColParam = (String)request.getParameter("level");}
%>
<%
//Driver DriverArtiCatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnArtiCatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnArtiCatRecordset = rcsiteDS.getConnection();
PreparedStatement StatementArtiCatRecordset = ConnArtiCatRecordset.prepareStatement("SELECT * FROM article_category WHERE level = '" + ArtiCatRecordset__MMColParam + "'");
ResultSet ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
boolean ArtiCatRecordset_isEmpty = !ArtiCatRecordset.next();
boolean ArtiCatRecordset_hasData = !ArtiCatRecordset_isEmpty;
Object ArtiCatRecordset_data;
int ArtiCatRecordset_numRows = 0;
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
              <jsp:include page="adminleftnavi.jsp?screen=article" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table align="center" class="text">
                <tr valign="baseline">
                  <td colspan="2" align="left" nowrap>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td colspan="2" align="left" nowrap><strong>Add Article Category</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Parent category:</strong></td>
                  <td> <select name="parentid">
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
                  <td nowrap align="left"><strong>Category name:</strong></td>
                  <td> <input name="category_name" type="text" value="" size="30" maxlength="28">
                    (max 22 characters) </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Title:</strong></td>
                  <td> <input type="text" name="title" value="" size="32"> </td>
                </tr>
                <tr> 
                  <td align="left" valign="top">
<p><strong>Description: 
                      </strong></p>
                    <p>(max 240 characters)</p>
                    </td>
                  <td valign="baseline"> <textarea name="description" cols="50" rows="5"></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Level:</strong></td>
                  <td> <select name="level">
                      <option value="category">Category</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Priority:</strong></td>
                  <td> <select name="priority">
                      <option value="1"  selected>1</option>
                      <option value="2" >2</option>
                      <option value="3" >3</option>
                      <option value="4" >4</option>
                      <option value="5" >5</option>
                      <option value="6" >6</option>
                      <option value="7" >7</option>
                      <option value="8" >8</option>
                      <option value="9" >9</option>
                      <option value="10" >10</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Active:</strong></td>
                  <td> <input name="active" type="checkbox" value=yes checked > </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td> <input type="submit" value="Insert Record"> </td>
                </tr>
              </table>
  <input type="hidden" name="MM_insert" value="form1">
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
ArtiCatRecordset.close();
StatementArtiCatRecordset.close();
ConnArtiCatRecordset.close();
%>
