<%@ page language="java" import="java.sql.*" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%
String ArticleRecordset__MMColParam = "3";
//if (request.getParameter("categoryid") !=null) {ArticleRecordset__MMColParam = (String)request.getParameter("categoryid");}
%>
<%
Driver DriverArticleRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
Connection ConnArticleRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
PreparedStatement StatementArticleRecordset = ConnArticleRecordset.prepareStatement("SELECT article_id, title FROM articles WHERE categoryid = " + ArticleRecordset__MMColParam + " AND aproval_status > 0 ORDER BY aproval_status DESC ");
ResultSet ArticleRecordset = StatementArticleRecordset.executeQuery();
boolean ArticleRecordset_isEmpty = !ArticleRecordset.next();
boolean ArticleRecordset_hasData = !ArticleRecordset_isEmpty;
Object ArticleRecordset_data;
int ArticleRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 10;
int Repeat1__index = 0;
ArticleRecordset_numRows += Repeat1__numRows;
%>

<table width="189" height="100%" border="0" cellpadding="0" cellspacing="0" class="text">
  <tr>
    <td><img src="images/spacer.gif" height="2" width="1"></td>
  </tr>
  <tr>
    <td height="22" valign="top" bgcolor="#C22929">
	    
	<div class="whitetitle" style="margin-left:5px; margin-top:3px "><img src="images/sym11.jpg" width="15" height="15" align="absmiddle" style="margin-right:5px ">What's 
        Hot? </div>
	</td>
  </tr>
  <tr>
    <td height="57" valign="top" bgcolor="#E7E7E7">
	<% while ((ArticleRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
	<div style="margin-left:8px; margin-top:6px "><img src="images/sym5.jpg" align="absmiddle" style="margin-right:4px "><strong><a href="../news/page.jsp?articleid=<%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>"><%=(((ArticleRecordset_data = ArticleRecordset.getObject("title"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></a></strong></div>
	          <%
  Repeat1__index++;
  ArticleRecordset_hasData = ArticleRecordset.next();
}
%>           
	</td>
  </tr>
  </table>

<%
ArticleRecordset.close();
StatementArticleRecordset.close();
ConnArticleRecordset.close();
%>

