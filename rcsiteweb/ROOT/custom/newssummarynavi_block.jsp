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

		<!-- start an article bloc -->
		<%
		articleCategoryId = "7"; // start of article category
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
		
		<%
		} // end of article category
		%>
		<!-- end article bloc -->

		
