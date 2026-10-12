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
	class="penci-ercol-25 penci-ercol-order-1 penci-sticky-sb penci-sidebarSC elementor-column elementor-col-25 elementor-top-column elementor-element elementor-element-41bc9bf"
	data-id="41bc9bf" data-element_type="column"
	style="position: relative; overflow: visible; box-sizing: border-box; min-height: 1px; order:3;">

	<div
		class="elementor-widget-wrap elementor-element-populated theiaStickySidebar"
		style="position: static; padding-top: 0px; padding-bottom: 1px;">
		
		<!-- start a resource bloc -->
		<div
			class="elementor-element elementor-element-c05069a elementor-widget elementor-widget-penci-small-list"
			data-id="c05069a" data-element_type="widget"
			data-widget_type="penci-small-list.default">
			<div class="elementor-widget-container">
				<div class="penci-wrapper-smalllist">
					<div
						class="penci-border-arrow penci-homepage-title penci-home-latest-posts style-6 pcalign-left pciconp-right pcicon-right block-title-icon-left">
						<h3 class="inner-arrow">
							<span> <span>Resources for Sri Lankan Charities:</span><a
								class="pcbh-extrabtn pcbh-btns-none pcbh-btnp-right pcbh-btni-right"
								href="../slcommunity/category/resources-for-sri-lankan-charities/">View
									All<i class="fas fa-long-arrow-alt-right"></i>
							</a>
							</span>
						</h3>
					</div>
					<div class="penci-smalllist-wrapper">
						<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
							<div
								class="penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">
			

								<!-- repeat this div start -->
								<!-- First image with play button -->
                <div class="elementor-widget-container" style="margin-top:10px; position: relative;">
                    <a href="../slcommunity/what-are-the-basic-guidelines-for-sri-lankan-charities-to-receive-international-donations/" target="_top">
                        <img src="../custom/media2/basic_guidelines_300x170.png"
                            alt="How important are accountability and transparency for a charity to receive international donations" 
                            width="300" height="250" border="0"  
                            style="display: block; margin-left: auto; margin-right: auto;"/>
                        <!-- YouTube play button overlay -->
                        <div class="youtube-play-overlay">
                            <div class="youtube-play-button">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="white">
                                    <path d="M8 5v14l11-7z"/>
                                </svg>
                            </div>
                        </div>
                    </a>
                </div>
                <style>
.youtube-play-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    pointer-events: none; 
}

.youtube-play-button {
    width: 40px; 
    height: 40px; 
    background-color: #ff0000;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
    
    pointer-events: auto; 
}

.youtube-play-button:hover {
    
}
</style>
								<!-- repeat this div end -->

								<!-- repeat this div start -->
								<div class="elementor-widget-container" style="margin-top:10px; position: relative;">
                    <a href="../slcommunity/how-important-are-accountability-and-transparency-for-a-charity-to-receive-international-donations/" target="_top">
                        <img src="../custom/media2/Accountability_and_Transparency_300x170.png"
                            alt="How important are accountability and transparency for a charity to receive international donations" 
                            width="300" height="250" border="0"  
                            style="display: block; margin-left: auto; margin-right: auto;"/>
                        <!-- YouTube play button overlay -->
                        <div class="youtube-play-overlay">
                            <div class="youtube-play-button">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="white">
                                    <path d="M8 5v14l11-7z"/>
                                </svg>
                            </div>
                        </div>
                    </a>
                </div>
								<!-- repeat this div end -->


							</div>


						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- end a resource bloc -->
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
										<div style="text-align: center; margin-bottom: 20px;">
										<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1991368893626594"
     crossorigin="anonymous"></script>
<!-- Home page square ad -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1991368893626594"
     data-ad-slot="4110918513"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
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
				
				
		
		<!-- start a Event Search Document bloc -->
		<%
		//articleCategoryId = "wp.49"; // start of article category
		articleCategoryId = (String) request.getAttribute("rightTopCategroy");
		List<SearchResult> searchResultList = ArticlePageGenerator.getSearchResultList(articleCategoryId);
		
		SolrDocument document = null;
		String title = "";
		String description = "";
		String site = "";
		String displayDate = "";
		String startDate = "";
		String category = "";

		if (searchResultList != null && searchResultList.size() > 0) {
			document = searchResultList.get(0).getMainDocument();
			//heading = (String)document.getFieldValue("category");
			heading = "Sri Lankan Community Events";
			
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
								href="../slcommunity/events/">View
											All<i class="fas fa-long-arrow-alt-right"></i>
							</a>
							</span>
						</h3>
					</div>
					
					<div class="penci-smalllist-wrapper">
						<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
							<div
								class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">

								<%
								SearchResult searchResult;
								//for(SearchResult searchResult: searchResultList ){
									Repeat1__numRows = 6;
									itr = searchResultList.iterator();
									while (itr.hasNext() && Repeat1__numRows >= 0) {
										searchResult = (SearchResult) itr.next();
										Repeat1__numRows--;
										
										document = searchResult.getMainDocument();
																	
										String thumbnail = "";
										title =  (String)document.getFieldValue("title");
										description =  (String)document.getFieldValue("description");									
										
								    	link =  (String)document.getFieldValue("url");
									
									 //category =  (String)document.getFieldValue("category"));
										thumbnail =  (String)document.getFieldValue("thumbnail");
										category = (String)document.getFieldValue("category");
//										startDate = (new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy")).format((document.getFieldValue("start_date")));
	//startDate =   ""+document.getFieldValue("start_date");
									if (title != null) {
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
													title="<%=title%>"
													class="penci-image-holder penci-lazy lazyloaded pcloaded"
													data-bgset="<%=thumbnail%>"
													data-ll-status="loaded"
													style="background-image: url(&quot;<%=thumbnail%>&quot;);">
												</a>
											</div>
											<%
											}
											%>
											<div class="pcsl-content">
												<div class="pcsl-title">
									       		 <a href="<%=link%>"><%=title%></a>
												</div>
											</div>
											<div style="order:4;">
										    	<span class="sl-date-author-italic" Style= "FONT-FAMILY: system-ui,-apple-system,Segoe UI; font-size: 12px; color: #C20017;  font-weight: bold; text-transform:uppercase;">
													<%=category == null ? "" :category%>
												</span>
											<div>
												<!--span class="sl-date">When: <time
					                        		class="entry-date published" datetime="2021-11-05">                                                                                  
													<%=startDate%></time>
												</span-->
											</div> 
											<div>
												<span class="sl-date">
													<time class="entry-date published" datetime="2021-11-05">
														<%=displayDate%>
													</time>
												</span>
											</div> 
											</div>
                                            <div style="order:5;">
											<p><%=description == null ? "" : description%></p>															
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
		<!-- end Event Search Document bloc -->
		
	<!-- start charity bloc -->
		
		<%
//articleCategoryId = "wp.18"; // start of article category
articleCategoryId = (String) request.getAttribute("rightCharityCatgroy");
searchResultList = ArticlePageGenerator.getSearchResultList(articleCategoryId);

document = null;
title = "";

if (searchResultList != null && searchResultList.size() > 0) {
    document = searchResultList.get(0).getMainDocument();
    heading = "Sri Lankan Charities";
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
							<span> <span>Sri Lankan Charities:</span><a
								class="pcbh-extrabtn pcbh-btns-none pcbh-btnp-right pcbh-btni-right"
								href="../slcommunity/single-category/sri-lankan-charities-sri-lanka/">View
									All<i class="fas fa-long-arrow-alt-right"></i>
							</a>
							</span>
						</h3>
					</div>
					<div class="penci-smalllist-wrapper">
						<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
							<div
								class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">

								<%
                        SearchResult searchResult;
                        Repeat1__numRows = 6;
                        itr = searchResultList.iterator();
                        while (itr.hasNext() && Repeat1__numRows >= 0) {
                            searchResult = (SearchResult) itr.next();
                            Repeat1__numRows--;
                            
                            document = searchResult.getMainDocument();
                                                        
                            String thumbnail = "";
                            title =  (String)document.getFieldValue("title");
                            description =  (String)document.getFieldValue("description");                                    
                            
                            link =  (String)document.getFieldValue("url");
                        
                            thumbnail =  (String)document.getFieldValue("thumbnail");
                            category = (String)document.getFieldValue("category");
                            
                            if (title != null) {
                        %>

								<!-- repeat this div start -->
								
								<!--<div
									class="pcsl-item ">
									<div class="pcsl-itemin">
										<div class="pcsl-iteminer">
											
											<div class="pcsl-thumb">
												<a
													href="../slcommunity/directory/organization-of-people-for-engagement-and-enterprise/"
													title="Organization of People for Engagement and Enterprise"
													class="penci-image-holder penci-lazy lazyloaded pcloaded"
													data-bgset="../slcommunity/wp-content/uploads/2023/07/opene-150x150.jpg"
													data-ll-status="loaded"
													style="background-image: url(&quot;../slcommunity/wp-content/uploads/2023/07/opene-150x150.jpg&quot;);">
												</a>
											</div>
											
											<div class="pcsl-content">

												<div class="pcsl-title">
													<a href="../slcommunity/directory/organization-of-people-for-engagement-and-enterprise/">Organization of People for Engagement and Enterprise</a>

												</div>


											</div>

										</div>
									</div>
								</div>-->
								<!-- repeat this div end -->

								

								<!-- repeat this div start -->
								<!-- <div
									class="pcsl-item ">
									<div class="pcsl-itemin">
										<div class="pcsl-iteminer">
											
											<div class="pcsl-thumb">
												<a
													href="../slcommunity/directory/kansarmen-sl-foundation/"
													title="Kansarmen SL Foundation"
													class="penci-image-holder penci-lazy lazyloaded pcloaded"
													data-bgset="../slcommunity/wp-content/uploads/2023/07/kansarmenslfoundationlogo2-150x150.png"
													data-ll-status="loaded"
													style="background-image: url(&quot;../slcommunity/wp-content/uploads/2023/07/kansarmenslfoundationlogo2-150x150.png&quot;);">
												</a>
											</div>
											
											<div class="pcsl-content">

												<div class="pcsl-title">
													<a href="../slcommunity/directory/kansarmen-sl-foundation/">Kansarmen SL Foundation</a>

												</div>


											</div>

										</div>
									</div>
								</div>-->
								<!-- repeat this div end -->

								

								<!-- repeat this div start -->
								<!--  <div
									class="pcsl-item ">
									<div class="pcsl-itemin">
										<div class="pcsl-iteminer">
											
											<div class="pcsl-thumb">
												<a
													href="../slcommunity/directory/rainforest-protectors-trust/"
													title="Rainforest Protectors Trust"
													class="penci-image-holder penci-lazy lazyloaded pcloaded"
													data-bgset="../slcommunity/wp-content/uploads/2022/11/RainforestProtectorsTrust3-150x150.jpg"
													data-ll-status="loaded"
													style="background-image: url(&quot;../slcommunity/wp-content/uploads/2022/11/RainforestProtectorsTrust3-150x150.jpg&quot;);">
												</a>
											</div>
											
											<div class="pcsl-content">

												<div class="pcsl-title">
													<a href="../slcommunity/directory/rainforest-protectors-trust/">Rainforest Protectors Trust</a>

												</div>


											</div>

										</div>
									</div>
								</div>-->
								<!-- repeat this div end -->
 <!-- repeat this div start -->
                        <div class="pcsl-item">
                            <div class="pcsl-itemin">
                                <div class="pcsl-iteminer">
                                    
                                    <div class="pcsl-thumb">
                                        <a href="<%=link%>"
                                           title="<%=title%>"
                                           class="penci-image-holder penci-lazy lazyloaded pcloaded"
                                           data-bgset="<%=thumbnail != null ? thumbnail : "../slcommunity/wp-content/uploads/2023/07/default-charity-150x150.jpg"%>"
                                           data-ll-status="loaded"
                                           style="background-image: url('<%=thumbnail != null ? thumbnail : "../slcommunity/wp-content/uploads/2023/07/default-charity-150x150.jpg"%>');">
                                        </a>
                                    </div>
                                    
                                    <div class="pcsl-content">
                                        <div class="pcsl-title">
                                            <a href="<%=link%>"><%=title%></a>
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
					<div style="margin-top: 10px; text-align: right;">
						<h3 class="inner-arrow">
							<a
								class="pcbh-extrabtn pcbh-btns-none pcbh-btnp-right pcbh-btni-right"
								href="../slcommunity/add-listing/"><h6>Add Your Sri Lankan Charity >></h6><i class="fas fa-long-arrow-alt-right"></i>
							</a>
							</span>
						</h3>
					</div>
				</div>
			</div>
		</div>
	<%
} // end of article category
%>	
		<!-- end charity bloc -->
		<aside style="margin-bottom: 30px;" id="penci_social_counter-1" class="widget penci_social_counter">
<h3 class="widget-title penci-border-arrow"><span class="inner-arrow">Follow Us</span></h3> 
<div class="pcsoc-wrapper-outside source-counter" id="penci-sct-708420"> 
<div class="pcsoc-wrapper pcsocs-s1 pcsocf-fill pcsocs-rectangle pcsoccl-brandbg pcsocc-1 pcsocc-tabcol-1 pcsocc-mocol-1"> <div class="pcsoc-item-wrap"> <a class="pcsoc-item pcsoci-facebook pcsc-brandflag" href="https://www.facebook.com/vivalanka" target="_blank" rel="noreferrer"> <span class="pcsoc-icon pcsoci-facebook"><i class="penci-faicon fa fa-facebook"></i></span> <span class="pcsoc-counter">Facebook</span> <span class="pcsoc-fan"></span> <span class="pcsoc-like">Like</span> </a> </div> <div class="pcsoc-item-wrap"> <a class="pcsoc-item pcsoci-twitter pcsc-brandflag empty-count" href="https://x.com/vivalanka" target="_blank" rel="noreferrer"> <span class="pcsoc-icon pcsoci-twitter"><i class="penci-faicon fa fa-twitter"></i></span> <span class="pcsoc-counter pcsoc-socname">twitter</span> <span class="pcsoc-like">Follow Us</span> </a> </div> <div class="pcsoc-item-wrap"> <a class="pcsoc-item pcsoci-youtube pcsc-brandflag empty-count" href="https://www.youtube.com/@vivalankanews" target="_blank" rel="noreferrer"> <span class="pcsoc-icon pcsoci-youtube"><i class="penci-faicon fa fa-youtube-play"></i></span> <span class="pcsoc-counter pcsoc-socname">youtube</span> <span class="pcsoc-like">Subscribe</span> </a> </div> <div class="pcsoc-item-wrap"> <a class="pcsoc-item pcsoci-instagram pcsc-brandflag empty-count" href="https://www.instagram.com/vivalankanews/" target="_blank" rel="noreferrer"> <span class="pcsoc-icon pcsoci-instagram"><i class="penci-faicon fa fa-instagram"></i></span> <span class="pcsoc-counter pcsoc-socname">instagram</span> <span class="pcsoc-like">Follow Us</span> </a> </div> <div class="pcsoc-item-wrap"> <a class="pcsoc-item pcsoci-tiktok pcsc-brandflag empty-count" href="https://www.tiktok.com/@vivalanka" target="_blank" rel="noreferrer"> <span class="pcsoc-icon pcsoci-tiktok"><i class="penci-faicon penciicon-tik-tok-1"></i></span> <span class="pcsoc-counter pcsoc-socname">tiktok</span> 
<span class="pcsoc-like">Follow Us</span> </a> </div> </div> </div> </aside>
		<!-- start a Resources for Donors & Partners Search Document bloc -->
		<%
		articleCategoryId = "wp.2499"; // start of article category
		
		 searchResultList = ArticlePageGenerator.getSearchResultList(articleCategoryId);
		
		 document = null;
		 title = "";		
		
		

		if (searchResultList != null && searchResultList.size() > 0) {
			document = searchResultList.get(0).getMainDocument();
			//heading = (String)document.getFieldValue("category");
			heading = "Resources for Donors & Partners";
			
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
								href="../slcommunity/category/resources-for-donors-and-partners-of-sri-lankan-charities/">View
											All<i class="fas fa-long-arrow-alt-right"></i>
							</a>
							</span>
						</h3>
					</div>
					
					<div class="penci-smalllist-wrapper">
						<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
							<div
								class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">

								<%
								SearchResult searchResult;
								//for(SearchResult searchResult: searchResultList ){
									Repeat1__numRows = 6;
									itr = searchResultList.iterator();
									while (itr.hasNext() && Repeat1__numRows >= 0) {
										searchResult = (SearchResult) itr.next();
										Repeat1__numRows--;
										
										document = searchResult.getMainDocument();
																	
										String thumbnail = "";
										title =  (String)document.getFieldValue("title");
										description =  (String)document.getFieldValue("description");									
										
								    	link =  (String)document.getFieldValue("url");
									
									 //category =  (String)document.getFieldValue("category"));
										thumbnail =  (String)document.getFieldValue("thumbnail");
										
		
									if (title != null) {
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
													title="<%=title%>"
													class="penci-image-holder penci-lazy lazyloaded pcloaded"
													data-bgset="<%=thumbnail%>"
													data-ll-status="loaded"
													style="background-image: url(&quot;<%=thumbnail%>&quot;);">
												</a>
											</div>
											<%
											}
											%>
											<div class="pcsl-content">
												<div class="pcsl-title">
									       		 <a href="<%=link%>"><%=title%></a>
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
		<!-- end Event Search Document bloc -->
		
		

	</div>
</div>