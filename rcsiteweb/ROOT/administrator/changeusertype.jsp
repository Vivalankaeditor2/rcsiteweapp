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
  MM_editTable  = "rc_customer";
  MM_editColumn = "username";
  MM_recordId   = "'" + request.getParameter("MM_recordId") + "'";
  MM_editRedirectUrl = "memberlist.jsp";
  String MM_fieldsStr = "username|value|type|value";
  String MM_columnsStr = "username|',none,''|type|',none,''";

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
String CustomerRecordset__MMColParam = "1";
if (request.getParameter("username")  !=null) {CustomerRecordset__MMColParam = (String)request.getParameter("username") ;}
%>
<%
//Driver DriverCustomerRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCustomerRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCustomerRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCustomerRecordset = ConnCustomerRecordset.prepareStatement("SELECT *  FROM rc_customer  WHERE username = '" + CustomerRecordset__MMColParam + "'");
ResultSet CustomerRecordset = StatementCustomerRecordset.executeQuery();
boolean CustomerRecordset_isEmpty = !CustomerRecordset.next();
boolean CustomerRecordset_hasData = !CustomerRecordset_isEmpty;
Object CustomerRecordset_data;
int CustomerRecordset_numRows = 0;
%>
<%
//Driver DriverUserTypeRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnUserTypeRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnUserTypeRecordset = rcsiteDS.getConnection();
PreparedStatement StatementUserTypeRecordset = ConnUserTypeRecordset.prepareStatement("SELECT * FROM usertype");
ResultSet UserTypeRecordset = StatementUserTypeRecordset.executeQuery();
boolean UserTypeRecordset_isEmpty = !UserTypeRecordset.next();
boolean UserTypeRecordset_hasData = !UserTypeRecordset_isEmpty;
Object UserTypeRecordset_data;
int UserTypeRecordset_numRows = 0;
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
            <jsp:include page="adminleftnavi.jsp?screen=" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table align="center">
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td colspan="2" align="left" nowrap><strong>Change User Type</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Username:</strong></td>
                  <td><%=(((CustomerRecordset_data = CustomerRecordset.getObject("username"))==null || CustomerRecordset.wasNull())?"":CustomerRecordset_data)%></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Pword:</strong></td>
                  <td>******</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Customer:</strong></td>
                  <td><%=(((CustomerRecordset_data = CustomerRecordset.getObject("customer"))==null || CustomerRecordset.wasNull())?"":CustomerRecordset_data)%></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Email:</strong></td>
                  <td><%=(((CustomerRecordset_data = CustomerRecordset.getObject("email"))==null || CustomerRecordset.wasNull())?"":CustomerRecordset_data)%></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Type:</strong></td>
                  <td> <select name="type">
                      <%
while (UserTypeRecordset_hasData) {
%>
                      <option value="<%=((UserTypeRecordset.getObject("usertypename")!=null)?UserTypeRecordset.getObject("usertypename"):"")%>" <%=(((UserTypeRecordset.getObject("usertypename")).toString().equals(((((CustomerRecordset_data = CustomerRecordset.getObject("type"))==null || CustomerRecordset.wasNull())?"":CustomerRecordset_data)).toString()))?"SELECTED":"")%> ><%=((UserTypeRecordset.getObject("usertypename")!=null)?UserTypeRecordset.getObject("usertypename"):"")%></option>
                      <%
  UserTypeRecordset_hasData = UserTypeRecordset.next();
}
UserTypeRecordset.close();
UserTypeRecordset = StatementUserTypeRecordset.executeQuery();
UserTypeRecordset_hasData = UserTypeRecordset.next();
UserTypeRecordset_isEmpty = !UserTypeRecordset_hasData;
%>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td> <input type="submit" value="Update Record"> </td>
                </tr>
              </table>
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((CustomerRecordset_data = CustomerRecordset.getObject("username"))==null || CustomerRecordset.wasNull())?"":CustomerRecordset_data)%>">
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
CustomerRecordset.close();
StatementCustomerRecordset.close();
ConnCustomerRecordset.close();
%>
<%
UserTypeRecordset.close();
StatementUserTypeRecordset.close();
ConnUserTypeRecordset.close();
%>
