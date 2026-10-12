<link href="../css/styles.css" rel="stylesheet" type="text/css"> 

<%
String screen = "email";
if (request.getParameter("screen") !=null) {screen = (String)request.getParameter("screen");}
%>
<table width="184" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td><img src="../images/shim.gif" width="1" height="1"></td>
  </tr>
  <tr> 
    <td width="6" bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
    <td align="left" bgcolor="#FFFFFF" class="title"><a href="articleintro.jsp">Articles</a></td>
    <td width="5%">&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td><img src="../images/shim.gif" width="1" height="1"></td>
  </tr>
  <%
   if ((screen!= null)&&(screen.equals("article")))
    {
	%>
  <tr> 
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td colspan="2" bgcolor="#FFFFFF" class=text><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><font face="Tahoma"><a href="articleadd.jsp">Add 
            Article</a></font></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="articlelist.jsp">Article 
            List/Edit</a></td>
        </tr>
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="articleaddcategory.jsp">Add 
            Article Category</a></td>
        </tr>
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="SearchArticle.jsp">AI
            Article Generator</a></td>
        </tr>
		<tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="articlecategorylist.jsp">Category 
            List/ Edit </a></td>
        </tr>
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="javascript:;" onClick="MM_openBrWindow('upload.jsp?dir=media3','images','toolbar=yes,scrollbars=yes,width=800,height=800')">images/files upload</a></td>
        </tr>
      </table></td>
  </tr>
  <%
     }//end of email menu
   %>
   
</table>
