<%@page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/TrainingConnection.jsp" %>
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
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {

  MM_editDriver     = MM_TrainingConnection_DRIVER;
  MM_editConnection = MM_TrainingConnection_STRING;
  MM_editUserName   = MM_TrainingConnection_USERNAME;
  MM_editPassword   = MM_TrainingConnection_PASSWORD;
  MM_editTable  = "media_file";
  MM_editRedirectUrl = "traininsertedsuccessfully.jsp";
  String MM_fieldsStr = "programid|value|filename|value|published_date|value|actual_url|value|display_url|value|file_type|value|description|value";
  String MM_columnsStr = "programid|none,none,NULL|filename|',none,''|published_date|',none,NULL|actual_url|',none,''|display_url|',none,''|file_type|',none,''|description|',none,''";

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
//Driver DriverProgramDetails = (Driver)Class.forName(MM_TrainingConnection_DRIVER).newInstance();
//Connection ConnProgramDetails = DriverManager.getConnection(MM_TrainingConnection_STRING,MM_TrainingConnection_USERNAME,MM_TrainingConnection_PASSWORD);
Driver DriverProgramDetails = (Driver)Class.forName(MM_TrainingConnection_DRIVER).newInstance();
Connection ConnProgramDetails = rcsiteDS.getConnection();
PreparedStatement StatementProgramDetails = ConnProgramDetails.prepareStatement("SELECT programid, programname  FROM training_program");
ResultSet ProgramDetails = StatementProgramDetails.executeQuery();
boolean ProgramDetails_isEmpty = !ProgramDetails.next();
boolean ProgramDetails_hasData = !ProgramDetails_isEmpty;
Object ProgramDetails_data;
int ProgramDetails_numRows = 0;
%>
<%
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int ProgramDetails_first = 1;
int ProgramDetails_last  = 1;
int ProgramDetails_total = -1;

if (ProgramDetails_isEmpty) {
  ProgramDetails_total = ProgramDetails_first = ProgramDetails_last = 0;
}

//set the number of rows displayed on this page
if (ProgramDetails_numRows == 0) {
  ProgramDetails_numRows = 1;
}
%>

<%
// *** Recordset Stats: if we don't know the record count, manually count them

if (ProgramDetails_total == -1) {

  // count the total records by iterating through the recordset
    for (ProgramDetails_total = 1; ProgramDetails.next(); ProgramDetails_total++);

  // reset the cursor to the beginning
  ProgramDetails.close();
  ProgramDetails = StatementProgramDetails.executeQuery();
  ProgramDetails_hasData = ProgramDetails.next();

  // set the number of rows displayed on this page
  if (ProgramDetails_numRows < 0 || ProgramDetails_numRows > ProgramDetails_total) {
    ProgramDetails_numRows = ProgramDetails_total;
  }

  // set the first and last displayed record
  ProgramDetails_first = Math.min(ProgramDetails_first, ProgramDetails_total);
  ProgramDetails_last  = Math.min(ProgramDetails_first + ProgramDetails_numRows - 1, ProgramDetails_total);
}
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
function MM_popupMsg(msg) { //v1.0
  alert(msg);
}

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
            <jsp:include page="adminleftnavi.jsp?screen=rcmerchant" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
            <table width="75%" border="0" class="text">
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td> <strong>Add a new Training File.</strong></td>
              </tr>
              <tr> 
                <td height="64"> <form action="<%=MM_editAction%>" method="post" name="mediafile" id="mediafile" onSubmit="MM_validateForm('filename','','R','actual_url','','R','display_url','','R','description','','R');return document.MM_returnValue">
                    <table align="center" class="text">
                      <tr valign="baseline"> 
                        <td align="left" nowrap>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr valign="baseline"> 
                        <td width="118" align="left" nowrap><strong><font face="Tahoma">Program 
                          Name:</font></strong></td>
                        <td width="413"> <strong><font size="2" face="Tahoma"> 
                          <select name="programid">
                            <option selected>---- Select a Training Program----</option>
                            <%
String ProgramName = "";
int ProgramId = 0;
for (int i = 0; i < ProgramDetails_total; i++)
{

    if(( ProgramDetails.getObject("programid") !=null ) && ( !ProgramDetails.wasNull() ))
    {
        ProgramId = ProgramDetails.getInt("programid");
    }
    if(( ProgramDetails.getObject("programname") !=null ) && ( !ProgramDetails.wasNull() ))
    {
        ProgramName = (String)ProgramDetails.getObject("programname");
    }
%>
                            <option value= "<%=ProgramId%>"><%=ProgramName%></option>
                            <%
    ProgramDetails.next();
}
%>
                          </select>
                          </font></strong></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left"><strong><font face="Tahoma">File 
                          Name:</font></strong></td>
                        <td> <input type="text" name="filename" value="" size="40"> 
                        </td>
                      </tr>
                      <%
  java.util.Date TempDate = new java.util.Date();
  java.sql.Date TodayDate = new java.sql.Date(TempDate.getTime());
 %>
                      <input type="hidden" name="published_date" value="<%=TodayDate%>" size="40">
                      <tr valign="baseline"> 
                        <td nowrap align="left"><strong><font face="Tahoma">Actual 
                          url:</font></strong></td>
                        <td> <input type="text" name="actual_url" value="" size="40"> 
                        </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left"><strong><font face="Tahoma">Display 
                          url:</font></strong></td>
                        <td> <input type="text" name="display_url" value="" size="40"></td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left"><strong><font face="Tahoma">File 
                          Type:</font></strong></td>
                        <td> <select name="file_type">
                            <option selected>VIDEO</option>
                            <option>AUDIO</option>
                            <option>DOCUMENT</option>
                          </select></td>
                      </tr>
                      <tr> 
                        <td nowrap align="left" valign="top"><strong><font face="Tahoma">Description:</font></strong></td>
                        <td valign="baseline"> <textarea name="description" cols="40" rows="5"></textarea> 
                        </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td height="26" align="right" nowrap>&nbsp;</td>
                        <td> <input type="submit" value="Insert New File" onbeforeupdate="MM_popupMsg('Select a valid Training Program')"> 
                        </td>
                      </tr>
                    </table>
                    <input type="hidden" name="MM_insert" value="form1">
                  </form>
                  <p>&nbsp;</p></td>
              </tr>
            </table>
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
ProgramDetails.close();
StatementProgramDetails.close();
ConnProgramDetails.close();
%>
