<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
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
  MM_editTable  = "rc_category";
  MM_editColumn = "category_id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "addurl.jsp";
  String MM_fieldsStr = "description|value|aproval_status|value|submit_url|value|submit_name|value|submit_email|value|category_name|value";
  String MM_columnsStr = "description|',none,''|aproval_status|',none,''|submit_url|',none,''|submit_name|',none,''|submit_email|',none,''|category_name|',none,''";

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
String CategoryRecordset__MMColParam = "1";
if (request.getParameter("category_id") !=null) {CategoryRecordset__MMColParam = (String)request.getParameter("category_id");}
%>
<%
//Driver DriverCategoryRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCategoryRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCategoryRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCategoryRecordset = ConnCategoryRecordset.prepareStatement("SELECT * FROM rc_category WHERE category_id = " + CategoryRecordset__MMColParam + " ORDER BY category_name ASC");
ResultSet CategoryRecordset = StatementCategoryRecordset.executeQuery();
boolean CategoryRecordset_isEmpty = !CategoryRecordset.next();
boolean CategoryRecordset_hasData = !CategoryRecordset_isEmpty;
Object CategoryRecordset_data;
int CategoryRecordset_numRows = 0;
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


<script language="JavaScript" type="text/JavaScript">
<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' must contain an e-mail address.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' is required.\n'; }
  } if (errors) alert('The following error(s) occurred:\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>
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
            <jsp:include page="adminleftnavi.jsp?screen=directory" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form action="<%=MM_editAction%>" method="post" name="form1" onSubmit="MM_validateForm('submit_email','','NisEmail');return document.MM_returnValue">
              <table align="center" class="text">
                <tr valign="baseline">
                  <td align="right" nowrap class="title">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Last 
                      update:</div></td>
                  <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("entry_date"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Category 
                      name:</div></td>
                  <td><input type="text" name="category_name" value="<%=(((CategoryRecordset_data = CategoryRecordset.getObject("category_name"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>" size="32"></td>
                </tr>
                <tr> 
                  <td align="right" valign="top" nowrap class="title"><div align="left">Description:</div></td>
                  <td valign="baseline"> <textarea name="description" cols="50" rows="5"><%=(((CategoryRecordset_data = CategoryRecordset.getObject("description"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Aproval 
                      status:</div></td>
                  <td> <select name="aproval_status">
                      <option value="Approved"  <%=(("Approved".toString().equals((((CategoryRecordset_data = CategoryRecordset.getObject("aproval_status"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)))?"SELECTED":"")%>>Approved</option>
                      <option value="Pending"  <%=(("Pending".toString().equals((((CategoryRecordset_data = CategoryRecordset.getObject("aproval_status"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)))?"SELECTED":"")%>>Pending</option>
                      <option value="Rejected"  <%=(("Rejected".toString().equals((((CategoryRecordset_data = CategoryRecordset.getObject("aproval_status"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)))?"SELECTED":"")%>>Rejected</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Submit 
                      url:</div></td>
                  <td> <input type="text" name="submit_url" value="<%=(((CategoryRecordset_data = CategoryRecordset.getObject("submit_url"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Submit 
                      name:</div></td>
                  <td> <input type="text" name="submit_name" value="<%=(((CategoryRecordset_data = CategoryRecordset.getObject("submit_name"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Submit 
                      email:</div></td>
                  <td> <input type="text" name="submit_email" value="<%=(((CategoryRecordset_data = CategoryRecordset.getObject("submit_email"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left"></div></td>
                  <td> <input type="submit" value="Update Record"> </td>
                </tr>
              </table>
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((CategoryRecordset_data = CategoryRecordset.getObject("category_id"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>">
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
CategoryRecordset.close();
StatementCategoryRecordset.close();
ConnCategoryRecordset.close();
%>
