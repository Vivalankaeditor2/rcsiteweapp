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
  MM_editTable  = "product_options";
  MM_editColumn = "option_id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "rcoptioninsert.jsp";
 
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


  String deleteQuery ="delete FROM product_options WHERE option_id="+MM_recordId;
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
String productId = "";
if (request.getParameter("prod_id") !=null) {productId = (String)request.getParameter("prod_id");}

%>
<%
String OptionRecordset__MMColParam = "1";
if (request.getParameter("option_id") !=null) {OptionRecordset__MMColParam = (String)request.getParameter("option_id");}
%>
<%
//Driver DriverOptionRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnOptionRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnOptionRecordset = rcsiteDS.getConnection();
PreparedStatement StatementOptionRecordset = ConnOptionRecordset.prepareStatement("SELECT * FROM product_options WHERE option_id = " + OptionRecordset__MMColParam + "");
ResultSet OptionRecordset = StatementOptionRecordset.executeQuery();
boolean OptionRecordset_isEmpty = !OptionRecordset.next();
boolean OptionRecordset_hasData = !OptionRecordset_isEmpty;
Object OptionRecordset_data;
int OptionRecordset_numRows = 0;
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
                <td> <%
					String naviUrl ="producteditnavibar.jsp?product_id=" +productId;
				%> <jsp:include page="<%= naviUrl%>" flush="true" /></td>
              </tr>
              <tr> 
                <td><form method="post" action="<%=MM_editAction%>" name="form1">
                    
				    <table align="center">
                      <tr valign="baseline"> 
                        <td colspan="2" align="left" nowrap><strong>Delete product 
                          option</strong></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Option id:</td>
                        <td> <%=(((OptionRecordset_data = OptionRecordset.getObject("option_id"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Attribute id:</td>
                        <td> <%=(((OptionRecordset_data = OptionRecordset.getObject("attri_id"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Order:</td>
                        <td> <%=(((OptionRecordset_data = OptionRecordset.getObject("order_"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Code:</td>
                        <td> <%=(((OptionRecordset_data = OptionRecordset.getObject("code"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Prompt:</td>
                        <td> <%=(((OptionRecordset_data = OptionRecordset.getObject("prompt"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%> </td>
                      </tr>
                      <tr align="left" valign="baseline"> 
                        <td colspan="2" nowrap><strong><font color="#FF0000">Are 
                          you sure you want to delete this product category?</font></strong></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="right">&nbsp;</td>
                        <td> <input type="submit" value="Delete"> </td>
                      </tr>
                    </table>
					<input type="hidden" name="cost" value="<%=(((OptionRecordset_data = OptionRecordset.getObject("cost"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%>" size="32">
                    <input type="hidden" name="image" value="<%=(((OptionRecordset_data = OptionRecordset.getObject("image"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%>" size="32">
                    <input type="hidden" name="price" value="<%=(((OptionRecordset_data = OptionRecordset.getObject("price"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%>" size="32">
                    <input type="hidden" name="MM_update" value="form1">
                    <input type="hidden" name="MM_recordId" value="<%=(((OptionRecordset_data = OptionRecordset.getObject("option_id"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%>">
                  </form></td>
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
OptionRecordset.close();
StatementOptionRecordset.close();
ConnOptionRecordset.close();
%>
