<%try{ 
out.println("video");
Articles videoArticle = null;
if(articleList!=null && !articleList.isEmpty()){
%><div class="text graybox" style="width:590px; margin-bottom:20px;">
 <%  	int Repeat1__numRows = 6;
        articleIterator=articleList.iterator();
   		while(articleIterator.hasNext() && Repeat1__numRows >= 0){
			videoArticle=(Articles)articleIterator.next();
			Repeat1__numRows--;
			if(videoArticle.getArticleId().intValue()!= articleID.intValue()){
   %><div class="videoitem"><% if(videoArticle.getAlias() !=null  ){%><a href="../newspage/<%=videoArticle.getArticleId()%>ai-<%=videoArticle.getAlias()%>"><%=videoArticle.getTitle()%></a><%
														 }else{%><a href="../news/page.jsp?articleid=<%=((videoArticle.getArticleId()==null )?"":videoArticle.getArticleId())%>"><%=((videoArticle.getTitle()==null )?"":videoArticle.getTitle())%></a><%}%></div>
		  <div class="videoitem"><% if(videoArticle.getAlias() !=null  ){%><a href="../newspage/<%=videoArticle.getArticleId()%>ai-<%=videoArticle.getAlias()%>"><img src="<%=((videoArticle.getThumbnail()==null )?videoArticle.getImage():videoArticle.getThumbnail())%>" alt="<%=videoArticle.getTitle()%>" width="120" height="75"/></a><%
														 }else{%><a href="../news/page.jsp?articleid=<%=((videoArticle.getArticleId()==null )?"":videoArticle.getArticleId())%>"><img src="<%=((videoArticle.getThumbnail()==null )? videoArticle.getImage():videoArticle.getThumbnail())%>" alt="<%=videoArticle.getTitle()%>" width="120" height="75"/></a><%}%></div>
	<%
				}
			}
	%><div><a href="../news/pagelist.jsp?categoryid=11">More&gt;&gt;</a></div>
</div>
<%
}
}catch(Exception ex){
ex.printStackTrace();
out.println("Error");
}%>