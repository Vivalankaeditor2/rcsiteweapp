<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
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
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {

  //MM_editDriver     = MM_RevCrea_DRIVER;
 // MM_editConnection = MM_RevCrea_STRING;
//  MM_editUserName   = MM_RevCrea_USERNAME;
//  MM_editPassword   = MM_RevCrea_PASSWORD;
  MM_editTable  = "feed_channel";
  MM_editRedirectUrl = "feedchannellist.jsp";
  String MM_fieldsStr = "name|value|link|value|poll_interval|value|feed_active|value|feed_type|value|poll_interval_min|value|poll_interval_max|value|source_site|value|next_poll|value|last_poll|value|default_category_id|value";
  String MM_columnsStr = "name|',none,''|link|',none,''|poll_interval|none,none,NULL|feed_active|none,none,NULL|feed_type|',none,''|poll_interval_min|none,none,NULL|poll_interval_max|none,none,NULL|source_site|',none,''|next_poll|',none,NULL|last_poll|',none,NULL|default_category_id|none,none,NULL";

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
    Connection MM_connection = rcsiteDS.getConnection(); //DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
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
String ArticleCategory__MMColParam = "1";
if (request.getParameter("categoryid") !=null) {ArticleCategory__MMColParam = (String)request.getParameter("categoryid");}
%>
<%
//Driver DriverArticleCategory = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
Connection ConnArticleCategory = rcsiteDS.getConnection(); //= DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
PreparedStatement StatementArticleCategory = ConnArticleCategory.prepareStatement("SELECT categoryid, parentid, category_name FROM article_category ORDER BY categoryid ASC");
ResultSet ArticleCategory = StatementArticleCategory.executeQuery();
boolean ArticleCategory_isEmpty = !ArticleCategory.next();
boolean ArticleCategory_hasData = !ArticleCategory_isEmpty;
Object ArticleCategory_data;
int ArticleCategory_numRows = 0;
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
      <td nowrap align="right">Name:</td>
      <td><input type="text" name="name" value="" size="32">
      </td>
      <td nowrap align="right">Poll_interval:</td>
      <td><input type="text" name="poll_interval" value="3600" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Link:</td>
      <td><input type="text" name="link" value="" size="32">
      </td>
	        <td nowrap align="right">Poll_interval_max:</td>
      <td><input type="text" name="poll_interval_max" value="3600" size="32">
      </td>
	  
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Feed_active:</td>
      <td>
        <!--input type="text" name="feed_active" value="" size="32"-->
	 
          <select name="feed_active">
            <option value="true">true</option>
            <option value="false">false</option>
		  
          </select>  
                </td>
      <td nowrap align="right">Poll_interval_min:</td>
      <td><input type="text" name="poll_interval_min" value="3200" size="32">
      </td>
    </tr>
    <tr valign="baseline">
	      <td nowrap align="right">Source_site:</td>
      <td><input type="text" name="source_site" value="" size="32">
      </td>
      <td nowrap align="right">Next_poll:</td>
      <td><input type="text" name="next_poll" value="2014-11-01 23:18:41.0" size="32">
      </td>
	  

    </tr>
    <tr valign="baseline">
	      <td nowrap align="right">Feed_type:</td>
      <td><select name="feed_type">
	  		<option value="RSS2.0_short">RSS2.0_short</option>
            <option value="RSS2.0">RSS2.0</option>
            <option value="atom2.0_youtube_vide">atom2.0_youtube_vide</option>
			<option value="atom2.0_short">atom2.0_short</option>
			<option value="atom2.0">atom2.0</option>
            <option value="RSS2.0_ceylontoday">RSS2.0_ceylontoday</option>
            <option value="RSS2.0_google">RSS2.0_google</option>
            <option value="RSS2.0_yahoo">RSS2.0_yahoo</option>
            <option value="RSS2.0_google_articl">RSS2.0_google_articl</option>
            <option value="RSS2.0_google_vedio">RSS2.0_google_vedio</option>
			<option value="atom2.0_fburner_short">atom2.0_fburner_short</option>
            <option value="atom2.0_fburner">atom2.0_fburner</option>
            <option value="RSS2.0_ceylontoday">RSS2.0_ceylontoday</option>
          </select>  
               </td>
	  
      <td nowrap align="right">Last_poll:</td>
      <td><input type="text" name="last_poll" value="2014-11-01 23:18:41.0" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Default_category_id:</td>
      <td><select name="default_category_id">
          <%
while (ArticleCategory_hasData) {
%>
          <option value="<%=((ArticleCategory.getObject("categoryid")!=null)?ArticleCategory.getObject("categoryid"):"")%>"><%=((ArticleCategory.getObject("category_name")!=null)?ArticleCategory.getObject("category_name"):"")%></option>
          <%
  ArticleCategory_hasData = ArticleCategory.next();
}
ArticleCategory.close();
ArticleCategory = StatementArticleCategory.executeQuery();
ArticleCategory_hasData = ArticleCategory.next();
ArticleCategory_isEmpty = !ArticleCategory_hasData;
%>
        </select>
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">&nbsp;</td>
      <td><input type="submit" value="Insert record">
      </td>
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
ArticleCategory.close();
StatementArticleCategory.close();
ConnArticleCategory.close();
%>
