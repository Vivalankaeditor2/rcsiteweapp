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
String displayDate="";
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

<!-- bottom left start  -->
						<div
							class="penci-ercol-50 penci-ercol-order-1 penci-sticky-ct  elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-a329099"
							data-id="a329099" data-element_type="column">
							
							<!-- start an article bloc -->
<%
//boolean isWorldNewsPage = request.getServletPath().contains("worldnews.jsp");

//articleCategoryId = isWorldNewsPage ? "104" : "103";
//articleCategoryId = "104"; // start of article category
articleCategoryId = (String) request.getAttribute("rightBotomCategroy");
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
							
							
							<div class="elementor-widget-wrap elementor-element-populated">
								<div
									class="elementor-element elementor-element-208e2e0 elementor-widget elementor-widget-penci-block-heading"
									data-id="208e2e0" data-element_type="widget"
									data-widget_type="penci-block-heading.default">
									<div class="elementor-widget-container">
										<div
											class="penci-border-arrow penci-homepage-title penci-home-latest-posts style-6 pcalign-left pciconp-right pcicon-right block-title-icon-left">
											<h3 class="inner-arrow">
												<span> <span><%=heading%></span>
												<!-- <a
													class="pcbh-extrabtn pcbh-btns-none pcbh-btnp-right pcbh-btni-right"
													href="../rcsearch/news?&q=&fq=category:%22<%=heading.substring(0, heading.lastIndexOf(":"))%>%22&NarrowBy=Category">View
														All<i class="fas fa-long-arrow-alt-right"></i>
												</a>-->
												
												</span>
											</h3>
										</div>
									</div>
								</div>
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
									
									
								
									if (newsSummary.getUpdated() != null) {
										displayDate = formatDate(newsSummary.getUpdated(), java.text.DateFormat.FULL, null);
									
									} else if (newsSummary.getPublished() != null) {
									displayDate = formatDate(newsSummary.getPublished(), java.text.DateFormat.FULL, java.util.Locale.CANADA);
								
									} else {
										displayDate = formatDate(newsSummary.getEntryDate(), java.text.DateFormat.FULL , java.util.Locale.CANADA);
									
									}
								

									if (newsSummary.getTitle() != null) {
								%>
<!-- repeat this div start-->
								<div
									class="elementor-element elementor-element-e5d9466 elementor-widget elementor-widget-penci-small-list"
									data-id="e5d9466" data-element_type="widget"
									data-widget_type="penci-small-list.default">
									<div class="elementor-widget-container">
										<script>
											if (typeof (penciBlock) === "undefined") {
												function penciBlock() {
													this.atts_json = '';
													this.content = '';
												}
											}
											var penciBlocksArray = penciBlocksArray
													|| [];
											var PENCILOCALCACHE = PENCILOCALCACHE
													|| {};
											var pcblock_8865 = new penciBlock();
											pcblock_8865.blockID = "pcblock_8865";
											pcblock_8865.atts_json = '{"type":"grid","dformat":"","date_pos":"left","column":"1","tab_column":"1","mb_column":"1","imgpos":"left","thumb_size":"","mthumb_size":"","post_meta":["cat","title","date"],"primary_cat":"","title_length":"","excerpt_pos":"below","rmstyle":"filled","excerpt_length":15,"nocrop":"","hide_cat_mobile":"","hide_meta_mobile":"","hide_excerpt_mobile":"","hide_rm_mobile":"","imgtop_mobile":"","ver_border":"","hide_thumb":"","show_reviewpie":"","show_formaticon":"","disable_lazy":"","show_excerpt":"","show_readmore":"","query":{"orderby":"date","order":"desc","ignore_sticky_posts":1,"post_status":"publish","post__not_in":[],"post_type":"post","posts_per_page":1,"tax_query":[],"paged":1},"category_ids":"","taxonomy":""}';
											penciBlocksArray.push(pcblock_8865);
										</script>
										<div class="penci-wrapper-smalllist">
											<div class="penci-smalllist-wrapper">
												<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
													<div
														class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">
														<div class="pcsl-item <%=(thumbnail == null?" pcsl-nothumb": "")%>">
															<div class="pcsl-itemin">
																<div class="pcsl-iteminer" style="padding: 15px;">
<%
											if (thumbnail != null) {
											%>
																	<div class="pcsl-thumb">
																		<a href="<%=link %>"
																			title="<%=newsSummary.getTitle()%>"
																			class="penci-image-holder penci-lazy"
																			data-bgset="<%=thumbnail%>">
																		</a>
																	</div>
																	<%
											}
											%>
																	<div class="pcsl-content">
																		<div class="cat pcsl-cat">
																			<!--  <a class="penci-cat-name penci-cat-2"
																				href="../rcsearch/news?&q=&fq=category:%22<%=heading.substring(0, heading.lastIndexOf(":"))%>%22&NarrowBy=Category"
																				rel="category tag"> <%=heading%></a>-->
																		</div>

																		<div class="pcsl-title">
																			<a href="<%=link %>"><%=newsSummary.getTitle()%></a>
																		</div>

																		<div class="grid-post-box-meta pcsl-meta">
																			<span class="sl-date"><time
																					class="entry-date published"
																					datetime="2021-11-05T08:24:47+00:00"><%=displayDate %></time></span>
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
<!-- repeat this div end-->
<%
								}

								}
								%>

							</div>
							
							<%
		} // end of article category
		%>
							<!-- end an article bloc -->
						</div>
						<!-- bottom left  end  -->