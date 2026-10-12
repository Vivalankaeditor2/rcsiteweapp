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
  MM_editRedirectUrl = "rcattributeupdate.jsp";
  String MM_fieldsStr = "default_code|value|order_|value|code|value|type|value|attemp_id|value|prompt|value|price|value|cost|value|required|value|image|value";
  String MM_columnsStr = "default_code|',none,''|order_|none,none,NULL|code|',none,''|type|',none,''|attemp_id|none,none,NULL|prompt|',none,''|price|none,none,NULL|cost|none,none,NULL|required|none,1,0|image|',none,''";

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
   // Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
   // Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection  = rcsiteDS.getConnection();
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
                        <td colspan="2" align="left" nowrap><strong>Update Attribute</strong></td>
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
                        <td> <input type="text" name="order_" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("order_"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>" size="32"> 
                        </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Code:</td>
                        <td> <input type="text" name="code" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("code"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>" size="32"> 
                        </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Prompt:</td>
                        <td> <input type="text" name="prompt" value="<%=(((AttributeRecordset_data = AttributeRecordset.getObject("prompt"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%>" size="32"> 
                        </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Type:</td>
                        <td> <select name="type">
                            <option value="select"  <%=(("select".toString().equals((((AttributeRecordset_data = AttributeRecordset.getObject("type"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)))?"SELECTED":"")%>>Drop-Down 
                            List</option>
                            <option value="radio"  <%=(("radio".toString().equals((((AttributeRecordset_data = AttributeRecordset.getObject("type"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)))?"SELECTED":"")%>>Radio 
                            Button</option>
                          </select> </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">Required:</td>
                        <td> <input type="checkbox" name="required" value=1  <%=(((((AttributeRecordset_data = AttributeRecordset.getObject("required"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data).toString().equals(("1").toString()))?"checked":"")%>> 
                        </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="right">&nbsp;</td>
                        <td> <input type="submit" value="Update Attribute"> </td>
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
