<%@ page language="java"
	import="java.sql.*,java.util.*,com.rev_creations.persistence.dao.*,java.time.*,java.time.format.*"
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
%>
<!-- start an article bloc elementor-8 -->
<%
String articleCategoryId = "7";

// start of article category 
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
<%
ZoneId srilanka = ZoneId.of("Asia/Colombo");
LocalDateTime slTime = LocalDateTime.now(srilanka);
DateTimeFormatter formatTodaySL=DateTimeFormatter.ofPattern("MMMM dd, yyyy");
%>
<!-- header start ==================================================================    -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 0 0" width="0"
	height="0" focusable="false" role="none"
	style="visibility: hidden; position: absolute; left: -9999px; overflow: hidden;">
		<defs>
			<filter id="wp-duotone-dark-grayscale">
				<fecolormatrix color-interpolation-filters="sRGB" type="matrix"
		values=" .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 ">
				</fecolormatrix>
				<fecomponenttransfer color-interpolation-filters="sRGB">
					<fefuncr type="table" tableValues="0 0.49803921568627"></fefuncr>
					<fefuncg type="table" tableValues="0 0.49803921568627"></fefuncg>
					<fefuncb type="table" tableValues="0 0.49803921568627"></fefuncb>
					<fefunca type="table" tableValues="1 1"></fefunca>
				</fecomponenttransfer>
				<fecomposite in2="SourceGraphic" operator="in"></fecomposite>
			</filter>
		</defs>
	</svg>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 0 0" width="0"
	height="0" focusable="false" role="none"
	style="visibility: hidden; position: absolute; left: -9999px; overflow: hidden;">
		<defs>
			<filter id="wp-duotone-grayscale">
				<fecolormatrix color-interpolation-filters="sRGB" type="matrix"
		values=" .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 ">
				</fecolormatrix>
				<fecomponenttransfer color-interpolation-filters="sRGB">
					<fefuncr type="table" tableValues="0 1"></fefuncr>
					<fefuncg type="table" tableValues="0 1"></fefuncg>
					<fefuncb type="table" tableValues="0 1"></fefuncb>
					<fefunca type="table" tableValues="1 1"></fefunca>
				</fecomponenttransfer>
				<fecomposite in2="SourceGraphic" operator="in"></fecomposite>
			</filter>
		</defs>
	</svg>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 0 0" width="0"
	height="0" focusable="false" role="none"
	style="visibility: hidden; position: absolute; left: -9999px; overflow: hidden;">
		<defs>
			<filter id="wp-duotone-purple-yellow">
				<fecolormatrix color-interpolation-filters="sRGB" type="matrix"
		values=" .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 ">
				</fecolormatrix>
				<fecomponenttransfer color-interpolation-filters="sRGB">
					<fefuncr type="table"
		tableValues="0.54901960784314 0.98823529411765"></fefuncr>
					<fefuncg type="table" tableValues="0 1"></fefuncg>
					<fefuncb type="table"
		tableValues="0.71764705882353 0.25490196078431"></fefuncb>
					<fefunca type="table" tableValues="1 1"></fefunca>
				</fecomponenttransfer>
				<fecomposite in2="SourceGraphic" operator="in"></fecomposite>
			</filter>
		</defs>
	</svg>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 0 0" width="0"
	height="0" focusable="false" role="none"
	style="visibility: hidden; position: absolute; left: -9999px; overflow: hidden;">
		<defs>
			<filter id="wp-duotone-blue-red">
				<fecolormatrix color-interpolation-filters="sRGB" type="matrix"
		values=" .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 ">
				</fecolormatrix>
				<fecomponenttransfer color-interpolation-filters="sRGB">
					<fefuncr type="table" tableValues="0 1"></fefuncr>
					<fefuncg type="table" tableValues="0 0.27843137254902"></fefuncg>
					<fefuncb type="table"
		tableValues="0.5921568627451 0.27843137254902"></fefuncb>
					<fefunca type="table" tableValues="1 1"></fefunca>
				</fecomponenttransfer>
				<fecomposite in2="SourceGraphic" operator="in"></fecomposite>
			</filter>
		</defs>
	</svg>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 0 0" width="0"
	height="0" focusable="false" role="none"
	style="visibility: hidden; position: absolute; left: -9999px; overflow: hidden;">
		<defs>
			<filter id="wp-duotone-midnight">
				<fecolormatrix color-interpolation-filters="sRGB" type="matrix"
		values=" .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 ">
				</fecolormatrix>
				<fecomponenttransfer color-interpolation-filters="sRGB">
					<fefuncr type="table" tableValues="0 0"></fefuncr>
					<fefuncg type="table" tableValues="0 0.64705882352941"></fefuncg>
					<fefuncb type="table" tableValues="0 1"></fefuncb>
					<fefunca type="table" tableValues="1 1"></fefunca>
				</fecomponenttransfer>
				<fecomposite in2="SourceGraphic" operator="in"></fecomposite>
			</filter>
		</defs>
	</svg>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 0 0" width="0"
	height="0" focusable="false" role="none"
	style="visibility: hidden; position: absolute; left: -9999px; overflow: hidden;">
		<defs>
			<filter id="wp-duotone-magenta-yellow">
				<fecolormatrix color-interpolation-filters="sRGB" type="matrix"
		values=" .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 ">
				</fecolormatrix>
				<fecomponenttransfer color-interpolation-filters="sRGB">
					<fefuncr type="table" tableValues="0.78039215686275 1"></fefuncr>
					<fefuncg type="table" tableValues="0 0.94901960784314"></fefuncg>
					<fefuncb type="table"
		tableValues="0.35294117647059 0.47058823529412"></fefuncb>
					<fefunca type="table" tableValues="1 1"></fefunca>
				</fecomponenttransfer>
				<fecomposite in2="SourceGraphic" operator="in"></fecomposite>
			</filter>
		</defs>
	</svg>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 0 0" width="0"
	height="0" focusable="false" role="none"
	style="visibility: hidden; position: absolute; left: -9999px; overflow: hidden;">
		<defs>
			<filter id="wp-duotone-purple-green">
				<fecolormatrix color-interpolation-filters="sRGB" type="matrix"
		values=" .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 ">
				</fecolormatrix>
				<fecomponenttransfer color-interpolation-filters="sRGB">
					<fefuncr type="table"
		tableValues="0.65098039215686 0.40392156862745"></fefuncr>
					<fefuncg type="table" tableValues="0 1"></fefuncg>
					<fefuncb type="table" tableValues="0.44705882352941 0.4"></fefuncb>
					<fefunca type="table" tableValues="1 1"></fefunca>
				</fecomponenttransfer>
				<fecomposite in2="SourceGraphic" operator="in"></fecomposite>
			</filter>
		</defs>
	</svg>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 0 0" width="0"
	height="0" focusable="false" role="none"
	style="visibility: hidden; position: absolute; left: -9999px; overflow: hidden;">
		<defs>
			<filter id="wp-duotone-blue-orange">
				<fecolormatrix color-interpolation-filters="sRGB" type="matrix"
		values=" .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 .299 .587 .114 0 0 ">
				</fecolormatrix>
				<fecomponenttransfer color-interpolation-filters="sRGB">
					<fefuncr type="table" tableValues="0.098039215686275 1"></fefuncr>
					<fefuncg type="table" tableValues="0 0.66274509803922"></fefuncg>
					<fefuncb type="table"
		tableValues="0.84705882352941 0.41960784313725"></fefuncb>
					<fefunca type="table" tableValues="1 1"></fefunca>
				</fecomponenttransfer>
				<fecomposite in2="SourceGraphic" operator="in"></fecomposite>
			</filter>
		</defs>
	</svg>
<div
	class="wrapper-boxed header-style-header-1 header-search-style-showup"
	style="transform: none;">
	<div class="penci-header-wrap pc-wrapbuilder-header">
		<div class="pc-wrapbuilder-header-inner">
			<div
				class="penci_header penci-header-builder penci_builder_sticky_header_desktop shadow-enable">
				<div class="penci_container">
					<div class="penci_stickybar penci_navbar">
						<div
							class="penci-desktop-sticky-mid penci-sticky-mid pcmiddle-normal pc-hasel">
							<div class="container container-1400">
								<div class="penci_nav_row">

									<div class="penci_nav_col penci_nav_left penci_nav_alignleft">

										<div
											class="pc-builder-element pc-logo-sticky pc-logo penci-header-image-logo ">
											<a href="../"> <img class="penci-mainlogo pclogo-cls"
												src="../custom/template_files/vivalankalogo.webp"
												alt="Latest News" width="355" height="180">
											</a>
										</div>

									</div>


									<div
										class="penci_nav_col penci_nav_center penci_nav_aligncenter">


									</div>


									<div class="penci_nav_col penci_nav_right penci_nav_alignright">

										<div class="pc-builder-element pc-builder-menu pc-main-menu">
											<nav
												class="navigation menu-style-1 no-class menu-item-normal "
												role="navigation" itemscope=""
												itemtype="https://schema.org/SiteNavigationElement">
                                                                                                                <ul id="menu-menu" class="menu"><li id="menu-item-1969" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1969"><a href="../">HOME</a></li>
                                                                                                                <li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1973"><a href="../news/Sinhala.jsp">සිංහල</a></li>
                                                    <li id="menu-item-1970" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1970"><a href="../slcommunity/">COMMUNITY NEWS</a></li>
													<li id="menu-item-1975" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Business%22&#038;NarrowBy=Category">BUSINESS</a></li>
                                                    <li id="menu-item-1971" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1971"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Video%22&#038;NarrowBy=Category">VIDEOS</a></li>
                                                    <li id="menu-item-1977" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1977"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Sports%22&#038;NarrowBy=Category">SPORTS</a></li>
                                                    <li id="menu-item-1972" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1972"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Entertainment%22&#038;NarrowBy=Category">ENTERTAINMENT</a></li>                              
                                                    <li id="menu-item-1974" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1974"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Tamil%22&#038;NarrowBy=Category">TAMIL</a></li>
                                                    <li id="menu-item-1694" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home ajax-mega-menu menu-item-1694"><a href="../slcommunity/charity-directory/">CHARITIES</a></li>
                                                    <li id="menu-item-1629" class="menu-item menu-item-type-post_type_archive menu-item-object-mec-events ajax-mega-menu menu-item-1629"><a href="../slcommunity/events/">EVENTS</a></li>
                                                    </ul> 
											</nav>
										</div>
										<div style=""
											class="penci-builder-element penci-vertical-line vertical-line-1 ">
										</div>
										<div id="top-search"
											class="pc-builder-element penci-top-search pcheader-icon top-search-classes ">
											<a class="search-click pc-button-define-customize"> <i
												class="penciicon-magnifiying-glass"></i>
											</a>
											<div class="show-search">
												<form role="search" method="get" class="pc-searchform"
													action="../rcsearch/news">
													<div class="pc-searchform-inner">
														<input type="text" class="search-input"
															placeholder="Type and hit enter..." name="q" id ="searchterm4" autocomplete="on"> <i
															class="penciicon-magnifiying-glass"></i> <input
															type="submit" class="searchsubmit" value="Search">
													</div>
												</form>
												<a class="search-click close-search"><i
													class="penciicon-close-button"></i></a>
											</div>
										</div>

									</div>

								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div
				class="penci_header penci-header-builder main-builder-header  normal no-shadow  ">
				<div
					class="penci_midbar penci-desktop-midbar penci_container bg-normal pcmiddle-normal pc-hasel">
					<div class="container container-1400">
						<div class="penci_nav_row">

							<div class="penci_nav_col penci_nav_left penci_nav_alignleft">

								<div
									class="pc-builder-element pc-logo pc-logo-desktop penci-header-image-logo ">
									<a href="../"> <img class="penci-mainlogo pclogo-cls"
										src="../custom/template_files/vivalankalogo.webp"
										alt="Latest News" width="355" height="180">
									</a>
								</div>

							</div>


							<div class="penci_nav_col penci_nav_center penci_nav_aligncenter">


							</div>


							<div class="penci_nav_col penci_nav_right penci_nav_alignright" >

								<div class="pc-builder-element pc-builder-menu pc-main-menu">
									<nav class="navigation menu-style-1 no-class menu-item-normal  "
										role="navigation" itemscope=""
										itemtype="https://schema.org/SiteNavigationElement">
												<ul id="menu-menu-1" class="menu"><li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1969"><a href="../">HOME</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1973"><a href="../news/Sinhala.jsp">සිංහල</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1970"><a href="../slcommunity/">COMMUNITY NEWS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Business%22&#038;NarrowBy=Category">BUSINESS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1971"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Video%22&#038;NarrowBy=Category">VIDEOS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1977"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Sports%22&#038;NarrowBy=Category">SPORTS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1972"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Entertainment%22&#038;NarrowBy=Category">ENTERTAINMENT</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1974"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Tamil%22&#038;NarrowBy=Category">TAMIL</a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home ajax-mega-menu menu-item-1694"><a href="../slcommunity/charity-directory/">CHARITIES</a></li>
<li class="menu-item menu-item-type-post_type_archive menu-item-object-mec-events ajax-mega-menu menu-item-1629"><a href="../slcommunity/events/">EVENTS</a></li>
</ul>    
									</nav>
								</div>
								<div style=""
									class="penci-builder-element penci-vertical-line vertical-line-1 ">
								</div>
								<a rel="noreferrer"
                                  href="/slcommunity/index.php/login/"
                                  class="penci-builder penci-builder-button button-1 button-define-style-4 button-shape-customize default"
                                   style="text-decoration: none;">
                                  LOGIN
                                    </a>

								<div id="top-search"
									class="pc-builder-element penci-top-search pcheader-icon top-search-classes ">
									<a class="search-click pc-button-define-customize"> <i
										class="penciicon-magnifiying-glass"></i>
									</a>
									<div class="show-search">
										<form role="search" method="get" class="pc-searchform"
											action="../rcsearch/news">
											<div class="pc-searchform-inner">
												<input type="text" class="searchinput ac_input" id ="searchterm5"
													name="q" placeholder="Type and hit enter..."
													autocomplete="on"> <i
													class="penciicon-magnifiying-glass"></i> <input
													type="submit" class="searchsubmit" value="Search">
											</div>
										</form>
										<a class="search-click close-search"><i
											class="penciicon-close-button"></i></a>
									</div>
								</div>

							</div>

						</div>
					</div>
				</div>
				<!-- news ticker desktop start -->
				<div
					class="penci_bottombar penci-desktop-bottombar penci_navbar penci_container bg-normal pcmiddle-normal pc-hasel">
					<div class="container container-1400">
						<div class="penci_nav_row">

							<div class="penci_nav_col penci_nav_left penci_nav_alignleft">


								<div class="penci-builder-element penci-data-time-format ">
									<span><%= formatTodaySL.format(slTime) %> 

									</span>
								</div>

							</div>
							
							<div class="penci_nav_col penci_nav_center penci_nav_alignleft">
                            <div class="penci-builder-element pctopbar-item penci-topbar-trending">
                            <span class="headline-title nticker-style-2 penci-enable-uppercase">Search News</span>
                            <span class="penci-trending-nav">
            
                           </span>
                            </div>
                            
                            <!-- SearchBar Start -->
                           <div class="penci-builder-element pc-search-form pc-search-form-sidebar search-style-default" style="background-color: white; border: 1px solid #87CEFA; border-radius: 0px; padding: 5px; margin-top: 8px;width:80%">
                           <form role="search" method="get" class="rc-pc-searchform" action="../rcsearch/news">
                           <div class="pc-searchform-inner" style="display: flex;">
                            <input type="text" class="search-input" placeholder="Type and hit enter to search news..." name="q" id ="searchterm" autocomplete="on" value="" style="flex: 1; padding: 2px; border: none; outline: none; border-radius: 3px 0 0 3px;">
                            <button type="submit" class="searchsubmit" style="background-color: white; color: black; border: none; padding: 7px 60px; border-radius: 0 3px 3px 0; cursor: pointer; font: bold 14px Roboto, sans-serif;">SUBMIT</button></div>
                           </form>
                           </div>
                           <!-- SearchBar End -->
                           </div>

<!-- social media start -->
<div class="penci_nav_col penci_nav_right penci_nav_alignright">
    <div class="header-social desktop-social penci-builder-element">
        <div class="inner-header-social social-icon-style penci-social-simple penci-social-textaccent">
            <a href="https://www.facebook.com/VivaLanka" aria-label="Facebook" rel="noreferrer" target="_blank">
                <i class="penci-faicon fa fa-facebook"></i>
            </a>
            <a href="https://www.youtube.com/@vivalankanews" aria-label="Youtube" rel="noreferrer" target="_blank">
                <i class="penci-faicon fa fa-youtube-play"></i>
            </a>
            <a href="https://twitter.com/vivalanka" aria-label="Twitter" rel="noreferrer" target="_blank">
                <i class="penci-faicon fa fa-twitter"></i>
            </a>
        </div>
    </div>
    
    <a rel="noreferrer" href="../rcsearch/news?&q=&fq=category:%22AI%20Flash%20News%22&NarrowBy=Category" class="penci-builder penci-builder-button button-2 button-define-style-4 button-shape-customize default" style="text-decoration: none;">
        <i class="fa fa-newspaper-o"></i>&nbsp;&nbsp;AI-Powered Unbiased News  
    </a>
</div>



<!-- social media end -->
										<!-- news ticket reapeat this div start-->

										<%
										Repeat1__numRows = 0;
										itr = newsSummaryList.iterator();
										while (itr.hasNext() && Repeat1__numRows >= 0) {
											newsSummary = (Articles) itr.next();
											Repeat1__numRows--;

											String thumbnail = null;
											if (newsSummary.getThumbnail() != null && newsSummary.getThumbnail().length() > 5) {
												thumbnail = newsSummary.getThumbnail();
											}

											if (newsSummary.getTitle() != null  && false) {
										%>


										<div>

											<%
											if (newsSummary.getAlias() != null) {
											%>
											<a class="penci-topbar-post-title  penci-disable-uppercase"
												href="../newspage/<%=newsSummary.getArticleId()%>ai-<%=newsSummary.getAlias()%>"><%=newsSummary.getTitle()%></a>
											<%
											} else {
											%><a
												class="penci-topbar-post-title  penci-disable-uppercase"
												href="../news/page.jsp?articleid=<%=newsSummary.getArticleId()%>"><%=newsSummary.getTitle()%></a>
											<%}%>
										</div>
										<%
										}
										}
										}
										%>
										<!-- news ticket reapeat this div ends-->

									</div>
								</div>

							</div>


							
				<!-- news ticker desktop end -->
			</div>
			<div class="penci_navbar_mobile ">
				<div
					class="penci_mobile_midbar penci-mobile-midbar penci_container sticky-enable pcmiddle-normal pc-hasel">
					<div class="container">
						<div class="penci_nav_row">

							<div class="penci_nav_col penci_nav_left penci_nav_alignleft">

								<div
									class="pc-button-define-customize pc-builder-element navigation mobile-menu ">
									<div class="button-menu-mobile header-builder">
										<svg width="18px" height="18px" viewBox="0 0 512 384"
											version="1.1" xmlns="http://www.w3.org/2000/svg"
											xmlns:xlink="http://www.w3.org/1999/xlink">
												<g stroke="none" stroke-width="1" fill-rule="evenodd">
													<g transform="translate(0.000000, 0.250080)">
														<rect x="0" y="0" width="512" height="62"></rect>
														<rect x="0" y="161" width="512" height="62"></rect>
														<rect x="0" y="321" width="512" height="62"></rect>
													</g>
												</g>
											</svg>
									</div>
								</div>

							</div>


							<div class="penci_nav_col penci_nav_center penci_nav_aligncenter">

								<div class="pc-builder-element pc-logo pb-logo-mobile penci-header-image-logo" style="padding: 0px 0px 0px 70px;">
                                  <a href="../">
                                  <img class="penci-mainlogo pclogo-cls" src="../custom/template_files/vivalankalogo.webp" alt="Latest News" width="355" height="180">
                                  </a>
                                </div>								
								<div style="padding: 0px 0px 0px 0px;">	                                        
                                <ol style="color: white; font-family: Roboto, sans-serif; font-size: 12px;">
                                    <li>
                                         <a href="../" style="color: white; text-decoration: none;">English</a>
                                    </li>
                                    <li>
                                         <a href="../news/Sinhala.jsp" style="color: white; text-decoration: none;">සිංහල</a>
                                    </li>                                                 
                                </ol>										
                               </div>

							</div>
							


							<div class="penci_nav_col penci_nav_right penci_nav_alignright">

								<div id="top-search"
									class="pc-builder-element penci-top-search pcheader-icon top-search-classes ">
									<a class="search-click pc-button-define-customize"> <i
										class="penciicon-magnifiying-glass"></i>
									</a>
									<div class="show-search">
										<form role="search" method="get" class="pc-searchform"
											action="../rcsearch/news">
											<div class="pc-searchform-inner">
												<input type="text" class="search-input"
													placeholder="Type and hit enter..." name="q" id ="searchterm2" autocomplete="on"> <i
													class="penciicon-magnifiying-glass"></i> <input
													type="submit" class="searchsubmit" value="Search">
											</div>
										</form>
										<a class="search-click close-search"><i
											class="penciicon-close-button"></i></a>
									</div>
								</div>

							</div>

						</div>
					</div>
				</div><!-- empowering start -->
				<div class="penci_mobile_bottombar penci-mobile-bottombar penci_container sticky-enable pcmiddle-normal pc-hasel bgtrans-enable">
    <div class="container">
        <div class="penci_nav_row">
			
                <div class="penci_nav_col penci_nav_left penci_nav_alignleft">

					
                </div>

				
                <div class="penci_nav_col penci_nav_center penci_nav_aligncenter">

					     <a rel="noreferrer" href="../rcsearch/news?&q=&fq=category:%22AI%20Flash%20News%22&NarrowBy=Category" class="penci-builder penci-builder-button button-2 button-define-style-4 button-shape-customize default" style="text-decoration: none;">
        <i class="fa fa-newspaper-o"></i>&nbsp;&nbsp;AI-Powered Unbiased News  
    </a>
                </div>

				
                <div class="penci_nav_col penci_nav_right penci_nav_alignright">

					
                </div>

				        </div>
    </div>
</div>
				<!-- empowering end-->
			</div>
			<a class="close-mobile-menu-builder"><i
				class="penci-faicon fa fa-close"></i></a>
			<div id="penci_off_canvas"
				class="penci-builder-mobile-sidebar-nav penci-menu-hbg">
				<div class="penci_mobile_wrapper">
					<div class="nav_wrap penci-mobile-sidebar-content-wrapper">
						<div class="penci-builder-item-wrap item_main">
							<div
								class="pc-builder-element pc-logo pb-logo-sidebar-mobile penci-header-image-logo ">
								<a href="../rcsearch/news"> <img
									class="penci-mainlogo pclogo-cls"
									src="../custom/template_files/vivalankalogo.webp"
									alt="Latest News" width="355" height="180">
								</a>
							</div>
							<div class="header-social penci-builder-element mobile-social">
								<div
									class="inner-header-social social-icon-style penci-social-circle penci-social-colored">
									<a href="https://www.facebook.com/vivalanka"
										aria-label="Facebook" rel="noreferrer" target="_blank"><i
										class="penci-faicon fa fa-facebook"></i></a> <a href="https://www.youtube.com/@vivalankanews"
                   aria-label="Youtube"  rel="noreferrer"                   target="_blank"><i class="penci-faicon fa fa-youtube-play" ></i></a> <a
										href="https://twitter.com/vivalanka" aria-label="Twitter"
										rel="noreferrer" target="_blank"><i
										class="penci-faicon fa fa-twitter"></i></a>
								</div>
							</div>
							<div
								class="penci-builder-element pc-search-form pc-search-form-sidebar search-style-default ">
								<form role="search" method="get" class="pc-searchform"
									action="../rcsearch/news">
									<div class="pc-searchform-inner">
										<input type="text" class="search-input"
											placeholder="Type and hit enter..." name="q" id ="searchterm3" autocomplete="on"> <i
											class="penciicon-magnifiying-glass"></i>
										<button type="submit" class="searchsubmit">Search</button>
									</div>
								</form>
							</div>
							<div class="pc-builder-element pc-builder-menu pc-dropdown-menu">
								<nav class="no-class normal-click" role="navigation"
									itemscope=""
									itemtype="https://schema.org/SiteNavigationElement">
												<ul id="menu-menu-2" class="menu menu-hgb-main"><li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1969"><a href="../">HOME</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1973"><a href="../news/Sinhala.jsp">සිංහල</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1970"><a href="../slcommunity/">COMMUNITY NEWS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Business%22&#038;NarrowBy=Category">BUSINESS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1971"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Video%22&#038;NarrowBy=Category">VIDEOS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1977"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Sports%22&#038;NarrowBy=Category">SPORTS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1972"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Entertainment%22&#038;NarrowBy=Category">ENTERTAINMENT</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1974"><a href="../rcsearch/news?&#038;q=&#038;fq=category:%22Tamil%22&#038;NarrowBy=Category">TAMIL</a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home ajax-mega-menu menu-item-1694"><a href="../slcommunity/">CHARITIES</a></li>
<li class="menu-item menu-item-type-post_type_archive menu-item-object-mec-events ajax-mega-menu menu-item-1629"><a href="../slcommunity/events/">EVENTS</a></li>
</ul>     
								</nav>
							</div>

							<div
								class="penci-builder-element penci-html-ads penci-html-ads-mobile">
								Copyright 2025 - All Right Reserved</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>