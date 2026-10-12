<%@ page contentType="text/html; charset=UTF-8" language="java"
	import="java.sql.*,java.io.*,com.rev_creations.rcsite.*,org.apache.solr.common.*" errorPage=""%>
<%
java.util.Date startTime = Calendar.getInstance().getTime();
java.util.Date endTime = java.util.Calendar.getInstance().getTime();
long loadTime = endTime.getTime() - startTime.getTime();
SortedMap loadTimeMap = new TreeMap();
loadTimeMap.put("10.startTime-index.jsp", startTime);
%><%@page
	import="java.text.DateFormat,java.util.*,com.rev_creations.persistence.dao.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../Connections/dbconnection.jsp"%>
<%
endTime = java.util.Calendar.getInstance().getTime();
loadTimeMap.put("20.enddbconnection", endTime);
int noofRow = 20;

int pageIndex = 1;
String offsetString = "";
String displayDate="";
ArticleCategory articleCategory = null;
List<ArticleCategory> articleCategoryList = null;
String heading = "";
String articleCategoryId = "";
int Repeat1__numRows;
Iterator itr;

List<Articles> articleList = null;
Articles article = null;

articleList = ArticlePageGenerator.getArticleList("7");
endTime = java.util.Calendar.getInstance().getTime();
loadTimeMap.put("30.getArticleList", endTime);

long newsListTime = 0;
Calendar calendar = Calendar.getInstance();
if (session.getServletContext().getAttribute("newsListTime") != null) {
	newsListTime = ((Long) session.getServletContext().getAttribute("newsListTime")).longValue();
	//calendar.setTimeInMillis(newsListTime);
	SimpleDateFormat formatter;
	formatter = new SimpleDateFormat("H:mm:ss:SSS");

}

if (request.getParameter("restart") != null) {
	session.getServletContext().setAttribute("newsListTime", calendar.getTimeInMillis());
	ArticlePageGenerator.start(session.getServletContext());
	System.out.println("index page news timer created.");
} else if (request.getParameter("stop") != null) {
	ArticlePageGenerator.newsPageTimer.cancel();
	System.out.println("index page news timer stops. +++++++++++++++++++++++++++++");
}
%>
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
	}%>
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html>
<head>
<title>VivaLanka.com - Sri Lanka's Breaking News</title>
<meta name="Description"
	content="Breaking news for Global Sri Lankan Community. Free web ads for Sri Lankan charity and cultural events." />
<meta name="keywords"
	content="breaking news, video, teledrama, latest news,cultural events, Sri Lanka" />
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
request.setAttribute("basePath", basePath);
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />

</head>
<body
	class="home page-template page-template-page-fullwidth page-template-page-fullwidth-php page page-id-8 soledad-ver-8-1-9 pclight-mode pcmn-drdw-style-slide_down pchds-showup elementor-default elementor-kit-4 elementor-page elementor-page-8 e--ua-blink e--ua-chrome e--ua-webkit"
	style="transform: none;" data-elementor-device-mode="desktop"
	data-new-gr-c-s-check-loaded="14.1065.0" data-gr-ext-installed="">
	<jsp:include page="../custom/rcheader.jsp" flush="true" />

	<!-- ================================================================= -->



	<!-- main part start -->
	<div class="container-single-page container-default-page"
		style="transform: none;">
		<div id="main" class="penci-main-single-page-default"
			style="transform: none;">
			<div data-elementor-type="wp-page" data-elementor-id="8"
				class="elementor elementor-8" style="transform: none;">				<!-- section main start -->
				<section
					class="penci-section penci-enSticky penci-repons-elsection penci-con_sb2_sb1 penci-structure-33 elementor-section elementor-top-section elementor-element elementor-element-35af948 elementor-section-boxed elementor-section-height-default elementor-section-height-default"
					data-id="35af948" data-element_type="section"
					style="transform: none;">
					<div class="elementor-container elementor-column-gap-extended"
						style="transform: none;">


						<!-- middel left (video) start -->

						<jsp:include page="../custom/newssummarynaviwide_topleft.jsp"
							flush="true" />
						<!-- middel left (video) end -->
						<!-- contentmiddleupper  start-->

						<%
						java.text.DateFormat newsdf = new SimpleDateFormat("yyyy-MM-dd");
						java.util.Calendar newsDate = java.util.Calendar.getInstance();
						newsDate.add(java.util.Calendar.HOUR, -6);
						String newsDateString = newsdf.format(newsDate.getTime());
						List<Articles> imageArticleList = new ArrayList();;
						String link = "";
						String thumbnail = null;
						int row_num = 0;
						int contentLength = 0;
						%>

						<div
							class="penci-ercol-50 penci-ercol-order-2 penci-sticky-ct  elementor-column elementor-col-40 elementor-top-column elementor-element elementor-element-29b88e4"
							data-id="29b88e4" data-element_type="column"
							data-settings="{&quot;background_background&quot;:&quot;classic&quot;}"
							style="position: relative; overflow: visible; box-sizing: border-box; min-height: 1px;">
							
							
										<!-- AI FLASH NEWS START -->
								
								<!-- start a Search Document bloc -->
		<%
		//articleCategoryId = "18"; // start of article category 		
		articleCategoryId = (String) request.getAttribute("middleTopCatgroy");
		//String[] articleCategoryIds = (String[]) request.getAttribute("middleTopCatgroy");


//Get pagination parameters
int start = 0;
int rows = 20;
if (request.getParameter("start") != null) {
 start = Integer.parseInt(request.getParameter("start"));
}
if (request.getParameter("noofRow") != null) {
 rows = Integer.parseInt(request.getParameter("noofRow"));
}

		List<SearchResult> searchResultList = ArticlePageGenerator.getSearchResultList(articleCategoryId);
	
		// Calculate pagination
		int totalResults = searchResultList.size();
		int totalPages = (int) Math.ceil((double) totalResults / rows);
		int currentPage = (start / rows) + 1;

		// Get subset of results for current page
		int fromIndex = start;
		int toIndex = Math.min(start + rows, totalResults);
		List<SearchResult> currentPageResults = searchResultList.subList(fromIndex, toIndex);
		
		SolrDocument document = null;
		String title = "";
		String description = "";
		String site = "";
		//String displayDate = "";
		String category = "";
		//SearchResult  imageSearchResult ;
		SolrDocument imageDocument = null;
		SearchResult searchResult;
		List<SolrDocument> mltResults = null;
		String image ="";
		String imageDocumentId ="";
		String documentId ="";

		if (searchResultList != null && searchResultList.size() > 0) {
			document = searchResultList.get(0).getMainDocument();
			//heading = (String)document.getFieldValue("category");
			heading = "World News";
			
		%>
		<div
    class="elementor-element elementor-element-4c4fa01 elementor-widget elementor-widget-penci-small-list"
    data-id="4c4fa01" data-element_type="widget"
    data-widget_type="penci-small-list.default">
    <div class="elementor-widget-container" style="border: 1px solid #ADD8E6; padding: 10px;">
        <div class="penci-wrapper-smalllist">

					
					<!-- slider start -->
								<%
								itr = currentPageResults.iterator();
								while (itr.hasNext()) {
									searchResult = (SearchResult) itr.next();
									
									document = searchResult.getMainDocument();
									mltResults = searchResult.getMltResults();

								    image = "";
									title =  (String)document.getFieldValue("title");
									image =  (String)document.getFieldValue("image");
									imageDocumentId = (String)document.getFieldValue("id");
									description =  (String)document.getFieldValue("description");
									if(description==null || "".equals(description)){
										description = (String)document.getFieldValue("content");
										if(description==null || !"".equals(description)){
											description = description.replaceAll("\\<[^>]*>","");
										}
										if(description!=null && description.length()>400){
											 description = description.substring(0, 400)+"...";
											
										} 
									}     
								//	System.out.println("image = " + document.getFieldValue("image"));
								    link =  (String)document.getFieldValue("url");
									category = (String)document.getFieldValue("category");
									displayDate = (new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy")).format((document.getFieldValue("lastModified")));								

									if (image != null && image.length()>2) {

													%>

<div class="elementor-element elementor-element-520f5d7 elementor-widget elementor-widget-penci-big-grid" data-id="520f5d7" data-element_type="widget" data-widget_type="penci-big-grid.default" style="margin-bottom: 0px;">
                <div class="elementor-widget-container">
                
						  <div class="penci-clearfix penci-biggrid-wrapper penci-grid-col-1 penci-grid-mcol-1 penci-bgrid-based-post penci-bgrid-style-1 pcbg-ficonpo-top-right pcbg-reiconpo-top-left penci-bgrid-content-below pencibg-imageh-zoom-in pencibg-texth-none pencibg-textani-movetop textop">
									<div class="penci-clearfix penci-biggrid penci-bgstyle-1 penci-bgel">
											  <div class="penci-biggrid-inner default">
														<div class="penci-clearfix penci-biggrid-data penci-dflex" >
																  <div class="penci-bgitem" style="margin-bottom: 0px;">
																			<div class="penci-bgitin">
																							  <div class="penci-bgmain" >
																											<div class="pcbg-thumb" style="padding: 0;">
																													  <div class="pcbg-thumbin"><a class="pcbg-bgoverlay" href="<%=link%>" 
																																												title="<%=title%>">
																																								</a>
		<div 
  class="penci-image-holder penci-lazy"
  data-bgset="<%=image%>" 
  data_bg_hidpi="<%=image%>" 
  data-sizes="(max-width: 767px) 585px, 768px"
  style="
    width:100%;
    aspect-ratio:620/349;
    background-image:url('<%=image%>');
    background-size:contain;
    background-position:center;
    background-repeat:no-repeat;
    transition:all 0.6s ease;
    will-change:transform, background-size;
    overflow:hidden;
    display:block;
  "
  >
</div>
																													  </div>
																											</div>
																											<div class="pcbg-content" >
																													  <div class="pcbg-content-flex"> <a class="pcbg-bgoverlay" href="<%=link%>" title="<%=title%>"></a>
																																<div class="pcbg-content-inner bgcontent-block" style="padding: 20px 10px 0 10px; " > <a href="<%=link%>" title="<%=title%>" class="pcbg-bgoverlaytext active-overlay item-hover"></a>
																																			
																																		  <div class="pcbg-heading item-hover">
																																			<h3 class="pcbg-title"> <a href="<%=link%>"> <%=title%> </a> </h3>
																																		  </div>
																																		  <div class="grid-post-box-meta pcbg-meta item-hover" >
																																				
																																					<div style="order:4;  padding:4px;">
											    <span class="sl-date-author.author-italic" Style= "FONT-FAMILY: system-ui,-apple-system,Segoe UI; font-size: 12px; color: #C20017;  font-weight: bold; text-transform:uppercase; ">
												<%=category == null ? "" :category%>
												</span><span class="sl-date">
												<time class="entry-date published" datetime="2021-11-05">
												- <%=displayDate%>
												</time></span> 
											</div>
																																							<div class="pcbg-pexcerpt"  style="padding: 0 0 20px 0; border: 1px solid #bad9f8;  border-width: 0 0 1px 0;">
																																							  <p><%=description == null ? "" : description%> &#8230;</p>
																																						
																																					<div class="mlt">
	                                    <a href="#" onclick='jQuery(this).siblings("pre2").toggle(); return false;'>Similar Stories</a>
	                                     <pre2 style="display:none">
	                                     <ul>
	                                     <%
	                                     for (SolrDocument mltDocument : mltResults){	                                     
	                                     %>
		                                 <li><div><a href= " <%= mltDocument.getFieldValue("url") %>" target="_top"> <%=  mltDocument.getFieldValue("title")%> </a> </div></li>
		                                <%
		                                } 
		                                %> 		                                
	                                     </ul>
	                                     </pre2>
	                                     </div>
	                                     </div>
																																				  </div>
																																		</div>
																															  </div>
																													</div>
																										  </div>
																							</div>
																		  </div>
																</div>
													  </div>
											</div>
								  </div>
						</div>
              </div>
<!--------------end 2023 03 04------------------->

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
										<div style="text-align: center; margin-bottom: 10px;">
											
											
											<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1991368893626594"
     crossorigin="anonymous"></script>
<ins class="adsbygoogle"
     style="display:block; text-align:center;"
     data-ad-layout="in-article"
     data-ad-format="fluid"
     data-ad-client="ca-pub-1991368893626594"
     data-ad-slot="2039041521"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</section>
								

								<%
								break;
								}
								}
								%>
								<!-- slider end -->
            
			    
					<div class="penci-smalllist-wrapper">
						<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
							<div
								class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">
								<%

									Repeat1__numRows = 20;
									itr = searchResultList.iterator();
									while (itr.hasNext() && Repeat1__numRows >= 0) {
										searchResult = (SearchResult) itr.next();
										Repeat1__numRows--;
										document = searchResult.getMainDocument();
										mltResults = searchResult.getMltResults();

									    thumbnail = "";
										title =  (String)document.getFieldValue("title");
										thumbnail =  (String)document.getFieldValue("thumbnail");
										documentId =  (String)document.getFieldValue("id");
										description =  (String)document.getFieldValue("description");
										if(description==null || "".equals(description)){
											description = (String)document.getFieldValue("content");
											if(description==null || !"".equals(description)){
												description = description.replaceAll("\\<[^>]*>","");
											}
											if(description!=null && description.length()>400){
												 description = description.substring(0, 400)+"...";
												
											} 
										}
										
									    link =  (String)document.getFieldValue("url");
										category = (String)document.getFieldValue("category");
										displayDate = (new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy")).format((document.getFieldValue("lastModified")));								

										if (title != null & !documentId.equals(imageDocumentId)) {
								%>
															
								<!-- Static content end -->
								
								<div
									class="pcsl-item <%=(thumbnail == null || thumbnail.length()<=3? " pcsl-nothumb" : "")%>">
									<div class="pcsl-itemin" style="padding: 10px 10px 10px 10px;">
										<div class="pcsl-iteminer">
											<%
											if (thumbnail != null && thumbnail.length()>3) {
											%>
											
											<div class="pcsl-thumb">
												<a
													href="<%=link%>"
													title="<%=title%>"
													class="penci-image-holder penci-lazy lazyloaded pcloaded"
													data-bgset="<%=thumbnail%>"
													data-ll-status="loaded"
													style="  background-image: url(&quot;<%=thumbnail%>&quot;);" >
												</a>
											</div>
											<%
											}
											%>
											<div class="pcsl-content" >
												<div class="pcsl-title">
													<a href="<%=link%>"><%=title%></a>
												</div>																													
											</div>
											<div style="order:4;  padding:4px;">
											    <span class="sl-date-author.author-italic" Style= "FONT-FAMILY: system-ui,-apple-system,Segoe UI; font-size: 12px; color: #C20017;  font-weight: bold; text-transform:uppercase; ">
												<%=category == null ? "" :category%>
												</span><span class="sl-date">
												<time class="entry-date published" datetime="2021-11-05">
												- <%=displayDate%>
												</time></span> 
											</div>
                                            <div style="order:5;">
											<p><%=description == null ? "" : description%></p>															
										  </div>										 
										</div>
										 <div class="mlt" ;>
	                                     <a href="#" onclick='jQuery(this).siblings("pre2").toggle(); return false;'>Similar Stories</a>
	                                     <pre2 style="display:none">
	                                     <ul>
	                                     <%
	                                     for (SolrDocument mltDocument : mltResults){	                                     
	                                     %>
		                                 <li><a href= " <%= mltDocument.getFieldValue("url") %>" target="_top"> <%=  mltDocument.getFieldValue("title")%> </a></li>
		                                <%
		                                } 
		                                %> 		                                
	                                     </ul>
	                                     </pre2>
	                                      </div>
									</div>
									
								</div>
								<!-- repeat this div end -->
                               <%								
	
									}

								}
								%>	
								
								<!-- page number start -->
								
								<div class="pcsl-item">
                                <div class="pcsl-itemin">
                                <div class="pcsl-iteminer">
                                <div class="pcsl-content">
                                <div class="pcsl-title">
                    <%
                    int noofPages = totalPages;
                    for (pageIndex = 1; pageIndex <= noofPages; pageIndex++) {
                        int pageStart = (pageIndex - 1) * rows;
                    %>|&nbsp;&nbsp;<span class="sl-comment"><a
                        href="../news/worldnews.jsp?country=<%=request.getParameter("country") != null ? request.getParameter("country") : "" %>&start=<%=pageStart%>&noofRow=<%=rows%>"><%=pageIndex%></a></span>
                    <%
                    }
                    %>&nbsp;&nbsp;|
                </div>
                <div class="grid-post-box-meta pcsl-meta"></div>
            </div>
        </div>
    </div>
</div>
&nbsp;
</div>										 	                            															
													<!-- page number end -->
								
							
							
						
					</div>
				</div>
				
			</div>
		</div>
		<%
		} // end of article category
		%>
		<!-- end Search Document bloc -->
	
								<!-- AI FLASH NEWS END -->
										
							<!-- ==================== SECOND BLOCK - Using middleMiddleCatgroy ==================== -->
							
							<!-- AI FLASH NEWS START - SECOND BLOCK -->
							
							<!-- start second Search Document bloc -->
							<%
							// SECOND BLOCK - Using middleMiddleCatgroy
							String secondArticleCategoryId = (String) request.getAttribute("middleMiddleCatgroy");

							// Get pagination parameters for second block
							int secondStart = 0;
							int secondRows = 20;
							if (request.getParameter("start") != null) {
								secondStart = Integer.parseInt(request.getParameter("start"));
							}
							if (request.getParameter("noofRow") != null) {
								secondRows = Integer.parseInt(request.getParameter("noofRow"));
							}

							List<SearchResult> secondSearchResultList = ArticlePageGenerator.getSearchResultList(secondArticleCategoryId);
					
							// Calculate pagination for second block
							int secondTotalResults = secondSearchResultList.size();
							int secondTotalPages = (int) Math.ceil((double) secondTotalResults / secondRows);
							int secondCurrentPage = (secondStart / secondRows) + 1;

							// Get subset of results for current page
							int secondFromIndex = secondStart;
							int secondToIndex = Math.min(secondStart + secondRows, secondTotalResults);
							List<SearchResult> secondCurrentPageResults = secondSearchResultList.subList(secondFromIndex, secondToIndex);
							
							SolrDocument secondDocument = null;
							String secondTitle = "";
							String secondDescription = "";
							String secondSite = "";
							//String displayDate = "";
							String secondCategory = "";
							//SearchResult  imageSearchResult ;
							SolrDocument secondImageDocument = null;
							SearchResult secondSearchResult;
							List<SolrDocument> secondMltResults = null;
							String secondImage ="";
							String secondImageDocumentId ="";
							String secondDocumentId ="";

							if (secondSearchResultList != null && secondSearchResultList.size() > 0) {
								secondDocument = secondSearchResultList.get(0).getMainDocument();
								//heading = (String)document.getFieldValue("category");
								heading = "Local News";
								
							%>
							<div
								class="elementor-element elementor-element-4c4fa01 elementor-widget elementor-widget-penci-small-list"
								data-id="4c4fa01" data-element_type="widget"
								data-widget_type="penci-small-list.default">
								<div class="elementor-widget-container" style="border: 1px solid #ADD8E6; padding: 10px; margin-top: 20px;">
									<div class="penci-wrapper-smalllist">

								
										<!-- slider start for second block -->
													<%
													itr = secondCurrentPageResults.iterator();
													while (itr.hasNext()) {
														secondSearchResult = (SearchResult) itr.next();
														
														secondDocument = secondSearchResult.getMainDocument();
														secondMltResults = secondSearchResult.getMltResults();

														secondImage = "";
														secondTitle =  (String)secondDocument.getFieldValue("title");
														secondImage =  (String)secondDocument.getFieldValue("image");
														secondImageDocumentId = (String)secondDocument.getFieldValue("id");
														secondDescription =  (String)secondDocument.getFieldValue("description");
														if(secondDescription==null || "".equals(secondDescription)){
															secondDescription = (String)secondDocument.getFieldValue("content");
															if(secondDescription==null || !"".equals(secondDescription)){
																secondDescription = secondDescription.replaceAll("\\<[^>]*>","");
															}
															if(secondDescription!=null && secondDescription.length()>400){
																 secondDescription = secondDescription.substring(0, 400)+"...";
																
															} 
														}     
														link =  (String)secondDocument.getFieldValue("url");
														secondCategory = (String)secondDocument.getFieldValue("category");
														displayDate = (new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy")).format((secondDocument.getFieldValue("lastModified")));								

														if (secondImage != null && secondImage.length()>2) {

																		%>

							<div class="elementor-element elementor-element-520f5d7 elementor-widget elementor-widget-penci-big-grid" data-id="520f5d7" data-element_type="widget" data-widget_type="penci-big-grid.default" style="margin-bottom: 0px;">
											<div class="elementor-widget-container">
											
													  <div class="penci-clearfix penci-biggrid-wrapper penci-grid-col-1 penci-grid-mcol-1 penci-bgrid-based-post penci-bgrid-style-1 pcbg-ficonpo-top-right pcbg-reiconpo-top-left penci-bgrid-content-below pencibg-imageh-zoom-in pencibg-texth-none pencibg-textani-movetop textop">
																	<div class="penci-clearfix penci-biggrid penci-bgstyle-1 penci-bgel">
																			  <div class="penci-biggrid-inner default">
																						<div class="penci-clearfix penci-biggrid-data penci-dflex" >
																								  <div class="penci-bgitem" style="margin-bottom: 0px;">
																											<div class="penci-bgitin">
																															  <div class="penci-bgmain" >
																																			<div class="pcbg-thumb" style="padding: 0;">
																																					  <div class="pcbg-thumbin"><a class="pcbg-bgoverlay" href="<%=link%>" 
																																																				title="<%=secondTitle%>">
																																																</a>
											<div 
							  class="penci-image-holder penci-lazy"
							  data-bgset="<%=secondImage%>" 
							  data_bg_hidpi="<%=secondImage%>" 
							  data-sizes="(max-width: 767px) 585px, 768px"
							  style="
								width:100%;
								aspect-ratio:620/349;
								background-image:url('<%=secondImage%>');
								background-size:contain;
								background-position:center;
								background-repeat:no-repeat;
								transition:all 0.6s ease;
								will-change:transform, background-size;
								overflow:hidden;
								display:block;
							  "
							  >
							</div>
																																					  </div>
																																			</div>
																																			<div class="pcbg-content" >
																																					  <div class="pcbg-content-flex"> <a class="pcbg-bgoverlay" href="<%=link%>" title="<%=secondTitle%>"></a>
																																								<div class="pcbg-content-inner bgcontent-block" style="padding: 20px 10px 0 10px; " > <a href="<%=link%>" title="<%=secondTitle%>" class="pcbg-bgoverlaytext active-overlay item-hover"></a>
																																											
																																										  <div class="pcbg-heading item-hover">
																																											<h3 class="pcbg-title"> <a href="<%=link%>"> <%=secondTitle%> </a> </h3>
																																										  </div>
																																										  <div class="grid-post-box-meta pcbg-meta item-hover" >
																																												
																																													<div style="order:4;  padding:4px;">
																<span class="sl-date-author.author-italic" Style= "FONT-FAMILY: system-ui,-apple-system,Segoe UI; font-size: 12px; color: #C20017;  font-weight: bold; text-transform:uppercase; ">
																<%=secondCategory == null ? "" : secondCategory%>
																</span><span class="sl-date">
																<time class="entry-date published" datetime="2021-11-05">
																- <%=displayDate%>
																</time></span> 
															</div>
																																															<div class="pcbg-pexcerpt"  style="padding: 0 0 20px 0; border: 1px solid #bad9f8;  border-width: 0 0 1px 0;">
																																															  <p><%=secondDescription == null ? "" : secondDescription%> &#8230;</p>
																																														
																																													<div class="mlt">
																	<a href="#" onclick='jQuery(this).siblings("pre2").toggle(); return false;'>Similar Stories</a>
																	 <pre2 style="display:none">
																	 <ul>
																	 <%
																	 for (SolrDocument mltDocument : secondMltResults){	                                     
																	 %>
																	 <li><div><a href= " <%= mltDocument.getFieldValue("url") %>" target="_top"> <%=  mltDocument.getFieldValue("title")%> </a> </div></li>
																	<%
																	} 
																	%> 		                                
																	 </ul>
																	 </pre2>
																	 </div>
																	 </div>
																																												  </div>
																																										</div>
																																							  </div>
																																					</div>
																																		  </div>
																															</div>
																										  </div>
																								</div>
																					  </div>
																			</div>
																  </div>
														</div>
											</div>
								</div>
							<!--------------end 2023 03 04------------------->

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
															<div style="text-align: center; margin-bottom: 10px;">
																
																
																<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1991368893626594"
									 crossorigin="anonymous"></script>
							<ins class="adsbygoogle"
								 style="display:block; text-align:center;"
								 data-ad-layout="in-article"
								 data-ad-format="fluid"
								 data-ad-client="ca-pub-1991368893626594"
								 data-ad-slot="2039041521"></ins>
							<script>
								 (adsbygoogle = window.adsbygoogle || []).push({});
							</script>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</section>
												

													<%
													break;
													}
													}
													%>
													<!-- slider end for second block -->
								
					
										<div class="penci-smalllist-wrapper">
											<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
												<div
													class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">
													<%

														Repeat1__numRows = 20;
														itr = secondSearchResultList.iterator();
														while (itr.hasNext() && Repeat1__numRows >= 0) {
															secondSearchResult = (SearchResult) itr.next();
															Repeat1__numRows--;
															secondDocument = secondSearchResult.getMainDocument();
															secondMltResults = secondSearchResult.getMltResults();

															thumbnail = "";
															secondTitle =  (String)secondDocument.getFieldValue("title");
															thumbnail =  (String)secondDocument.getFieldValue("thumbnail");
															secondDocumentId =  (String)secondDocument.getFieldValue("id");
															secondDescription =  (String)secondDocument.getFieldValue("description");
															if(secondDescription==null || "".equals(secondDescription)){
																secondDescription = (String)secondDocument.getFieldValue("content");
																if(secondDescription==null || !"".equals(secondDescription)){
																	secondDescription = secondDescription.replaceAll("\\<[^>]*>","");
																}
																if(secondDescription!=null && secondDescription.length()>400){
																	 secondDescription = secondDescription.substring(0, 400)+"...";
																	
																} 
															}
															
															link =  (String)secondDocument.getFieldValue("url");
															secondCategory = (String)secondDocument.getFieldValue("category");
															displayDate = (new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy")).format((secondDocument.getFieldValue("lastModified")));								

															if (secondTitle != null & !secondDocumentId.equals(secondImageDocumentId)) {
													%>
																
													<!-- Static content end -->
													
													<div
														class="pcsl-item <%=(thumbnail == null || thumbnail.length()<=3 ? "pcsl-nothumb" : "")%>">
														<div class="pcsl-itemin" style="padding: 10px 10px 10px 10px;">
															<div class="pcsl-iteminer">
																<%
																if (thumbnail != null && thumbnail.length()>3) {
																%>
																
																<div class="pcsl-thumb">
																	<a
																		href="<%=link%>"
																		title="<%=secondTitle%>"
																		class="penci-image-holder penci-lazy lazyloaded pcloaded"
																		data-bgset="<%=thumbnail%>"
																		data-ll-status="loaded"
																		style="  background-image: url(&quot;<%=thumbnail%>&quot;);" >
																	</a>
																</div>
																<%
																}
																%>
																<div class="pcsl-content" >
																	<div class="pcsl-title">
																		<a href="<%=link%>"><%=secondTitle%></a>
																	</div>																													
																</div>
																<div style="order:4;  padding:4px;">
																	<span class="sl-date-author.author-italic" Style= "FONT-FAMILY: system-ui,-apple-system,Segoe UI; font-size: 12px; color: #C20017;  font-weight: bold; text-transform:uppercase; ">
																	<%=secondCategory == null ? "" : secondCategory%>
																	</span><span class="sl-date">
																	<time class="entry-date published" datetime="2021-11-05">
																	- <%=displayDate%>
																	</time></span> 
																</div>
																<div style="order:5;">
																<p><%=secondDescription == null ? "" : secondDescription%></p>															
															  </div>										 
															</div>
															 <div class="mlt" ;>
															 <a href="#" onclick='jQuery(this).siblings("pre2").toggle(); return false;'>Similar Stories</a>
															 <pre2 style="display:none">
															 <ul>
															 <%
															 for (SolrDocument mltDocument : secondMltResults){	                                     
															 %>
															 <li><a href= " <%= mltDocument.getFieldValue("url") %>" target="_top"> <%=  mltDocument.getFieldValue("title")%> </a></li>
															<%
															} 
															%> 		                                
															 </ul>
															 </pre2>
															  </div>
														</div>
														
													</div>
													<!-- repeat this div end -->
												   <%								
		
														}

													}
													%>	
													
													<!-- page number start for second block -->
													
													<div class="pcsl-item">
													<div class="pcsl-itemin">
													<div class="pcsl-iteminer">
													<div class="pcsl-content">
													<div class="pcsl-title">
										<%
										int secondNoofPages = secondTotalPages;
										for (int secondPageIdx = 1; secondPageIdx <= secondNoofPages; secondPageIdx++) {
											int pageStart = (secondPageIdx - 1) * secondRows;
										%>|&nbsp;&nbsp;<span class="sl-comment"><a
											href="../news/worldnews.jsp?country=<%=request.getParameter("country") != null ? request.getParameter("country") : "" %>&start=<%=pageStart%>&noofRow=<%=secondRows%>"><%=secondPageIdx%></a></span>
										<%
										}
										%>&nbsp;&nbsp;|
									</div>
									<div class="grid-post-box-meta pcsl-meta"></div>
								</div>
							</div>
						</div>
					</div>
					&nbsp;
					</div>										 	                            															
														<!-- page number end for second block -->
									
								
								
								
						</div>
					</div>
					
				</div>
			</div>
			<%
			} // end of second article category
			%>
			<!-- end second Search Document bloc -->
		
									<!-- AI FLASH NEWS END FOR SECOND BLOCK -->				
						

							
							</div>
						</div>
						<!-- contentmiddleupper  end -->
						<!-- middel right (business) start -->

						<!--newssummarynavi start-->
						<jsp:include page="../custom/newssummarynavinarrow_topright.jsp" flush="true" />

						<!--newssummarynavi end-->
						<!-- middel rigt (bussiness and more) end -->
					</div>
				</section>
				<!-- section main end -->
				<!-- section bottom banner start -->
						</section>
					<section
					class="penci-section penci-disSticky penci-structure-10 elementor-section elementor-top-section elementor-element elementor-element-c790fbe elementor-section-boxed elementor-section-height-default elementor-section-height-default"
					data-id="c790fbe" data-element_type="section" style="margin-top:-30px;">
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
											
											<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1991368893626594"
     crossorigin="anonymous"></script>
<ins class="adsbygoogle"
     style="display:block; text-align:center;"
     data-ad-layout="in-article"
     data-ad-format="fluid"
     data-ad-client="ca-pub-1991368893626594"
     data-ad-slot="7200116281"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
											
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</section>
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
			<!-- ins class="adsbygoogle"
				style="display:inline-block;width:728px;height:90px"
				data-ad-client="ca-pub-1991368893626594" data-ad-slot="1235243111"></ins>
			<script>
				(adsbygoogle = window.adsbygoogle || []).push({});
			</script -->
			
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</section>
				<!-- section bottom banner end -->
				<!-- section bottom middle start -->
				<section
					class="penci-section penci-disSticky penci-structure-20 elementor-section elementor-top-section elementor-element elementor-element-826c242 elementor-section-boxed elementor-section-height-default elementor-section-height-default"
					data-id="826c242" data-element_type="section">
					<div class="elementor-container elementor-column-gap-extended">
					
						<!-- bottom left start  -->
						<jsp:include page="../custom/newssummarynaviwide_bottomleft.jsp" flush="true" />
						
						<!-- bottom left  end  -->
						<!-- bottom right start  -->
						<jsp:include page="../custom/newssummarynaviwide_bottomright.jsp" flush="true" />
						
						<!-- bottom right end  -->
					</div>
				</section>
				<!-- section bottom middle ends -->
			</div>
		</div>
	</div>
	<!-- main part end  -->


	<!-- ================================================================== -->
			
	
	<%
	endTime = java.util.Calendar.getInstance().getTime();
	loadTimeMap.put("50.afternewssummarynavi", endTime);
	%>
	<jsp:include page="../custom/rcfooter.jsp" flush="true" />
	<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WLFTTCS"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
</body>
</html>
<%@ include file="../logwriter.jsp"%>