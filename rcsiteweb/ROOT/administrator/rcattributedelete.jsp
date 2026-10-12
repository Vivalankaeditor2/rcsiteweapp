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
  MM_editTable  = "product_attributes";
  MM_editColumn = "attribute_id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "rcattributeinsert.jsp";
 
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

   String deleteQuery ="delete FROM product_attributes WHERE attribute_id="+MM_recordId;
  
  if (!MM_abortEdit) {
    // finish the sql and execute it
    //Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
    //Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection = rcsiteDS.getConnection();
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
String productId = "1";
if (request.getParameter("product_id") !=null) {productId  = (String)request.getParameter("product_id");}
String productName = "1";
if (request.getParameter("product_name") !=null) {productName= (String)request.getParameter("product_name");}
%>
<%
String AttributeRecordset__MMColParam = "1";
if (request.getParameter("attribute_id") !=null) {AttributeRecordset__MMColParam = (String)request.getParameter("attribute_id");}
%>
<%
//Driver DriverAttributeRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnAttributeRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnAttributeRecordset = rcsiteDS.getConnection();
PreparedStatement StatementAttributeRecordset = ConnAttributeRecordset.prepareStatement("SELECT * FROM product_attributes WHERE attribute_id = " + AttributeRecordset__MMColParam + " ORDER BY order_ ASC");
ResultSet AttributeRecordset = StatementAttributeRecordset.executeQuery();
boolean AttributeRecordset_isEmpty = !AttributeRecordset.next();
boolean AttributeRecordset_hasData = !AttributeRecordset_isEmpty;
Object AttributeRecordset_data;
int AttributeRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
AttributeRecordset_numRows += Repeat1__numRows;
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
                <td>
		<%
			String naviUrl ="producteditnavibar.jsp?product_id=" +productId;
		%>
            <jsp:include page="<%= naviUrl%>" flush="true" />
				</td>
              </tr>
              <tr>
                <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
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
                <td><strong>Attribute Id</strong></td>
                <td><strong>Product Id</strong></td>
                <td><strong>Order_</strong></td>
                <td><strong>Code</strong></td>
                <td><strong>Type</strong></td>
                <td><strong>Prompt</strong></td>
                <td><strong>Required</strong></td>
              </tr>
              <% while ((AttributeRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <tr valign="top" <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"CCCCCC\" ");}%>> 
                <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("attribute_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
                <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("prod_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
                <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("order_"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
                <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("code"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
                <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("type"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
                <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("prompt"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
                <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("required"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
              </tr>
              <%
  Repeat1__index++;
  AttributeRecordset_hasData = AttributeRecordset.next();
}

%>
              <%
AttributeRecordset.close();
StatementAttributeRecordset.close();
StatementAttributeRecordset = ConnAttributeRecordset.prepareStatement("SELECT * FROM product_attributes WHERE attribute_id = " + AttributeRecordset__MMColParam + " ORDER BY order_ ASC");
AttributeRecordset = StatementAttributeRecordset.executeQuery();
AttributeRecordset_isEmpty = !AttributeRecordset.next();
AttributeRecordset_hasData = !AttributeRecordset_isEmpty;
AttributeRecordset_numRows = 0;

%>
            </table>
				
				</td>
              </tr>
              <tr>
                <td><form method="post" action="<%=MM_editAction%>" name="form1">
                    <table align="left">
                      <tr valign="baseline"> 
                        <td colspan="2" align="left" nowrap>&nbsp;</td>
                      </tr>
                      <tr valign="baseline"> 
                        <td colspan="2" align="left" nowrap><strong>Delete attribute</strong></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Attribute id:</td>
                        <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("attribute_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Product id:</td>
                        <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("prod_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Order:</td>
                        <td> <%=(((AttributeRecordset_data = AttributeRecordset.getObject("order_"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Code:</td>
                        <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("code"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Prompt:</td>
                        <td> <%=(((AttributeRecordset_data = AttributeRecordset.getObject("prompt"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Type:</td>
                        <td> <%=(((AttributeRecordset_data = AttributeRecordset.getObject("type"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Required:</td>
                        <td> <%=(((AttributeRecordset_data = AttributeRecordset.getObject("required"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%> </td>
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
              <input type="hidden" name="default_code" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("default_code"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>" size="32">
              <input type="hidden" name="attemp_id" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("attemp_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>" size="32">
              <input type="hidden" name="price" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("price"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>" size="32">
              <input type="hidden" name="cost" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("cost"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>" size="32">
              <input type="hidden" name="image" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("image"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>" size="32">
              <input type="hidden" name="MM_update" value="form1">
              <input type="hidden" name="MM_recordId" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("attribute_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>">
            </form></td>
              </tr>
            </table>
           
            
            <p>&nbsp;</p>
            
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
AttributeRecordset.close();
StatementAttributeRecordset.close();
ConnAttributeRecordset.close();
%>
