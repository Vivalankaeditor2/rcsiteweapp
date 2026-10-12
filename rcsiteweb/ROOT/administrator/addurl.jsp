<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String pageMessage = "";
if (request.getParameter("pagemessage") !=null) {pageMessage = (String)request.getParameter("pagemessage");}

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

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "directory";
  MM_editRedirectUrl = "addurl.jsp";
  String MM_fieldsStr = "title|value|description|value|url|value|category1|value|category2|value|aproval_status|value|reciprocal_url|value|owner_name|value|owner_email|value|address1|value|address2|value|phone|value|dcode|value";
  String MM_columnsStr = "title|',none,''|description|',none,''|url|',none,''|category1|',none,''|category2|',none,''|aproval_status|',none,''|reciprocal_url|',none,''|owner_name|',none,''|owner_email|',none,''|address1|',none,''|address2|',none,''|phone|',none,''|dcode|',none,''";

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
    //Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
   // Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
   Connection MM_connection  = rcsiteDS.getConnection();
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(MM_editQuery.toString());
    try{
	MM_editStatement.executeUpdate();
	pageMessage="URL has been successfully inserted.";
	}catch(Exception e)
		{
%>
			<jsp:forward page="errorpage.jsp" />
<%
			System.out.print("exception");
		  out.print("___________Duplicate entry______________");
		}
    MM_connection.close();

    // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0) {
      response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl)+"?pagemessage="+pageMessage);
      return;
    }
  }
}
%>
<%
//Driver DriverCategoryRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCategoryRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCategoryRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCategoryRecordset = ConnCategoryRecordset.prepareStatement("SELECT * FROM rc_category ORDER BY category_name ASC");
ResultSet CategoryRecordset = StatementCategoryRecordset.executeQuery();
boolean CategoryRecordset_isEmpty = !CategoryRecordset.next();
boolean CategoryRecordset_hasData = !CategoryRecordset_isEmpty;
Object CategoryRecordset_data;
int CategoryRecordset_numRows = 0;
%>

<%@ include file="../custom/config.jsp" %>
<html lang="en" ><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
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
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --><jsp:include page="adminleftnavi.jsp?screen=directory" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form action="<%=MM_editAction%>" method="post" name="form1" onSubmit="MM_validateForm('title','','R','url','','R','owner_email','','NisEmail');return document.MM_returnValue">
              <table align="center" class="text">
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr align="left" valign="baseline"> 
                  <td colspan="2" nowrap class="text"><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
                </tr>
                <tr align="left" valign="baseline"> 
                  <td colspan="2" nowrap class="text"><strong>Add new URL</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td width="105" align="right" nowrap class="title">Title:</td>
                  <td width="311"> <input name="title" type="text" value="" size="50" maxlength="80"> 
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="top" nowrap class="title">Description:</td>
                  <td valign="baseline"> <textarea name="description" cols="50" rows="2"></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">URL:</td>
                  <td> http:// 
                    <input name="url" type="text" size="50" maxlength="100"> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Index:</td>
                  <td> <select name="category1">
                      <option value="0-9">0-9</option>
                      <option value="A">A</option>
                      <option value="B">B</option>
                      <option value="C">C</option>
                      <option value="D">D</option>
                      <option value="E">E</option>
                      <option value="F">F</option>
                      <option value="G">G</option>
                      <option value="H">H</option>
                      <option value="I">I</option>
                      <option value="J">J</option>
                      <option value="K">K</option>
                      <option value="L">L</option>
                      <option value="M">M</option>
                      <option value="N">N</option>
                      <option value="O">O</option>
                      <option value="P">P</option>
                      <option value="Q">Q</option>
                      <option value="R">R</option>
                      <option value="S">S</option>
                      <option value="T">T</option>
                      <option value="U">U</option>
                      <option value="V">V</option>
                      <option value="W">W</option>
                      <option value="X">X</option>
                      <option value="Y">Y</option>
                      <option value="Z">Z</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Category:</td>
                  <td> <select name="category2">
                      <%
while (CategoryRecordset_hasData) {
%>
                      <option value="<%=((CategoryRecordset.getObject("category_id")!=null)?CategoryRecordset.getObject("category_id"):"")%>"><%=((CategoryRecordset.getObject("category_name")!=null)?CategoryRecordset.getObject("category_name"):"")%></option>
                      <%
  CategoryRecordset_hasData = CategoryRecordset.next();
}
CategoryRecordset.close();
CategoryRecordset = StatementCategoryRecordset.executeQuery();
CategoryRecordset_hasData = CategoryRecordset.next();
CategoryRecordset_isEmpty = !CategoryRecordset_hasData;
%>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Aproval Status:</td>
                  <td> <select name="aproval_status">
                      <option value="Approved"  selected>Approved</option>
                      <option value="Pending" >Pending</option>
                      <option value="Rejected" >Rejected</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Reciprocal URL:</td>
                  <td> http:// 
                    <input name="reciprocal_url" type="text" size="50" maxlength="100"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Owner name:</td>
                  <td> <input name="owner_name" type="text" value="" size="32" maxlength="40"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Owner email:</td>
                  <td> <input name="owner_email" type="text" value="" size="32" maxlength="40"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Address1:</td>
                  <td> <input name="address1" type="text" size="50" maxlength="90"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Address2:</td>
                  <td> <input name="address2" type="text" size="50" maxlength="90"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title">Phone:</td>
                  <td> <input name="phone" type="text" size="32" maxlength="15"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><input name="dcode" type="hidden" id="dcode" value="<%=(String)session.getValue("dcode")%>"></td>
                  <td> <input type="submit" value="Insert URL"> </td>
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
CategoryRecordset.close();
StatementCategoryRecordset.close();
ConnCategoryRecordset.close();
%>
