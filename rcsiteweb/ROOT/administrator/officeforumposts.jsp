<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/OfficeConnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%
String PostsRecordset__MMColParam = "0";
if (request.getParameter("poststatus") !=null) {PostsRecordset__MMColParam = (String)request.getParameter("poststatus");}
%>
<%
//Driver DriverPostsRecordset = (Driver)Class.forName(MM_TrainingConnection_DRIVER).newInstance();
//Connection ConnPostsRecordset = DriverManager.getConnection(MM_TrainingConnection_STRING,MM_TrainingConnection_USERNAME,MM_TrainingConnection_PASSWORD);
Connection ConnPostsRecordset = rcsiteDS.getConnection();
PreparedStatement StatementPostsRecordset = ConnPostsRecordset.prepareStatement("SELECT * FROM  mvnforumPost WHERE PostStatus = " + PostsRecordset__MMColParam + " ORDER BY PostLastEditDate DESC");
ResultSet PostsRecordset = StatementPostsRecordset.executeQuery();
boolean PostsRecordset_isEmpty = !PostsRecordset.next();
boolean PostsRecordset_hasData = !PostsRecordset_isEmpty;
Object PostsRecordset_data;
int PostsRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 20;
int Repeat1__index = 0;
PostsRecordset_numRows += Repeat1__numRows;
%>
<%
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int PostsRecordset_first = 1;
int PostsRecordset_last  = 1;
int PostsRecordset_total = -1;

if (PostsRecordset_isEmpty) {
  PostsRecordset_total = PostsRecordset_first = PostsRecordset_last = 0;
}

//set the number of rows displayed on this page
if (PostsRecordset_numRows == 0) {
  PostsRecordset_numRows = 1;
}
%>
<%
// *** Recordset Stats: if we don't know the record count, manually count them

if (PostsRecordset_total == -1) {

  // count the total records by iterating through the recordset
    for (PostsRecordset_total = 1; PostsRecordset.next(); PostsRecordset_total++);

  // reset the cursor to the beginning
  PostsRecordset.close();
  PostsRecordset = StatementPostsRecordset.executeQuery();
  PostsRecordset_hasData = PostsRecordset.next();

  // set the number of rows displayed on this page
  if (PostsRecordset_numRows < 0 || PostsRecordset_numRows > PostsRecordset_total) {
    PostsRecordset_numRows = PostsRecordset_total;
  }

  // set the first and last displayed record
  PostsRecordset_first = Math.min(PostsRecordset_first, PostsRecordset_total);
  PostsRecordset_last  = Math.min(PostsRecordset_first + PostsRecordset_numRows - 1, PostsRecordset_total);
}
%>
<% String MM_paramName = ""; %>
<%
// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = PostsRecordset;
int       MM_rsCount = PostsRecordset_total;
int       MM_size = PostsRecordset_numRows;
String    MM_uniqueCol = "";
          MM_paramName = "";
int       MM_offset = 0;
boolean   MM_atTotal = false;
boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);
%>
<%
// *** Move To Record: handle 'index' or 'offset' parameter

if (!MM_paramIsDefined && MM_rsCount != 0) {

  //use index parameter if defined, otherwise use offset parameter
  String r = request.getParameter("index");
  if (r==null) r = request.getParameter("offset");
  if (r!=null) MM_offset = Integer.parseInt(r);

  // if we have a record count, check if we are past the end of the recordset
  if (MM_rsCount != -1) {
    if (MM_offset >= MM_rsCount || MM_offset == -1) {  // past end or move last
      if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  //move the cursor to the selected record
  int i;
  for (i=0; PostsRecordset_hasData && (i < MM_offset || MM_offset == -1); i++) {
    PostsRecordset_hasData = MM_rs.next();
  }
  if (!PostsRecordset_hasData) MM_offset = i;  // set MM_offset to the last possible record
}
%>
<%
// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; PostsRecordset_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    PostsRecordset_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!PostsRecordset_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!PostsRecordset_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  PostsRecordset.close();
  PostsRecordset = StatementPostsRecordset.executeQuery();
  PostsRecordset_hasData = PostsRecordset.next();
  MM_rs = PostsRecordset;

  // move the cursor to the selected record
  for (i=0; PostsRecordset_hasData && i < MM_offset; i++) {
    PostsRecordset_hasData = MM_rs.next();
  }
}
%>
<%
// *** Move To Record: update recordset stats

// set the first and last displayed record
PostsRecordset_first = MM_offset + 1;
PostsRecordset_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  PostsRecordset_first = Math.min(PostsRecordset_first, MM_rsCount);
  PostsRecordset_last  = Math.min(PostsRecordset_last, MM_rsCount);
}

// set the boolean used by hide region to check if we are on the last record
MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
%>
<%
// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
String[] MM_removeList = { "index", MM_paramName };

// create the MM_keepURL string
if (request.getQueryString() != null) {
  MM_keepURL = '&' + request.getQueryString();
  for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) {
  int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    if (start >= 0 && MM_keepURL.charAt(start) == '&' &&
        MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') {
      int stop = MM_keepURL.indexOf('&', start + 1);
      if (stop == -1) stop = MM_keepURL.length();
      MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    }
  }
}

// add the Form variables to the MM_keepForm string
if (request.getParameterNames().hasMoreElements()) {
  java.util.Enumeration items = request.getParameterNames();
  while (items.hasMoreElements()) {
    String nextItem = (String)items.nextElement();
    boolean found = false;
    for (int i=0; !found && i < MM_removeList.length; i++) {
      if (MM_removeList[i].equals(nextItem)) found = true;
    }
    if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) {
      MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
    }
  }
}

// create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL + MM_keepForm;
if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);
%>
<%
// *** Move To Record: set the strings for the first, last, next, and previous links

String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
{
  String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
  String MM_moveParam = "index=";

  // if the page has a repeated region, remove 'offset' from the maintained parameters
  if (MM_size > 1) {
    MM_moveParam = "offset=";
    int start = MM_keepMove.indexOf(MM_moveParam);
    if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) {
      int stop = MM_keepMove.indexOf('&', start);
      if (start == 0 && stop != -1) stop++;
      if (stop == -1) stop = MM_keepMove.length();
      if (start > 0) start--;
      MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
    }
  }

  // set the strings for the move to links
  StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
  if (MM_keepMove.length() > 0) urlStr.append('&');
  urlStr.append(MM_moveParam);
  MM_moveFirst = urlStr + "0";
  MM_moveLast  = urlStr + "-1";
  MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
  MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
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


<table border="1" cellpadding="0" cellspacing="3" bordercolor="#FFFFFF" class="text">
  
  <tr> 
    <td colspan="4"><strong>Office Forum - Latest posts.</strong></td>
  </tr>
  <tr bgcolor="#999999"> 
    <td bgcolor="#999999"><font color="#FFFFFF"><strong>&nbsp; Posted User</strong></font></td>
    <td><font color="#FFFFFF"><strong>&nbsp; Post Topic</strong></font></td>
    <td><font color="#FFFFFF"><strong> &nbsp; Last Edit Date</strong></font></td>
    <td><font color="#FFFFFF">&nbsp;</font></td>
  </tr>
  <% while ((PostsRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr valign="top" <%if (Repeat1__index%2 ==1){out.print("bgcolor=\"CCCCCC\" ");}%> > 
    <td><%=(((PostsRecordset_data = PostsRecordset.getObject("MemberName"))==null || PostsRecordset.wasNull())?"":PostsRecordset_data)%></td>
    <td><%=(((PostsRecordset_data = PostsRecordset.getObject("PostTopic"))==null || PostsRecordset.wasNull())?"":PostsRecordset_data)%></td>
    <td align="right"><%= DoDateTime((((PostsRecordset_data = PostsRecordset.getObject("PostLastEditDate"))==null || PostsRecordset.wasNull())?"":PostsRecordset_data), java.text.DateFormat.LONG, null) %></td>
    <td><a href="<%=officeforumUrl%>/forum/viewthread?thread=<%=(((PostsRecordset_data = PostsRecordset.getObject("ThreadID"))==null || PostsRecordset.wasNull())?"":PostsRecordset_data)%>" target="_blank">View 
      this thread</a></td>
  </tr>
  <%
  Repeat1__index++;
  PostsRecordset_hasData = PostsRecordset.next();
}
%>
</table>


<p>Records <%=(PostsRecordset_first)%> to <%=(PostsRecordset_last)%> of <%=(PostsRecordset_total)%></p>
<p> 
  <%
PostsRecordset.close();
StatementPostsRecordset.close();
ConnPostsRecordset.close();
%>
</p>

<table border="0" width="50%" align="center">
  <tr> 
    <td width="23%" align="center"> <% if (MM_offset !=0) { %>
      <a href="<%=MM_moveFirst%>">&lt;&lt;First</a> 
      <% } /* end MM_offset != 0 */ %> </td>
    <td width="31%" align="center"> <% if (MM_offset !=0) { %>
      <a href="<%=MM_movePrev%>">&lt;Previous</a> 
      <% } /* end MM_offset != 0 */ %> </td>
    <td width="23%" align="center"> <% if (!MM_atTotal) { %>
      <a href="<%=MM_moveNext%>">Next&gt;</a> 
      <% } /* end !MM_atTotal */ %> </td>
    <td width="23%" align="center"> <% if (!MM_atTotal) { %>
      <a href="<%=MM_moveLast%>">Last&gt;&gt;</a> 
      <% } /* end !MM_atTotal */ %> </td>
  </tr>
</table>
