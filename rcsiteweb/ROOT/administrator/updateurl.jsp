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
  MM_editTable  = "directory";
  MM_editColumn = "link_id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "index.jsp";
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
String UpdateUlRecordset__MMColParam = "1";
if (request.getParameter("link_id")  !=null) {UpdateUlRecordset__MMColParam = (String)request.getParameter("link_id") ;}
%>
<%
//Driver DriverUpdateUlRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnUpdateUlRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnUpdateUlRecordset = rcsiteDS.getConnection();
PreparedStatement StatementUpdateUlRecordset = ConnUpdateUlRecordset.prepareStatement("SELECT *  FROM directory  WHERE link_id = " + UpdateUlRecordset__MMColParam + "");
ResultSet UpdateUlRecordset = StatementUpdateUlRecordset.executeQuery();
boolean UpdateUlRecordset_isEmpty = !UpdateUlRecordset.next();
boolean UpdateUlRecordset_hasData = !UpdateUlRecordset_isEmpty;
Object UpdateUlRecordset_data;
int UpdateUlRecordset_numRows = 0;
%>
<%
//Driver DriverRecordset1 = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnRecordset1 = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnRecordset1 = rcsiteDS.getConnection();
PreparedStatement StatementRecordset1 = ConnRecordset1.prepareStatement("SELECT * FROM rc_category ORDER BY category_name ASC");
ResultSet Recordset1 = StatementRecordset1.executeQuery();
boolean Recordset1_isEmpty = !Recordset1.next();
boolean Recordset1_hasData = !Recordset1_isEmpty;
Object Recordset1_data;
int Recordset1_numRows = 0;
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
<form action="<%=MM_editAction%>" method="post" name="form1" onSubmit="MM_validateForm('title','','R','url','','R','owner_email','','NisEmail');return document.MM_returnValue">
              <table align="center" class="text">
                <tr valign="baseline">
                  <td align="right" nowrap class="title">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td width="99" align="right" nowrap class="title"><div align="left">Last 
                      up date:</div></td>
                  <td width="315"><%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("entry_date"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Title:</div></td>
                  <td> <input name="title" type="text" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("title"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>" size="50" maxlength="90"> 
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="top" nowrap class="title"><div align="left">Description:</div></td>
                  <td valign="baseline"> <textarea name="description" cols="50" rows="5"><%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("description"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">URL 
                      :</div></td>
                  <td> http:// 
                    <input name="url" type="text" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("url"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>" size="50" maxlength="180"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Index:</div></td>
                  <td> <select name="category1">
                      <option value="0-9"  <%=(("0-9".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>0-9</option>
                      <option value="A"  <%=(("A".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>A</option>
                      <option value="B"  <%=(("B".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>B</option>
                      <option value="C"  <%=(("C".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>C</option>
                      <option value="D"  <%=(("D".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>D</option>
                      <option value="E" <%=(("E".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>E</option>
                      <option value="F" <%=(("F".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>F</option>
                      <option value="G" <%=(("G".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>G</option>
                      <option value="H" <%=(("H".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>H</option>
                      <option value="I" <%=(("I".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>I</option>
                      <option value="J" <%=(("J".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>J</option>
                      <option value="K" <%=(("K".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>K</option>
                      <option value="L" <%=(("L".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>L</option>
                      <option value="M" <%=(("M".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>M</option>
                      <option value="N" <%=(("N".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>N</option>
                      <option value="O" <%=(("O".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>O</option>
                      <option value="P" <%=(("P".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>P</option>
                      <option value="Q" <%=(("Q".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>Q</option>
                      <option value="R" <%=(("R".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>R</option>
                      <option value="S" <%=(("S".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>S</option>
                      <option value="T" <%=(("T".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>T</option>
                      <option value="U" <%=(("U".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>U</option>
                      <option value="V" <%=(("V".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>V</option>
                      <option value="W" <%=(("W".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>W</option>
                      <option value="X" <%=(("X".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>X</option>
                      <option value="Y" <%=(("Y".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>Y</option>
                      <option value="Z" <%=(("Z".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>Z</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Category:</div></td>
                  <td> <select name="category2">
                      <%
while (Recordset1_hasData) {
%>
                      <option value="<%=((Recordset1.getObject("category_id")!=null)?Recordset1.getObject("category_id"):"")%>" <%=(((Recordset1.getObject("category_id")).toString().equals(((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("category2"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)).toString()))?"SELECTED":"")%> ><%=((Recordset1.getObject("category_name")!=null)?Recordset1.getObject("category_name"):"")%></option>
                      <%
  Recordset1_hasData = Recordset1.next();
}
Recordset1.close();
Recordset1 = StatementRecordset1.executeQuery();
Recordset1_hasData = Recordset1.next();
Recordset1_isEmpty = !Recordset1_hasData;
%>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Aproval 
                      status:</div></td>
                  <td> <select name="aproval_status">
                      <option value="Approved"  <%=(("Approved".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("aproval_status"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>Approved</option>
                      <option value="Pending"  <%=(("Pending".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("aproval_status"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>Pending</option>
                      <option value="Rejected"  <%=(("Rejected".toString().equals((((UpdateUlRecordset_data = UpdateUlRecordset.getObject("aproval_status"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)))?"SELECTED":"")%>>Rejected</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Reciprocal 
                      URL</div></td>
                  <td> http:// 
                    <input name="reciprocal_url" type="text" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("reciprocal_url"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>" size="50" maxlength="180"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Owner 
                      Name:</div></td>
                  <td> <input name="owner_name" type="text" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("owner_name"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>" size="32" maxlength="40"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Owner 
                      Email:</div></td>
                  <td> <input name="owner_email" type="text" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("owner_email"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>" size="32" maxlength="40"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Address1:</div></td>
                  <td> <input name="address1" type="text" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("address1"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>" size="50" maxlength="90"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Address2:</div></td>
                  <td> <input name="address2" type="text" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("address2"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>" size="50" maxlength="90"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Phone:</div></td>
                  <td> <input name="phone" type="text" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("phone"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>" size="32" maxlength="15"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left"></div></td>
                  <td> <input type="submit" value="Update Record"> </td>
                </tr>
              </table>
			  <input type="hidden" name="dcode" value="<%=(String)session.getValue("dcode")%>">
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((UpdateUlRecordset_data = UpdateUlRecordset.getObject("link_id"))==null || UpdateUlRecordset.wasNull())?"":UpdateUlRecordset_data)%>">
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
UpdateUlRecordset.close();
StatementUpdateUlRecordset.close();
ConnUpdateUlRecordset.close();
%>
<%
Recordset1.close();
StatementRecordset1.close();
ConnRecordset1.close();
%>
