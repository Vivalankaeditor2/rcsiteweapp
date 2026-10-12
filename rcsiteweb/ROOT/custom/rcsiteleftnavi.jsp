<% String parentid = "1";
if (request.getParameter("parentid") !=null) {parentid = (String)request.getParameter("parentid");}
String naviUrl ="";%>
<div>
        <div class="redheading whitetitle">Menu</div>
          <div class="text catlist"><a href="../">Home</a></div>
          <div class="text catlist"><a  href="../news/pagelist.jsp?categoryid=7">Breaking News</a></div>
          <div class="text catlist"><a href="../news/pagelist.jsp?categoryid=local">Local News</a></div>
          <div class="text catlist"><a  href="../news/pagelist.jsp?categoryid=8">Sport</a></div>
          <div class="text catlist"><a  href="../news/pagelist.jsp?categoryid=10">Business</a></div>
          <div class="text catlist"><a  href="../news/pagelist.jsp?categoryid=11">Video-Teledrama</a></div>
          <div class="text catlist"><a  href="../news/pagelist.jsp?categoryid=13">Travel</a></div>
          <div class="text catlist"><a  href="../news/pagelist.jsp?categoryid=12">Entertainment</a></div>
          <div class="text catlist"><a  href="../news/pagelist.jsp?categoryid=14">Technology</a></div>
          <div class="text catlist"><a  href="../worldnews/canada-events">Events</a></div>
          <div class="text catlist"><a  href="../worldnews/canada-businesses">SL Business Locations</a></div>
          <div class="text boldtext" style="margin-left:120px;"><a  href="../news/sitemap.jsp" >More&gt;&gt;</a></div>
          <div class="redheading whitetitle">Stay Connected</div>
          <div style="margin-left:20px; margin-top:5px "><a href="http://www.facebook.com/VivaLanka"><img src="../custom/images/viva_email_facebook.png" alt="facebook"  width="41" height="43" border="0"/></a><a href="http://twitter.com/vivalanka"><img src="../custom/images/viva_email_twitter.png" alt="twitter" width="42" height="44" border="0"/></a><a href="../mobile"><img src="../custom/images/viva_email_mobile.png" alt="mobile" width="43" height="42" border="0"/></a>
          								<br />
								Popular Searches
  <br /><img src="../custom/images/square1.jpg" width="7" alt="" height="7" align="absmiddle" style="margin-right:4px; margin-bottom:3px; "/><a href="../rcsearch/news?q=%22T20+World+Cup%22">T20 World Cup</a>  </div>
		  <jsp:include page="../custom/localadsnavi.jsp" flush="true" />
		   </div>
         