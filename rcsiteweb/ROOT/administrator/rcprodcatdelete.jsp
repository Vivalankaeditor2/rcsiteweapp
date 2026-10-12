<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
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
// *** Update Record: set variables

if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_update").toString().equals("form1") &&
    request.getParameter("MM_recordId") != null) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "prodxcat";
  MM_editColumn = "line_id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "rcaddtocategory.jsp";
  
  /*
  String MM_fieldsStr = "category_id|value|order_|value";
  String MM_columnsStr = "category_id|none,none,NULL|order_|none,none,NULL";

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
*/
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
/*
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
  */

 String deleteQuery ="delete FROM prodxcat WHERE line_id="+MM_recordId;

  if (!MM_abortEdit) {
    // finish the sql and execute it
    //Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
    //Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection  = rcsiteDS.getConnection();
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(deleteQuery);
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
String ProCatRecordset__MMColParam = "1";
if (request.getParameter("line_id") !=null) {ProCatRecordset__MMColParam = (String)request.getParameter("line_id");}
String productId = "1";
if (request.getParameter("product_id") !=null) {productId = (String)request.getParameter("product_id");}

%>
<%
//Driver DriverProCatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnProCatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnProCatRecordset= rcsiteDS.getConnection();
PreparedStatement StatementProCatRecordset = ConnProCatRecordset.prepareStatement("SELECT * FROM prodxcat WHERE line_id = " + ProCatRecordset__MMColParam + "");
ResultSet ProCatRecordset = StatementProCatRecordset.executeQuery();
boolean ProCatRecordset_isEmpty = !ProCatRecordset.next();
boolean ProCatRecordset_hasData = !ProCatRecordset_isEmpty;
Object ProCatRecordset_data;
int ProCatRecordset_numRows = 0;
%>
<%
String CategoryRecordset__MMColParam = "usa";
if (request.getParameter("store") !=null) {CategoryRecordset__MMColParam = (String)request.getParameter("store");}
%>
<%
//Driver DriverCategoryRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCategoryRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCategoryRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCategoryRecordset = ConnCategoryRecordset.prepareStatement("SELECT * FROM product_categories WHERE store = '" + CategoryRecordset__MMColParam + "'");
ResultSet CategoryRecordset = StatementCategoryRecordset.executeQuery();
boolean CategoryRecordset_isEmpty = !CategoryRecordset.next();
boolean CategoryRecordset_hasData = !CategoryRecordset_isEmpty;
Object CategoryRecordset_data;
int CategoryRecordset_numRows = 0;
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
            <jsp:include page="adminleftnavi.jsp?screen=rcmerchant" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" --> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><%
		String naviUrl ="producteditnavibar.jsp?product_id=" +productId;
	%> <jsp:include page="<%= naviUrl%>" flush="true" /></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><strong>Remove product X category</strong></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><form method="post" action="<%=MM_editAction%>" name="form1">
                    <table align="center">
                      <tr valign="baseline"> 
                        <td nowrap align="left">Line id:</td>
                        <td><%=(((ProCatRecordset_data = ProCatRecordset.getObject("line_id"))==null || ProCatRecordset.wasNull())?"":ProCatRecordset_data)%></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Category:</td>
                        <td> <%=(((ProCatRecordset_data = ProCatRecordset.getObject("category_id"))==null || ProCatRecordset.wasNull())?"":ProCatRecordset_data)%>
                         </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Product id:</td>
                        <td><%=(((ProCatRecordset_data = ProCatRecordset.getObject("product_id"))==null || ProCatRecordset.wasNull())?"":ProCatRecordset_data)%></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Order:</td>
                        <td> <%=(((ProCatRecordset_data = ProCatRecordset.getObject("order_"))==null || ProCatRecordset.wasNull())?"":ProCatRecordset_data)%>
                        </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td colspan="2" align="left" nowrap><strong><font color="#FF0000">Are 
                          you sure you want to remove this product from this category?</font></strong></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">&nbsp;</td>
                        <td> <input name="submit" type="submit" value="Remove"> 
                        </td>
                      </tr>
                    </table>
                    <input type="hidden" name="MM_update" value="form1">
                    <input type="hidden" name="MM_recordId" value="<%=(((ProCatRecordset_data = ProCatRecordset.getObject("line_id"))==null || ProCatRecordset.wasNull())?"":ProCatRecordset_data)%>">
                  </form></td>
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
ProCatRecordset.close();
StatementProCatRecordset.close();
ConnProCatRecordset.close();
%>
<%
CategoryRecordset.close();
StatementCategoryRecordset.close();
ConnCategoryRecordset.close();
%>
