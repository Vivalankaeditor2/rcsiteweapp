<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String pageMessage="";
if (request.getParameter("pagemessage") !=null) {
pageMessage = (String)request.getParameter("pagemessage");
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
// *** Update Record: set variables

if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_update").toString().equals("form1") &&
    request.getParameter("MM_recordId") != null) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "article_category";
  MM_editColumn = "categoryid";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "index.jsp";
  String MM_fieldsStr = "parentid|value|category_name|value|title|value|description|value|level|value|priority|value|active|value";
  String MM_columnsStr = "parentid|none,none,NULL|category_name|',none,''|title|',none,''|description|',none,''|level|',none,''|priority|none,none,NULL|active|',none,''";

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
   // Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
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
String CatUpdateRecordset__MMColParam = "1";
int previousOne =1;
int nextOne =3;
if (request.getParameter("categoryid") !=null) {CatUpdateRecordset__MMColParam = (String)request.getParameter("categoryid");
previousOne =Integer.parseInt(CatUpdateRecordset__MMColParam) -1;
nextOne = Integer.parseInt(CatUpdateRecordset__MMColParam) +1;
}

%>
<%
//Driver DriverCatUpdateRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCatUpdateRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCatUpdateRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCatUpdateRecordset = ConnCatUpdateRecordset.prepareStatement("SELECT * FROM article_category WHERE categoryid = " + CatUpdateRecordset__MMColParam + " ORDER BY parentid ASC");
ResultSet CatUpdateRecordset = StatementCatUpdateRecordset.executeQuery();
boolean CatUpdateRecordset_isEmpty = !CatUpdateRecordset.next();
boolean CatUpdateRecordset_hasData = !CatUpdateRecordset_isEmpty;
Object CatUpdateRecordset_data;
int CatUpdateRecordset_numRows = 0;
%>
<%
String ParentRecordset__MMColParam = "main";
if (request.getParameter("level") !=null) {ParentRecordset__MMColParam = (String)request.getParameter("level");}
%>
<%
//Driver DriverParentRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnParentRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnParentRecordset = rcsiteDS.getConnection();
PreparedStatement StatementParentRecordset = ConnParentRecordset.prepareStatement("SELECT categoryid, category_name FROM article_category WHERE level = '" + ParentRecordset__MMColParam + "' ORDER BY priority ASC");
ResultSet ParentRecordset = StatementParentRecordset.executeQuery();
boolean ParentRecordset_isEmpty = !ParentRecordset.next();
boolean ParentRecordset_hasData = !ParentRecordset_isEmpty;
Object ParentRecordset_data;
int ParentRecordset_numRows = 0;
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
              <jsp:include page="adminleftnavi.jsp?screen=article" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table align="center" class="text">
                <tr valign="baseline"> 
                  <td colspan="2" align="left" nowrap><a href="/administrator/articleupdatecategory.jsp?categoryid=<%=previousOne%> "><< Previous</a> ||<%=CatUpdateRecordset__MMColParam%> || <a href="/administrator/articleupdatecategory.jsp?categoryid=<%=nextOne%> ">Next >></a> <font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
                </tr>
                <tr valign="baseline"> 
                  <td colspan="2" align="left" nowrap><strong>Update Article category</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap><strong>Parent category:</strong></td>
                  <td> <select name="parentid">
                      <%
while (ParentRecordset_hasData) {
%>
                      <option value="<%=((ParentRecordset.getObject("categoryid")!=null)?ParentRecordset.getObject("categoryid"):"")%>" <%=(((ParentRecordset.getObject("categoryid")).toString().equals(((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("parentid"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)).toString()))?"SELECTED":"")%> ><%=((ParentRecordset.getObject("category_name")!=null)?ParentRecordset.getObject("category_name"):"")%></option>
                      <%
  ParentRecordset_hasData = ParentRecordset.next();
}
ParentRecordset.close();
ParentRecordset = StatementParentRecordset.executeQuery();
ParentRecordset_hasData = ParentRecordset.next();
ParentRecordset_isEmpty = !ParentRecordset_hasData;
%>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap><strong>Category name:</strong></td>
                  <td> <input name="category_name" type="text" value="<%=(((CatUpdateRecordset_data = CatUpdateRecordset.getObject("category_name"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)%>" size="23" maxlength="22">
                    (max 22 characters) </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap><strong>Title:</strong></td>
                  <td> <input type="text" name="title" value="<%=(((CatUpdateRecordset_data = CatUpdateRecordset.getObject("title"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr> 
                  <td align="left" valign="top" nowrap><p><strong>Description:</strong></p>
                    <p>(max 240 characters)</p></td>
                  <td valign="baseline"> <textarea name="description" cols="50" rows="5"><%=(((CatUpdateRecordset_data = CatUpdateRecordset.getObject("description"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)%></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap><strong>Level:</strong></td>
                  <td> <select name="level">
                      <option value="category"  <%=(("category".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("level"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>Category</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap><strong>Priority:</strong></td>
                  <td> <select name="priority">
                      <option value="1"  <%=(("1".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>1</option>
                      <option value="2"  <%=(("2".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>2</option>
                      <option value="3"  <%=(("3".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>3</option>
                      <option value="4"  <%=(("4".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>4</option>
                      <option value="5"  <%=(("5".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>5</option>
                      <option value="6"  <%=(("6".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>6</option>
                      <option value="7"  <%=(("7".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>7</option>
                      <option value="8"  <%=(("8".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>8</option>
                      <option value="9"  <%=(("9".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>9</option>
                      <option value="10"  <%=(("10".toString().equals((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("priority"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)))?"SELECTED":"")%>>10</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap><strong>Active:</strong></td>
                  <td> <input type="checkbox" name="active" value=yes  <%=(((((CatUpdateRecordset_data = CatUpdateRecordset.getObject("active"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data).toString().equals(("yes").toString()))?"checked":"")%>> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap>&nbsp;</td>
                  <td> <input type="submit" value="Update Record"> </td>
                </tr>
              </table>
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((CatUpdateRecordset_data = CatUpdateRecordset.getObject("categoryid"))==null || CatUpdateRecordset.wasNull())?"":CatUpdateRecordset_data)%>">
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
CatUpdateRecordset.close();
StatementCatUpdateRecordset.close();
ConnCatUpdateRecordset.close();
%>
<%
ParentRecordset.close();
StatementParentRecordset.close();
ConnParentRecordset.close();
%>
