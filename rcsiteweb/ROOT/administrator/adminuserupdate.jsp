<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
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
  MM_editTable  = "ijts_student";
  MM_editColumn = "id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "adminuserupdate.jsp";
  String MM_fieldsStr = "nic|value|batch_|value|student_status|value|student_source|value|other_source|value|salutation|value|surname|value|first_name|value|other_name|value|date_of_birth|value|address_no|value|address_road|value|address_city|value|designation|value|name_of_working_place|value|home_phone|value|mobile_phone|value|highest_education|value|email|value|decided_to_come|value|introduce_by|value|intervied_by|value";
  String MM_columnsStr = "nic|',none,''|batch_|',none,''|student_status|',none,''|student_source|',none,''|other_source|',none,''|salutation|',none,''|surname|',none,''|first_name|',none,''|other_name|',none,''|date_of_birth|',none,NULL|address_no|',none,''|address_road|',none,''|address_city|',none,''|designation|',none,''|name_of_working_place|',none,''|home_phone|',none,''|mobile_phone|',none,''|highest_education|',none,''|email|',none,''|decided_to_come|',none,''|introduce_by|',none,''|intervied_by|',none,''";

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
  //  Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
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
String StudentRecordset__MMColParam = "ala";
if (request.getParameter("login") !=null) {StudentRecordset__MMColParam = (String)request.getParameter("login");}
%>
<%
//Driver DriverStudentRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnStudentRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnStudentRecordset = rcsiteDS.getConnection();
PreparedStatement StatementStudentRecordset = ConnStudentRecordset.prepareStatement("SELECT * FROM ijts_student WHERE login = '" + StudentRecordset__MMColParam + "'");
ResultSet StudentRecordset = StatementStudentRecordset.executeQuery();
boolean StudentRecordset_isEmpty = !StudentRecordset.next();
boolean StudentRecordset_hasData = !StudentRecordset_isEmpty;
Object StudentRecordset_data;
int StudentRecordset_numRows = 0;
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
            <jsp:include page="/administrator/adminleftnavi.jsp?screen=edu" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
  <table align="center">
    <tr valign="baseline"> 
      <td nowrap align="right">Nic:</td>
      <td> <input type="text" name="nic" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("nic"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Batch_:</td>
      <td> <input type="text" name="batch_" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("batch_"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Student_status:</td>
      <td> <select name="student_status">
          <option value="scjp"  <%=(("scjp".toString().equals((((StudentRecordset_data = StudentRecordset.getObject("student_status"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)))?"SELECTED":"")%>>scjp</option>
          <option value="call"  <%=(("call".toString().equals((((StudentRecordset_data = StudentRecordset.getObject("student_status"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)))?"SELECTED":"")%>>call</option>
        </select> </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Student_source:</td>
      <td> <input type="text" name="student_source" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("student_source"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Other_source:</td>
      <td> <input type="text" name="other_source" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("other_source"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Salutation:</td>
      <td> <select name="salutation">
          <option value="Mr."  <%=(("Mr.".toString().equals((((StudentRecordset_data = StudentRecordset.getObject("salutation"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)))?"SELECTED":"")%>>Mr.</option>
        </select> </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Surname:</td>
      <td> <input type="text" name="surname" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("surname"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">First_name:</td>
      <td> <input type="text" name="first_name" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("first_name"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Other_name:</td>
      <td> <input type="text" name="other_name" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("other_name"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Date_of_birth:</td>
      <td> <input type="text" name="date_of_birth" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("date_of_birth"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Address_no:</td>
      <td> <input type="text" name="address_no" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("address_no"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Address_road:</td>
      <td> <input type="text" name="address_road" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("address_road"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Address_city:</td>
      <td> <input type="text" name="address_city" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("address_city"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Designation:</td>
      <td> <input type="text" name="designation" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("designation"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Name_of_working_place:</td>
      <td> <input type="text" name="name_of_working_place" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("name_of_working_place"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Home_phone:</td>
      <td> <input type="text" name="home_phone" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("home_phone"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Mobile_phone:</td>
      <td> <input type="text" name="mobile_phone" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("mobile_phone"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Highest_education:</td>
      <td> <input type="text" name="highest_education" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("highest_education"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Email:</td>
      <td> <input type="text" name="email" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("email"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Decided_to_come:</td>
      <td> <select name="decided_to_come">
          <option value="Paper Article"  <%=(("Paper Article".toString().equals((((StudentRecordset_data = StudentRecordset.getObject("decided_to_come"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)))?"SELECTED":"")%>>Paper 
          Article</option>
          <option value="Advertisement: Sunday Observer"  <%=(("Advertisement: Sunday Observer".toString().equals((((StudentRecordset_data = StudentRecordset.getObject("decided_to_come"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)))?"SELECTED":"")%>>Advertisement: 
          Sunday Observer</option>
        </select> </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Introduce_by:</td>
      <td> <input type="text" name="introduce_by" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("introduce_by"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Intervied_by:</td>
      <td> <input type="text" name="intervied_by" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("intervied_by"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">&nbsp;</td>
      <td> <input type="submit" value="Update Record"> </td>
    </tr>
  </table>
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((StudentRecordset_data = StudentRecordset.getObject("id"))==null || StudentRecordset.wasNull())?"":StudentRecordset_data)%>">
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
StudentRecordset.close();
StatementStudentRecordset.close();
ConnStudentRecordset.close();
%>
