<%@ page language="java"
	import="java.sql.*,java.util.*,com.rev_creations.persistence.dao.*"
	contentType="text/html; charset=UTF-8"%>
<%@page import="com.maxmind.geoip.Location"%>
<%@page import="com.rev_creations.rcsite.*"%>
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
	style="position: relative; overflow: visible; box-sizing: border-box; min-height: 1px;">

	<div
		class="elementor-widget-wrap elementor-element-populated theiaStickySidebar"
		style="position: static; padding-top: 0px; padding-bottom: 1px;">

		<!-- start an article bloc -->
		<%
		articleCategoryId = "8"; // start of article category
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
							<span> <span><%=heading%></span><a
								class="pcbh-extrabtn pcbh-btns-none pcbh-btnp-right pcbh-btni-right"
								href="../news/pagelist.jsp?categoryid=<%=articleCategoryId%>">View
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
													style="background-image: url(&quot;<%=newsSummary.getThumbnail()%>&quot;);">
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
					href="http://rev-creations.com/rcmerchant/productcategory.jsp?code=WDP"
					target="_top"><img
					src="http://rev-creations.com/webads/images/webdesignad_300x250.png"
					alt="rev-creations web design" width="400" height="333" border="0" /></a>
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

				<%
				}
				%>





			</div>
		</div>
		<!-- end advertising bloc -->
		
			<!-- start an article bloc -->
		<%
		articleCategoryId = "10"; // start of article category
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
							<span> <span><%=heading%></span><a
								class="pcbh-extrabtn pcbh-btns-none pcbh-btnp-right pcbh-btni-right"
								href="../news/pagelist.jsp?categoryid=<%=articleCategoryId%>">View
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
													href="../newspage/<%=newsSummary.getArticleId()%>ai-<%=newsSummary.getAlias()%>"
													title="<%=newsSummary.getTitle()%>"
													class="penci-image-holder penci-lazy lazyloaded pcloaded"
													data-bgset="<%=newsSummary.getThumbnail()%>"
													data-ll-status="loaded"
													style="background-image: url(&quot;<%=newsSummary.getThumbnail()%>&quot;);">
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