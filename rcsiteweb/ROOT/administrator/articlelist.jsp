<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,com.rev_creations.rcsite.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
String ArtiCatRecordset__MMColParam = "main";
if (request.getParameter("level") !=null) {ArtiCatRecordset__MMColParam = (String)request.getParameter("level");}
%>
<%
//Driver DriverArtiCatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnArtiCatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnArtiCatRecordset = rcsiteDS.getConnection();
PreparedStatement StatementArtiCatRecordset = ConnArtiCatRecordset.prepareStatement("SELECT categoryid, category_name FROM article_category WHERE  active ='yes' AND level <> '" + ArtiCatRecordset__MMColParam + "' ORDER BY priority DESC");
ResultSet ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
boolean ArtiCatRecordset_isEmpty = !ArtiCatRecordset.next();
boolean ArtiCatRecordset_hasData = !ArtiCatRecordset_isEmpty;
Object ArtiCatRecordset_data;
int ArtiCatRecordset_numRows = 0;
%>

<%
String categoryid = "90";
String aprovalStatus ="0";
String whereClue = ""; 
if (request.getParameter("categoryid") !=null) {
categoryid = (String)request.getParameter("categoryid");
	whereClue = "where articles.categoryid = "+categoryid; 
}

if (request.getParameter("aproval_status") !=null &&
  request.getParameter("aproval_status").length()>0) {
aprovalStatus = (String)request.getParameter("aproval_status");
	whereClue = whereClue+" and articles.aproval_status = '"+aprovalStatus+"'"; 
}

if(whereClue.length()<5){
	whereClue = "where articles.categoryid in (90, 91) and articles.aproval_status ='0' ";
}


%>
<%
//Driver DriverArticleRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnArticleRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnArticleRecordset = rcsiteDS.getConnection();
PreparedStatement StatementArticleRecordset = ConnArticleRecordset.prepareStatement("SELECT articles.article_id, articles.aproval_status, articles.title, articles.alias, article_category.category_name FROM (articles left join article_category  on articles.categoryid=article_category.categoryid) "+whereClue+" ORDER BY articles.article_id DESC limit 100 ");
ResultSet ArticleRecordset = StatementArticleRecordset.executeQuery();
boolean ArticleRecordset_isEmpty = !ArticleRecordset.next();
boolean ArticleRecordset_hasData = !ArticleRecordset_isEmpty;
Object ArticleRecordset_data;
int ArticleRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 40;
int Repeat1__index = 0;
ArticleRecordset_numRows += Repeat1__numRows;
%>
<%
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int ArticleRecordset_first = 1;
int ArticleRecordset_last  = 1;
int ArticleRecordset_total = -1;

if (ArticleRecordset_isEmpty) {
  ArticleRecordset_total = ArticleRecordset_first = ArticleRecordset_last = 0;
}

//set the number of rows displayed on this page
if (ArticleRecordset_numRows == 0) {
  ArticleRecordset_numRows = 1;
}
%>
<% String MM_paramName = ""; %>
<%
// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = ArticleRecordset;
int       MM_rsCount = ArticleRecordset_total;
int       MM_size = ArticleRecordset_numRows;
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
  for (i=0; ArticleRecordset_hasData && (i < MM_offset || MM_offset == -1); i++) {
    ArticleRecordset_hasData = MM_rs.next();
  }
  if (!ArticleRecordset_hasData) MM_offset = i;  // set MM_offset to the last possible record
}
%>
<%
// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; ArticleRecordset_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    ArticleRecordset_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!ArticleRecordset_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!ArticleRecordset_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  ArticleRecordset.close();
  ArticleRecordset = StatementArticleRecordset.executeQuery();
  ArticleRecordset_hasData = ArticleRecordset.next();
  MM_rs = ArticleRecordset;

  // move the cursor to the selected record
  for (i=0; ArticleRecordset_hasData && i < MM_offset; i++) {
    ArticleRecordset_hasData = MM_rs.next();
  }
}
%>
<%
// *** Move To Record: update recordset stats

// set the first and last displayed record
ArticleRecordset_first = MM_offset + 1;
ArticleRecordset_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  ArticleRecordset_first = Math.min(ArticleRecordset_first, MM_rsCount);
  ArticleRecordset_last  = Math.min(ArticleRecordset_last, MM_rsCount);
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
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document </title>
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
            <table width="90%" border="0" cellpadding="0" cellspacing="1" class="text">
              <tr> 
                <td>&nbsp;</td>
                <td colspan="5">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td colspan="5"><strong>Article List</strong></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td colspan="5" align="right"><form name="form1" method="post" action="">
                 
				   <select name="categoryid">
				     <%
while (ArtiCatRecordset_hasData) {
%>
				     <option value="<%=((ArtiCatRecordset.getObject("categoryid")!=null)?ArtiCatRecordset.getObject("categoryid"):"")%>" <%=((categoryid.toString().equals(((((ArtiCatRecordset_data = ArtiCatRecordset.getObject("categoryid"))==null || ArtiCatRecordset.wasNull())?"":ArtiCatRecordset_data)).toString()))?"SELECTED":"")%> ><%=((ArtiCatRecordset.getObject("category_name")!=null)?ArtiCatRecordset.getObject("category_name"):"")%></option>
				     <%
  ArtiCatRecordset_hasData = ArtiCatRecordset.next();
}
ArtiCatRecordset.close();
StatementArtiCatRecordset.close();
ConnArtiCatRecordset.close();

//ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
//ArtiCatRecordset_hasData = ArtiCatRecordset.next();
//ArtiCatRecordset_isEmpty = !ArtiCatRecordset_hasData;
%>
                    </select>
				   <select name="aproval_status">
				   <option value=""></option>
				     <option value="0" <%=(("0".equals(aprovalStatus))?"SELECTED":"")%> >0</option>
				     <option value="1" <%=(("1".equals(aprovalStatus))?"SELECTED":"")%> >1</option>
					 <option value="2" <%=(("2".equals(aprovalStatus))?"SELECTED":"")%> >2</option>
				     <option value="3" <%=(("3".equals(aprovalStatus))?"SELECTED":"")%> >3</option>
					 <option value="4" <%=(("4".equals(aprovalStatus))?"SELECTED":"")%> >4</option>
				     <option value="5" <%=(("5".equals(aprovalStatus))?"SELECTED":"")%> >5</option>
					 <option value="6" <%=(("6".equals(aprovalStatus))?"SELECTED":"")%> >6</option>
				     <option value="7" <%=(("7".equals(aprovalStatus))?"SELECTED":"")%> >7</option>
					 <option value="8" <%=(("8".equals(aprovalStatus))?"SELECTED":"")%> >8</option>
				     <option value="9" <%=(("9".equals(aprovalStatus))?"SELECTED":"")%> >9</option>
					 <option value="10" <%=(("10".equals(aprovalStatus))?"SELECTED":"")%> >10</option>
				   </select>
					
                  <input type="submit" name="Submit" value="Submit">
                </form></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="4%">Article Id</td>
                <td><strong>Title</strong></td>
                
                <td><strong>Category </strong></td>
                <td><strong>Priority</strong></td>
                <td><strong>Edit</strong></td>
				<td><strong>Edit</strong></td>
              </tr>
              <% while ((ArticleRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <tr  <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"C8E4FF\" ");}%> > 
                <td><%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></td>
                <td><a class="rc_heading" href="/rcsitepage/<%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>ai-<%=(((ArticleRecordset_data = ArticleRecordset.getObject("alias"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" target="_blank"><%=(((ArticleRecordset_data = ArticleRecordset.getObject("title"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></a>
				<% if(Config.getValue("newsenabled")!=null &&
			"1".equals(Config.getValue("newsenabled").trim())){%>
				&nbsp;&nbsp;<a href="../news/page.jsp?articleid=<%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" target="_blank">news</a>
				<%}%>
				</td>
             
                <td><%=(((ArticleRecordset_data = ArticleRecordset.getObject("category_name"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></td>
                <td align="left"><%=(((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></td>
                <td><a href="articlesedit.jsp?articleid=<%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>">Edit</a></td>
				 <td><a href="articlesedit.jsp?articleid=<%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>&html=true">Edit HTML</a></td>
              </tr>
              <%
  Repeat1__index++;
  ArticleRecordset_hasData = ArticleRecordset.next();
}
%>
              <tr> 
                <td>&nbsp;</td>
                <td colspan="4">&nbsp; <table border="0" width="50%" align="center">
                    <tr> 
                      <td width="23%" align="center"> <% if (MM_offset !=0) { %>
                        <a href="<%=MM_moveFirst%>">First</a> 
                        <% } /* end MM_offset != 0 */ %> </td>
                      <td width="31%" align="center"> <% if (MM_offset !=0) { %>
                        <a href="<%=MM_movePrev%>">Previous</a> 
                        <% } /* end MM_offset != 0 */ %> </td>
                      <td width="23%" align="center"> <% if (!MM_atTotal) { %>
                        <a href="<%=MM_moveNext%>">Next</a> 
                        <% } /* end !MM_atTotal */ %> </td>
                      <td width="23%" align="center"> <% if (!MM_atTotal) { %>
                        <a href="<%=MM_moveLast%>">Last</a> 
                        <% } /* end !MM_atTotal */ %> </td>
                    </tr>
                  </table></td>
                <td>&nbsp;</td>
              </tr>
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
ArticleRecordset.close();
StatementArticleRecordset.close();
ConnArticleRecordset.close();
%>
