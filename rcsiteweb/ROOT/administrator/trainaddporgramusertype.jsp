<%@page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" %>
<%@ include file="../Connections/TrainingConnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
	String Programid = "";
	if(session.getAttribute("programid")!=null)
    {
        Programid = (String)session.getAttribute("programid");
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

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("usertypecatogories")) {

  MM_editDriver     = MM_TrainingConnection_DRIVER;
  MM_editConnection = MM_TrainingConnection_STRING;
  MM_editUserName   = MM_TrainingConnection_USERNAME;
  MM_editPassword   = MM_TrainingConnection_PASSWORD;
  MM_editTable  = "user_program_subcatogory";
  MM_editRedirectUrl = "traininsertedsuccessfully.jsp";
  String MM_fieldsStr = "programid|value|usertypename|value|subcatogoryname|value";
  String MM_columnsStr = "programid|none,none,NULL|usertypename|',none,''|subcatogoryname|',none,''";

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
//Driver DriverUserTypeDetails = (Driver)Class.forName(MM_TrainingConnection_DRIVER).newInstance();
//Connection ConnUserTypeDetails = DriverManager.getConnection(MM_TrainingConnection_STRING,MM_TrainingConnection_USERNAME,MM_TrainingConnection_PASSWORD);
Connection ConnUserTypeDetails = rcsiteDS.getConnection();
PreparedStatement StatementUserTypeDetails = ConnUserTypeDetails.prepareStatement("SELECT usertypeid, usertypename  FROM usertype");
ResultSet UserTypeDetails = StatementUserTypeDetails.executeQuery();
boolean UserTypeDetails_isEmpty = !UserTypeDetails.next();
boolean UserTypeDetails_hasData = !UserTypeDetails_isEmpty;
Object UserTypeDetails_data;
int UserTypeDetails_numRows = 0;
%>
<%
//Driver DriverSubcatogoryDetails = (Driver)Class.forName(MM_TrainingConnection_DRIVER).newInstance();
//Connection ConnSubcatogoryDetails = DriverManager.getConnection(MM_TrainingConnection_STRING,MM_TrainingConnection_USERNAME,MM_TrainingConnection_PASSWORD);
Connection ConnSubcatogoryDetails = rcsiteDS.getConnection();
PreparedStatement StatementSubcatogoryDetails = ConnSubcatogoryDetails.prepareStatement("SELECT subcatogoryid, subcatogory_name  FROM subcatogory");
ResultSet SubcatogoryDetails = StatementSubcatogoryDetails.executeQuery();
boolean SubcatogoryDetails_isEmpty = !SubcatogoryDetails.next();
boolean SubcatogoryDetails_hasData = !SubcatogoryDetails_isEmpty;
Object SubcatogoryDetails_data;
int SubcatogoryDetails_numRows = 0;

%>




<%@ include file="../custom/config.jsp" %>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->
<link href="../css/styles.css" rel="stylesheet" type="text/css">
<!-- InstanceEndEditable -->
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

<div align="center">
              <table class="text">
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td width="486"> <font face="Tahoma"><strong>Add User Type and 
                    Subcatogories for Training Program</strong></font> </td>
                </tr>
                <tr> 
                  <td height="21"> <form action="<%=MM_editAction%>" method="post" name="usertypecatogories" id="usertypecatogories">
                      <table width="384" align="center">
                        <tr valign="baseline"> 
                          <td width="376" align="right" nowrap> <div align="left"> 
                              <table width="378" class="text" >
                                <tr> 
                                  <td>&nbsp;</td>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr> 
                                  <td width="161"> <strong>Usertype Name</strong>:</td>
                                  <td width="205"> <div align="left"> 
                                      <select name="usertypename">
                                        <%
while (UserTypeDetails_hasData) {
%>
                                        <option value="<%=((UserTypeDetails.getObject("usertypename")!=null)?UserTypeDetails.getObject("usertypename"):"")%>"><%=((UserTypeDetails.getObject("usertypename")!=null)?UserTypeDetails.getObject("usertypename"):"")%></option>
                                        <%
  UserTypeDetails_hasData = UserTypeDetails.next();
}
UserTypeDetails.close();
UserTypeDetails = StatementUserTypeDetails.executeQuery();
UserTypeDetails_hasData = UserTypeDetails.next();
UserTypeDetails_isEmpty = !UserTypeDetails_hasData;
%>
                                      </select>
                                    </div></td>
                                </tr>
                                <tr valign="baseline"> 
                                  <td nowrap><strong>Subcatogory Name:</strong></td>
                                  <td> <div align="left"> 
                                      <select name="subcatogoryname">
                                        <%
while (SubcatogoryDetails_hasData) {
%>
                                        <option value="<%=((SubcatogoryDetails.getObject("subcatogory_name")!=null)?SubcatogoryDetails.getObject("subcatogory_name"):"")%>"><%=((SubcatogoryDetails.getObject("subcatogory_name")!=null)?SubcatogoryDetails.getObject("subcatogory_name"):"")%></option>
                                        <%
  SubcatogoryDetails_hasData = SubcatogoryDetails.next();
}
SubcatogoryDetails.close();
SubcatogoryDetails = StatementSubcatogoryDetails.executeQuery();
SubcatogoryDetails_hasData = SubcatogoryDetails.next();
SubcatogoryDetails_isEmpty = !SubcatogoryDetails_hasData;
%>
                                      </select>
                                    </div></td>
                                </tr>
                              </table>
                            </div>
                        <tr valign="baseline"> 
                          <td> <div align="center"> <strong> <font face="Tahoma"> 
                              <input name="submit" type="submit" value="Insert Usertype Catogories">
                              </font> </strong> </div></td>
                        </tr>
                      </table>
                      <input type="hidden" name="programid" value="<%=Programid%>" size="32">
                      <input type="hidden" name="MM_insert" value="usertypecatogories">
                    </form>
                    <p>&nbsp;</p></td>
                </tr>
              </table>
  <p>&nbsp;</p>
</div>
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
UserTypeDetails.close();
StatementUserTypeDetails.close();
ConnUserTypeDetails.close();
%>
<%
SubcatogoryDetails.close();
StatementSubcatogoryDetails.close();
ConnSubcatogoryDetails.close();
%>
