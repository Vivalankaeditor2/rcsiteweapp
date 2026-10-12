<%
try{
Articles videoArticle = null;
if(articleList!=null && !articleList.isEmpty()){
%>
<table width="140" height="100%" border="0" cellpadding="0" cellspacing="0"  class="text graybox">
  <tr>
    <TD > 
                                         <p><strong>Most Popular </strong><br />
										   <a href="pagelist.jsp?tsearch=Video:%20Rupavahini%20News">Rupavahini News  </a>
										   <br />
										   <a href="pagelist.jsp?tsearch=Video:%20ITN%20News">ITN News  </a>
										   <br />
										   <a href="pagelist.jsp?tsearch=Video:%20Derana%20News"> Derana News  </a>
										   <br />
										   <a href="pagelist.jsp?tsearch=Video:%20Sirasa%20News">Sirasa News  </a>/<a href="pagelist.jsp?tsearch=Video:%20News%201st">News 1st</a>
										   <br />
										   <a href="pagelist.jsp?tsearch=Video:%20Megastar">Megastar  </a>
										   <br />
										   <a href="pagelist.jsp?tsearch=Video:%20boda%20meedum">Boda Meedum  </a>
                                          <br />
										   <a href="pagelist.jsp?tsearch=Video:%20gahanu%20lamai">Gahanu Lamai  </a>
									    </TD> 
											  </tr>
   <tr>
    <TD align="center" > <div class="grayline"><IMG src="../custom/images/spacer.gif" width="100"  height="1"></div></TD> 
   </tr><tr>
    <TD align="center" > 
										<form action="pagelist.jsp">
										<input name="vsearch" type="text" id="vsearch" size="15">
										<br />
										<input type="submit" name="Submit" value="Search Video">
	 </form></TD> 
   </tr>
     <tr>
    <TD align="center" > <div class="grayline"><IMG src="../custom/images/spacer.gif" width="100"  height="1"></div></TD> 
   </tr>
   <%  int Repeat1__numRows = 10;
        articleIterator=articleList.iterator();
   		while(articleIterator.hasNext() && Repeat1__numRows >= 0){
 		videoArticle=(Articles)articleIterator.next();
 		Repeat1__numRows--;
 		if(videoArticle.getArticleId().intValue()!= articleID.intValue()){
   %>
  <tr>
    <td height="57" valign="top">

	<div style="margin-left:8px; margin-top:6px "><a href="../news/page.jsp?articleid=<%=((videoArticle.getArticleId()==null )?"":videoArticle.getArticleId())%>"><%=((videoArticle.getTitle()==null )?"":videoArticle.getTitle())%></a></div>
      <div style="margin-left:8px; margin-top:6px;margin-bottom:6px "><a href="../news/page.jsp?articleid=<%=((videoArticle.getArticleId()==null )?"":videoArticle.getArticleId())%>"><img src="<%=((videoArticle.getImage()==null )?"":videoArticle.getImage())%>"></a></div>

</td>
  </tr>
  <tr>
    <TD align="center" > <div class="grayline"><IMG src="../custom/images/spacer.gif" width="100"  height="1"></div></TD> 
   </tr>
<%
}
}
%>
      <tr>
    <td align="right"><a href="/news/pagelist.jsp?categoryid=11">More&gt;&gt;</a></td>
  </tr>
</table>

				  
<%
}

}catch(Exception ex){
ex.printStackTrace();
out.println("Error");
}
%>
