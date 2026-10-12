<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.util.*,com.rev_creations.persistence.dao.*,com.rev_creations.rcsite.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%

 %>
<%
List adList = null;
Map articleListMap = null;
Articles ad;
int articleCount = 0;

if (request.getParameter("Submit") != null && request.getParameter("Submit").toString().equals("Reset")) {
        ArticlePageGenerator.entityManager.close();
		articleListMap = new HashMap();
		session.getServletContext().setAttribute("adListMap", articleListMap);
}
 %>

<html lang="en"s><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Ad Map List </title>
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
              <jsp:include page="adminleftnavi.jsp?screen=news" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
            <table width="90%" border="0" cellpadding="0" cellspacing="1" class="text">
              <tr> 
                <td width="4%">&nbsp;</td>
                <td width="4%" >&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td nowrap ><strong>Ad List</strong></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                 <td>&nbsp;</td>
                <td ><form name="form1" method="post" action="">
                 
				   
					
                  <input type="submit" name="Submit" value="Reset">
                </form></td>
               
              </tr>
              <tr> 
                <td >&nbsp;</td>
                <td>&nbsp;</td>
                
                <td>&nbsp;</td>

              </tr>
              <% 	
			  		//adListMap = (HashMap)session.getServletContext().getAttribute("adListMap");
			  									  		 	List<ArticleCategory> articleCategoryList = null;
							  		 	ArticleCategory articleCategory = null;
							  		 	String heading ="";
							  		 	String categories;
							  		 	Iterator iter ;

			  							articleListMap =ArticlePageGenerator.articleListMap;
			        					Iterator it = articleListMap.entrySet().iterator();
    									while (it.hasNext()) {
        				
            							    heading ="";
				            				Map.Entry pairs = (Map.Entry)it.next();
				      						categories = pairs.getKey().toString();
				
					      					articleCategoryList =ArticlePageGenerator.getArticleCategoryMap(categories);
					      	      			if( articleCategoryList!=null){
						       					iter = articleCategoryList.iterator();
						      					while(iter.hasNext()){
						      						articleCategory = (ArticleCategory)iter.next();
							    					heading =  articleCategory.getTitle()+"("+articleCategory.getCategoryid()+") / "+heading;
						      					}
						      					heading = heading.substring(0,heading.lastIndexOf(" /"));
					      					}
       
						%>
			 <tr> 
                <td width="4%">&nbsp;</td>
                <td>&nbsp;</td>
                
                <td><strong><%=heading%></strong></td>

              </tr>
						<%
						adList = (ArrayList) pairs.getValue();
						if(adList!=null){
						Iterator itr = adList.iterator();
						while (itr.hasNext()) {
								ad = (Articles) itr.next();
			%>
			 <tr> 
                <td width="4%"><%=++articleCount%></td>
                <td><a href="articlesedit.jsp?articleid=<%=ad.getArticleId()%>">Edit</a></td>
                
                <td><a href="../news/page.jsp?articleid=<%=ad.getArticleId()%>"><%=ad.getTitle()%></a></td>

              </tr>
				

			<%
				}
				}

    }
%>
              <tr> 
                <td>&nbsp;</td>
                <td colspan="4">&nbsp;</td>
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

