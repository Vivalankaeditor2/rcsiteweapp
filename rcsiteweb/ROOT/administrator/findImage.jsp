<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.apache.solr.client.solrj.SolrServer" %>
<%@ page import="org.apache.solr.client.solrj.SolrServerException" %>
<%@ page import="org.apache.solr.client.solrj.impl.HttpSolrServer" %>
<%@ page import="org.apache.solr.client.solrj.response.QueryResponse" %>
<%@ page import="org.apache.solr.common.SolrDocument" %>
<%@ page import="org.apache.solr.common.params.ModifiableSolrParams" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.time.LocalDate, java.time.ZoneOffset,java.time.format.DateTimeFormatter,java.time.format.DateTimeParseException" %>

<%
DateTimeFormatter formatter  = DateTimeFormatter.ofPattern("yyyy-MM-dd");

String StartDate =  ((LocalDate.now()).minusDays(1)).format(formatter); 
String EndDate = ((LocalDate.now()).minusDays(-1)).format(formatter);;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Local Image Search</title>
    
 <link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" --> 
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>

<!-- InstanceEndEditable -->

</head>
<body>

  
<div class="content">
    <h1>Local Image Search</h1>
     
 <form action="" method="post" class="search-form">
        <input type="hidden" name="formId" value="<%= System.currentTimeMillis()%>">
        
        <div class="input-group6">
            <label class="input-label" for="SearchTerm">Search:</label>
            <input type="text" id="SearchTerm" name="SearchTerm" required>       
               <div class="action-buttons">
                   <button type="submit" class="submit-btn">Submit</button>&nbsp;&nbsp;
                <a href="../administrator/upload.jsp?dir=media3" class="back-btn">Back</a>
              </div>

        </div> 
    </form>
    
    <%
        SolrServer server = new HttpSolrServer("https://www.vivalanka.com/rcsearch");
   		   		
   		String wordCountDefault = com.rev_creations.rcsite.Config.getValue("ai.newsarticle.wordcount.default");
   		String creativityDefault = com.rev_creations.rcsite.Config.getValue("ai.newsarticle.creativity.default");
   		String newsStyleDefault = com.rev_creations.rcsite.Config.getValue("ai.newsarticle.newsStyle.default");
   
        ModifiableSolrParams params = new ModifiableSolrParams();
        params.set("qt", "/news");
        params.set("fl", "title,category,url,content,thumbnail,lastModified,site");
        params.set("q", request.getParameter("SearchTearm"));
       
        QueryResponse qresponse = server.query(params);
       System.out.println("response = " + qresponse);

        List<SolrDocument> testList = qresponse.getResults();
    %>
    
    <% int counter = 0;
        for (Iterator iterator = testList.iterator(); iterator.hasNext();) {
            counter++;     
        SolrDocument document = (SolrDocument)iterator.next();
    %>
   
       <table>
    <tr>
        <td width="9%"><img src="<%= document.getFieldValue("thumbnail") %>" alt="Image" /></td>
        <td><input type="text" value="<%= document.getFieldValue("url") %>" /></td>
    </tr>
</table>

    </div>
   

    <%
        }
    %>
      
<br>
</body>
</html>
