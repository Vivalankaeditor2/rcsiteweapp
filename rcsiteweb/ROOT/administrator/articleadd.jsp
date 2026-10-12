<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="java.sql.*, com.rev_creations.persistence.dao.*, com.rev_creations.rcsite.*,com.rev_creations.util.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
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
ImageHelper imageHelper = null;

String imagePath = null,newImagePath = null, imageFolder =null ;
%>
<%
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "articles";
  MM_editRedirectUrl = "../administrator/SearchArticle.jsp?pagemessage=article has been successfully submited.";
  imageHelper = new ImageHelper();
  imageFolder = "C:\\inetpub\\vhosts\\vivalanka.com\\httpdocs";
  int articleCountMax =3;
  if(request.getParameter("title2").length() <3 || "1".equals(request.getParameter("skip")) ){
	  articleCountMax =2;
  }
  for (int articleCount = 1; articleCount < articleCountMax; articleCount++) {
	//  String articleCount ="";
	  System.out.println(articleCount);  
	  
  String MM_fieldsStr = "title"+articleCount+"|value|description"+articleCount+"|value|details"+articleCount+"|value|author_name"+articleCount+"|value|author_intro"+articleCount+"|value|aproval_status"+articleCount+"|value|editor_name"+articleCount+"|value|editor_email"+articleCount+"|value|categoryid"+articleCount+"|value'|dcode"+articleCount+"|',none,'|entry_date"+articleCount+"|value|url"+articleCount+"|value|alias"+articleCount+"|value|thumbnail"+articleCount+"|value|image"+articleCount+"|value|process_status"+articleCount+"|value|";
 // String MM_columnsStr = "title|',none,''|description|',none,''|details|',none,''|author_name|',none,''|author_intro|',none,''|aproval_status|',none,''|editor_name|',none,''|editor_email|',none,''";
  String MM_columnsStr = "title|',none,''|description|',none,''|details|',none,''|author_name|',none,''|author_intro|',none,''|aproval_status|',none,''|editor_name|',none,''|editor_email|',none,''|categoryid|none,none,NULL'|dcode|',none,''|entry_date|',none,none'|url|',none,''|alias|',none,''|thumbnail|',none,''|image|',none,''|process_status|',none,''";
 // System.out.println(MM_fieldsStr); 
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
  MM_fields[21] = (new java.text.SimpleDateFormat("yy-MM-dd HH:mm:ss")).format((new java.util.Date() ));
 String alias ="";
 String  title  = request.getParameter("title"+articleCount);
 
 if(title!=null && title.length()>0){
 	alias = title.trim().toLowerCase();

	System.out.println(alias);
	alias = alias.replaceAll("\\.$","");
	System.out.println(alias);
	alias =alias.replaceAll("[^a-zA-Z0-9]","-").toLowerCase();
	System.out.println(alias);
	alias = alias.replaceAll("\\-{2,4}","-");
	System.out.println(alias);
	MM_fields[25] = alias;
 }
 String imageCaption  = request.getParameter("image_caption"+articleCount);
 System.out.println("imageCaption: " +imageCaption);
 System.out.println("MM_fields[29]: " +MM_fields[29]);
 imagePath =  MM_fields[29].replace("/", "\\").replace("..", imageFolder);
 System.out.println("imagePath: " +imagePath);
 boolean isSinhala = false;
 if(articleCount==2){
	 isSinhala = true;
 }
 if(!isSinhala){
 newImagePath = imageHelper.writeOnImage( imagePath, imageCaption, isSinhala );
 }
 System.out.println("newImagePath: " +newImagePath);
 MM_fields[29] = newImagePath.replace(imageFolder, "..").replace("\\","/");
 System.out.println("MM_fields[29]: " +MM_fields[29]);
 
  // append the query string to the redirect URL
  if (MM_editRedirectUrl.length() != 0 && request.getQueryString() != null) {
    MM_editRedirectUrl += ((MM_editRedirectUrl.indexOf('?') == -1)?"?":"&") + request.getQueryString();
  }
//}
%>
<%System.out.println("entry_date1: " +request.getParameter("entry_date1"));
System.out.println("entry_date2: " +request.getParameter("entry_date2"));
%>
<%
// *** Insert Record: construct a sql insert statement and execute it

//if (request.getParameter("MM_insert") != null) { //Start inserting article

  // create the insert sql statement
  StringBuffer MM_tableValues = new StringBuffer(), MM_dbValues = new StringBuffer();
  for (int i=0; i+1 < MM_fields.length; i+=2) {
    String formVal = MM_fields[i+1];
    String elem;
    java.util.StringTokenizer formValTokens = new java.util.StringTokenizer(MM_columns[i+1],",");
    String delim    = ((elem = (String)formValTokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    String altVal   = ((elem = (String)formValTokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    String emptyVal = ((elem = (String)formValTokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
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
    //Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection = rcsiteDS.getConnection();
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(MM_editQuery.toString());
   // System.out.println("MM_editQuery.toString()"+MM_editQuery.toString()); 
    MM_editStatement.executeUpdate();
    MM_connection.close();


  }
} // end for loop
// redirect with URL parameters
if (MM_editRedirectUrl.length() != 0) {
  response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl));
  return;
}
} //end inserting article
%>
<% //AI Article generation starts
String ArtiCatRecordset__MMColParam = "main";
if (request.getParameter("level") !=null) {ArtiCatRecordset__MMColParam = (String)request.getParameter("level");}
%>
<%
//Driver DriverArtiCatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnArtiCatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnArtiCatRecordset = rcsiteDS.getConnection();
PreparedStatement StatementArtiCatRecordset = ConnArtiCatRecordset.prepareStatement("SELECT categoryid, category_name FROM article_category WHERE level <> '" + ArtiCatRecordset__MMColParam + "' ORDER BY priority DESC");
ResultSet ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
boolean ArtiCatRecordset_isEmpty = !ArtiCatRecordset.next();
boolean ArtiCatRecordset_hasData = !ArtiCatRecordset_isEmpty;
Object ArtiCatRecordset_data;
int ArtiCatRecordset_numRows = 0;
%>
<%
String theApiKey = com.rev_creations.rcsite.Config.getValue("ai.apikey");
String theApiKeyClaude = com.rev_creations.rcsite.Config.getValue("ai.apikey.claude");
String systemRoleContent = com.rev_creations.rcsite.Config.getValue("ai.newsarticle.systemprompt");
String userRoleContent= com.rev_creations.rcsite.Config.getValue("ai.newsarticle.userprompt")+" " ;
Map<String, Object> aiResultMapEnglish;
Map<String, Object> aiResultMapSinhala;
Articles[] articleArray = new Articles[2];
String[] imageCaptionArray = new String[2];
AIArticleGenerator aiArticleGenerator = new AIArticleGenerator();

Articles article = null;
String urls="";
String thumbnail="";
String image ="";
String details="";
String wordCount="";
String creativity="";
String newsStyle="";
String newImageUrl="";
double creativityNumber = .1;
int intWordCount = 300;

thumbnail = request.getParameter("thumbnail");
if("uploadedimage".equals(thumbnail)){
	thumbnail = request.getParameter("uploadedimageurl");
}
if(thumbnail != null ){
	image = thumbnail.replace("tn","");
}

creativity = request.getParameter("creativity");
creativityNumber = Double.parseDouble(creativity);

wordCount = request.getParameter("wordCount");
intWordCount = Integer.parseInt(wordCount);

newsStyle = request.getParameter("newsStyle");

newImageUrl = request.getParameter("newImageUrl");
userRoleContent = userRoleContent+" It should be a "+ wordCount +"-word news article in the "+ newsStyle+" ";

String[] selectedValues = request.getParameterValues("additionalOption");

for (int i = 0; i < selectedValues.length; i++) {
    String articleNumber= selectedValues[i];
    
    userRoleContent =userRoleContent+request.getParameter("description"+articleNumber);
    userRoleContent =userRoleContent+request.getParameter("title"+articleNumber);
    urls = urls + "<br>" + request.getParameter("url" + articleNumber);
     
}

System.out.println("userRoleContent " + userRoleContent  );

aiArticleGenerator.setApiKey(theApiKey);
aiArticleGenerator.setTemperature(creativityNumber);

//Generate English article
//systemRoleContent = "Please translate to English. "+systemRoleContent;
aiArticleGenerator.setSystemRoleContent("Please translate to English. "+systemRoleContent);
aiResultMapEnglish = aiArticleGenerator.getNewsArticles(systemRoleContent,userRoleContent, true);
article = (Articles)aiResultMapEnglish.get("Articles");
imageCaptionArray[0] =(String) aiResultMapEnglish.get("ShortDescription");
details="<img style=\"float: left; padding: 10px;\" title=\"\" role=\"\" src=\" "+ thumbnail.replace("tn","")+"\" alt=\"\" >"+article.getDetails();

//translate article to Sinhala 
systemRoleContent = "Please translate to Sinhala. "+ systemRoleContent ;
userRoleContent = "Title: " + article.getTitle()+ " Description: " +article.getDescription()+ " Details: " +article.getDetails();
aiArticleGenerator.setApiKeyClaude(theApiKeyClaude);


try{
	aiResultMapEnglish = aiArticleGenerator.translateArticle(systemRoleContent,userRoleContent, true);
	articleArray[1] = (Articles)aiResultMapEnglish.get("Articles");
	imageCaptionArray[1] =(String) aiResultMapEnglish.get("ShortDescription");
} catch (Exception e) {
	System.out.println("Error occurred " + e);
	articleArray[1] = new Articles();
	articleArray[1].setTitle("");
	articleArray[1].setDescription("");
	articleArray[1].setDetails("");
	imageCaptionArray[1] ="";
}

%>
<!DOCTYPE HTML>
<html><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="../js/tinymce/tinymce.min.js" referrerpolicy="origin"></script>
    <script>
      tinymce.init({
    	      
    	 plugins: [
    		    'advlist', 'anchor', 'autolink', 'charmap', 'code', 'fullscreen',
    		    'help', 'image', 'insertdatetime', 'link', 'lists', 'media',
    		    'preview', 'searchreplace', 'table', 'fullscreen', 'tableofcontents', 'wordcount',
    		    'visualblocks', 'inlinecss'
    		  ],
    		  
    		
              selector: '#addArticleDetails'
        
        
        
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
          <td width="40%">&nbsp;<!--%=bannerCode%--></td>
          <td width="40%">&nbsp;<!--%=bannerCode%--></td>
          <td width="7%">&nbsp;</td>
  </tr>
  <tr valign="top"> 
  <form method="post" action="<%=MM_editAction%>" name="form1">
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --> 
            <jsp:include page="../administrator/adminleftnavi.jsp?screen=article" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->

              <table border="0" align="center" cellpadding="0" cellspacing="0" class="text">
                <tr valign="baseline">
                  <td align="right" nowrap>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td><strong>Add Articles</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td><strong>Title:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td width="10" align="right" nowrap><div align="left"></div></td>
                  <td width="1000"> <input type="text" name="title1" value="<%= article.getTitle() %>" size="50"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Description:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="description1" cols="60" rows="5" mce_editable="false"><%= article.getDescription() %></textarea> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Details: </strong></td>
                </tr>
                <tr> 
                <td nowrap align="right" valign="top">
                <div align="left"></div>
                </td>
                  <td valign="baseline"> 
                 <textarea name="details1"  id="addArticleDetails" cols="100" rows="40" ><%= details %></textarea>
                </td>
                 </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Author Name:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="author_name1" value="VivaLanka.com" size="32"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Author Introduction:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="author_intro1" cols="60" rows="5" mce_editable="false"><%= urls %></textarea> 
                  </td>
                </tr>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Image:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="image1" cols="60" rows="1" mce_editable="false"><%= image %></textarea> 
                  </td>
                </tr>
                 <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Image caption:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="image_caption1" cols="60" rows="1" mce_editable="false"><%= imageCaptionArray[0] %></textarea> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Thumbnail:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="thumbnail1" cols="60" rows="1" mce_editable="false"><%= thumbnail %></textarea> 
                  </td>
                </tr>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Category:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td> <select name="categoryid1">
                      <%
while (ArtiCatRecordset_hasData) {
%>
                      <option value="<%=((ArtiCatRecordset.getObject("categoryid")!=null)?ArtiCatRecordset.getObject("categoryid"):"")%>" 
                      <%=((("90").toString().equals(((((ArtiCatRecordset_data = ArtiCatRecordset.getObject("categoryid"))==null || ArtiCatRecordset.wasNull())?"":ArtiCatRecordset_data)).toString()))?"SELECTED":"")%>
                      
                      ><%=((ArtiCatRecordset.getObject("category_name")!=null)?ArtiCatRecordset.getObject("category_name"):"")%></option>
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
                  <td><strong>Priority/Aproval Status:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <select name="aproval_status1">
                      <option value="0">0</option>
                      <option value="1">1</option>
                      <option value="2">2</option>
                      <option value="3">3</option>
                      <option value="4">4</option>
                      <option value="5">5</option>
                      <option value="6">6</option>
                      <option value="7">7</option>
                      <option value="8">8</option>
                      <option value="9">9</option>
                      <option value="10" selected>10</option>
                    </select>
                    0=Rejected 10= Highest priority </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Editor Name:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="editor_name1" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Editor Email:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="editor_email1" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>URL:</strong></td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td><input type="text" name="url1" value="" size="50"></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="submit" value="Insert Record" > 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> 
                  		<input name="dcode1" type="hidden" id="dcode" value="<%=(String)session.getValue("dcode")%>">
                  		<input name="process_status1" type="hidden" id="process_status" value="|initial_entry|">
                  		<input name="entry_date1_" type="hidden" id="entry_date" value="<%= (new java.text.SimpleDateFormat("yy-MM-dd HH:mm:ss")).format((new java.util.Date()))%>">
                  
                  <button><a href="ArticleSearchResult.jsp" >Go Back</a></button>
                  <script>
                    function goBack() {
                      window.history.back();
                      }
                    </script>
                  </td>
                </tr>
           
              </table>




<p>&nbsp;</p>

<!-- InstanceEndEditable --></td>

<td><!-- InstanceBeginEditable name="MainEditRegion" Sinhala-->
<%
article = articleArray[1];
details="<img style=\"float: left; padding: 10px;\" title=\"\" role=\"\" src=\" "+ thumbnail.replace("tn","")+"\" alt=\"\" >"+article.getDetails();
%>

              <table border="0" align="center" cellpadding="0" cellspacing="0" class="text">

                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td><strong>Add Articles</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="right" nowrap>&nbsp;</td>
                  <td><strong>Title:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td width="10" align="right" nowrap><div align="left"></div></td>
                  <td width="1000"> <input type="text" name="title2" value=" <%= article.getTitle() %>" size="50"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Description:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="description2" cols="60" rows="5" mce_editable="false"> <%= article.getDescription() %></textarea> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Details: </strong></td>
                </tr>
                <tr> 
                <td nowrap align="right" valign="top">
                <div align="left"></div>
                </td>
                  <td valign="baseline"> 
                 <textarea name="details2"  id="addArticleDetails" cols="100" rows="40" ><%= details %></textarea>
                </td>
                 </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Author Name:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="author_name2" value="VivaLanka.com" size="32"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Author Introduction:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="author_intro2" cols="60" rows="5" mce_editable="false"><%= urls %></textarea> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Image:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="image2" cols="60" rows="1" mce_editable="false"><%= image %></textarea> 
                  </td>
                </tr>
                 <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Image Caption:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="image_caption2" cols="60" rows="1" mce_editable="false"><%= imageCaptionArray[1]%></textarea> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top">&nbsp;</td>
                  <td valign="baseline"><strong>Thumbnail:</strong></td>
                </tr>
                <tr> 
                  <td nowrap align="right" valign="top"><div align="left"></div></td>
                  <td valign="baseline"> <textarea name="thumbnail2" cols="60" rows="1" mce_editable="false"><%= thumbnail %></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Category:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td> <select name="categoryid2">
                      <%
while (ArtiCatRecordset_hasData) {
%>
                      <option value="<%=((ArtiCatRecordset.getObject("categoryid")!=null)?ArtiCatRecordset.getObject("categoryid"):"")%>" 
                      <%=((("91").toString().equals(((((ArtiCatRecordset_data = ArtiCatRecordset.getObject("categoryid"))==null || ArtiCatRecordset.wasNull())?"":ArtiCatRecordset_data)).toString()))?"SELECTED":"")%>
                      
                      ><%=((ArtiCatRecordset.getObject("category_name")!=null)?ArtiCatRecordset.getObject("category_name"):"")%></option>
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
                  <td><strong>Priority/Aproval Status:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <select name="aproval_status2">
                      <option value="0">0</option>
                      <option value="1">1</option>
                      <option value="2">2</option>
                      <option value="3">3</option>
                      <option value="4">4</option>
                      <option value="5">5</option>
                      <option value="6">6</option>
                      <option value="7">7</option>
                      <option value="8">8</option>
                      <option value="9">9</option>
                      <option value="10" selected>10</option>
                    </select>
                    0=Rejected 10= Highest priority </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Editor Name:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="editor_name2" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>Editor Email:</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="text" name="editor_email2" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="right">&nbsp;</td>
                  <td><strong>URL:</strong></td>
                </tr>
				<tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td><input type="text" name="url2" value="" size="50"></td>
                </tr>
                <tr valign="baseline"> 
                <td nowrap align="right"><div align="left"></div></td>
                <td>
                <label>
                <input type="checkbox" name="skip" value="1">
                 Skip
                </label>
                </td>
                </tr>
                <br>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> <input type="submit" value="Insert Record" > 
                  </td>
                </tr>
                <br>
                <tr valign="baseline"> 
                  <td nowrap align="right"><div align="left"></div></td>
                  <td> 
                  	<input name="dcode2" type="hidden" id="dcode" value="<%=(String)session.getValue("dcode")%>">
                  	<input name="process_status2" type="hidden" id="process_status" value="|initial_entry|">
                  		<%
                  		java.util.Date entryDate2 = new java.util.Date();
                  		entryDate2.setSeconds(entryDate2.getSeconds() + 5);%>
					<input name="entry_date2_" type="hidden" id="entry_date" value="<%= (new java.text.SimpleDateFormat("yy-MM-dd HH:mm:ss")).format((entryDate2))%>">
                  
                  <button><a href="ArticleSearchResult.jsp" >Go Back</a></button>
                  <script>
                    function goBack() {
                      window.history.back();
                      }
                    </script>
                  </td>
                </tr>
           
              </table>




<p>&nbsp;</p>

<!-- InstanceEndEditable Sinhala --></td>

    <td>&nbsp;</td>
      <input type="hidden" name="MM_insert" value="form1">
    </form>
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
ArtiCatRecordset.close();
StatementArtiCatRecordset.close();
ConnArtiCatRecordset.close();
%>
