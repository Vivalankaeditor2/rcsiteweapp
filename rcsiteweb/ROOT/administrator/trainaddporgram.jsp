<%@page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/TrainingConnection.jsp"%>
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
String MM_editRedirectUrl = "trainaddporgramusertype.jsp";

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

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1"))
{

  MM_editDriver     = MM_TrainingConnection_DRIVER;
  MM_editConnection = MM_TrainingConnection_STRING;
  MM_editUserName   = MM_TrainingConnection_USERNAME;
  MM_editPassword   = MM_TrainingConnection_PASSWORD;
  MM_editTable  = "training_program";
  String MM_fieldsStr = "programname|value|description|value|restricted_description|value|published_date|value";
  String MM_columnsStr = "programname|',none,''|description|',none,''|restricted_description|',none,''|published_date|',none,NULL";

  // create the MM_fields and MM_columns arrays
  java.util.StringTokenizer tokens = new java.util.StringTokenizer(MM_fieldsStr,"|");
  MM_fields = new String[tokens.countTokens()];
  for (int i=0; tokens.hasMoreTokens(); i++)
  {
    MM_fields[i] = tokens.nextToken();
  }

  tokens = new java.util.StringTokenizer(MM_columnsStr,"|");
  MM_columns = new String[tokens.countTokens()];
  for (int i=0; tokens.hasMoreTokens(); i++) MM_columns[i] = tokens.nextToken();

  // set the form values
  for (int i=0; i+1 < MM_fields.length; i+=2)
  {
    MM_fields[i+1] = ((request.getParameter(MM_fields[i])!=null)?(String)request.getParameter(MM_fields[i]):"");
  }

}
%>
<%
// *** Insert Record: construct a sql insert statement and execute it

if (request.getParameter("MM_insert") != null)
{
   //Get all the Data to get ProgramId
    String Programname = "";
    String Description = "";
    String RestrictedDescription = "";
    String Publisheddate = "";

    if (request.getParameter("programname")!=null)
    {
        Programname = (String)request.getParameter("programname");
    }

    if (request.getParameter("description")!=null)
    {
        Description = (String)request.getParameter("description");
    }

    if (request.getParameter("restricted_description")!=null)
    {
        RestrictedDescription = (String)request.getParameter("restricted_description");
    }

    if (request.getParameter("published_date")!=null)
    {
        Publisheddate = (String)request.getParameter("published_date");
    }


  // create the insert sql statement
  StringBuffer MM_tableValues = new StringBuffer(), MM_dbValues = new StringBuffer();
  for (int i=0; i+1 < MM_fields.length; i+=2)
  {
    String formVal = MM_fields[i+1];
    String elem;
    java.util.StringTokenizer tokens = new java.util.StringTokenizer(MM_columns[i+1],",");
    String delim    = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    String altVal   = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    String emptyVal = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    if (formVal.length() == 0)
    {
      formVal = emptyVal;
    }
    else
    {
      if (altVal.length() != 0)
      {
        formVal = altVal;
      }
      else if (delim.compareTo("'") == 0)
      {  // escape quotes
        StringBuffer escQuotes = new StringBuffer(formVal);
        for (int j=0; j < escQuotes.length(); j++)
          if (escQuotes.charAt(j) == '\'') escQuotes.insert(j++,'\'');
            formVal = "'" + escQuotes + "'";
      }
      else
      {
        formVal = delim + formVal + delim;
      }
    }
    MM_tableValues.append((i!=0)?",":"").append(MM_columns[i]);
    MM_dbValues.append((i!=0)?",":"").append(formVal);
  }
  MM_editQuery = new StringBuffer("insert into " + MM_editTable);
  MM_editQuery.append(" (").append(MM_tableValues.toString()).append(") values (");
  MM_editQuery.append(MM_dbValues.toString()).append(")");

  if (!MM_abortEdit)
  {
    // finish the sql and execute it
    //Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
    //Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection = rcsiteDS.getConnection();
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(MM_editQuery.toString());
    MM_editStatement.executeUpdate();
    MM_connection.close();


    //Driver DriverProgramDetails = (Driver)Class.forName(MM_TrainingConnection_DRIVER).newInstance();
    //Connection ConnProgramDetails = DriverManager.getConnection(MM_TrainingConnection_STRING,MM_TrainingConnection_USERNAME,MM_TrainingConnection_PASSWORD);
    Connection ConnProgramDetails = rcsiteDS.getConnection();
	PreparedStatement StatementProgramDetails = ConnProgramDetails.prepareStatement("SELECT programid  FROM training_program  WHERE programname='"+Programname+
        "' AND description='"+ Description +"' AND restricted_description='"+RestrictedDescription+"' AND published_date='"+Publisheddate+"'");
    ResultSet ProgramDetails = StatementProgramDetails.executeQuery();
    boolean ProgramDetails_isEmpty = !ProgramDetails.next();
    boolean ProgramDetails_hasData = !ProgramDetails_isEmpty;
    Object ProgramDetails_data;
    int ProgramDetails_numRows = 0;

    int Programid = 0;
    if(( ProgramDetails.getObject("programid") !=null ) && ( !ProgramDetails.wasNull()))
    {
	    Programid = ProgramDetails.getInt("programid");
    }
    Integer Id = new Integer(Programid);
    session.setAttribute("programid",Id.toString());
    ProgramDetails.close();
    StatementProgramDetails.close();
    ConnProgramDetails.close();
    // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0)
    {
      response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl));
      return;
    }
  }
}
%>

<%

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
            <table class="text">
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td> <div align="left"><u><strong>Add a new Training program - 
                    Program Details</strong></u></div></td>
              </tr>
              <tr> 
                <td> <form method="post" action="<%=MM_editAction%>" name="form1">
                    <table width="616" height="304" align="center" class="text">
                      <tr valign="baseline"> 
                        <td align="left" nowrap>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr valign="baseline"> 
                        <td width="149" align="left"><strong>Program Name:</strong></td>
                        <td width="455"> <input type="text" name="programname" value="" size="48"> 
                        </td>
                      </tr>
                      <tr> 
                        <td height="119" align="left" valign="top"><strong>Program 
                          Description</strong>:</td>
                        <td valign="baseline"> <textarea name="description" cols="40" rows="5"></textarea> 
                        </td>
                      </tr>
                      <tr> 
                        <td height="117" align="left" valign="top"><strong>Restricted 
                          Description</strong>:</td>
                        <td valign="baseline"> <textarea name="restricted_description" cols="40" rows="5"></textarea> 
                        </td>
                      </tr>
                      <tr valign="baseline"> 
                        <td nowrap align="left">&nbsp;</td>
                        <td> <input name="submit" type="submit" value="Insert Training Program"></td>
                      </tr>
                    </table>
                    <%
  java.util.Date TempDate = new java.util.Date();
  java.sql.Date TodayDate = new java.sql.Date(TempDate.getTime());
%>
                    <input type="hidden" name="published_date" value="<%=TodayDate%>" size="32">
                    <input type="hidden" name="MM_insert" value="form1">
                  </form></td>
              </tr>
            </table>
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

%>
