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

 // MM_editDriver     = MM_RevCrea_DRIVER;
 // MM_editConnection = MM_RevCrea_STRING;
 // MM_editUserName   = MM_RevCrea_USERNAME;
 // MM_editPassword   = MM_RevCrea_PASSWORD;
  MM_editTable  = "feed_channel";
  MM_editColumn = "id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  
  MM_editRedirectUrl = "feedchannelupdate.jsp";
	if (request.getParameter("updateandlist") != null &&
    request.getParameter("updateandlist").toString().equals("Update and go to the list")){
		MM_editRedirectUrl = "feedchannellist.jsp";
	}
	
  String MM_fieldsStr = "id|value|name|value|link|value|poll_interval|value|feed_active|value|feed_type|value|poll_interval_min|value|poll_interval_max|value|source_site|value|next_poll|value|last_poll|value|default_category_id|value|comment|value";
  String MM_columnsStr = "id|none,none,NULL|name|',none,''|link|',none,''|poll_interval|none,none,NULL|feed_active|none,none,NULL|feed_type|',none,''|poll_interval_min|none,none,NULL|poll_interval_max|none,none,NULL|source_site|',none,''|next_poll|',none,NULL|last_poll|',none,NULL|default_category_id|none,none,NULL|comment|',none,''";

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
  //  Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
    Connection MM_connection = rcsiteDS.getConnection(); // DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
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
String ArticleCategoryRecordset__MMColParam = "1";


if (request.getParameter("categoryid") !=null) {
ArticleCategoryRecordset__MMColParam = (String)request.getParameter("categoryid");

}
%>
<%
//Driver DriverArticleCategoryRecordset = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
Connection ConnArticleCategoryRecordset = rcsiteDS.getConnection(); //= DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
PreparedStatement StatementArticleCategoryRecordset = ConnArticleCategoryRecordset.prepareStatement("SELECT categoryid, category_name FROM article_category ORDER BY categoryid ASC");
ResultSet ArticleCategoryRecordset = StatementArticleCategoryRecordset.executeQuery();
boolean ArticleCategoryRecordset_isEmpty = !ArticleCategoryRecordset.next();
boolean ArticleCategoryRecordset_hasData = !ArticleCategoryRecordset_isEmpty;
Object ArticleCategoryRecordset_data;
int ArticleCategoryRecordset_numRows = 0;
%>
<%
String FeedChannelRecordset__MMColParam = "1";
int previousOne =1;
int nextOne =3;
if (request.getParameter("id") !=null) {FeedChannelRecordset__MMColParam = (String)request.getParameter("id");
previousOne =Integer.parseInt(FeedChannelRecordset__MMColParam) -1;
nextOne = Integer.parseInt(FeedChannelRecordset__MMColParam) +1;
}
%>
<%
//String RecordsetFeedChannelLog__MMColParam = "1";
//if (request.getParameter("channel_id") !=null) {RecordsetFeedChannelLog__MMColParam = (String)request.getParameter("channel_id");}
%>
<%
//Driver DriverFeedChannelRecordset = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
Connection ConnFeedChannelRecordset = rcsiteDS.getConnection(); //= DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
PreparedStatement StatementFeedChannelRecordset = ConnFeedChannelRecordset.prepareStatement("SELECT * FROM feed_channel WHERE id = " + FeedChannelRecordset__MMColParam + " ORDER BY id ASC");
ResultSet FeedChannelRecordset = StatementFeedChannelRecordset.executeQuery();
boolean FeedChannelRecordset_isEmpty = !FeedChannelRecordset.next();
boolean FeedChannelRecordset_hasData = !FeedChannelRecordset_isEmpty;
Object FeedChannelRecordset_data;
int FeedChannelRecordset_numRows = 0;
%>
<%
if(FeedChannelRecordset_isEmpty){
		String redirect = request.getRequestURL().toString();
		
		pageMessage=" Sorry...Channel "+FeedChannelRecordset__MMColParam+" could not be found. " ;
		redirect += "?id="+nextOne+"&pagemessage="+pageMessage;//+"&articleid="+ArticleRecordset__MMColParam;


        response.sendRedirect(response.encodeRedirectURL(redirect));
      	return;

}
%>
<%!
public String DoDateTime(java.lang.Object aObject,int nNamedFormat,java.util.Locale aLocale) throws Exception{	
if ((aObject != null) && (aObject instanceof java.util.Date)){
   if (aLocale!=null){
		java.text.DateFormat df = java.text.DateFormat.getDateInstance(nNamedFormat,aLocale);
			return df.format(aObject);
	}
	else{
		java.text.DateFormat df = java.text.DateFormat.getDateInstance(nNamedFormat);
			return df.format(aObject);
	 }
 }
return "";
}
%>
<%
//Driver DriverRecordsetFeedChannelLog = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
Connection ConnRecordsetFeedChannelLog = rcsiteDS.getConnection();// DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
PreparedStatement StatementRecordsetFeedChannelLog = ConnRecordsetFeedChannelLog.prepareStatement("SELECT * FROM feed_channel_log WHERE channel_id = " + FeedChannelRecordset__MMColParam + " ORDER BY log_time DESC");
ResultSet RecordsetFeedChannelLog = StatementRecordsetFeedChannelLog.executeQuery();
boolean RecordsetFeedChannelLog_isEmpty = !RecordsetFeedChannelLog.next();
boolean RecordsetFeedChannelLog_hasData = !RecordsetFeedChannelLog_isEmpty;
Object RecordsetFeedChannelLog_data;
int RecordsetFeedChannelLog_numRows = 0;
%>
<%
int Repeat1__numRows = 100;
int Repeat1__index = 0;
RecordsetFeedChannelLog_numRows += Repeat1__numRows;
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
  <table align="left">
    <tr valign="baseline">
      <td width="125" align="right" nowrap><a href="/administrator/feedchannelupdate.jsp?id=<%=previousOne%> "><< Previous</a> ||</td>
      <td width="257"><%=FeedChannelRecordset__MMColParam%> || <a href="/administrator/feedchannelupdate.jsp?id=<%=nextOne%> ">Next >></a> <font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
      <td width="125" align="right" nowrap>&nbsp;</td>
      <td width="237">&nbsp;</td>
    </tr>
    <tr valign="baseline">
      <td width="125" align="right" nowrap>Name:</td>
      <td width="257"><input type="text" name="name" value="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("name"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" size="32">
      </td>
      <td nowrap align="right">Poll_interval:</td>
      <td><input type="text" name="poll_interval" value="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("poll_interval"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Link:</td>
      <td><input type="text" name="link" value="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("link"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" size="32">
      </td>
      <td nowrap align="right">Poll_interval_max:</td>
      <td><input type="text" name="poll_interval_max" value="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("poll_interval_max"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Feed_active:</td>
      <td><select name="feed_active">
          <option value="true" <%=((FeedChannelRecordset.getInt("feed_active") == 1)?"SELECTED":"")%>>true</option>
          <option value="false" <%=((FeedChannelRecordset.getInt("feed_active")== 0)?"SELECTED":"")%>>false</option>
        </select>
      </td>
      <td nowrap align="right">Poll_interval_min:</td>
      <td><input type="text" name="poll_interval_min" value="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("poll_interval_min"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Source_site:</td>
      <td><input type="text" name="source_site" value="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("source_site"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" size="32"></td>
      <td nowrap align="right">Next_poll:</td>
      <td><input type="text" name="next_poll" value="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("next_poll"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Feed_type:</td>
      <td><select name="feed_type">
	   <option <%=(("RSS2.0_short".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>               value="RSS2.0_short">RSS2.0_short</option>
          <option <%=(("RSS2.0".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>               value="RSS2.0">RSS2.0</option>
          <option <%=(("atom2.0_youtube_vide".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%> value="atom2.0_youtube_vide">atom2.0_youtube_vide</option>
          <option <%=(("atom2.0_short".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>              value="atom2.0_short">atom2.0_short</option>
		  <option <%=(("atom2.0".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>              value="atom2.0">atom2.0</option>
          <option <%=(("RSS2.0_ceylontoday".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>   value="RSS2.0_ceylontoday">RSS2.0_ceylontoday</option>
          <option <%=(("RSS2.0_google".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>        value="RSS2.0_google">RSS2.0_google</option>
          <option <%=(("RSS2.0_yahoo".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>         value="RSS2.0_yahoo">RSS2.0_yahoo</option>
          <option <%=(("RSS2.0_google_articl".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%> value="RSS2.0_google_articl">RSS2.0_google_articl</option>
          <option <%=(("RSS2.0_google_vedio ".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%> value="RSS2.0_google_vedio">RSS2.0_google_vedio</option>
          <option <%=(("atom2.0_fburner_short".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>      value="atom2.0_fburner_short">atom2.0_fburner_short</option>
		  <option <%=(("atom2.0_fburner".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>      value="atom2.0_fburner">atom2.0_fburner</option>
          <option <%=(("RSS2.0_ceylontoday".toString().equals((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("feed_type"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)))?"SELECTED":"")%>   value="RSS2.0_ceylontoday">RSS2.0_ceylontoday</option>
        </select>
      </td>
      <td nowrap align="right">Last_poll:</td>
      <td><input type="text" name="last_poll" value="<%= (((FeedChannelRecordset_data = FeedChannelRecordset.getObject("last_poll"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data) %>" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">Default Category:</td>
      <td><select name="default_category_id">
          <%
while (ArticleCategoryRecordset_hasData) {
%>
          <option value="<%=((ArticleCategoryRecordset.getObject("categoryid")!=null)?ArticleCategoryRecordset.getObject("categoryid"):"")%>" <%=(((ArticleCategoryRecordset.getObject("categoryid")).toString().equals(((((FeedChannelRecordset_data = FeedChannelRecordset.getObject("default_category_id"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)).toString()))?"SELECTED":"")%> ><%=((ArticleCategoryRecordset.getObject("category_name")!=null)?ArticleCategoryRecordset.getObject("category_name"):"")%></option>
          <%
  ArticleCategoryRecordset_hasData = ArticleCategoryRecordset.next();
}
ArticleCategoryRecordset.close();
ArticleCategoryRecordset = StatementArticleCategoryRecordset.executeQuery();
ArticleCategoryRecordset_hasData = ArticleCategoryRecordset.next();
ArticleCategoryRecordset_isEmpty = !ArticleCategoryRecordset_hasData;
%>
        </select>
      </td>
	  <td nowrap align="right">&nbsp;</td>
      <td align="right" nowrap>&nbsp;</td>
	  
	  
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">&nbsp;</td>
      <td><input type="submit" value="Update record">
        <input type="submit" value="Update and go to the list" name="updateandlist">
</td>
<td align="right" valign="top" nowrap>Comments:</td>
	  
	  <td rowspan="2" nowrap><textarea name="comment" cols="30" rows="2"><%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("comment"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%></textarea></td>
	  </tr>
    <tr valign="baseline">
      <td nowrap align="right">View Articles </td>
      <td><a href="../news/pagelist.jsp?searchterm=1&csearch=<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("id"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>" target="_blank"><%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("id"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%></a></td>
      <td nowrap align="right">&nbsp;</td>
    </tr>
  </table>
  <input type="hidden" name="id" value="" size="32">
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((FeedChannelRecordset_data = FeedChannelRecordset.getObject("id"))==null || FeedChannelRecordset.wasNull())?"":FeedChannelRecordset_data)%>">
</form>
<p>&nbsp;</p>

<p>&nbsp;</p>
<table border="1" cellpadding="1" cellspacing="1">
  <tr valign="top">
    <td><div align="left">id</div></td>
    <td><div align="left">channel_id</div></td>
    <td><div align="left">log_time</div></td>
    <td><div align="left">location</div></td>
    <td><div align="left">severity</div></td>
    <td><div align="left">message</div></td>
    <td><div align="left">trace</div></td>
  </tr>
  <% while ((RecordsetFeedChannelLog_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr valign="top">
    <td><div align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("id"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></div></td>
    <td><div align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("channel_id"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></div></td>
    <td><div align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("log_time"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></div></td>
    <td><div align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("location"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></div></td>
    <td><div align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("severity"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></div></td>
    <td><div align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("message"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></div></td>
    <td><div align="left"><%=(((RecordsetFeedChannelLog_data = RecordsetFeedChannelLog.getObject("trace"))==null || RecordsetFeedChannelLog.wasNull())?"":RecordsetFeedChannelLog_data)%></div></td>
  </tr>
  <%
  Repeat1__index++;
  RecordsetFeedChannelLog_hasData = RecordsetFeedChannelLog.next();
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
ArticleCategoryRecordset.close();
StatementArticleCategoryRecordset.close();
ConnArticleCategoryRecordset.close();
%>
<%
FeedChannelRecordset.close();
StatementFeedChannelRecordset.close();
ConnFeedChannelRecordset.close();
%>
<%
RecordsetFeedChannelLog.close();
StatementRecordsetFeedChannelLog.close();
ConnRecordsetFeedChannelLog.close();
%>

