<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*, java.io.*" errorPage="" %>
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
  MM_editTable  = "email";
  MM_editColumn = "emailid";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "emaildetails.jsp";
  String MM_fieldsStr = "emailid|value|entered_date|value|from_name|value|from_email|value|to_name|value|to_email|value|subject|value|type|value|attachment|value|message|value|description|value|folder|value";
  String MM_columnsStr = "emailid|none,none,NULL|entered_date|',none,NULL|from_name|',none,''|from_email|',none,''|to_name|',none,''|to_email|',none,''|subject|',none,''|type|',none,''|attachment|',none,''|message|',none,''|description|',none,''|folder|',none,''";

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
String EmailRecordset__MMColParam = "1";
if (request.getParameter("emailid") !=null) {EmailRecordset__MMColParam = (String)request.getParameter("emailid");}
%>
<%
//Driver DriverEmailRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnEmailRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnEmailRecordset = rcsiteDS.getConnection();
PreparedStatement StatementEmailRecordset = ConnEmailRecordset.prepareStatement("SELECT * FROM email WHERE emailid = " + EmailRecordset__MMColParam + " ORDER BY entered_date DESC");
ResultSet EmailRecordset = StatementEmailRecordset.executeQuery();
/*
String emailBody = "";
    ByteArrayOutputStream ByteoutDetails = new ByteArrayOutputStream(1024);
 while(EmailRecordset.next())
{
    try
    {
        BufferedInputStream ByteinDetails = new BufferedInputStream( EmailRecordset.getBinaryStream("message") );
        byte ByteIndata[]= new byte[100000] ;
        int Bytesread = 0;
        // Make sure its not a NULL value in the column:
        if ( !EmailRecordset.wasNull() )
        {
            if ( (Bytesread = ByteinDetails.read(ByteIndata,0,ByteIndata.length)) != -1 )
            {
                // Write out 'bytesread' bytes to the writer instance:
                ByteoutDetails.write(ByteIndata,0,Bytesread);
                emailBody = ByteoutDetails.toString();
            }
            else
            {
                // When the read() method returns -1 we've hit the end of the stream,
                // so now we can get our bytes out of the writer object:
                //allBytesInBlob = baos.getBytes();
                emailBody = ByteoutDetails.toString();
            }
        }
    }
    catch(Exception ex)
    {
        // The driver could not handle this as a BLOB...
        // Fallback to default (and slower) byte[] handling
        // byte[] bytes = Recordset1.getBytes(1);
        emailBody = " Error - Please try latter." ;
    }
}
*/
boolean EmailRecordset_isEmpty = !EmailRecordset.next();
boolean EmailRecordset_hasData = !EmailRecordset_isEmpty;
Object EmailRecordset_data;
int EmailRecordset_numRows = 0;

//EmailRecordset.close();
//EmailRecordset = StatementEmailRecordset.executeQuery();
//EmailRecordset_hasData = EmailRecordset.next();
//EmailRecordset_isEmpty = !EmailRecordset_hasData;
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript" src="../jscripts/fulleditor.js"></script>
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
            <jsp:include page="adminleftnavi.jsp?screen=email" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table align="center" class="text">
                
                <tr valign="baseline">
                  <td align="right" nowrap class="title">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"> <div align="left">From:</div></td>
                  <td><%=(((EmailRecordset_data = EmailRecordset.getObject("from_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"> <div align="left">To:</div></td>
                  <td> <%=(((EmailRecordset_data = EmailRecordset.getObject("to_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"> <div align="left">Subject:</div></td>
                  <td> <input type="text" name="subject" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("subject"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"><div align="left">Message:</div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td colspan="2" align="right" nowrap class="title">  
                      <textarea name="message" id="message" cols="70" rows="30" mce_editable="true"><%=(((EmailRecordset_data = EmailRecordset.getObject("message"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></textarea>
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" valign="top" nowrap class="title"> <div align="left">Description:</div></td>
                  <td> <textarea name="description" cols="32" rows="3"><%=(((EmailRecordset_data = EmailRecordset.getObject("description"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"> <div align="left">Type:</div></td>
                  <td> <%=(((EmailRecordset_data = EmailRecordset.getObject("type"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"> <div align="left">Folder:</div></td>
                  <td> <%=(((EmailRecordset_data = EmailRecordset.getObject("folder"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap class="title"> <div align="left"></div></td>
                  <td> <input type="submit" value="Update Record" > </td>
                </tr>
              </table>
 
              	<input name="from_email" type="hidden" id="from_email" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("from_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">
              	<input name="to_name" type="hidden" id="to_name" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("to_name"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">
              	<input name="to_email" type="hidden" id="to_email" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("to_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">
              	<input name="type" type="hidden" id="type" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("type"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">
			  	<input name="attachment" type="hidden" id="attachment" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("attachment"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">
			  	<input name="folder" type="hidden" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("folder"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">
			  	<input name="from_name" type="hidden" id="from_name" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("from_name"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">
  				<input type="hidden" name="emailid" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("emailid"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>" size="32">
  				<input type="hidden" name="entered_date" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("entered_date"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>" size="32">
  				<input type="hidden" name="MM_update" value="form1">
 				<input type="hidden" name="MM_recordId" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("emailid"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>">

</form>

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
EmailRecordset.close();
StatementEmailRecordset.close();
ConnEmailRecordset.close();
%>
