<%@ page language="java"
	import="java.sql.*,java.util.*,com.rev_creations.persistence.dao.*"
	contentType="text/html; charset=UTF-8"%>
<%@page import="com.maxmind.geoip.Location"%>
<%@page import="com.rev_creations.rcsite.*,org.apache.solr.common.*"%>
<%@ include file="../Connections/dbconnection.jsp"%>
<%
String localNewsCategories = (String) session.getAttribute("localNewsCategories");
String localFeaturesCategories = (String) session.getAttribute("localFeaturesCategories");
List newsSummaryList = null;
int Repeat1__numRows;
Articles newsSummary;
Articles thubnailSummary;
Calendar calendar = new GregorianCalendar();
String countryCode = ((LocationBean) session.getAttribute("location")).getCountryCode();
calendar.add(Calendar.MONTH, -3);

Iterator itr;
int contentLength = 0;
int row_num = 0;
ArticleCategory articleCategory = null;
List<ArticleCategory> articleCategoryList = null;
String heading = "";
String link = "";
String articleCategoryId = "";
%>

<div
	class="penci-ercol-25 penci-ercol-order-1 penci-sticky-sb penci-sidebarSC elementor-column elementor-col-35 elementor-top-column elementor-element elementor-element-41bc9bf"
	data-id="41bc9bf" data-element_type="column"
	style="position: relative; overflow: visible; box-sizing: border-box; min-height: 1px;  ">
	 

	<div
		class="elementor-widget-wrap elementor-element-populated theiaStickySidebar"
		style="position: static; padding-top: 0px; padding-bottom: 1px;">
		
		<!-- start a Search Document bloc -->


		<%
		//articleCategoryId = "wp.18"; // start of article category
		articleCategoryId = (String) request.getAttribute("leftTopCategroy");
		List<SearchResult> searchResultList = ArticlePageGenerator.getSearchResultList(articleCategoryId);
		
		SolrDocument document = null;
		String title = "";
		String description = "";
		String site = "";
		String displayDate = "";
		String category = "";

		if (searchResultList != null && searchResultList.size() > 0) {
			document = searchResultList.get(0).getMainDocument();
			//heading = (String)document.getFieldValue("category");
			heading = "Sri Lankan Community News";
			
		%>
		<div
			class="elementor-element elementor-element-c05069a elementor-widget elementor-widget-penci-small-list"
			data-id="c05069a" data-element_type="widget"
			data-widget_type="penci-small-list.default">
			<div class="elementor-widget-container">
				<div class="penci-wrapper-smalllist">
					<div
						class="penci-border-arrow penci-homepage-title penci-home-latest-posts style-6 pcalign-left pciconp-right pcicon-right block-title-icon-left">
						<h3 class="inner-arrow">
							<span> <span><%=heading%></span><a
								class="pcbh-extrabtn pcbh-btns-none pcbh-btnp-right pcbh-btni-right"
								href="../news/pagelist.jsp?categoryid=92">View
											All<i class="fas fa-long-arrow-alt-right"></i>
							</a>
							</span>
						</h3>
					</div>
					<!-- Community video start -->
             <%
				if (true) {
				%>
					 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                     <div class="container">
                     <div class="embed-responsive embed-responsive-16by9">
                         	<%
// Get URL for category ID 92 directly from the article's URL field
articleCategoryId = "92";
newsSummaryList = ArticlePageGenerator.getArticleList(articleCategoryId);
if (newsSummaryList != null && !newsSummaryList.isEmpty()) {
    Articles latestArticle = (Articles) newsSummaryList.get(0);
    String articleUrl = latestArticle.getUrl();
    
    if (articleUrl != null && !articleUrl.isEmpty()) {
%>
                    <!-- <iframe class="embed-responsive-item" width="450" height="250" src="https://www.youtube.com/embed/qDVuSFy7e4o" allowfullscreen></iframe>-->
                     <%
    }
}
%>    	<%
articleCategoryId = "92";
newsSummaryList = ArticlePageGenerator.getArticleList(articleCategoryId);
if (newsSummaryList != null && !newsSummaryList.isEmpty()) {
    Articles latestArticle = (Articles) newsSummaryList.get(0);
    String articleUrl = latestArticle.getUrl();
    String articleTitle = latestArticle.getTitle();
    
    if (articleUrl != null && !articleUrl.isEmpty()) {
       
        String videoId = null;
        int index = articleUrl.indexOf("v=");
        if (index != -1) {
            videoId = articleUrl.substring(index + 2);
            
            int ampIndex = videoId.indexOf("&");
            if (ampIndex != -1) {
                videoId = videoId.substring(0, ampIndex);
            }
        }
        
        if (videoId != null) {
%>
            <iframe class="embed-responsive-item" width="450" height="250" 
                src="https://www.youtube.com/embed/<%=videoId%>" 
                allowfullscreen>
            </iframe>
             <div class="pcsl-content mt-2">
        <div class="pcsl-title fw-bold">
            <a href="<%=articleUrl%>"><%=articleTitle%></a>
        </div>
    </div>
<%
        }
    }
}
%>

                     
                     </div>
					 <br>
                    </div>
				<%
				} else {
				%>
				<script async
					src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
				<!-- 300X250 -->
				<ins class="adsbygoogle"
					style="display:inline-block;width:300px;height:250px"
					data-ad-client="ca-pub-1991368893626594" data-ad-slot="7137416951"></ins>
				<script>
					(adsbygoogle = window.adsbygoogle || []).push({});
				</script>
				<%}%>
			    <!-- Community video end -->
					<div class="penci-smalllist-wrapper">
						<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
							<div
								class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">
								<%
								SearchResult searchResult;
								List<SolrDocument> mltResults = null;
									Repeat1__numRows = 10;
									itr = searchResultList.iterator();
									while (itr.hasNext() && Repeat1__numRows >= 0) {
										searchResult = (SearchResult) itr.next();
										Repeat1__numRows--;
										document = searchResult.getMainDocument();
										mltResults = searchResult.getMltResults();

										String thumbnail = "";
										title =  (String)document.getFieldValue("title");
										thumbnail =  (String)document.getFieldValue("thumbnail");
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

										if (title != null) {
								%>
															
								<!-- Static content end -->
								
								<div
									class="pcsl-item <%=(thumbnail == null ? " pcsl-nothumb" : "")%>">
									<div class="pcsl-itemin">
										<div class="pcsl-iteminer">
											<%
											if (thumbnail != null) {
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
											<div style="order:4;  padding:8px;">
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
								<!-- repeat this div end -->
                               <%								
	
									}

								}
								%>																
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%
		} // end of article category
		%>
		<!-- end Search Document bloc -->
		
	
		<!-- start advertising bloc -->
		<div
			class="elementor-element elementor-element-22fb751 elementor-widget elementor-widget-html"
			data-id="22fb751" data-element_type="widget"
			data-widget_type="html.default">
			<div class="elementor-widget-container">
			<%
				if (true) {
				%>

					<a
					href="../slcommunity/registration/"
					target="_top"><img
					src="../custom/media2/Charities.png"
					alt="How can Sri Lankan charities find international donors and partners?" width="600" height="250" border="0"  
					style=" display: block; margin-left: auto; margin-right: auto;"/></a>
				<%
				} else {
				%>
 
				<script async
					src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
				<!-- 300X250 -->
				<ins class="adsbygoogle"
					style="display:inline-block;width:300px;height:250px"
					data-ad-client="ca-pub-1991368893626594" data-ad-slot="7137416951"></ins>
				<script>
					(adsbygoogle = window.adsbygoogle || []).push({});
				</script>

				<%}%>
			</div>
		</div>
		<!-- end advertising bloc -->
		<!-- start list bloc -->
    <div class="box-container" style= "padding: 20px 20px 20px 20px; border:  1px solid #ADD8E6; ">
        <div class="elementor-element elementor-element-210a843 elementor-widget elementor-widget-penci-popular-cat"
             data-id="210a843" data-element_type="widget" data-widget_type="penci-popular-cat.default">
            <div class="penci-block-vc penci-block-popular-cat widget_categories widget widget_categories">
                <div class="row">
                    <h5 class="inner-arrow" style="text-align: left;">
                        <span> <span>Categories: </span> </span>
                    </h5>
                    <div class="col-md-4">
                        <div class="left-list">
                            <ul>
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=7">Breaking News</a></li>
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=8">Sports</a></li>
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=10">Business</a></li>
                                <li class="cat-item cat-item-2"><a href="../slcommunity/">Community News<span class="category-item-count"></span></a></li>                      
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="center-list">
                            <ul>
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=13">Travel</a></li>
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=16">Education</a></li>
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=14">Technology</a></li>   
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=94">Lanka Life Diaries</a></li>                                                        
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="right-list">
                              <ul>
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=11">Video</a></li>
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=90">AI Flash News<span class="category-item-count"></span></a></li>                               
                                <li class="cat-item cat-item-2"><a href="../news/pagelist.jsp?categoryid=12">Entertainment</a></li>
                            </ul>  
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="padding-container" style=" padding: 10px;"></div>
<!-- end list bloc -->

		<!-- start an article bloc -->
		<%
		articleCategoryId = "11"; // start of article category
		newsSummaryList = ArticlePageGenerator.getArticleList(articleCategoryId);
		articleCategoryList = ArticlePageGenerator.getArticleCategoryMap(articleCategoryId);
		if (newsSummaryList != null && newsSummaryList.size() > 0) {

			Iterator iter = articleCategoryList.iterator();
			while (iter.hasNext()) {
				articleCategory = (ArticleCategory) iter.next();
				heading = articleCategory.getCategoryName() + " / ";//+heading;
			}
			heading = heading.substring(0, heading.lastIndexOf(" /")) + ":";
		%>
		<div
			class="elementor-element elementor-element-c05069a elementor-widget elementor-widget-penci-small-list"
			data-id="c05069a" data-element_type="widget"
			data-widget_type="penci-small-list.default">
			<div class="elementor-widget-container">
				<div class="penci-wrapper-smalllist">
					<div
						class="penci-border-arrow penci-homepage-title penci-home-latest-posts style-6 pcalign-left pciconp-right pcicon-right block-title-icon-left">
						<h3 class="inner-arrow">
							<span> <span><%=heading%></span>
							<!--  <a
								class="pcbh-extrabtn pcbh-btns-none pcbh-btnp-right pcbh-btni-right"
								href="../rcsearch/news?&q=&fq=category:%22<%=heading.substring(0, heading.lastIndexOf(":"))%>%22&NarrowBy=Category">View
									All<i class="fas fa-long-arrow-alt-right"></i>
							</a>-->
							</span>
						</h3>
					</div>
					<div class="penci-smalllist-wrapper">
						<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
							<div
								class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">
								<%
								Repeat1__numRows = 6;
								itr = newsSummaryList.iterator();
								while (itr.hasNext() && Repeat1__numRows >= 0) {
									newsSummary = (Articles) itr.next();
									Repeat1__numRows--;

									String thumbnail = null;
									if (newsSummary.getThumbnail() != null && newsSummary.getThumbnail().length() > 5) {
										thumbnail = newsSummary.getThumbnail();
									}

									if (newsSummary.getAlias() != null) {
										link = "../newspage/" + newsSummary.getArticleId() + "ai-" + newsSummary.getAlias();
									} else {
										link = "../news/page.jsp?articleid=" + newsSummary.getArticleId();
									}

									if (newsSummary.getTitle() != null) {
								%>
								<!-- repeat this div start -->
								<div
									class="pcsl-item <%=(thumbnail == null ? " pcsl-nothumb" : "")%>">
									<div class="pcsl-itemin">
										<div class="pcsl-iteminer">
											<%
											if (thumbnail != null) {
											%>
											<div class="pcsl-thumb">
												<a
													href="<%=link%>"
													title="<%=newsSummary.getTitle()%>"
													class="penci-image-holder penci-lazy lazyloaded pcloaded"
													data-bgset="<%=thumbnail%>"
													data-ll-status="loaded"
													style="background-image: url('<%=newsSummary.getThumbnail()%>');">
												</a>
											</div>
											<%
											}
											%>
											<div class="pcsl-content">
												<div class="pcsl-title">
													<a href="<%=link%>"><%=newsSummary.getTitle()%></a>
												</div>
											</div>
										</div>
									</div>
								</div>
								<!-- repeat this div end -->

								<%
								}

								}
								%>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%
		} // end of article category
		%>
		<!-- end article bloc -->
	</div>
</div>