<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String pageMessage="";
boolean added =false;
String to_email="";
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
  MM_editTable  = "rc_customer";
  MM_editRedirectUrl = "";
  String MM_fieldsStr = "username|value|pword|value|customer|value|age|value|gender|value|email|value|address|value|height_feet|value|height_inches|value|starting_weight|value|goal_weight|value|goal_date_value|value|goal_date_name|value|start_size|value|goal_size|value|high_bp|value|heart_conditions|value|food_allergies|value|other_medical|value|nursing|value|happy_energy|value|appetite_problem|value|water_glasses|value|favorite_foods|value|drink_coffee|value|drink_soda|value|drink_alcohol|value|smoking|value|type|value|consultant|value";
  String MM_columnsStr = "username|',none,''|pword|',none,''|customer|',none,''|age|none,none,NULL|gender|',none,''|email|',none,''|address|',none,''|height_feet|none,none,NULL|height_inches|none,none,NULL|starting_weight|none,none,NULL|goal_weight|none,none,NULL|goal_date_value|none,none,NULL|goal_date_name|',none,''|start_size|none,none,NULL|goal_size|none,none,NULL|high_bp|',none,''|heart_conditions|',none,''|food_allergies|',none,''|other_medical|',none,''|nursing|',none,''|happy_energy|',none,''|appetite_problem|',none,''|water_glasses|none,none,NULL|favorite_foods|',none,''|drink_coffee|',none,''|drink_soda|',none,''|drink_alcohol|',none,''|smoking|',none,''|type|',none,''|consultant|',none,''";

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
  to_email = MM_fields[11];
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
  try{
    MM_editStatement.executeUpdate();
	pageMessage="New member has been successfully added.";
	added=true;
	}catch(Exception ex)
		{
		pageMessage="Error: This user name and/or customer name may be in use. Check member list.";
		
	}finally{
    MM_connection.close();
		}

    // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0) {
      response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl));
      return;
    }
  }
}
%>
<%
//Driver DriverTypeRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnTypeRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnTypeRecordset = rcsiteDS.getConnection();
PreparedStatement StatementTypeRecordset = ConnTypeRecordset.prepareStatement("SELECT * FROM usertype");
ResultSet TypeRecordset = StatementTypeRecordset.executeQuery();
boolean TypeRecordset_isEmpty = !TypeRecordset.next();
boolean TypeRecordset_hasData = !TypeRecordset_isEmpty;
Object TypeRecordset_data;
int TypeRecordset_numRows = 0;
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->
<link href="../css/styles.css" rel="stylesheet" type="text/css">
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
            <jsp:include page="adminleftnavi.jsp?screen=advertising" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
              <tr> 
                <td width="10%">&nbsp;</td>
                <td width="84%">&nbsp;</td>
                <td width="6%">&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><strong>Add A Member</strong></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
                <td>&nbsp;</td>
              </tr>
              <%
  if(added){
  %>
              <tr> 
                <td>&nbsp;</td>
                <td>Send an email to: <a href="emailselector.jsp?singleaddress=<%=to_email%>"><%=to_email%></a> </td>
                <td>&nbsp;</td>
              </tr>
              <%
  }
  %>
            </table>

<form action="<%=MM_editAction%>" method="post" name="form1" onSubmit="MM_validateForm('username','','R','customer','','R','email','','NisEmail','pword','','R');return document.MM_returnValue">
              <table align="center" class="text">
                <tr valign="baseline"> 
                  <td width="64" align="left" nowrap><strong>Username:</strong></td>
                  <td width="215"> <input name="username" type="text" value="" size="20" maxlength="18"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Password:</strong></td>
                  <td> <input name="pword" type="password" value="" size="20" maxlength="18"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Customer Name:</strong></td>
                  <td> <input type="text" name="customer" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Email:</strong></td>
                  <td> <input type="text" name="email" value="" size="32"> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left"><strong>Member Type:</strong></td>
                  <td> <select name="type">
                      <%
while (TypeRecordset_hasData) {
%>
                      <option value="<%=((TypeRecordset.getObject("usertypename")!=null)?TypeRecordset.getObject("usertypename"):"")%>" <%=(((TypeRecordset.getObject("usertypename")).toString().equals(((((TypeRecordset_data = TypeRecordset.getObject("usertypename"))==null || TypeRecordset.wasNull())?"":TypeRecordset_data)).toString()))?"SELECTED":"")%> ><%=((TypeRecordset.getObject("usertypename")!=null)?TypeRecordset.getObject("usertypename"):"")%></option>
                      <%
  TypeRecordset_hasData = TypeRecordset.next();
}
TypeRecordset.close();
TypeRecordset = StatementTypeRecordset.executeQuery();
TypeRecordset_hasData = TypeRecordset.next();
TypeRecordset_isEmpty = !TypeRecordset_hasData;
%>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td> <input type="submit" value="Insert Record"> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td> <input type="hidden" name="age" value="" size="32"> <input type="hidden" name="gender" value="" size="32"> 
                    <input type="hidden" name="address" value="" size="32"> <input type="hidden" name="height_feet" value="" size="32"> 
                    <input type="hidden" name="height_inches" value="" size="32"> 
                    <input type="hidden" name="starting_weight" value="" size="32"> 
                    <input type="hidden" name="goal_weight" value="" size="32"> 
                    <input type="hidden" name="goal_date_value" value="" size="32"></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td><input type="hidden" name="goal_date_name" value="" size="32"> 
                    <input type="hidden" name="start_size" value="" size="32"> 
                    <input type="hidden" name="goal_size" value="" size="32"> 
                    <input type="hidden" name="high_bp" value="" size="32"> <input type="hidden" name="heart_conditions" value="" size="32"> 
                    <input type="hidden" name="food_allergies" value="" size="32"> 
                    <input type="hidden" name="other_medical" value="" size="32"> 
                    <input type="hidden" name="nursing" value="" size="32"></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td><input type="hidden" name="happy_energy" value="" size="32"> 
                    <input type="hidden" name="appetite_problem" value="" size="32"> 
                    <input type="hidden" name="water_glasses" value="" size="32"> 
                    <input type="hidden" name="favorite_foods" value="" size="32"> 
                    <input type="hidden" name="drink_coffee" value="" size="32"> 
                    <input type="hidden" name="smoking" value="" size="32"> <input type="hidden" name="drink_soda" value="" size="32"> 
                    <input type="hidden" name="drink_alcohol" value="" size="32">
					 <input type="hidden" name="consultant" value="<%=(String)session.getValue("dcode")%>" size="32"></td>
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
TypeRecordset.close();
StatementTypeRecordset.close();
ConnTypeRecordset.close();
%>
