<%@ page contentType="text/html; charset=UTF-8" language="java"
	import="java.util.*,java.sql.*,java.io.*,javax.persistence.*,com.rev_creations.persistence.dao.*,javax.naming.*,
	com.rev_creations.persistence.interfaces.*,com.rev_creations.rcsite.*,java.text.DateFormat,java.text.SimpleDateFormat,java.util.regex.*" errorPage=""%>
<%
java.util.Date startTime = Calendar.getInstance().getTime();
java.util.Date endTime = java.util.Calendar.getInstance().getTime();
long loadTime = endTime.getTime() - startTime.getTime();
SortedMap loadTimeMap = new TreeMap();
String details = "";

%>
<%@ include file="../Connections/dbconnection.jsp"%>
<%!public String formatDate(java.lang.Object aObject, int nNamedFormat, java.util.Locale aLocale) throws Exception {
		if ((aObject != null) && (aObject instanceof java.util.Date)) {
			java.text.DateFormat df = java.text.DateFormat.getDateInstance(nNamedFormat);
			if (aLocale != null) {
				
				return df.format(aObject);
			} else {
			
				return df.format(aObject);
			}
		}
		return "";
}

public String DoDateTime(java.lang.Object aObject, int nNamedFormat, java.util.Locale aLocale) throws Exception {
	if ((aObject != null) && (aObject instanceof java.util.Date)) {
		if (aLocale != null) {
			java.text.DateFormat df = java.text.DateFormat.getDateTimeInstance();
			return df.format(aObject);
		} else {
			java.text.DateFormat df = java.text.DateFormat.getDateTimeInstance();
			return df.format(aObject);
		}
	}
	return "";
}

public String getISOTime(java.lang.Object aObject) throws Exception {
	if ((aObject != null) && (aObject instanceof java.util.Date)) {

		java.text.DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
		return df.format(aObject);

	}
	return "";
}

private Pattern pattern = Pattern.compile("-?\\d+(\\.\\d+)?");

public boolean isNumeric(String strNum) {
    if (strNum == null) {
        return false; 
    }
    return pattern.matcher(strNum).matches();
}
%>

<%
try {

int noofRow = 5;
int pageIndex = 1;
String displayDate="";
List<Articles> articleList = null;
Articles article = null;
Calendar calendar = Calendar.getInstance();

endTime = java.util.Calendar.getInstance().getTime();
loadTimeMap.put("30.getArticleList", endTime);


String articleIDString = "1465";
String pageURI = request.getRequestURI();
//System.out.println("pageURI"+pageURI);
if (pageURI.indexOf("/newspage/") >= 0 && pageURI.indexOf("ai-") >= 0) {
	articleIDString = pageURI.substring(10, pageURI.indexOf("ai-"));
	System.out.println("articleIDString: "+articleIDString);
	if (!validateNumeric(articleIDString, pageURI, request, response)) {
return;
	}
} else if (pageURI.indexOf("/newspage/") >= 0 && pageURI.indexOf("ai-") < 0) {
	String searchTerm = "";
	if (request.getLocalName().contains("vivalanka") || request.getLocalName().contains("rcsiteweb")
	|| request.getLocalName().contains("127")) {
		searchTerm = request.getRequestURI().replaceAll("/", " ").replaceAll("\\.", " ");
		searchTerm = searchTerm.trim();
	
		if (!searchTerm.contains("rcsearch")) {//avoid redirect loop
			String url = "http://" + request.getLocalName() + "/rcsearch/news?q=" + searchTerm;
	
			response.setStatus(303);
			response.setHeader("Location", url);
			response.setHeader("Connection", "close");
	
		} else {
			//formAction="http://"+request.getLocalName()+"/rcsearch/news?q=";
		}
	}
}

if (request.getParameter("i") != null) {
	if (!validateNumeric(request.getParameter("i"), "/n/p", request, response)) {
		return;
	}
	articleIDString = (String) request.getParameter("i");
}
if (request.getParameter("articleid") != null) {
	if (!validateNumeric(request.getParameter("articleid"), "/news/page.jsp", request, response)) {
		return;
	}
	articleIDString = (String) request.getParameter("articleid");
}
//System.out.println( "user-agent page id "+articleIDString +"  "+ request.getHeader("user-agent"));


Iterator articleIterator = null;
Integer articleID = new Integer(articleIDString);
String articleTable = "articles";
int articleTableSufix = 50;
/*
if (articleID < 350000) {
	articleTableSufix = ((articleID + 50000) / 50000) * 50;
	articleTable = "articles" + articleTableSufix;
} else if (articleID < 1000000) {
	articleTableSufix = 1000;
	articleTable = "articles" + articleTableSufix;
}
*/
//System.out.println(articleIDString + ": " + articleTableSufix + ": " + articleTable);

ArticlesFacadeRemote articlesFacadeRemote = null;

Connection ConnArticleRecordset = null;
PreparedStatement StatementArticleRecordset = null;
ResultSet ArticleRecordset = null;
Map<String, Articles> allArticleMap = null;

List<Articles> allArticleList = null;

try {

	if (article == null || article.getTitle() == null) {
		try {
			ConnArticleRecordset = rcsiteDS.getConnection();
	
			StatementArticleRecordset = ConnArticleRecordset.prepareStatement(
					"SELECT title, description,image,details, categoryid, author_name,author_intro, "
							+ " entry_date, published, updated, url, alias, dcode,thumbnail,aproval_status  FROM " + articleTable
							+ "  WHERE article_id = ?");
			
			
			StatementArticleRecordset.setInt(1, articleID);
			endTime = java.util.Calendar.getInstance().getTime();
			loadTimeMap.put("39.beforeselectarticle", endTime);
			ArticleRecordset = StatementArticleRecordset.executeQuery();
			endTime = java.util.Calendar.getInstance().getTime();
			loadTimeMap.put("40.endselectarticle id=" + articleID, endTime);
			boolean ArticleRecordset_isEmpty = !ArticleRecordset.next();
			boolean ArticleRecordset_hasData = !ArticleRecordset_isEmpty;
			Object ArticleRecordset_data;
			int ArticleRecordset_numRows = 0;
			if (ArticleRecordset_hasData) {
				
				article = new Articles();
	
				article.setArticleId(articleID);
				article.setTitle(ArticleRecordset.getString("title"));
				article.setDescription(ArticleRecordset.getString("description"));
				article.setDetails(ArticleRecordset.getString("details"));
				article.setImage(ArticleRecordset.getString("image"));
				article.setThumbnail(ArticleRecordset.getString("thumbnail"));
				article.setCategoryid(ArticleRecordset.getInt("categoryid"));
				article.setAuthorName(ArticleRecordset.getString("author_name"));
				article.setAuthorIntro(ArticleRecordset.getString("author_intro"));
				article.setEntryDate(ArticleRecordset.getTimestamp("entry_date"));
				article.setPublished(ArticleRecordset.getTimestamp("published"));
				article.setUpdated(ArticleRecordset.getTimestamp("updated"));
				article.setUrl(ArticleRecordset.getString("url"));
				article.setAlias(ArticleRecordset.getString("alias"));
				article.setDcode(ArticleRecordset.getString("dcode"));
				article.setAprovalStatus(ArticleRecordset.getString("aproval_status"));
				
	
			}
			ArticleRecordset.close();
			StatementArticleRecordset.close();
			ConnArticleRecordset.close();
	
		} catch (Exception re) {
			System.out.print("page.jsp article Exception id: " + articleIDString + "  message: " + re.getMessage());
			re.printStackTrace();
		}

	}

	if (article == null || article.getTitle() == null) {

			System.out.print(" article==null ********JBoss******** id: " + articleIDString);
		
			endTime = java.util.Calendar.getInstance().getTime();
			loadTimeMap.put("25.start jboss ", endTime);
			InitialContext jpaContext = null;;
			jpaContext = (InitialContext) getServletContext().getAttribute("jpaContext");
			articlesFacadeRemote = (ArticlesFacadeRemote) getServletContext().getAttribute("articlesFacadeRemote");
			try {
				if (jpaContext == null) {
					Hashtable env = new Hashtable();
					env.put(Context.INITIAL_CONTEXT_FACTORY, "org.jnp.interfaces.NamingContextFactory");
					env.put(Context.PROVIDER_URL, "localhost:1099");
					env.put(Context.URL_PKG_PREFIXES, "org.jboss.naming:org.jnp.interfaces");
					jpaContext = new InitialContext(env);
					endTime = java.util.Calendar.getInstance().getTime();
					loadTimeMap.put("26.InitialContext", endTime);
					articlesFacadeRemote = (ArticlesFacadeRemote) jpaContext.lookup("ArticlesFacade/remote");
					endTime = java.util.Calendar.getInstance().getTime();
					loadTimeMap.put("27.remote facade lookup 1", endTime);
		
					getServletContext().setAttribute("jpaContext", jpaContext);
					getServletContext().setAttribute("articlesFacadeRemote", articlesFacadeRemote);
				}
		
				if (articlesFacadeRemote == null) {
					articlesFacadeRemote = (ArticlesFacadeRemote) jpaContext.lookup("ArticlesFacade/remote");
					getServletContext().setAttribute("articlesFacadeRemote", articlesFacadeRemote);
					endTime = java.util.Calendar.getInstance().getTime();
					loadTimeMap.put("28.remote facade lookup 2", endTime);
		
				}
		
				article = (Articles) articlesFacadeRemote.findById(articleID);
				endTime = java.util.Calendar.getInstance().getTime();
				loadTimeMap.put("29.remote findById", endTime);
				System.out.print(" ********JBoss******** Success " + articleIDString);
			} catch (Exception ex) {
				ex.printStackTrace();
				System.out.println("ERROR: JBoss articleID: " + articleIDString + " -- " + ex.getMessage());
			}
		
			endTime = java.util.Calendar.getInstance().getTime();
			loadTimeMap.put("30.endjbossarticle", endTime);
	}

} catch (RuntimeException re) {
	System.out.print("page.jsp RuntimeException id: " + articleIDString + "  message: " + re.getMessage());
	re.printStackTrace();
} catch (Exception re) {
	System.out.print("page.jsp exception id: " + articleIDString + "  message: " + re.getMessage());
	re.printStackTrace();
}

if (article == null || "4".equalsIgnoreCase(article.getAprovalStatus())) {
System.out.print(articleIDString + "emptyRecordSet **emptyRecordSet** /news/page.jsp");
if (!validateNumeric(articleIDString + "emptyRecordSet", "**emptyRecordSet** /news/page.jsp", request, response)) {
	return;
}
}


%>

<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html>
<head>
<title><%=((article.getTitle() == null) ? "" : article.getTitle())%></title>
<meta name="Description"
	content="<%=shortenString((String) ((article.getDescription() == null) ? "" : article.getDescription()), 150)%>" />
<meta name="keywords"
	content="breaking news, video, teledrama, latest news,cultural events, Sri Lanka" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%
String pageUrl;
if (article.getAlias() != null) {
	if(article.getDcode() != null & isNumeric(article.getDcode())){
		pageUrl = Config.getValue("wwwUrl").trim() + "/newspage/" + article.getDcode() + "ai-" + article.getAlias();
	}else{
		pageUrl = Config.getValue("wwwUrl").trim() + "/newspage/" + article.getArticleId() + "ai-" + article.getAlias();
	}
} else {
	if(article.getDcode() != null & isNumeric(article.getDcode())){
		pageUrl = Config.getValue("wwwUrl").trim() + "/news/page.jsp?articleid=" + article.getDcode();
	}else{
		pageUrl = Config.getValue("wwwUrl").trim() + "/news/page.jsp?articleid=" + article.getArticleId();
	}
}
String imageUrl = "/custom/images/200x200vivalanka0.png";
if(article.getImage() != null){
	imageUrl= article.getImage().trim().substring(2);
}else if( article.getThumbnail() != null){
	imageUrl= article.getThumbnail().trim().substring(2);
}


%>
<meta property="og:url" content="<%=pageUrl%>" />
<meta property="og:title"
	content="<%=((article.getTitle() == null) ? "" : article.getTitle())%>" />
<meta property="og:description"
	content="<%=(String) ((article.getDescription() == null) ? "" : article.getDescription().replaceAll("\\<.*?>", ""))%>" />
<meta property="og:image"
	content="<%=Config.getValue("wwwUrl").trim() + imageUrl %>" />
<meta property="og:type" content="article" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:description" content="<%=(String) ((article.getDescription() == null) ? "" : article.getDescription().replaceAll("\\<.*?>", ""))%>" />
<meta name="twitter:title" content="<%=((article.getTitle() == null) ? "" : article.getTitle())%>" />
<meta name="twitter:image" content="<%=Config.getValue("wwwUrl").trim() + imageUrl %>" />
 <meta name="twitter:url" content="<%=pageUrl%>">
<link rel="canonical" href="<%=pageUrl%>" />

<jsp:include page="/custom/rchtmlhead.jsp" flush="true" />
</head>
<body
	class="home page-template page-template-page-fullwidth page-template-page-fullwidth-php page page-id-8 soledad-ver-8-1-9 pclight-mode pcmn-drdw-style-slide_down pchds-showup elementor-default elementor-kit-4 elementor-page elementor-page-8 e--ua-blink e--ua-chrome e--ua-webkit"
	style="transform: none;" data-elementor-device-mode="desktop"
	data-new-gr-c-s-check-loaded="14.1065.0" data-gr-ext-installed="">
	<jsp:include page="/custom/rcheader.jsp" flush="true" />

	<!-- ================================================================= -->

	<!-- main part start -->
	<div class="container-single-page container-default-page"                     
		style="transform: none;">
		<div id="main" class="penci-main-single-page-default"
			style="transform: none;">
			<div data-elementor-type="wp-page" data-elementor-id="8"
				class="elementor elementor-8" style="transform: none;">
				<!-- section main start -->
				<section
					class="penci-section penci-enSticky penci-repons-elsection penci-con_sb2_sb1 penci-structure-33 elementor-section elementor-top-section elementor-element elementor-element-35af948 elementor-section-boxed elementor-section-height-default elementor-section-height-default"
					data-id="35af948" data-element_type="section"
					style="transform: none;">
					<div class="elementor-container elementor-column-gap-extended"
						style="transform: none;">

						
						<!-- middel left (video) start -->

						<jsp:include page="/custom/newssummarynavinarrow_topleft.jsp"	flush="true" />
						<!-- middel left (video) end -->
						
						
						<!-- contentmiddleupper  start-->

						<%
						articleList = ArticlePageGenerator.getArticleList("7");
						java.text.DateFormat newsdf = new SimpleDateFormat("yyyy-MM-dd");
						java.util.Calendar newsDate = java.util.Calendar.getInstance();
						newsDate.add(java.util.Calendar.HOUR, -6);
						String newsDateString = newsdf.format(newsDate.getTime());
						List<Articles> imageArticleList = new ArrayList();;
						String link = "";
						String thumbnail = null;
						int row_num = 0;
						int contentLength = 0;
						boolean isTextArticle= true;
						%>
						
						

						<div
					
							class="penci-ercol-50 penci-ercol-order-2 penci-sticky-ct  elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-29b88e4"
							data-id="29b88e4" data-element_type="column"
							data-settings="{&quot;background_background&quot;:&quot;classic&quot;}"
							style="position: relative; overflow: visible; box-sizing: border-box; min-height: 1px;">

							<div
								class="elementor-widget-wrap elementor-element-populated theiaStickySidebar"
								style="position: static; padding-top: 0px; padding-bottom: 1px;">
								<!--  single article end -->
								<%
								if (article.getTitle().contains("Video:")) {
										isTextArticle = false;
									}
								if (article.getDetails() != null) {
									details = article.getDetails();
						
					}
					if (article.getDcode() != null && article.getDcode().contains("_short")) {
						details = article.getDescription().replaceAll("\\<.*?>", "");
					}
					if (article.getAlias() != null) {
						link = "../newspage/" + article.getArticleId() + "ai-" + article.getAlias();
					} else {
						link = "../news/page.jsp?articleid=" + article.getArticleId();
					}
					
					if (article.getUpdated() != null) {
						displayDate = formatDate(article.getUpdated(), java.text.DateFormat.FULL, null);
					
					} else if (article.getPublished() != null) {
					displayDate = formatDate(article.getPublished(), java.text.DateFormat.FULL, java.util.Locale.CANADA);
				
					} else {
						displayDate = formatDate(article.getEntryDate(), java.text.DateFormat.FULL , java.util.Locale.CANADA);
					
					}
					
					ArticleCategory articleCategory = null;
					List<ArticleCategory> articleCategoryList = null;
					String heading = "";
					
					
					articleCategoryList = ArticlePageGenerator.getArticleCategoryMap(article.getCategoryid().toString());
					 
					Iterator iter = articleCategoryList.iterator();
					while (iter.hasNext()) {
						articleCategory = (ArticleCategory) iter.next();
						heading = articleCategory.getCategoryName() + " / ";//+heading;
					}
					heading = heading.substring(0, heading.lastIndexOf(" /")) ;
					 
					 
					 
					 %>

									<!-- breadcrumb start -->
									
                                         <div style="padding: 10px 10px 20px 10px;">	                                        
                                              <ol class="breadcrumb" style="color: var(--pcmeta-cl); FONT-FAMILY: Roboto sans-serif; font-size: 16px;">
                                                  <li class="breadcrumb-item" >
                                                       <a href="../">Home</a>
                                                  </li>
                                                  <li class="breadcrumb-item">
                                                       <a href="../rcsearch/news?&q=&fq=category:%22<%=heading == null ? "" : heading %>%22&NarrowBy=Category">
                                                       <%=heading == null ? "" : heading %>
                                                       </a>
                                                  </li>
                                                  <li class="breadcrumb-item">
                                                  <%=((article.getTitle() == null) ? "" : article.getTitle())%>
                                                  </li>
                                              </ol>										
                                         </div>
                                                                                 
                                     <!-- breadcrumb end -->  
                                     
                                     
				
					                <article id="post-133" class="post type-post status-publish">

									<div class="post-entry blockquote-style-1">								
										<div class="inner-post-entry entry-content"
											id="penci-post-entry-inner" style="padding: 0 10px 0 10px;">
											
									  
 
											<h1>
												<span style="color: #003366;"><%=((article.getTitle() == null) ? "" : article.getTitle())%></span>
											</h1>
											<div>
																			<span class="sl-date"><time
																					class="entry-date published" datetime="2021-11-05">
																					<%= displayDate%>
																				</time></span> <span class="sl-date-author author-italic">
																				- <%=article.getAuthorName() == null ? "" : article.getAuthorName()%>
																			</span>
																		</div>
											
											<p> <%=details%></p>

<%
					if (article.getUrl() != null && article.getUrl().length() > 0 && article.getUrl().indexOf("http") == 0) {
					%>
					
						<div class="pcsl-title">
						<a href="<%=article.getUrl()%>"> <%=((article.getAuthorName() == null) ? "" : article.getAuthorName())%> - <%=((article.getTitle()==null )?"":article.getTitle())%></a>
						</div>
					<%
					}
					%>

										</div>
									</div>
									
			<!-- Social media start -->
  <div>
    <div class="tags-share-box single-post-share tags-share-box-s2 tags-share-box-2_3 social-align-default post-share" style="opacity: 1; border: none;">
        <span class="penci-social-share-text">
            <i class="penciicon-sharing"></i>Share
        </span>
        <span class="post-share-item post-share-plike">
            <span class="count-number-like">0</span>
            <a href="#" aria-label="Like this post" class="penci-post-like single-like-button" data-post_id="8608" title="Like" data-like="Like" data-unlike="Unlike">
                <i class="penci-faicon fa fa-heart-o"></i>
            </a>
        </span>
        <div class="post-share">
    <a class="new-ver-share post-share-item post-share-facebook show" 
       aria-label="Share on Facebook" target="_blank" rel="noreferrer" href="https://www.facebook.com/sharer/sharer.php?u=<%=pageUrl%>">
        <i class="penci-faicon fa fa-facebook"></i>
        <span class="dt-share">Facebook</span>
    </a>  

    <a class="new-ver-share post-share-item post-share-twitter show" 
       aria-label="Share on Twitter" target="_blank" rel="noreferrer" href="https://twitter.com/intent/tweet?text=<%=(String) ((article.getDescription() == null) ? "" : article.getDescription().replaceAll("\\<.*?>", ""))%> <%=pageUrl%>">
        <i class="penci-faicon fa fa-twitter"></i>
        <span class="dt-share">Twitter</span>
    </a>

    <a class="new-ver-share post-share-item post-share-pinterest show" 
       aria-label="Pin to Pinterest" data-pin-do="none" rel="noreferrer" target="_blank" href="https://www.pinterest.com/pin/create/button/?url=<%=pageUrl%>&amp;media=https://www.vivalanka.com/images/chamari-athapaththu.jpg&amp;description=Chamari+Athapaththu+to+Compete+in+The+Hundred+Following+Historic+Asia+Cup+Victory">
        <i class="penci-faicon fa fa-pinterest"></i>
        <span class="dt-share">Pinterest</span>
    </a>

    <a class="new-ver-share post-share-item post-share-email show" 
       target="_blank" aria-label="Share via Email" rel="noreferrer" href="mailto:?subject=Chamari%20Athapaththu%20to%20Compete%20in%20The%20Hundred%20Following%20Historic%20Asia%20Cup%20Victory&amp;body=Read%20more%20about%20Chamari%20Athapaththu's%20latest%20achievement%20here:%20<%=pageUrl%>">
        <i class="penci-faicon fa fa-envelope"></i>
        <span class="dt-share">Email</span>
    </a>
       <a class="post-share-item post-share-expand hidden" href="#" aria-label="Share Expand" style="">
            <i class="penci-faicon penciicon-add"></i>
        </a>
    </div>
</div>

									
<!-- Social media end-->

<!-- edit button start -->

<div>
             <%
          // *** Restrict Access To Page: Grant or deny access to this page
             String MM_authorizedUsers="admin,Editor,CONSULTANT,ADMINISTRATOR,Emp";
             String MM_authFailedURL="../user/login.jsp";
             boolean MM_grantAccess=false;
             if (session.getValue("MM_Username") != null && !session.getValue("MM_Username").equals("")) {
               if (false || (session.getValue("MM_UserAuthorization")=="") || 
                       (MM_authorizedUsers.indexOf((String)session.getValue("MM_UserAuthorization")) >=0)) {
                 MM_grantAccess = true;
               }
             }
             if (MM_grantAccess) {
             %>

              <button style="background-color: #D3D3D3; color: white; border: none; padding: 6px 70px; font-size: 14px; cursor: pointer;">
               <a href="../administrator/articlesedit.jsp?articleid=<%=article.getArticleId()%>" style="color: black; text-decoration: none;">
                EDIT
               </a>
              </button>
              <% } %>
                
</div>

<!-- edit button end -->
									
					<!--  comments start -->
					
					<div class="addthis_sharing_toolbox"></div>
					<div class="fb-comments"
						data-href="<%=pageUrl%>"
						data-numposts="5" data-colorscheme="light"></div>
						<!--  comments end -->
				<!--  ad start -->
				<!-- div style="text-align:left">
					<script async
						src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
				</div>
				<ins class="adsbygoogle"
					style="display:inline-block;width:468px;height:60px"
					data-ad-client="ca-pub-1991368893626594" data-ad-slot="3156070245"></ins>
				<script>
					(adsbygoogle = window.adsbygoogle || []).push({});
				</script-->
			<!--  ad end -->

								</article>
									<!--  single article end -->
                                  
                                  
                                  <!--  main   news start-->

                                
                                 <div
									class="elementor-element elementor-element-4c4fa01 elementor-widget elementor-widget-penci-small-list"
									data-id="4c4fa01" data-element_type="widget"
									data-widget_type="penci-small-list.default">
									<%if(isTextArticle){ %>

									 <div class="elementor-widget-container">
									<div class="post-title-box"><h4 class="post-box-title">You may also like</h4></div>
										<div class="penci-wrapper-smalllist">
											<div class="penci-smalllist-wrapper">
												<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
													<div
														class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">


														<!-- repeat this div start -->
														<%
														articleList = ArticlePageGenerator.getArticleList("7");

														if (request.getAttribute("row_num") != null) {
															row_num = Integer.parseInt((String) request.getAttribute("row_num").toString());
														}

														for (pageIndex = 0; pageIndex <= noofRow; pageIndex++) {
															article = articleList.get(pageIndex);

														}
														for (pageIndex = row_num; pageIndex <= row_num + noofRow; pageIndex++) {
															article = articleList.get(pageIndex);

															contentLength = contentLength + article.getDescription().trim().length() + article.getTitle().trim().length() + 50;

															if (article.getTitle() != null) {
																if (!(article.getDescription() != null && article.getDescription().trim().length() > 150)
																&& article.getUrl() != null && article.getUrl().length() > 10
																&& !(article.getDcode() != null && article.getDcode().contains("hosted"))) {
															link = article.getUrl();
																} else if (article.getAlias() != null) {
															link = "../newspage/" + article.getArticleId() + "ai-" + article.getAlias();
																} else {
															link = "../news/page.jsp?articleid=" + article.getArticleId();
																}

																thumbnail = null;
																if (article.getThumbnail() != null && article.getThumbnail().length() > 5) {
																	thumbnail = article.getThumbnail();
																}
																
																if (article.getUpdated() != null) {
																	displayDate = formatDate(article.getUpdated(), java.text.DateFormat.FULL, null);
																
																} else if (article.getPublished() != null) {
																displayDate = formatDate(article.getPublished(), java.text.DateFormat.FULL, java.util.Locale.CANADA);
															
																} else {
																	displayDate = formatDate(article.getEntryDate(), java.text.DateFormat.FULL , java.util.Locale.CANADA);
																
																}
														%>
														<div class="pcsl-item <%=(thumbnail == null?" pcsl-nothumb": "")%>">
															<div class="pcsl-itemin">
																<div class="pcsl-iteminer">
																	<%
																	if (thumbnail != null) {
																	%>
																	<div class="pcsl-thumb">
																		<a href="<%=link%>" title="<%=article.getTitle()%>"
																			class="penci-image-holder penci-lazy lazyloaded pcloaded"
																			data-bgset="<%=thumbnail%>" data-ll-status="loaded"
																			style="background-image: url(&quot;<%=thumbnail%>&quot;);">
																		</a>
																	</div>
																	<%
																	}
																	%>
																	<div class="pcsl-content">

																		<div class="pcsl-title">
																			<a href="<%=link%>"><%=article.getTitle()%></a>
																		</div>

																		<div>
																			<span class="sl-date"><time
																					class="entry-date published" datetime="2021-11-05">
																					<%= displayDate%>
																				</time></span> <span class="sl-date-author author-italic">
																				- <%=article.getAuthorName() == null ? "" : article.getAuthorName()%>
																			</span>
																		</div>
																		<div>
																			<p style="text-align: left;"><%=article.getDescription() == null ? "" : article.getDescription()%>

																			</p>
																		</div>

																	</div>

																</div>
															</div>
														</div>
														<%
														}
														}
														%>

														<!-- repeat this div end  -->
	
													</div>
												</div>
											</div>
										</div>
									</div>
									<% } %>
								</div>
								 <!--  main  news end-->
							</div>
						</div>
						<!-- contentmiddleupper  end -->
						<!-- middel right (business) start -->

						<!--newssummarynavi start-->
						<jsp:include page="/custom/newssummarynavinarrow_topright.jsp" flush="true" />

						<!--newssummarynavi end-->
						<!-- middel rigt (bussiness and more) end -->
					</div>
				</section>
				<!-- section main end -->
				<!-- section bottom banner start -->
				<section
					class="penci-section penci-disSticky penci-structure-10 elementor-section elementor-top-section elementor-element elementor-element-c790fbe elementor-section-boxed elementor-section-height-default elementor-section-height-default"
					data-id="c790fbe" data-element_type="section">
					<div class="elementor-container elementor-column-gap-no">
						<div
							class="penci-ercol-100 penci-ercol-order-1 penci-sticky-ct  elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-e233981"
							data-id="e233981" data-element_type="column">
							<div class="elementor-widget-wrap elementor-element-populated">
								<div
									class="elementor-element elementor-element-5e3b2d2 elementor-widget elementor-widget-html"
									data-id="5e3b2d2" data-element_type="widget"
									data-widget_type="html.default">
									<div class="elementor-widget-container">
										<div style="text-align: center;">

												<!-- script async
				src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script-->
			<!-- 728x90 -->
			<!--  ins class="adsbygoogle"
				style="display:inline-block;width:728px;height:90px"
				data-ad-client="ca-pub-1991368893626594" data-ad-slot="1235243111"></ins>
			<script>
				(adsbygoogle = window.adsbygoogle || []).push({});
			</script-->
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</section>
				<!-- section bottom banner end -->
				<% if(isTextArticle){ %> <!-- section bottom middle start -->
				<section
					class="penci-section penci-disSticky penci-structure-20 elementor-section elementor-top-section elementor-element elementor-element-826c242 elementor-section-boxed elementor-section-height-default elementor-section-height-default"
					data-id="826c242" data-element_type="section">
					<div class="elementor-container elementor-column-gap-extended">
					
						<!-- bottom left start  -->
						<jsp:include page="/custom/newssummarynaviwide_bottomleft.jsp" flush="true" />
						
						<!-- bottom left  end  -->
						<!-- bottom right start  -->
						<jsp:include page="/custom/newssummarynaviwide_bottomright.jsp" flush="true" />
						
						<!-- bottom right end  -->
					</div>
				</section>
				<% } %> <!-- section bottom middle ends -->
			</div>
		</div>
	</div>
	<!-- main part end  -->


	<!-- ================================================================== -->
			
	
	<%
	endTime = java.util.Calendar.getInstance().getTime();
	loadTimeMap.put("50.afternewssummarynavi", endTime);
	%>

	<jsp:include page="/custom/rcfooter.jsp" flush="true" />
	<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WLFTTCS"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
</body>
</html>

<%
} catch (Exception ex) {
out.print("error -try again.");
ex.printStackTrace();
out.println("<!--");
StringWriter sw = new StringWriter();
PrintWriter pw = new PrintWriter(sw);
ex.printStackTrace(pw);
out.print(sw);
sw.close();
pw.close();
out.println("-->");
}
%>
<%@ include file="../logwriter.jsp"%>