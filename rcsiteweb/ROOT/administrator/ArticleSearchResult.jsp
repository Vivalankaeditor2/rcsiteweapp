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
<%!
public static String convertDateToSolrFormat(String date) {
    try {
        // Define the input and output date formats
        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");

        // Parse the input date string
        LocalDate localDate = LocalDate.parse(date, inputFormatter);

        // Convert to the required format
        String formattedDate = localDate.atStartOfDay().atOffset(ZoneOffset.UTC).format(outputFormatter);

        return formattedDate;
    } catch (DateTimeParseException e) {
        e.printStackTrace();
        return "*";
    }
}
%>
<%
DateTimeFormatter formatter  = DateTimeFormatter.ofPattern("yyyy-MM-dd");

String StartDate =  ((LocalDate.now()).minusDays(1)).format(formatter); 
String EndDate = ((LocalDate.now()).minusDays(-1)).format(formatter);;
%>

<%
String pageMessage="";
if (request.getParameter("pagemessage") !=null) {
pageMessage = (String)request.getParameter("pagemessage");
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Article Search Result</title>
    
 <link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" --> 
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>

<!-- InstanceEndEditable -->

</head>
<body>
<table width="100%" border="0" cellpadding="2"  cellspacing="0" bgcolor="e8ad03">
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
        <tr bgcolor="e8ad03"> 
          <td width="20%">&nbsp;</td>
          <td width="80%">&nbsp;<!--%=bannerCode%--></td>
          <td width="10%">&nbsp;</td>
  </tr>
  <tr valign="top"> 
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --> 
            <jsp:include page="../administrator/adminleftnavi.jsp?screen=article" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
  
<div class="content">
<font color="#FF0000"><strong><%=pageMessage%></strong></font>
    <h1>Article Search Result</h1>
   
 <form action="ArticleSearchResult.jsp" method="post" class="search-form">
        <input type="hidden" name="formId" value="<%= System.currentTimeMillis()%>">
        
        <div class="input-group6">
            <label class="input-label" for="SearchTerm">Search:</label>
            <input type="text" id="SearchTerm" name="SearchTerm" required>
        </div>

        <div class="input-group">
            <label class="input-label" for="startDate">Start Date:</label>
            <input type="date" value="<%= StartDate %>" id="startDate" name="startDate">
        </div>

        <div class="input-group">
            <label class="input-label" for="endDate">End Date:</label>
            <input type="date" value="<%= EndDate %>" id="endDate" name="endDate">
        </div>

        <div class="input-group">
            <label class="input-label" for="category">Category:</label>
            <select id="category" name="category">
                <option value="Breaking News" selected>Breaking News</option>
                <option value="*">All Categories</option>
                <option value="Sports">Sports</option>
                <option value="Business">Business</option>
                <option value="Video">Video</option>
                <option value="Travel">Travel</option>
                <option value="Education">Education</option>
                <option value="Technology">Technology</option>
                <option value="Entertainment">Entertainment</option>
            </select>
        </div>

        <div class="action-buttons">
            <button type="submit" class="submit-btn">Submit</button>
            <button type="reset" class="reset-btn">Reset</button>
        </div>
    </form>
    
    
    <%
    
    
        SolrServer server = new HttpSolrServer("https://www.vivalanka.com/rcsearch");
   		 // Set date range
    	String startDate = request.getParameter("startDate") != null ? 
                       convertDateToSolrFormat(request.getParameter("startDate")) : 
                       ((LocalDate.now()).minusDays(1)).format(formatter);

        String endDate = request.getParameter("endDate") != null ? 
                     convertDateToSolrFormat(request.getParameter("endDate")) : 
                    	 ((LocalDate.now()).minusDays(-1)).format(formatter);
   		
   		String wordCountDefault = com.rev_creations.rcsite.Config.getValue("ai.newsarticle.wordcount.default");
   		String creativityDefault = com.rev_creations.rcsite.Config.getValue("ai.newsarticle.creativity.default");
   		String newsStyleDefault = com.rev_creations.rcsite.Config.getValue("ai.newsarticle.newsStyle.default");

   		String category = request.getParameter("category");   
    

        ModifiableSolrParams params = new ModifiableSolrParams();
        params.set("qt", "/news");
        params.set("fl", "title,category,url,content,thumbnail,lastModified,site");
        params.set("q", request.getParameter("SearchTearm"));
        params.set("fq", "lastModified:[" + startDate + " TO " + endDate + "]");
      	params.add("fq", "category:" + category );

        QueryResponse qresponse = server.query(params);
      //  System.out.println("response = " + qresponse);

        List<SolrDocument> testList = qresponse.getResults();
    %>
    
    <form action="articleadd.jsp" method="post">
    <% int counter = 0;
        for (Iterator iterator = testList.iterator(); iterator.hasNext();) {
            counter++;     
        SolrDocument document = (SolrDocument)iterator.next();
    %>
   
    <div class="result-container2">
        <div class="radio-group2">
            <label><input type="radio" name="thumbnail" value="<%= document.getFieldValue("thumbnail") %>"> Select image</label><br><br>
            <div class="checkbox-group2">
                <label><input type="checkbox" name="additionalOption" value="<%= counter %>"> Select Article</label>
            </div>
        </div>
        <div class="result-content2">
            <input type="text" name="title<%=counter%>" value="<%= document.getFieldValue("title") %>"><br>
            <input type="hidden" name="category" value="<%= document.getFieldValue("category") %>">
            <textarea name="description<%=counter%>" class="result-description2"><%=((String)document.getFieldValue("content")).replaceAll("\\<[^>]*>","") %></textarea><br>
            <input type="hidden" name="url<%=counter%>" value="<%= document.getFieldValue("url") %>">
           <div class="result-category2"><%= document.getFieldValue("site") %> - <%=new java.text.SimpleDateFormat("yyyy MMMM dd").format(document.getFieldValue("lastModified"))%> - <%= document.getFieldValue("category") %></div>
            <a class="result-link2" href="<%= document.getFieldValue("url") %>" target="_blank" >Read more</a><br>
        </div>
        <div class="image-box2">
            <img src="<%= document.getFieldValue("thumbnail") %>" alt="">
          
        </div>
    </div>
   
    

    <%
        }
    %>
      
<div class="option-group5">
    <label>
        <input type="radio" name="thumbnail" value="uploadedimage">
        Select image
    </label>
    <input type="text" name="uploadedimageurl" value="">
</div>
<div class="result-container2">
        <div class="radio-group2">
            <div class="checkbox-group2">
                <label><input type="checkbox" name="additionalOption" value=""> Select Article</label>
            </div>
        </div>
        <div class="result-content2">
           Title<br> <input type="text" name="title" value=""><br>
           Description <textarea name="description" class="result-description2"></textarea><br>
           Source URL <input type="text" name="url" value="">         
        </div>
        <div class="image-box2">
            <img src="" alt="">
       
        </div>
    </div>

</div>
<br>
   
<div class="dropdown-container2">
<div>
                               
 <label for="wordCount">Word Count:</label>
<select name="wordCount" id="wordCount">
    <option value="150"<%=(("150".equals(wordCountDefault))?"SELECTED":"")%>>150</option>   
    <option value="300" <%=(("300".equals(wordCountDefault))?"SELECTED":"")%> >300</option>
    <option value="500"<%=(("500".equals(wordCountDefault))?"SELECTED":"")%>>500</option>
    <option value="1000"<%=(("1000".equals(wordCountDefault))?"SELECTED":"")%>>1000</option>
    <option value="2000"<%=(("2000".equals(wordCountDefault))?"SELECTED":"")%>>2000</option>
</select>
</div>

    <div>
        <label for="creativity">Creativity:</label>
        <select name="creativity" id="creativity">
            <option value="0.1"<%=(("0.1".equals(creativityDefault))?"SELECTED":"")%>>0.1</option>
            <option value="0.2"<%=(("0.2".equals(creativityDefault))?"SELECTED":"")%>>0.2</option>
            <option value="0.3"<%=(("0.3".equals(creativityDefault))?"SELECTED":"")%>>0.3</option>
            <option value="0.4"<%=(("0.4".equals(creativityDefault))?"SELECTED":"")%>>0.4</option>
            <option value="0.5"<%=(("0.5".equals(creativityDefault))?"SELECTED":"")%>>0.5</option>
            <option value="0.6"<%=(("0.6".equals(creativityDefault))?"SELECTED":"")%>>0.6</option>
            <option value="0.7"<%=(("0.7".equals(creativityDefault))?"SELECTED":"")%>>0.7</option>
            <option value="0.8"<%=(("0.8".equals(creativityDefault))?"SELECTED":"")%>>0.8</option>
            <option value="0.9"<%=(("0.9".equals(creativityDefault))?"SELECTED":"")%>>0.9</option>
        </select>
    </div>

    <div>
        <label for="newsStyle">News Tone:</label>
        <select name="newsStyle" id="newsStyle">
            <option value="investigative Tone"<%=(("investigative Tone".equals(newsStyleDefault))?"SELECTED":"")%>>Investigative Tone</option>
            <option value="formal Tone"<%=(("formal Tone".equals(newsStyleDefault))?"SELECTED":"")%>>Formal Tone</option>
            <option value="serious Tone"<%=(("serious Tone".equals(newsStyleDefault))?"SELECTED":"")%>>Serious Tone</option>
            <option value="light-hearted Tone"<%=(("light-hearted Tone".equals(newsStyleDefault))?"SELECTED":"")%>>Light-hearted Tone</option>
            <option value="analytical Tone"<%=(("analytical Tone".equals(newsStyleDefault))?"SELECTED":"")%>>Analytical Tone</option>
            <option value="informative Tone"<%=(("informative Tone".equals(newsStyleDefault))?"SELECTED":"")%>>Informative Tone</option>
            <option value="objective Tone"<%=(("objective Tone".equals(newsStyleDefault))?"SELECTED":"")%>>Objective Tone</option>
        </select>
    </div>
</div>
  <br>
    <br> 
    </div>
     
    <input type="submit" id="submitBtn" class="submit-btn2" value="Submit">
    <br>
    <br>
    </form>
</div>


<script>
document.addEventListener('DOMContentLoaded', function() {
    var submitBtn = document.getElementById('submitBtn');
    var checkboxes = document.getElementsByClassName('articleCheckbox');
    var radioButtons = document.querySelectorAll('input[type="radio"]');
    
    function enableSubmit() {
        submitBtn.disabled = false;
    }                                                
    
    function checkSubmission(event) {
        var isChecked = false;
        
        
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].checked) {
                isChecked = true;
                break;
            }
        }
        
      
        if (!isChecked) {
            for (var i = 0; i < radioButtons.length; i++) {
                if (radioButtons[i].checked) {
                    isChecked = true;
                    break;
                }
            }
        }
        
        // If no checkbox or radio button is checked, prevent form submission
        if (!isChecked) {
            event.preventDefault(); 
            alert("Please click at least one Select Image & Select Article.");
        }
    }
    
    
    for (var i = 0; i < checkboxes.length; i++) {
        checkboxes[i].addEventListener('click', enableSubmit);
    }
    
    for (var i = 0; i < radioButtons.length; i++) {
        radioButtons[i].addEventListener('click', enableSubmit);
    }
    
   
    submitBtn.addEventListener('click', checkSubmission);
});
</script>


</body>
</html>
