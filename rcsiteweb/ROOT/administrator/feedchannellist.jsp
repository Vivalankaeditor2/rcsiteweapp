<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.text.*,java.util.*,com.rev_creations.rcsite.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
// *** Edit Operations: declare variables
	Calendar calendar = Calendar.getInstance();
	ArticlePageGenerator.categoryLimitTable.put("7", new GeneratorSetting(150,20,calendar.getTime()));
	
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
  String MM_fieldsStr = "name|value|link|value|poll_interval|value|feed_active|value|feed_type|value|poll_interval_min|value|poll_interval_max|value|source_site|value|next_poll|value|last_poll|value|default_category_id|value|comment|value";
  String MM_columnsStr = "name|',none,''|link|',none,''|poll_interval|none,none,NULL|feed_active|none,none,NULL|feed_type|',none,''|poll_interval_min|none,none,NULL|poll_interval_max|none,none,NULL|source_site|',none,''|next_poll|',none,NULL|last_poll|',none,NULL|default_category_id|none,none,NULL|comment|',none,''";

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

<%
String FeedChannelRecordset__MMColParam = "1";
if (request.getParameter("id") !=null) {FeedChannelRecordset__MMColParam = (String)request.getParameter("id");}
String orderby = "id";
if (request.getParameter("orderby") !=null) {orderby = (String)request.getParameter("orderby");}
String whereClue ="WHERE level <> 'hidden'";
String feedActive = "1";
if (request.getParameter("feed_active") !=null) {
feedActive = (String)request.getParameter("feed_active");
whereClue = "WHERE  level <> 'hidden'  AND feed_active = "+feedActive+" ";
}

%>
<%
//Driver DriverFeedChannelRecordset = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
Connection ConnFeedChannelRecordset = rcsiteDS.getConnection();  //= DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
PreparedStatement StatementFeedChannelRecordset = ConnFeedChannelRecordset.prepareStatement("SELECT * FROM  (article_category  left join feed_channel on feed_channel.default_category_id=article_category.categoryid ) "+whereClue + "ORDER BY "+orderby+" DESC");
ResultSet FeedChannelRecordset = StatementFeedChannelRecordset.executeQuery();
boolean FeedChannelRecordset_isEmpty = !FeedChannelRecordset.next();
boolean FeedChannelRecordset_hasData = !FeedChannelRecordset_isEmpty;
Object FeedChannelRecordset_data;
int FeedChannelRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 300;
int Repeat1__index = 0;
FeedChannelRecordset_numRows += Repeat1__numRows;
%>
<%!
public String DoDateTime(java.lang.Object aObject,int nNamedFormat,java.util.Locale aLocale) throws Exception{	
if ((aObject != null) && (aObject instanceof java.util.Date)){
   if (aLocale!=null){
		java.text.DateFormat df = java.text.DateFormat.getDateInstance(nNamedFormat,aLocale);
			return df.format(aObject);
	}
	else{
		//java.text.DateFormat df = java.text.DateFormat.getDateInstance("");
		SimpleDateFormat df =   new SimpleDateFormat ("yyyy/MM/dd hh:mm");
			return df.format(aObject);
	 }
 }
return "";
}
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Feed Channel List</title>
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
      <table align="left">
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
          <td><!--input type="text" name="feed_active" value="" size="32"-->
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
          <td><input type="text" name="source_site" value="" size="32"></td>
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
          <td align="right" valign="top" nowrap>Comments:</td>
		  <td rowspan="2"  nowrap><textarea name="comment" cols="30" rows="2"></textarea></td>
        </tr>
        <tr valign="baseline">
          <td nowrap align="right">&nbsp;</td>
          <td><input type="submit" value="Insert record">
          </td>
          <td nowrap align="right">&nbsp;</td>
		  </tr>
      </table>
      <input type="hidden" name="MM_insert" value="form1">
</form>
<p>&nbsp;</p>

<table border="1" cellpadding="1" cellspacing="1">
  <tr>
    <td><div align="right">Select</div></td>
    <td>&nbsp;</td>
    
    <td><form action="" method="post" name="feed_activeform" id="feed_activeform">
<select name="feed_active">
  <option value="1">true</option>
  <option value="0">false</option>
</select><input name="Go" type="submit" value="Go">
</form></td>
<td>&nbsp;</td>
    <td><div>Order By </div><form action="" method="post" name="orderbyform" id="orderbyform">
<select name="orderby">
  <option value="feed_active">feed_active</option>
  <option value="next_poll">next_poll</option>
  <option value="last_poll">last_poll</option>
</select><input name="Go" type="submit" value="Go">
</form></td>
   <td>&nbsp;</td>
  

    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><a href="feedchannellist.jsp?orderby=id">View Articles</a></td>
    <td><a href="feedchannellist.jsp?orderby=name">name</a></td>
	   <td><a href="feedchannellist.jsp?orderby=feed_active">feed_active</a></td>
	 <td><a href="feedchannellist.jsp?orderby=article_category.category_name">category </a></td>
    <td><a href="feedchannellist.jsp?orderby=link">link</a></td>
 
    <td>source_site</td>
    <td><a href="feedchannellist.jsp?orderby=next_poll">next_poll</a></td>
    <td><a href="feedchannellist.jsp?orderby=last_poll">last_poll</a></td>
   
  </tr>
  <% while ((FeedChannelRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr>
    <td><a href="../news/pagelist.jsp?searchterm=1&csearch=<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("id"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" target="_blank"><%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("id"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%></a></td>
    <td><a href="feedchannelupdate.jsp?id=<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("id"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>"><%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("name"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%></a></td>
    <td><%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_active"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%></td>
	   <td nowrap><%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("article_category.category_name"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%></td>
    <td><a href="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("link"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" target="_blank"><%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("link"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%></a></td>
	
    <td><%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("source_site"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%></td>
    <td nowrap><%= DoDateTime((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("next_poll"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data), java.text.DateFormat.LONG, null)%></td>
    <td nowrap><%=DoDateTime((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("last_poll"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data), java.text.DateFormat.LONG, null)%></td>   
  </tr>
  <%
  Repeat1__index++;
  FeedChannelRecordset_hasData = FeedChannelRecordset.next();
}
%>
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
FeedChannelRecordset.close();
StatementFeedChannelRecordset.close();
ConnFeedChannelRecordset.close();
%>

<%
ArticleCategory.close();
StatementArticleCategory.close();
ConnArticleCategory.close();
%>
