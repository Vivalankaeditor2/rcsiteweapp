<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.sql.*,java.io.*,javax.persistence.*,com.rev_creations.persistence.dao.*,javax.naming.*,com.rev_creations.persistence.interfaces.*,com.rev_creations.rcsite.*" errorPage="" %>
<%java.util.Date startTime = Calendar.getInstance().getTime(); 
java.util.Date endTime = java.util.Calendar.getInstance().getTime(); 
long loadTime = endTime.getTime()- startTime.getTime();
SortedMap loadTimeMap = new TreeMap();
loadTimeMap.put("10.startTime-page.jsp",startTime);
%><%@ include file="../Connections/dbconnection.jsp" %><%
loadTimeMap.putAll(loadTimeMap2);
endTime = java.util.Calendar.getInstance().getTime(); 
loadTimeMap.put("20.enddbconnection",endTime);
String articleIDString = "1";

String pageURI = request.getRequestURI();
//System.out.println("pageURI"+pageURI);
if(pageURI.indexOf("/mobilepage/")>=0 && pageURI.indexOf("ai-")>=0){
	articleIDString = pageURI.substring(12, pageURI.indexOf("ai-"));
	//System.out.println("articleIDString: "+articleIDString);
	if(!validateNumeric( articleIDString, "/mobile/page.jsp", request,  response)){return;}
}
if (request.getParameter("i") !=null ) {
     if(!validateNumeric( request.getParameter("i"), "/n/p", request,  response)){return;}
     articleIDString = (String)request.getParameter("i");
}
if (request.getParameter("articleid") !=null ) {
	if(!validateNumeric( request.getParameter("articleid"), "/news/page.jsp", request,  response)){return;}
	articleIDString = (String)request.getParameter("articleid");
}
//System.out.println( "user-agent page id "+articleIDString +"  "+ request.getHeader("user-agent"));

Articles article = null;
List<Articles> articleList = null;
Iterator articleIterator= null;
Integer articleID = new Integer(articleIDString);
String articleTable = "articles";
int articleTableSufix = 50;


if(articleID < 250000){
articleTableSufix = ((articleID +50000) / 50000) *50;
	articleTable = "articles"+articleTableSufix;
}
System.out.println("mobile" + articleIDString+": "+articleTableSufix +": "+articleTable);

ArticlesFacadeRemote articlesFacadeRemote = null;

Connection ConnArticleRecordset  = null;
PreparedStatement StatementArticleRecordset  = null ;
ResultSet ArticleRecordset = null;
try { 
		articleList = ArticlePageGenerator.getArticleList("11");
		endTime = java.util.Calendar.getInstance().getTime(); 
		loadTimeMap.put("25.start jboss ",endTime);
		InitialContext jpaContext = null;;
           		jpaContext = (InitialContext) getServletContext().getAttribute("jpaContext");
           		articlesFacadeRemote = (ArticlesFacadeRemote) getServletContext().getAttribute("articlesFacadeRemote");
				try {		
					if (jpaContext == null) {
			            Hashtable env = new Hashtable();
						env.put(Context.INITIAL_CONTEXT_FACTORY,
								"org.jnp.interfaces.NamingContextFactory");
						env.put(Context.PROVIDER_URL, "localhost:1099");
						env.put(Context.URL_PKG_PREFIXES,
								"org.jboss.naming:org.jnp.interfaces");
						jpaContext = new InitialContext(env);
				endTime = java.util.Calendar.getInstance().getTime(); 
				loadTimeMap.put("26.InitialContext",endTime);
						articlesFacadeRemote = (ArticlesFacadeRemote) jpaContext
							.lookup("ArticlesFacade/remote");
			    endTime = java.util.Calendar.getInstance().getTime(); 
				loadTimeMap.put("27.remote facade lookup 1",endTime);							
							
						getServletContext().setAttribute("jpaContext",jpaContext);
						getServletContext().setAttribute("articlesFacadeRemote",articlesFacadeRemote);		
		             }
		             
		             if(articlesFacadeRemote == null){
		             	articlesFacadeRemote = (ArticlesFacadeRemote) jpaContext
							.lookup("ArticlesFacade/remote");
						getServletContext().setAttribute("articlesFacadeRemote",articlesFacadeRemote);
				endTime = java.util.Calendar.getInstance().getTime(); 
				loadTimeMap.put("28.remote facade lookup 2",endTime);
					
		             }

					article = (Articles) articlesFacadeRemote.findById(articleID);
				endTime = java.util.Calendar.getInstance().getTime(); 
				loadTimeMap.put("29.remote findById",endTime);
					
				}catch (Exception ex) {
					ex.printStackTrace();
					System.out.println("ERROR: JBoss articleID: "+articleIDString +" -- " + ex.getMessage());
				}
				
				endTime = java.util.Calendar.getInstance().getTime(); 
				loadTimeMap.put("30.endjbossarticle",endTime);

		if(article==null || article.getTitle()==null){	
			
			System.out.print( "********rcsiteDS******** id: "+articleIDString );
			try {	
						ConnArticleRecordset = rcsiteDS.getConnection();
			
			StatementArticleRecordset = ConnArticleRecordset.prepareStatement("SELECT title, description, details, author_name,author_intro, "+ 
					" entry_date, published, updated, url, alias  FROM "+articleTable+"  WHERE article_id = ?");
			StatementArticleRecordset.setInt(1,articleID);
			endTime = java.util.Calendar.getInstance().getTime(); 
			loadTimeMap.put("39.beforeselectarticle",endTime);
			ArticleRecordset = StatementArticleRecordset.executeQuery();
			endTime = java.util.Calendar.getInstance().getTime(); 
			loadTimeMap.put("40.endselectarticle",endTime);
			boolean ArticleRecordset_isEmpty = !ArticleRecordset.next();
			boolean ArticleRecordset_hasData = !ArticleRecordset_isEmpty;
			Object ArticleRecordset_data;
			int ArticleRecordset_numRows = 0;
			if(ArticleRecordset_hasData){
			
			article = new Articles();
			
			article.setArticleId(articleID);
			article.setTitle(ArticleRecordset.getString("title"));
			article.setDescription(ArticleRecordset.getString("description"));
			article.setDetails(ArticleRecordset.getString("details"));
			article.setAuthorName(ArticleRecordset.getString("author_name"));
			article.setAuthorIntro(ArticleRecordset.getString("author_intro"));
			article.setEntryDate(ArticleRecordset.getTimestamp("entry_date"));
			article.setPublished(ArticleRecordset.getTimestamp("published"));
			article.setUpdated(ArticleRecordset.getTimestamp("updated"));
			article.setUrl(ArticleRecordset.getString("url"));
			article.setAlias(ArticleRecordset.getString("alias"));
			
			}
			ArticleRecordset.close();
			StatementArticleRecordset.close();
			ConnArticleRecordset.close();
			
					} catch (Exception re) {
						System.out.print( "page.jsp article Exception id: "+articleIDString +"  message: "+ re.getMessage());
						re.printStackTrace();
					}
			 	
				
		}


/*
		articleIterator=articleList.iterator();
		while(articleIterator.hasNext()){
 			article =(Articles)articleIterator.next();
 			if(article.getArticleId().intValue()== articleID.intValue()){
 				break;
 			}
 			
 		}
*/		
} catch (RuntimeException re) {
	System.out.print( "page.jsp RuntimeException id: "+articleIDString +"  message: "+ re.getMessage());
	re.printStackTrace();
}catch (Exception re) {
	System.out.print( "page.jsp exception id: "+articleIDString +"  message: "+ re.getMessage());
	re.printStackTrace();
}
		

%><% 
if (article ==null ) {
System.out.print( articleIDString+"emptyRecordSet **emptyRecordSet** /news/page.jsp");
	if(!validateNumeric( articleIDString+"emptyRecordSet", "**emptyRecordSet** /news/page.jsp", request,  response)){return;}
}	
%><%!
public String DoDateTime(java.lang.Object aObject,int nNamedFormat,java.util.Locale aLocale) throws Exception{	
if ((aObject != null) && (aObject instanceof java.util.Date)){
   if (aLocale!=null){
		java.text.DateFormat df = java.text.DateFormat.getDateTimeInstance();
			return df.format(aObject);
	}
	else{
		java.text.DateFormat df = java.text.DateFormat.getDateTimeInstance();
			return df.format(aObject);
	 }
 }
return "";
}
%><!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<%@ page import="java.io.UnsupportedEncodingException,java.net.URLEncoder" %><%!
// Copyright 2010 Google Inc. All Rights Reserved.
private static final String GA_ACCOUNT = "MO-27234214-1";
private static final String GA_PIXEL = "/ga.jsp";

private String googleAnalyticsGetImageUrl(
    HttpServletRequest request) throws UnsupportedEncodingException {
  StringBuilder url = new StringBuilder();
  url.append(GA_PIXEL + "?");
  url.append("utmac=").append(GA_ACCOUNT);
  url.append("&utmn=").append(Integer.toString((int) (Math.random() * 0x7fffffff)));
  String referer = request.getHeader("referer");
  String query = request.getQueryString();
  String path = request.getRequestURI();
  if (referer == null || "".equals(referer)) {
    referer = "-";
  }
  url.append("&utmr=").append(URLEncoder.encode(referer, "UTF-8"));
  if (path != null) {
    if (query != null) {
      path += "?" + query;
    }
    url.append("&utmp=").append(URLEncoder.encode(path, "UTF-8"));
  }
  url.append("&guid=ON");
  return url.toString().replace("&", "&amp;");
}
%><html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=((article.getTitle()==null )?"":article.getTitle())%></title>
<link href="../custom/mobile.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="wrapper">
<div id="logo"><a href="../mobile/"><img src="../custom/images/logo_mobile.jpg" alt="VivaLanka" width="190" height="44" border="0" /></a></div>
<div class="topnav"><a href="../mobile/" class="topnav">Home</a> | <a href="../mobile/8ci-sports" class="topnav">Sports</a> | <a href="../mobile/10ci-business" class="topnav">Business</a></div>
<div id="content">
<div class="newsdetail" style="font-weight:bold;"><%=((article.getTitle()==null )?"":article.getTitle())%></div>
<div class="newsdetail"><%=(article.getDescription()==null )?"":article.getDescription()%></div>
<div class="xsmalltext"><% if(article.getUpdated()!= null){
					%><%= DoDateTime(article.getUpdated(), java.text.DateFormat.MEDIUM, null) %><%
				}else if(article.getPublished()!= null){
					%><%= DoDateTime(article.getPublished(), java.text.DateFormat.LONG, java.util.Locale.CANADA) %> <%}else{
					%><%=DoDateTime(((article.getEntryDate()==null )?"":article.getEntryDate()), java.text.DateFormat.LONG, java.util.Locale.CANADA)%><%
				}%>- <%=((article.getAuthorName()==null )?"":article.getAuthorName())%></div>	
</div>
<div id="footer">
  <div>
  <div style="margin-bottom:3px;"><span class="redbg_num"> 1 </span><a accesskey="1" href="../mobile/" class="bottomnav" >Home</a> </div> 
  <div style="margin-bottom:3px;"><span class="redbg_num"> 2 </span><a accesskey="2" href="../mobile/8ci-sports" class="bottomnav">Sports</a></div> 
  <div style="margin-bottom:6px;"><span class="redbg_num"> 3 </span><a accesskey="3" href="../mobile/10ci-business" class="bottomnav">Business</a></div>
  </div>
  <div class="xsmalltext" style="margin-top:10px;">© Copyright 2010-2012 VivaLanka.com. All rights reserved. Powered by<a href="http://www.rev-creations.com/" target="_blank" class="bottomnav"> Rev-Creations Inc.</a></div></div>
</div><% String googleAnalyticsImageUrl = googleAnalyticsGetImageUrl(request); %>
<img src="<%= googleAnalyticsImageUrl %>" />
</body>
</html>