<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.util.*,com.rev_creations.persistence.dao.*,com.rev_creations.rcsite.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%

Map articleListMap = null;
%><jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
<title>Site Map</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<jsp:include page="../custom/rcheader.jsp" flush="true" />
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
	  <tr> 
		<td width="5%">&nbsp;</td>
		<td width="4%">&nbsp;</td>
		<td width="91%">&nbsp;</td>
	  </tr>
	   <tr> 
		 <td width="5%">&nbsp;</td>
		 <td colspan="2" class="subtitle">Site Map</td>
	   </tr>
	  <tr> 
		<td width="5%">&nbsp;</td>
		<td width="4%">&nbsp;</td>
		<td width="91%">&nbsp;</td>
	  </tr><% 	

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
					heading =  articleCategory.getTitle()+" / "+heading;
				}
				heading = heading.substring(0,heading.lastIndexOf(" /"));
			}

%>	<tr> 
		<td align="center"><img src="../custom/images/bulletlist.gif"></td>
		<td colspan="2"><strong><a href="pagelist.jsp?categoryid=<%=categories%>"><%=heading%></a></strong></td>
	</tr>
	<tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr><%		
		}
		%>
</table>
<jsp:include page="../custom/rcfooter.jsp" flush="true" />
</body>
</html>
