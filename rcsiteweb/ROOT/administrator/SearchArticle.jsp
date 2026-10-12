<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.time.LocalDate, java.time.ZoneOffset,java.time.format.DateTimeFormatter,java.time.format.DateTimeParseException" %>
<%@ include file="checkadminlogin.jsp" %>
<%
DateTimeFormatter formatter  = DateTimeFormatter.ofPattern("yyyy-MM-dd");

String startDate =  ((LocalDate.now()).minusDays(1)).format(formatter); 
String endDate = ((LocalDate.now()).minusDays(-1)).format(formatter);;
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
<meta charset="ISO-8859-1">
<title>Search Article</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">


<style>
    body {
        font-family: Arial, sans-serif;
        background-color:white;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        padding-top: 56px; 
    }
    
    .container {
         background: rgb(253, 253, 254);
         background: radial-gradient(90deg, rgba(253, 253, 254, 1) 0%, rgba(7, 5, 106, 1) 2%);
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        max-width: 400px; /* Maximum width for larger screens */
        width: 90%; /* Take up 90% of smaller screens */
        margin: auto; /* Center the container */
    }

    .container h2 {
        text-align: center;
        margin-bottom: 20px;
        color: #333;
    }

    .container .form-group {
        margin-bottom: 12px;
    }

    .container .form-group label {
        display: block;
        margin-bottom: 5px;
        color: #333;
    }

    .container .form-group input,
    .container .form-group select {
        width: 100%; /* Full width for all screen sizes */
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 15px;
        box-sizing: border-box; 
    }
    
    .container .form-group input[type="text"] {
        height: 40px; 
    }

    .container .form-group input:focus,
    .container .form-group select:focus {
        border-color:#000099;
        outline: none;
    }

   .container .form-group .btn-group {
        display: flex;
        flex-wrap: wrap; 
        justify-content: space-between;
        margin-top: 20px;
    }

    .container .form-group .btn {
        flex: 1;
        margin-right: 10px;
        padding: 10px;
        background: #000099;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: background 0.3s ease;
    }

    .container .form-group .btn-reset {
        flex: 1;
        margin-right: 0;
        padding: 10px;
        background: #ccc;
        color: #333;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: background 0.3s ease;
    }

    .container .form-group .btn:hover {
        background: #005bb5;
    }

    .container .form-group .btn-reset:hover {
        background: #bbb;
    }

    .error {
        color: red;
        margin-top: 5px;
    }

    /* Media Query for mobile screens */
    @media (max-width: 600px) {
        .container {
            padding: 20px;
        }
        .container .form-group .btn-group {
            flex-direction: column; 
            align-items: center; 
        }
        .container .form-group .btn {
            margin-bottom: 10px; 
            width: 100%; 
        }
        .container .form-group .btn-reset {
            width: 100%; 
        }
    }
</style>

<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" --> 
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>

</head>
<body>
<table width="100%" border="0" cellpadding="2"  cellspacing="0" bgcolor="e8ad03">
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
        <tr bgcolor="e8ad03"> 
          <td width="13%">&nbsp;</td>
          <td width="60%">&nbsp;<!--%=bannerCode%--></td>
          <td width="50%">&nbsp;</td>
  </tr>
  <tr valign="top"> 
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --> 
            <jsp:include page="../administrator/adminleftnavi.jsp?screen=article" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<br>
<br>
<br>
<div class="container">
<font color="#FF0000"><strong><%=pageMessage%></strong></font>
    <h2>Search Articles</h2>
    <form action="ArticleSearchResult.jsp" method="post">
    <input type="hidden" name="formId" value="<%= System.currentTimeMillis()%>">
        <div class="form-group">
            <label for="name">Search:</label>
            <input type="text" id="SearchTearm" name="SearchTearm" required>
        </div>
        <div class="form-group">
            <label for="startDate">Start Date:</label>
            <input type="date" value="<%=startDate %>" id="startDate" name="startDate"><br><br>
            <label for="endDate">End Date:</label>
            <input type="date" value="<%=endDate %>" id="endDate" name="endDate"> 
            
            
        </div>
        <div class="form-group">
            <label for="category" value="BreakingNews">Category:</label>
            <select id="category" name="category" >
                <option value="Breaking News" selected>Breaking News</option>
                <option value="*">All Categories</option>
                <option value="Sports">Sports</option>
                <option value="Business">Business</option>
                <option value="Video">Video</option>
                <option value="Travel">Travel</option>
                <option value="Education">Education</option>
                <option value="Technology">Technology</option>
                <option value="Entertainment">Travel</Entertainment>
            </select>
        </div>
        <div class="form-group btn-group">
            <button type="submit" class="btn">Submit</button>
            <button type="reset" class="btn-reset">Reset</button>
        </div>
    </form>
   
</div>
</td>
    </tr>
    </table>
</body>
</html>
