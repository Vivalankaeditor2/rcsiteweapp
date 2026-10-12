<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/TrainingConnection.jsp" %>
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


<table border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF" class="text">
  <tr> 
    <td colspan="4"><strong>Discussion Forum - Latest posts.</strong></td>
  </tr>
  <tr bgcolor="#999999"> 
    <td bgcolor="#999999"><font color="#FFFFFF"><strong>Posted User</strong></font></td>
    <td><font color="#FFFFFF"><strong>Post Topic</strong></font></td>
    <td><font color="#FFFFFF"><strong> Last Edit Date</strong></font></td>
    <td><font color="#FFFFFF">&nbsp;</font></td>
  </tr>
  <% while ((PostsRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr valign="top" <%if (Repeat1__index%2 ==1){out.print("bgcolor=\"CCCCCC\" ");}%> > 
    <td><%=(((PostsRecordset_data = PostsRecordset.getObject("MemberName"))==null || PostsRecordset.wasNull())?"":PostsRecordset_data)%></td>
    <td><%=(((PostsRecordset_data = PostsRecordset.getObject("PostTopic"))==null || PostsRecordset.wasNull())?"":PostsRecordset_data)%></td>
    <td align="right"><%= DoDateTime((((PostsRecordset_data = PostsRecordset.getObject("PostLastEditDate"))==null || PostsRecordset.wasNull())?"":PostsRecordset_data), java.text.DateFormat.LONG, null) %></td>
    <td><a href="<%=forumUrl%>/forum/viewthread?thread=<%=(((PostsRecordset_data = PostsRecordset.getObject("ThreadID"))==null || PostsRecordset.wasNull())?"":PostsRecordset_data)%>" target="_blank">View 
      this thread</a></td>
  </tr>
  <%
  Repeat1__index++;
  PostsRecordset_hasData = PostsRecordset.next();
}
%>
</table>

<%
PostsRecordset.close();
StatementPostsRecordset.close();
ConnPostsRecordset.close();
%>
