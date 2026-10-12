<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.util.*,java.sql.*,java.io.*,javax.persistence.*,com.rev_creations.persistence.dao.*,javax.naming.*,com.rev_creations.persistence.interfaces.*,com.rev_creations.rcsite.*" errorPage="" %>
<div style="text-align:center;width:140px;padding-top:5px;"><a href="../worldnews/advertise-with-us"><img src="../custom/images/ad_space_E_AdHere.jpg" border="0"></a></div>
<%try{ 
List<Articles> videoArticleList = ArticlePageGenerator.getArticleList("11");
Articles videoArticle = null;
Iterator videoArticleIterator= null;

if(videoArticleList!=null && !videoArticleList.isEmpty()){
%><div class="text graybox" style="width:140px; margin:10px 0 20px 0;text-align:center">
 <%  	int Repeat1__numRows = 6;
        videoArticleIterator=videoArticleList.iterator();
   		while(videoArticleIterator.hasNext() && Repeat1__numRows >= 0){
			videoArticle=(Articles)videoArticleIterator.next();
			Repeat1__numRows--;
			
   %><div class="videoitem"><% if(videoArticle.getAlias() !=null  ){%><a href="../newspage/<%=videoArticle.getArticleId()%>ai-<%=videoArticle.getAlias()%>"><%=videoArticle.getTitle()%></a><%
														 }else{%><a href="../news/page.jsp?articleid=<%=((videoArticle.getArticleId()==null )?"":videoArticle.getArticleId())%>"><%=((videoArticle.getTitle()==null )?"":videoArticle.getTitle())%></a><%}%></div>
		  <div class="videoitem"><% if(videoArticle.getAlias() !=null  ){%><a href="../newspage/<%=videoArticle.getArticleId()%>ai-<%=videoArticle.getAlias()%>"><img src="<%=((videoArticle.getThumbnail()==null )?videoArticle.getImage():videoArticle.getThumbnail())%>" alt="<%=videoArticle.getTitle()%>" width="120" height="75"/></a><%
														 }else{%><a href="../news/page.jsp?articleid=<%=((videoArticle.getArticleId()==null )?"":videoArticle.getArticleId())%>"><img src="<%=((videoArticle.getThumbnail()==null )? videoArticle.getImage():videoArticle.getThumbnail())%>" alt="<%=videoArticle.getTitle()%>" width="120" height="75"/></a><%}%></div>
	<%
				}

	%><div><a href="../news/pagelist.jsp?categoryid=11">More&gt;&gt;</a></div>
</div>
<%
}
}catch(Exception ex){
ex.printStackTrace();
out.println("Error");
}%>

<div style="text-align:center; padding-top:10px;">
    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 160x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:160px;height:600px"
     data-ad-client="ca-pub-1991368893626594"
     data-ad-slot="2216991212"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>