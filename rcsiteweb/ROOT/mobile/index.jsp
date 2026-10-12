<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,java.util.*,javax.persistence.*" errorPage="" %>
<%@page import="com.rev_creations.rcsite.ArticlePageGenerator,com.rev_creations.persistence.dao.*"%>
<%java.util.Date startTime = Calendar.getInstance().getTime();
java.util.Date endTime = java.util.Calendar.getInstance().getTime(); 
long loadTime = endTime.getTime()- startTime.getTime();
SortedMap loadTimeMap = new TreeMap();
loadTimeMap.put("10.startTime-pagelist.jsp",startTime);
%><%@ include file="../Connections/dbconnection.jsp" %>
<%endTime = java.util.Calendar.getInstance().getTime(); 
loadTimeMap.put("20.enddbconnection",endTime); %><%!
public boolean validateCategory(String number, String page, HttpServletRequest request, HttpServletResponse response){
boolean result = true;
   if (number.matches("\\d{1,7}") 
        || "local".equals(number)
        || number.replaceAll(",","").matches("\\d{1,7}") ) {
       result = true;
   }else{
       try{
        request.setAttribute("invaliddatapage",page);
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/invaliddataerror.jsp");
        dispatcher.forward(request, response);
        result= false;
        	}
            catch(Exception ex)
            { ex.printStackTrace();
            }
   }
    return result ;
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
%><%
	List<Articles> articleList = null ;
	int noofRow         = 12;
    int offset          = 0;
    int pageIndex       = 1;
	String offsetString = "";
	String categories   = null;
	Articles article    = null;
	String heading ="";
	String titleSearch = null;
	String searchTerm = null;
	
//System.out.println( "user-agent pagelist " + request.getHeader("user-agent"));
categories = "7";
String pageURI = request.getRequestURI();
//System.out.println("pageURI"+pageURI);
if(pageURI.indexOf("/mobile/")>=0 && pageURI.indexOf("ci-")>=0){
	categories = pageURI.substring(8, pageURI.indexOf("ci-"));
	//System.out.println("articleIDString: "+articleIDString);
	if(!validateCategory( categories, "/mobile/pagelist.jsp", request,  response)){return;}
}
if (request.getParameter("categoryid") !=null){
    if(!validateCategory( request.getParameter("categoryid"), "/mobile/pagelist.jsp", request,  response)){return;}
    
	categories = (String)request.getParameter("categoryid");
}
if("local".equals(categories)){
   if(session.getAttribute("localNewsCategories")!= null 
    &&  ((String)session.getAttribute("localNewsCategories")).length()>0){
		categories = (String)session.getAttribute("localNewsCategories");
   }else{
   categories = "7";
   }
}
//System.out.println("categories : "+ categories);
%><%

if (request.getParameter("searchterm") !=null) {
	searchTerm = (String)request.getParameter("searchterm");
	searchTerm = treatStringParam(searchTerm);
}

if (request.getParameter("vsearch") !=null) {
   titleSearch = "video: "+request.getParameter("vsearch");
    categories = "11";
}else if (request.getParameter("tsearch") !=null) {
   titleSearch = (String)request.getParameter("tsearch");
    categories = "11";
}


if(searchTerm !=null){
	String whereClue ="WHERE ";
	
	if (titleSearch !=null && titleSearch.length()>0 ) {
		titleSearch = treatStringParam(titleSearch);
		String titleWords[] =titleSearch.split(" ");
		
		for (int t = 0; t < titleWords.length; t++){
		 whereClue = whereClue +" model.title LIKE '%" + titleWords[t] + "%'  AND ";
		}
		heading = "Search Results on \"" +titleSearch+ "\"";
	}
	
	if (searchTerm !=null && searchTerm.length()>0 ) {
	 	whereClue = whereClue+" (model.title LIKE '%" + searchTerm + "%' or model.description  LIKE '%" + searchTerm + "%' or model.details   LIKE '%" + searchTerm + "%' or model.authorName  LIKE '%" + searchTerm + "%' or model.authorIntro  LIKE '%" + searchTerm + "%') AND" ;
		heading = "Search Results on \"" +searchTerm+ "\"";
	 }
 	

	Query query ;
	String queryString = "select model from Articles model "+whereClue ;
	queryString = queryString +" model.aprovalStatus <> '0' ORDER BY model.articleId DESC " ;
	query = entityManager.createQuery(queryString);
	query.setMaxResults(60);
	articleList = query.getResultList();
}
	
if(categories !=null){
	ArticleCategory articleCategory = null;
	String[] categoryArray = categories.split(",");
	String[] categoryArrayInner = categories.split(",");
	List<ArticleCategory> articleCategoryList = null;
	
	  if(com.rev_creations.rcsite.Config.getValue("categorylimit."+categories)==null){
		 	String configCategory ="";
		 	categories = "7";
		 	boolean found = false;
				Iterator iter = com.rev_creations.rcsite.Config.getConfigList().iterator();
				while(iter.hasNext()){
				configCategory = ((RcsiteConfig)iter.next()).getConfigKey();
					if(configCategory.contains("categorylimit.") && configCategory.contains(categoryArray[0]) ){
							categories = configCategory.substring(configCategory.indexOf("categorylimit.")+14);
							categoryArrayInner = categories.split(",");
							for (int i = 0; i < categoryArrayInner.length; i++) { 
    							if(categoryArrayInner[i].equals(categoryArray[0])){
    							found =true;
    								break;
    							}
							}
							if(found){
								break;
							}
							
					}
				}
		}

	      articleCategoryList =ArticlePageGenerator.getArticleCategoryMap(categories);
	      if( articleCategoryList!=null){
		      Iterator iter = articleCategoryList.iterator();
		      while(iter.hasNext()){
		      		articleCategory = (ArticleCategory)iter.next();
			    	heading =  articleCategory.getTitle()+" / "+heading;
		      }
		      heading = heading.substring(0,heading.lastIndexOf(" /"))+":";
	      }
 
	articleList = ArticlePageGenerator.getArticleList(categories);
	endTime = java.util.Calendar.getInstance().getTime(); 
loadTimeMap.put("30.getArticleList",endTime);
}

	if (request.getParameter("offset") !=null && request.getParameter("offset").matches("[+]?[0-9]*") ) {
		offsetString = (String)request.getParameter("offset");
		offset = Integer.parseInt(offsetString);
	}
	

 boolean dispalyNewsVedio = false;

 if(categories!=null && "11".equals(categories.trim()) && (offset == 0 )){dispalyNewsVedio = true;}
 if(categories!=null && "11".equals(categories.trim())){
noofRow = 10;
}
 System.out.println("mobile: "+heading);
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
<title><%=heading%></title>
<link href="../custom/mobile.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="wrapper">
<div id="logo"><a href="../mobile/"><img src="../custom/images/logo_mobile.jpg" alt="VivaLanka" width="190" height="44" border="0" /></a></div>
<div class="topnav"><a href="/mobile/" class="topnav">Home</a> | <a href="/mobile/8ci-sports" class="topnav">Sports</a> | <a href="/mobile/10ci-business" class="topnav">Business</a></div>
<div id="content">
<div class="newsdetail" style="font-weight:bold;"><%=heading%></div>
	<%  
	if (articleList != null && !articleList.isEmpty()) {
		  for(pageIndex=offset; (pageIndex <= (offset +noofRow)-1) && (pageIndex <= articleList.size()-1); pageIndex++){
				article=articleList.get(pageIndex);
				if (article.getTitle() != null && article.getDescription() != null && article.getDescription().length() > 100) {
%><div><a class="newslist" href="../mobilepage/<%=article.getArticleId()%>ai-<%=((article.getAlias()==null )?"":article.getAlias())%>"><%=article.getTitle()%></a></div><% }}}  %>
</div>
<div id="footer">
  <div>
  <div style="margin-bottom:3px;"><span class="redbg_num"> 1 </span><a accesskey="1" href="../mobile/" class="bottomnav" >Home</a> </div> 
  <div style="margin-bottom:3px;"><span class="redbg_num"> 2 </span><a accesskey="2" href="../mobile/8ci-sports" class="bottomnav">Sports</a></div> 
  <div style="margin-bottom:15px;"><span class="redbg_num"> 3 </span><a accesskey="3" href="../mobile/10ci-business" class="bottomnav">Business</a></div>
  </div>
  <div class="xsmalltext">© Copyright 2010-2012 VivaLanka.com. All rights reserved. Powered by<a href="http://www.rev-creations.com/" target="_blank" class="bottomnav"> Rev-Creations Inc.</a></div></div>
</div>
</div><% String googleAnalyticsImageUrl = googleAnalyticsGetImageUrl(request); %>
<img src="<%= googleAnalyticsImageUrl %>" />
</body>
</html>
