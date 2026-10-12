<%
String articleId = "1";
String encodedUrl = "1";
try{

if (request.getParameter("articleid") !=null) {articleId = (String)request.getParameter("articleid");}
if (request.getParameter("url") !=null) {encodedUrl = (String)request.getParameter("url");}

response.sendRedirect(encodedUrl);

}catch(Exception ex){


response.sendRedirect(response.encodeRedirectURL("page.jsp?articleid="+articleId));
ex.printStackTrace();

}
%>
