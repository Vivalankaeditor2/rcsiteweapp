<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.io.*" errorPage="" %>
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
  MM_editTable  = "articles";
  MM_editColumn = "article_id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "";
 // String MM_fieldsStr = "title|value|description|value|image|value|details|value|author_name|value|author_intro|value|aproval_status|value";
  String MM_fieldsStr = "title|value|description|value|image|value|details|value|author_name|value|author_intro|value|aproval_status|value|editor_name|value|editor_email|value|categoryid|value|url|value|alias|value|image|value|thumbnail|value";
  //String MM_columnsStr = "title|',none,''|description|',none,''|image|',none,''|details|',none,''|author_name|',none,''|author_intro|',none,''|aproval_status|',none,''";
  String MM_columnsStr = "title|',none,''|description|',none,''|image|',none,''|details|',none,''|author_name|',none,''|author_intro|',none,''|aproval_status|',none,''|editor_name|',none,''|editor_email|',none,''|categoryid|none,none,NULL|url|',none,''|alias|',none,''|image|',none,''|thumbnail|',none,''";

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
  
 	String alias ="";
 	String  title  = request.getParameter("title");
 
 	if(title!=null && title.length()>0){
	 	alias = title.trim().toLowerCase();
		alias =alias.replaceAll("[^a-zA-Z0-9]","-").toLowerCase();
		alias = alias.replaceAll("\\-{2,20}","-");
		alias = alias.replaceAll("\\-{1,20}$","");
		alias = alias.replaceAll("^\\-{1,20}","");
		MM_fields[23] = alias;
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
 //   Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection = rcsiteDS.getConnection();
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(MM_editQuery.toString());
    MM_editStatement.executeUpdate();
    MM_editStatement.close();
    MM_connection.close();
	pageMessage="article has been successfully updated";

    // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0) {
      response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl));
      return;
    }
  }
}
%>
<%
String ArticleRecordset__MMColParam = "1";
int previousOne =1;
int nextOne =3;

if (request.getParameter("articleid") !=null) {
ArticleRecordset__MMColParam = (String)request.getParameter("articleid");
previousOne =Integer.parseInt(ArticleRecordset__MMColParam) -1;
nextOne = Integer.parseInt(ArticleRecordset__MMColParam) +1;
    
}
%>
<%
Connection ConnArticleRecordset = rcsiteDS.getConnection();
PreparedStatement StatementArticleRecordset = ConnArticleRecordset.prepareStatement("SELECT *  FROM articles  WHERE article_id = " + ArticleRecordset__MMColParam + "");
ResultSet ArticleRecordset = StatementArticleRecordset.executeQuery();
	
boolean ArticleRecordset_isEmpty = !ArticleRecordset.next();
boolean ArticleRecordset_hasData = !ArticleRecordset_isEmpty;
Object ArticleRecordset_data;
int ArticleRecordset_numRows = 0;
%>
<%
if(ArticleRecordset_isEmpty){
		String redirect = request.getRequestURL().toString();
		
		pageMessage="Sorry...Article could be not found." ;
		redirect += "?pagemessage="+pageMessage;//+"&articleid="+ArticleRecordset__MMColParam;


        response.sendRedirect(response.encodeRedirectURL(redirect));
      	return;

}
%>
<%
String ArtiCatRecordset__MMColParam = "main";
if (request.getParameter("level") !=null) {ArtiCatRecordset__MMColParam = (String)request.getParameter("level");}
%>
<%
Connection ConnArtiCatRecordset = rcsiteDS.getConnection();
PreparedStatement StatementArtiCatRecordset = ConnArtiCatRecordset.prepareStatement("SELECT categoryid, category_name FROM article_category WHERE level <> '" + ArtiCatRecordset__MMColParam + "' ORDER BY priority DESC");
ResultSet ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
boolean ArtiCatRecordset_isEmpty = !ArtiCatRecordset.next();
boolean ArtiCatRecordset_hasData = !ArtiCatRecordset_isEmpty;
Object ArtiCatRecordset_data;
int ArtiCatRecordset_numRows = 0;
%>
<!DOCTYPE HTML>
<html lang="en" ><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="javascript" type="text/javascript" src="../jscripts/fulleditor.js"></script>
<script src="../js/tinymce/tinymce.min.js" referrerpolicy="origin"></script>
    <script>
      tinymce.init({
    	      
    	 plugins: [
    		    'advlist', 'anchor', 'autolink', 'charmap', 'code', 'fullscreen',
    		    'help', 'image', 'insertdatetime', 'link', 'lists', 'media',
    		    'preview', 'searchreplace', 'table', 'fullscreen', 'tableofcontents', 'wordcount',
    		    'visualblocks', 'inlinecss'
    		  ],
    		  
    		
              selector: '#editArticleDetails' 
        
        
        
      });
      
      
    </script>
    
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
              <jsp:include page="adminleftnavi.jsp?screen=article" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table border="0" align="center" cellpadding="0" cellspacing="0" class="text">
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Edit Article</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td align="right"><strong><a href="articlesedit.jsp?articleid=<%=previousOne%><% if(request.getParameter("html")!=null) out.print("&html=true");%>">&lt;Previous</a> 
                    | <%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%> | <a href="articlesedit.jsp?articleid=<%=nextOne%><% if(request.getParameter("html")!=null) out.print("&html=true");%>">Next&gt;</a></strong></td>
                </tr>
                <tr valign="baseline">
                  <td nowrap align="right">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Article id: <%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Title:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="title" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("title"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" size="40"> 
                  </td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Image:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="image" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("image"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" size="40"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Description:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="description" cols="80" rows="20" ><%=(((ArticleRecordset_data = ArticleRecordset.getObject("description"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></textarea> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Details:</strong> </td>
                </tr>
                <tr>                   <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="details" id="editArticleDetails" cols="130" rows="70" <% if(request.getParameter("html")==null) out.print(" class=\"mceEditor\" ");%>><%=(((ArticleRecordset_data = ArticleRecordset.getObject("details"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Author name:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="author_name" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("author_name"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Author introduction:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"><textarea name="author_intro" cols="60" rows="5" mce_editable="false"><%=(((ArticleRecordset_data = ArticleRecordset.getObject("author_intro"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></textarea></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Entry date:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td><%=(((ArticleRecordset_data = ArticleRecordset.getObject("entry_date"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Category:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td> <select name="categoryid">
                      <%
while (ArtiCatRecordset_hasData) {
%>
                      <option value="<%=((ArtiCatRecordset.getObject("categoryid")!=null)?ArtiCatRecordset.getObject("categoryid"):"")%>" <%=(((ArtiCatRecordset.getObject("categoryid")).toString().equals(((((ArticleRecordset_data = ArticleRecordset.getObject("categoryid"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)).toString()))?"SELECTED":"")%> ><%=((ArtiCatRecordset.getObject("category_name")!=null)?ArtiCatRecordset.getObject("category_name"):"")%></option>
                      <%
  ArtiCatRecordset_hasData = ArtiCatRecordset.next();
}
ArtiCatRecordset.close();
ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
ArtiCatRecordset_hasData = ArtiCatRecordset.next();
ArtiCatRecordset_isEmpty = !ArtiCatRecordset_hasData;
%>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Priority</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"> <div align="left"></div></td>
                  <td> <select name="aproval_status">
                      <option value="0"  <%=(("0".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>0</option>
                      <option value="1"  <%=(("1".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>1</option>
                      <option value="2"  <%=(("2".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>2</option>
                      <option value="3"  <%=(("3".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>3</option>
                      <option value="4"  <%=(("4".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>4</option>
                      <option value="5"  <%=(("5".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>5</option>
                      <option value="6"  <%=(("6".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>6</option>
                      <option value="7"  <%=(("7".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>7</option>
                      <option value="8"  <%=(("8".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>8</option>
                      <option value="9"  <%=(("9".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>9</option>
                      <option value="10"  <%=(("10".toString().equals((((ArticleRecordset_data = ArticleRecordset.getObject("aproval_status"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)))?"SELECTED":"")%>>10</option>
                    </select>
                    0=Rejected 10= Highest priority</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Editor name:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td> <input type="text" name="editor_name" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("editor_name"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Editor email:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td> <input type="text" name="editor_email" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("editor_email"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Thumbnail:</strong></td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td><input type="text" name="thumbnail" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("Thumbnail"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" size="50"></td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>URL:</strong></td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td><input type="text" name="url" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("url"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" size="50"></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Alias:</strong></td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td><%=(((ArticleRecordset_data = ArticleRecordset.getObject("alias"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="submit" value="Update Article" > </td>
                </tr>
              </table>

  <input type="hidden" name="image" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("image"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>" size="32">
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((ArticleRecordset_data = ArticleRecordset.getObject("article_id"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%>">
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
ArticleRecordset.close();
StatementArticleRecordset.close();
ConnArticleRecordset.close();
%>
<%
ArtiCatRecordset.close();
StatementArtiCatRecordset.close();
ConnArtiCatRecordset.close();
%>
