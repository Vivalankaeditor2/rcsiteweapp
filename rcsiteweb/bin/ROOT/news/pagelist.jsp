<%@ page contentType="text/html; charset=UTF-8" language="java"
	import="java.util.*,java.sql.*,java.io.*,javax.persistence.*,com.rev_creations.persistence.dao.*,javax.naming.*,
	com.rev_creations.persistence.interfaces.*,com.rev_creations.rcsite.*,java.text.DateFormat,java.text.SimpleDateFormat"
	errorPage=""%>
	
<%!
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
%>
<%
java.util.Date startTime = Calendar.getInstance().getTime();
java.util.Date endTime = java.util.Calendar.getInstance().getTime();
long loadTime = endTime.getTime() - startTime.getTime();
SortedMap loadTimeMap = new TreeMap();
loadTimeMap.put("10.startTime-pagelist.jsp",startTime);
String heading ="";
String categories   = "7";
ArticleCategory articleCategory = null;
List<ArticleCategory> articleCategoryList = null;
%>
<%@ include file="../Connections/dbconnection.jsp"%>
<%
try {
	if (request.getParameter("categoryid") !=null){
	    if(!validateCategory( request.getParameter("categoryid"), "/news/pagelist.jsp", request,  response)){return;} 
		categories = (String)request.getParameter("categoryid");
	}
	
	articleCategoryList =ArticlePageGenerator.getArticleCategoryMap(categories);
    if( articleCategoryList!=null){
	      Iterator iter = articleCategoryList.iterator();
	      while(iter.hasNext()){
	      		articleCategory = (ArticleCategory)iter.next();
		    	heading =  articleCategory.getCategoryName()+" / ";//+heading;
	      }
	      heading = heading.substring(0,heading.lastIndexOf(" /"))+":";
    }
%>
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html>
<head>
<title><%=heading%></title>
<meta name="Description" content="" />
<meta name="keywords"
	content="breaking news, video, teledrama, latest news,cultural events, Sri Lanka" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
<script>
	function resizeIframe(obj) {
		obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
	}
</script>
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
				class="elementor elementor-8" style="transform: none;">
				<!-- section main start -->
				<section
					class="penci-section penci-enSticky penci-repons-elsection penci-con_sb2_sb1 penci-structure-33 elementor-section elementor-top-section elementor-element elementor-element-35af948 elementor-section-boxed elementor-section-height-default elementor-section-height-default"
					data-id="35af948" data-element_type="section"
					style="transform: none;">
					<div class="elementor-container elementor-column-gap-extended"
						style="transform: none;">
						<!-- middel left (video) start -->
						<jsp:include page="../custom/newssummarynavinarrow_topleft.jsp"
							flush="true" />
						<!-- middel left (video) end -->
						<!-- contentmiddleupper  start-->



						<div
							class="penci-ercol-50 penci-ercol-order-2 penci-sticky-ct  elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-29b88e4"
							data-id="29b88e4" data-element_type="column"
							data-settings="{&quot;background_background&quot;:&quot;classic&quot;}"
							style="position: relative; overflow: visible; box-sizing: border-box; min-height: 1px;">

							<div
								class="elementor-element-populated theiaStickySidebar"
								style="position: static; padding-top: 0px; padding-bottom: 1px;">
								
								
								<!--  single article end -->


								


							
								<!--  single article end -->
								<!--  main   news start-->
								
								
								<div
									class="elementor-element elementor-element-4c4fa01 elementor-widget elementor-widget-penci-small-list"
									data-id="4c4fa01" data-element_type="widget"
									data-widget_type="penci-small-list.default">
									<div class="elementor-widget-container">
										<div class="penci-wrapper-smalllist">
											<div class="penci-smalllist-wrapper">
												<div class="penci-smalllist pcsl-wrapper pwsl-id-default">
													<div
														class="pcsl-inner penci-clearfix pcsl-grid pcsl-imgpos-left pcsl-col-1 pcsl-tabcol-1 pcsl-mobcol-1">


														<!-- repeat this div start -->
														
														
										  <div>
      <h3><%=heading%></h3>
    </div>
										
<iframe  frameborder="0" src="../rcsearch/news?&q=&layout=plain&fq=category:%22<%=heading.replace(":","").replaceAll(",", "%2C").replaceAll(" ","+")%>%22&NarrowBy=Category" scrolling="no" onload="resizeIframe(this)"></iframe>
										
										
								
													

														<!-- repeat this div end  -->


														<div class="pcsl-item">
															<div class="pcsl-itemin">
																<div class="pcsl-iteminer">
																	<div class="pcsl-content">
																		<div class="pcsl-title">
																		|&nbsp;&nbsp;<span class="sl-comment"><a
																				href="/news/pagelist.jsp?categoryid=7&offset=" ></a></span>
																			&nbsp;&nbsp;|
																		</div>

																		<div class="grid-post-box-meta pcsl-meta"></div>

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
								
								
								
								
								
								<!--  main  news end-->
							</div>
						</div>
						<!-- contentmiddleupper  end -->
						<!-- middel right (business) start -->

						<!--newssummarynavi start-->
						<jsp:include page="../custom/newssummarynavinarrow_topright.jsp"
							flush="true" />

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
											
											<script async
												src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
											<!-- 728x90 -->
											<ins class="adsbygoogle"
												style="display:inline-block;width:728px;height:90px"
												data-ad-client="ca-pub-1991368893626594"
												data-ad-slot="1235243111"></ins>
											<script>
												(adsbygoogle = window.adsbygoogle
														|| []).push({});
											</script>
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
						<jsp:include page="../custom/newssummarynaviwide_bottomleft.jsp"
							flush="true" />

						<!-- bottom left  end  -->
						<!-- bottom right start  -->
						<jsp:include page="../custom/newssummarynaviwide_bottomright.jsp"
							flush="true" />

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
	<script type="text/javascript"
		src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-5567b8ad75e24181"
		async="async"></script>
	<jsp:include page="../custom/rcfooter.jsp" flush="true" />
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