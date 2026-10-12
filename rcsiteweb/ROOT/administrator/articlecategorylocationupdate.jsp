<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*,com.rev_creations.rcsite.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
// *** Edit Operations: declare variables

// set the form action variable
String MM_editAction = request.getRequestURI();
if (request.getQueryString() != null && request.getQueryString().length() > 0) {
  String queryString = request.getQueryString();
  String tempStr = "";
  for (int i=0; i < queryString.length(); i++) {
    if (queryString.charAt(i) == '<') tempStr = tempStr + "&lt;";
    else if (queryString.charAt(i) == '>') tempStr = tempStr + "&gt;";
    else if (queryString.charAt(i) == '"') tempStr = tempStr +  "&quot;";
    else tempStr = tempStr + queryString.charAt(i);
  }
  MM_editAction += "?" + tempStr;
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


  MM_editTable  = "location_article_category";
  MM_editColumn = "id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "";
  String MM_fieldsStr = "location_id|value|category_id|value";
  String MM_columnsStr = "location_id|none,none,NULL|category_id|none,none,NULL";

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
    Connection MM_connection = rcsiteDS.getConnection();// DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
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
LocationBean locationBean= (com.rev_creations.rcsite.LocationBean) session.getAttribute("location");

String locationid = "0";
String region ="";
String countryCode ="";
if (request.getParameter("locationid") !=null) {locationid = (String)request.getParameter("locationid");}
if (locationBean !=null) {
region = locationBean.getRegion();
countryCode = locationBean.getCountryCode();
}

%>
<%
String RecordsetLocationCategory__MMColParam = "1";
if (request.getParameter("locationid") !=null) {RecordsetLocationCategory__MMColParam = (String)request.getParameter("locationid");}
%>
<%
//Driver DriverRecordsetLocationCategory = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
Connection ConnRecordsetLocationCategory =rcsiteDS.getConnection();// DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
PreparedStatement StatementRecordsetLocationCategory = ConnRecordsetLocationCategory.prepareStatement("SELECT * FROM location_article_category WHERE location_id = " + RecordsetLocationCategory__MMColParam + " ORDER BY id DESC");
ResultSet RecordsetLocationCategory = StatementRecordsetLocationCategory.executeQuery();
boolean RecordsetLocationCategory_isEmpty = !RecordsetLocationCategory.next();
boolean RecordsetLocationCategory_hasData = !RecordsetLocationCategory_isEmpty;
Object RecordsetLocationCategory_data;
int RecordsetLocationCategory_numRows = 0;
%>
<%
String RecordsetArticleCategory__MMColParam = "2";
if (request.getParameter("parentid") !=null) {RecordsetArticleCategory__MMColParam = (String)request.getParameter("parentid");}
%>
<%
//Driver DriverRecordsetArticleCategory = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
Connection ConnRecordsetArticleCategory = rcsiteDS.getConnection(); //DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
PreparedStatement StatementRecordsetArticleCategory = ConnRecordsetArticleCategory.prepareStatement("SELECT categoryid, parentid, title FROM article_category WHERE parentid = " + RecordsetArticleCategory__MMColParam + " ORDER BY categoryid DESC");
ResultSet RecordsetArticleCategory = StatementRecordsetArticleCategory.executeQuery();
boolean RecordsetArticleCategory_isEmpty = !RecordsetArticleCategory.next();
boolean RecordsetArticleCategory_hasData = !RecordsetArticleCategory_isEmpty;
Object RecordsetArticleCategory_data;
int RecordsetArticleCategory_numRows = 0;
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
            <jsp:include page="adminleftnavi.jsp?screen=news" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
  <table align="center">
        <tr valign="baseline">
      <td colspan="2" align="right" nowrap><strong>Match Location to Article Category   - Update   </strong></td>
      </tr>
        <tr valign="baseline">
      <td nowrap align="right">Region:</td>
      <td> <%=countryCode%>, <%=region%>
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Category_id:</td>
      <td><select name="category_id">
          <%
while (RecordsetArticleCategory_hasData) {
%>
          <option value="<%=((RecordsetArticleCategory.getObject("categoryid")!=null)?RecordsetArticleCategory.getObject("categoryid"):"")%>" <%=(((RecordsetArticleCategory.getObject("categoryid")).toString().equals(((((RecordsetLocationCategory_data = RecordsetLocationCategory.getObject("category_id"))==null || RecordsetLocationCategory.wasNull())?"":RecordsetLocationCategory_data)).toString()))?"SELECTED":"")%> ><%=((RecordsetArticleCategory.getObject("title")!=null)?RecordsetArticleCategory.getObject("title"):"")%></option>
          <%
  RecordsetArticleCategory_hasData = RecordsetArticleCategory.next();
}
RecordsetArticleCategory.close();
RecordsetArticleCategory = StatementRecordsetArticleCategory.executeQuery();
RecordsetArticleCategory_hasData = RecordsetArticleCategory.next();
RecordsetArticleCategory_isEmpty = !RecordsetArticleCategory_hasData;
%>
        </select>
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">&nbsp;</td>
      <td><input type="submit" value="Update record">
      </td>
    </tr>
  </table>
  <input type="hidden" name="location_id" value="<%=(((RecordsetLocationCategory_data = RecordsetLocationCategory.getObject("location_id"))==null || RecordsetLocationCategory.wasNull())?"":RecordsetLocationCategory_data)%>" size="32">
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((RecordsetLocationCategory_data = RecordsetLocationCategory.getObject("id"))==null || RecordsetLocationCategory.wasNull())?"":RecordsetLocationCategory_data)%>">
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
RecordsetLocationCategory.close();
StatementRecordsetLocationCategory.close();
ConnRecordsetLocationCategory.close();
%>
<%
RecordsetArticleCategory.close();
StatementRecordsetArticleCategory.close();
ConnRecordsetArticleCategory.close();
%>
