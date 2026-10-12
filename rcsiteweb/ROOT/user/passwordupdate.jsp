<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>

<%
String headerBG =(String)session.getValue("headerBG");
%>
<%
if (session.getValue("store")==null || ((String)session.getValue("store")).equals("")) {
	session.putValue("store", "usa"); 
}
if (request.getParameter("store") !=null && !request.getParameter("store").equals("")) {
	session.putValue("store", (String)request.getParameter("store")); 
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

String pageMessage ="";
if (request.getParameter("pagemessage") !=null) {pageMessage = (String)request.getParameter("pagemessage");}
%>
<%
String store =(String)session.getValue("store");
String dcode =(String)session.getValue("dcode");
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
  MM_editRedirectUrl = "welcome.jsp";
  String MM_fieldsStr = "pword|value|email|value";
  String MM_columnsStr = "pword|',none,''|email|',none,''";

  


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
String password2 ="";
if (request.getParameter("pword2") !=null) {password2 = (String)request.getParameter("pword2");}


  if(!password2.equalsIgnoreCase((String)MM_fields[1])){
  		pageMessage= "The passwords did not match, please re-enter your new password.";
	response.sendRedirect(response.encodeRedirectURL("passwordupdate.jsp?pagemessage="+pageMessage));
      return;
  
  }
  
  
    if(!MM_recordId.equalsIgnoreCase("'"+((String)session.getValue("MM_Username"))+"'")){
  		pageMessage= "The passwords/username did not match, please re-enter your new password.";
	response.sendRedirect(response.encodeRedirectURL("passwordupdate.jsp?pagemessage="+pageMessage));
      return;
  
  }
  // append the query string to the redirect URL
  if (MM_editRedirectUrl.length() != 0 && request.getQueryString() != null) {
    //MM_editRedirectUrl += ((MM_editRedirectUrl.indexOf('?') == -1)?"?":"&") + request.getQueryString();
	MM_editRedirectUrl = MM_editRedirectUrl+"?dcode="+dcode+"&store="+store;
  }
}
%>
<%
  
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
String CustomerRecordset__MMColParam = (String)session.getValue("MM_Username");
//if (request.getParameter("username") !=null) {CustomerRecordset__MMColParam = (String)request.getParameter("username");}
%>
<%
//Driver DriverCustomerRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCustomerRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCustomerRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCustomerRecordset = ConnCustomerRecordset.prepareStatement("SELECT username, pword, customer, email FROM rc_customer WHERE username = '" + CustomerRecordset__MMColParam + "'");
ResultSet CustomerRecordset = StatementCustomerRecordset.executeQuery();
boolean CustomerRecordset_isEmpty = !CustomerRecordset.next();
boolean CustomerRecordset_hasData = !CustomerRecordset_isEmpty;
Object CustomerRecordset_data;
int CustomerRecordset_numRows = 0;
%>
<jsp:include page="../custom/storeconfig.jsp" flush="true" />
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
<title>Change Password</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
</head>


<BODY leftMargin=0 topMargin=0 marginwidth="0" marginheight="0">
<jsp:include page="../custom/rcheader.jsp" flush="true" />
<form method="post" action="<%=MM_editAction%>" name="form1">
                      <table align="center" class="text">
                        <tr valign="baseline"> 
                          <td colspan="2" align="left" nowrap><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="left"><strong>Username:</strong></td>
                          <td><%=(((CustomerRecordset_data = CustomerRecordset.getObject("username"))==null || CustomerRecordset.wasNull())?"":CustomerRecordset_data)%></td>
                        </tr>
                        <tr valign="baseline"> 
                          <td height="24" align="left" nowrap><strong>New password:</strong></td>
                          <td> <input name="pword" type="password" size="15" maxlength="15" class="input" > 
                          </td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="left"><strong>Retype new password:</strong></td>
                          <td><input name="pword2" type="password" size="15" maxlength="15" class="input" ></td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="left"><strong>Email lost passwords 
                            to:</strong></td>
                          <td> <input type="text" name="email" value="<%=(((CustomerRecordset_data = CustomerRecordset.getObject("email"))==null || CustomerRecordset.wasNull())?"":CustomerRecordset_data)%>" size="32" class="input" > 
                          </td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="right">&nbsp;</td>
                          <td> <input type="submit" value="Change Password"> </td>
                        </tr>
                      </table>
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((CustomerRecordset_data = CustomerRecordset.getObject("username"))==null || CustomerRecordset.wasNull())?"":CustomerRecordset_data)%>">
</form>
<jsp:include page="../custom/rcfooter.jsp" flush="true" />
</body>
</html>
<%
CustomerRecordset.close();
StatementCustomerRecordset.close();
ConnCustomerRecordset.close();
%>
