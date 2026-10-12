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
String currentURI = request.getRequestURI();
//Homepage detection
if (currentURI.equals("/") || currentURI.endsWith("index.jsp")) {
 articleCategoryId = "90";  // Breaking News category
}
//World News page
else if (currentURI.contains("worldnews.jsp")) {
 //articleCategoryId = "7";   // World News category
 articleCategoryId = (String) request.getAttribute("middleMiddleCatgroy");
}
//Sinhala page
else if (currentURI.contains("Sinhala.jsp")) {
 articleCategoryId = "91";  // Sinhala category ID
}
//Category listing pages
else if (currentURI.contains("pagelist.jsp")) {
 String catId = request.getParameter("categoryid");
 if (catId != null) {
     if (catId.equals("102")) {
         articleCategoryId = "102";  // Sports
     } else if (catId.equals("14")) {
         articleCategoryId = "14";   // Technology
     } else if (catId.equals("10")) {
         articleCategoryId = "10";   // Business
     
     } else {
         articleCategoryId = "7";    // Default
     }
 }
}

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
											
											<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1991368893626594"
     crossorigin="anonymous"></script>
<ins class="adsbygoogle"
     style="display:block; text-align:center;"
     data-ad-layout="in-article"
     data-ad-format="fluid"
     data-ad-client="ca-pub-1991368893626594"
     data-ad-slot="7599609528"></ins>
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

<form action="../news/worldnews.jsp" method="get" style="margin-right: 15px;">
    <select name="country" onchange="this.form.submit()" 
            style="padding: 8px 12px; 
                   font-size: 14px; 
                   border: 1px solid #87CEFA; 
                   border-radius: 2px; 
                   background-color: white;
                   color: #333;
                   cursor: pointer;
                   outline: none;
                   font-family: inherit;
                   min-width: 150px;
                   transition: all 0.3s ease;">
        <!--  <option value="" <%= request.getParameter("country") == null ? "selected" : "" %>>World News</option>-->
        <option value="LK" <%= "LK".equals(request.getParameter("country")) ? "selected" : "" %>>Sri Lanka</option>
        <option value="AUS" <%= "AUS".equals(request.getParameter("country")) ? "selected" : "" %>>Australia</option>
        <option value="CA" <%= "CA".equals(request.getParameter("country")) ? "selected" : "" %>>Canada</option>
        <option value="NZ" <%= "NZ".equals(request.getParameter("country")) ? "selected" : "" %>>New Zealand</option>
        <option value="UK" <%= "UK".equals(request.getParameter("country")) ? "selected" : "" %>>United Kingdom</option>        
        <option value="USA" <%= "USA".equals(request.getParameter("country")) ? "selected" : "" %>>USA</option>        
    </select>
</form>

<script>
    // Set selected value from JSP parameter
    document.getElementById("countrySelect").value = "<%= request.getParameter("country") != null ? request.getParameter("country") : "" %>";
</script>

									<div
										class="penci_nav_col penci_nav_center penci_nav_aligncenter">


									</div>


									<div class="penci_nav_col penci_nav_right penci_nav_alignright">

										<div class="pc-builder-element pc-builder-menu pc-main-menu">
											<nav
												class="navigation menu-style-1 no-class menu-item-normal "
												role="navigation" itemscope=""
												itemtype="https://schema.org/SiteNavigationElement">
												
                                                                                                                <ul id="menu-menu" class="menu">
                                                                                                               
                                                                                                                <li id="menu-item-1969" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1969"><a href="../">HOME</a></li>
                                                                                                                <li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1973"><a href="../news/Sinhala.jsp">සිංහල</a></li>
                                                    <li id="menu-item-1970" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1970"><a href="../slcommunity/">COMMUNITY NEWS</a></li>
													<li id="menu-item-1975" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../news/pagelist.jsp?categoryid=10">BUSINESS</a></li>
													<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../news/pagelist.jsp?categoryid=14">TECHNOLOGY</a></li>
                                                    <li id="menu-item-1971" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1971"><a href="../news/pagelist.jsp?categoryid=11">VIDEOS</a></li>
                                                    <li id="menu-item-1977" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1977"><a href="../news/pagelist.jsp?categoryid=102">SPORTS</a></li>
                                                  <!--  <li id="menu-item-1972" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1972"><a href="../news/pagelist.jsp?categoryid=12">ENTERTAINMENT</a></li>-->                              
                                                    <li id="menu-item-1974" class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1974"><a href="../news/pagelist.jsp?categoryid=45">TAMIL</a></li>
                                                    <li id="menu-item-1694" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home ajax-mega-menu menu-item-1694"><a href="../slcommunity/charity-directory/">CHARITIES</a></li>
                                                   

                                                  
                                                    <li id="menu-item-1629" class="menu-item menu-item-type-post_type_archive menu-item-object-mec-events ajax-mega-menu menu-item-1629"><a href="../slcommunity/events/">EVENTS</a></li>
                                                    </ul> 
											</nav>
										</div>
										<div style="margin-bottom:12px;"
									class="penci-builder-element penci-vertical-line vertical-line-1 ">
								</div>
								<a rel="noreferrer"
                                  href="/slcommunity/index.php/login/"
                                  class="penci-builder penci-builder-button button-1 button-define-style-4 button-shape-customize default"
                                   style="text-decoration: none; margin-bottom:12px;">
                                  LOGIN
                                    </a>
										<div id="top-search"
									class="pc-builder-element penci-top-search pcheader-icon top-search-classes ">
									<a style="margin-bottom:10px;" class="search-click pc-button-define-customize"> <i
										class="penciicon-magnifiying-glass"></i>
									</a>
									<!--  <div  class="show-search">
										<form role="search" method="get" class="pc-searchform"
											action="../rcsearch/news">
											<div class="pc-searchform-inner" style="display: flex; align-items: center;">
												<input type="text" class="searchinput ac_input" id ="searchterm5"
													name="q" placeholder="Type and hit enter..."
													autocomplete="on"> <i 
													class="penciicon-magnifiying-glass"
													></i> 
													<input type="submit" class="searchsubmit" value="Search"
                       style="padding: 2px 10px 2px 10px ; background: rgb(239, 239, 239); color: rgb(0, 0, 0); border: none; 
                              border-radius: 0 4px 4px 0; cursor: pointer; white-space: nowrap;
                              font-family: inherit; font-size: inherit; min-width: 80px; min-height: 10px;">
                <i class="penciicon-magnifiying-glass" style="display: none;"></i>
											
											</div>
										</form>
										<a class="search-click close-search"><i
											class="penciicon-close-button"></i></a>
									</div>-->
								</div>

									</div>

								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- -----------------------desktop version menu-------------------- -->
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
							<form action="../news/worldnews.jsp" method="get" style="margin-right: 15px;">
    <select name="country" onchange="this.form.submit()" 
            style="padding: 8px 12px; 
                   font-size: 14px; 
                   border: 1px solid #87CEFA; 
                   border-radius: 2px; 
                   background-color: white;
                   color: #333;
                   cursor: pointer;
                   outline: none;
                   font-family: inherit;
                   min-width: 150px;
                   transition: all 0.3s ease;">
        <!--  <option value="" <%= request.getParameter("country") == null ? "selected" : "" %>>World News</option>-->
        <option value="LK" <%= "LK".equals(request.getParameter("country")) ? "selected" : "" %>>Sri Lanka</option>
        <option value="AUS" <%= "AUS".equals(request.getParameter("country")) ? "selected" : "" %>>Australia</option>
        <option value="CA" <%= "CA".equals(request.getParameter("country")) ? "selected" : "" %>>Canada</option>
        <option value="NZ" <%= "NZ".equals(request.getParameter("country")) ? "selected" : "" %>>New Zealand</option>
        <option value="UK" <%= "UK".equals(request.getParameter("country")) ? "selected" : "" %>>United Kingdom</option>        
        <option value="USA" <%= "USA".equals(request.getParameter("country")) ? "selected" : "" %>>USA</option>      
    </select>
</form>

<!--  <form action="../news/worldnews.jsp" method="get">
    <select name="country" onchange="this.form.submit()">
        <option value="">World News</option>
        <option value="AUS" ${param.country == 'AUS' ? 'selected' : ''}>Australia</option>
        <option value="UK" ${param.country == 'UK' ? 'selected' : ''}>United Kingdom</option>
        <option value="NZ" ${param.country == 'NZ' ? 'selected' : ''}>New Zealand</option>
        <option value="USA" ${param.country == 'USA' ? 'selected' : ''}>USA</option>
        <option value="CA" ${param.country == 'CA' ? 'selected' : ''}>Canada</option>
    </select>
</form>-->

<%--<form action="../news/worldnews.jsp" method="get">
    <select name="country" onchange="this.form.submit()">
        <option value="">World News</option>
        <option value="AUS">Australia</option>
        <option value="UK">United Kingdom</option>
        <option value="NZ">New Zealand</option>
        <option value="USA">USA</option>
        <option value="CA">Canada</option>
    </select>
</form>--%>


							<div class="penci_nav_col penci_nav_center penci_nav_aligncenter">


							</div>


							<div class="penci_nav_col penci_nav_right penci_nav_alignright" >

								<div  class="pc-builder-element pc-builder-menu pc-main-menu">
									<nav class="navigation menu-style-1 no-class menu-item-normal  "
										role="navigation" itemscope=""
										itemtype="https://schema.org/SiteNavigationElement">
										
												<ul id="menu-menu-1" class="menu">
												
												<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1969"><a href="../">HOME</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1973"><a href="../news/Sinhala.jsp">සිංහල</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1970"><a href="../slcommunity/">COMMUNITY NEWS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../news/pagelist.jsp?categoryid=10">BUSINESS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../news/pagelist.jsp?categoryid=14">TECHNOLOGY</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1971"><a href="../news/pagelist.jsp?categoryid=11">VIDEOS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1977"><a href="../news/pagelist.jsp?categoryid=102">SPORTS</a></li>
<!--<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1972"><a href="../news/pagelist.jsp?categoryid=12">ENTERTAINMENT</a></li>-->
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1974"><a href="../news/pagelist.jsp?categoryid=45">TAMIL</a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home ajax-mega-menu menu-item-1694"><a href="../slcommunity/charity-directory/">CHARITIES</a></li>


<li class="menu-item menu-item-type-post_type_archive menu-item-object-mec-events ajax-mega-menu menu-item-1629"><a href="../slcommunity/events/">EVENTS</a></li>
</ul>    
									</nav>
								</div>
								<div style="margin-bottom:12px;"
									class="penci-builder-element penci-vertical-line vertical-line-1 ">
								</div>
								<a rel="noreferrer"
                                  href="/slcommunity/index.php/login/"
                                  class="penci-builder penci-builder-button button-1 button-define-style-4 button-shape-customize default"
                                   style="text-decoration: none; margin-bottom:12px;">
                                  LOGIN
                                    </a>

								<div id="top-search"
									class="pc-builder-element penci-top-search pcheader-icon top-search-classes ">
									<a style="margin-bottom:10px;" class="search-click pc-button-define-customize"> <i
										class="penciicon-magnifiying-glass"></i>
									</a>
									<!-- <div  class="show-search">
										<form role="search" method="get" class="pc-searchform"
											action="../rcsearch/news">
											<div class="pc-searchform-inner" style="display: flex; align-items: center;">
												<input type="text" class="searchinput ac_input" id ="searchterm5"
													name="q" placeholder="Type and hit enter..."
													autocomplete="on"> <i 
													class="penciicon-magnifiying-glass"
													></i> 
													<input type="submit" class="searchsubmit" value="Search"
                       style="padding: 2px 10px 2px 10px ; background: rgb(239, 239, 239); color: rgb(0, 0, 0); border: none; 
                              border-radius: 0 4px 4px 0; cursor: pointer; white-space: nowrap;
                              font-family: inherit; font-size: inherit; min-width: 80px; min-height: 10px;">
                <i class="penciicon-magnifiying-glass" style="display: none;"></i>
											
											</div>
										</form>
										<a class="search-click close-search"><i
											class="penciicon-close-button"></i></a>
									</div>-->
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
                            
                            <!--<div class="penci-builder-element pc-search-form pc-search-form-sidebar search-style-default" style="background-color: white; border: 1px solid #87CEFA; border-radius: 0px; padding: 5px; margin-top: 8px;width:80%">
                           <form role="search" method="get" class="rc-pc-searchform" action="../rcsearch/news">
                           <div class="pc-searchform-inner" style="display: flex;">
                            <input type="text" class="search-input" placeholder="Type and hit enter to search news..." name="q" id ="searchterm" autocomplete="on" value="" style="flex: 1; padding: 2px; border: none; outline: none; border-radius: 3px 0 0 3px;">
                            <button type="submit" class="searchsubmit" style="background-color: white; color: black; border: none; padding: 7px 60px; border-radius: 0 3px 3px 0; cursor: pointer; font: bold 14px Roboto, sans-serif;">SUBMIT</button></div>
                           </form>
                           </div>-->
                           
                           <div class="penci-builder-element pctopbar-item penci-topbar-trending">
<span class="penci-trending-nav">
  <a class="penci-slider-prev" aria-label="Previous" href="#"><i class="penci-faicon fa fa-angle-left"></i></a>
  <a class="penci-slider-next" aria-label="Next" href="#"><i class="penci-faicon fa fa-angle-right"></i></a>
</span>
<div class="penci-owl-carousel penci-owl-carousel-slider penci-headline-posts" data-auto="true" data-nav="false" data-autotime="3000" data-speed="200" data-anim="slideInUp">
<%
itr = newsSummaryList.iterator();
while (itr.hasNext()) {
  newsSummary = (Articles) itr.next();
  if (newsSummary.getTitle() != null) {
%>
<div>
<% if (newsSummary.getAlias() != null) { %>
  <a class="penci-topbar-post-title penci-disable-uppercase" href="../newspage/<%=newsSummary.getArticleId()%>ai-<%=newsSummary.getAlias()%>"><%=newsSummary.getTitle()%></a>
<% } else { %>
  <a class="penci-topbar-post-title penci-disable-uppercase" href="../news/page.jsp?articleid=<%=newsSummary.getArticleId()%>"><%=newsSummary.getTitle()%></a>
<% } %>
</div>
<% } } %>
</div>
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
            
            <a href="https://www.tiktok.com/@vivalanka" aria-label="TikTok" rel="noreferrer" target="_blank">
    <svg class="penci-faicon fa" width="12" height="12" viewBox="0 0 24 24" style="fill: currentColor; vertical-align: middle;  margin-top:-10px;">
        <path d="M12.525.02c1.31-.02 2.61-.01 3.91-.02.08 1.53.63 3.09 1.75 4.17 1.12 1.11 2.7 1.62 4.24 1.79v4.03c-1.44-.05-2.89-.35-4.2-.97-.57-.26-1.1-.59-1.62-.93-.01 2.92.01 5.84-.02 8.75-.08 1.4-.54 2.79-1.35 3.94-1.31 1.92-3.58 3.17-5.91 3.21-1.43.08-2.86-.31-4.08-1.03-2.02-1.19-3.44-3.37-3.65-5.71-.02-.5-.03-1-.01-1.49.18-1.9 1.12-3.72 2.58-4.96 1.66-1.44 3.98-2.13 6.15-1.72.02 1.48-.04 2.96-.04 4.44-.99-.32-2.15-.23-3.02.37-.63.41-1.11 1.04-1.36 1.75-.21.51-.15 1.07-.14 1.61.24 1.64 1.82 3.02 3.5 2.87 1.12-.01 2.19-.66 2.77-1.61.19-.33.4-.67.41-1.06.1-1.79.06-3.57.07-5.36.01-4.03-.01-8.05.02-12.07z"/>
    </svg>
</a>
            <a href="https://www.instagram.com/vivalankanews"
								        aria-label="Instagram" rel="noreferrer"
								        target="_blank"><i class="penci-faicon fa fa-instagram"></i></a>
        </div>
    </div>
    
    <!-- <a rel="noreferrer" href="../rcsearch/news?&q=&fq=category:%22AI%20Flash%20News%22&NarrowBy=Category" class="penci-builder penci-builder-button button-2 button-define-style-4 button-shape-customize default" style="text-decoration: none;">
        <i class="fa fa-newspaper-o"></i>&nbsp;&nbsp;AI-Powered Unbiased News  
    </a> -->
    
    
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

								<div class="pc-builder-element pc-logo pb-logo-mobile penci-header-image-logo" style="padding: 0px 0px 0px 10px;">
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
							<!-- country" -->
							<form action="../news/worldnews.jsp" method="get" style="margin-right: 15px;">
    <select name="country" onchange="this.form.submit()" 
            style="padding: 4px 6px; 
                   font-size: 14px; 
                   border: 1px solid #87CEFA; 
                   border-radius: 2px; 
                   background-color: white;
                   color: #333;
                   cursor: pointer;
                   outline: none;
                   font-family: inherit;
                   min-width: 40px;
                   transition: all 0.3s ease;">
        <!--  <option value="" <%= request.getParameter("country") == null ? "selected" : "" %>>World</option>-->
        <option value="LK" <%= "LK".equals(request.getParameter("country")) ? "selected" : "" %>>SL</option>
        <option value="AUS" <%= "AUS".equals(request.getParameter("country")) ? "selected" : "" %>>AUS</option>
        <option value="CA" <%= "CA".equals(request.getParameter("country")) ? "selected" : "" %>>CA</option>
        <option value="NZ" <%= "NZ".equals(request.getParameter("country")) ? "selected" : "" %>>NZ</option>
        <option value="UK" <%= "UK".equals(request.getParameter("country")) ? "selected" : "" %>>UK</option>       
        <option value="USA" <%= "USA".equals(request.getParameter("country")) ? "selected" : "" %>>USA</option>
        
    </select>
</form>
							<!--<form action="../news/worldnews.jsp" method="get">
    <select name="country" onchange="this.form.submit()">
        <option value="">World News</option>
        <option value="AUS" ${param.country == 'AUS' ? 'selected' : ''}>AUS</option>
        <option value="UK" ${param.country == 'UK' ? 'selected' : ''}>UK</option>
        <option value="NZ" ${param.country == 'NZ' ? 'selected' : ''}>NZ</option>
        <option value="USA" ${param.country == 'USA' ? 'selected' : ''}>USA</option>
        <option value="CA" ${param.country == 'CA' ? 'selected' : ''}>CA</option>
    </select>
</form>-->


							<div class="penci_nav_col penci_nav_right penci_nav_alignright">

									<div id="top-search"
									class="pc-builder-element penci-top-search pcheader-icon top-search-classes ">
									<a class="search-click pc-button-define-customize"> <i
										class="penciicon-magnifiying-glass"></i>
									</a>
									<!--  <div class="show-search">
										<form role="search" method="get" class="pc-searchform"
											action="../rcsearch/news">
											<div class="pc-searchform-inner" style="display: flex; align-items: center;">
												<input type="text" class="searchinput ac_input" id ="searchterm5"
													name="q" placeholder="Type and hit enter..."
													autocomplete="on"> <i
													class="penciicon-magnifiying-glass"
													></i> 
													<input type="submit" class="searchsubmit" value="Search"
                       style="padding: 3px 15px 3px 15px; background: rgb(239, 239, 239); color: rgb(0, 0, 0); border: none; 
                              border-radius: 0 4px 4px 0; cursor: pointer; white-space: nowrap;
                              font-family: inherit; font-size: inherit; min-width: 80px;">
                <i class="penciicon-magnifiying-glass" style="display: none;"></i>
											
											</div>
										</form>
										<a class="search-click close-search"><i
											class="penciicon-close-button"></i></a>
									</div>-->
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

					    <!-- <a rel="noreferrer" href="../rcsearch/news?&q=&fq=category:%22AI%20Flash%20News%22&NarrowBy=Category" class="penci-builder penci-builder-button button-2 button-define-style-4 button-shape-customize default" style="text-decoration: none;">
        <i class="fa fa-newspaper-o"></i>&nbsp;&nbsp;AI-Powered Unbiased News  
    </a>-->
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
								<!-- <a href="../rcsearch/news">  -->
								<a> 
								<img
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
                   aria-label="Youtube"  rel="noreferrer"                   target="_blank"><i class="penci-faicon fa fa-youtube-play" ></i></a> 
                   <a
										href="https://twitter.com/vivalanka" aria-label="Twitter"
										rel="noreferrer" target="_blank"><i
										class="penci-faicon fa fa-twitter"></i></a>
										   <a href="https://www.tiktok.com/@vivalanka" aria-label="TikTok" rel="noreferrer" target="_blank">
  <span class="penci-faicon fa" 
        style="display:inline-flex; align-items:center; justify-content:center; width:32px; height:32px; border-radius:50%; background:#000; color:#fff;">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" 
         style="width:18px; height:18px; fill:currentColor;">
      <path d="M12.525.02c1.31-.02 2.61-.01 3.91-.02.08 1.53.63 3.09 1.75 4.17 1.12 1.11 2.7 1.62 4.24 1.79v4.03c-1.44-.05-2.89-.35-4.2-.97-.57-.26-1.1-.59-1.62-.93-.01 2.92.01 5.84-.02 8.75-.08 1.4-.54 2.79-1.35 3.94-1.31 1.92-3.58 3.17-5.91 3.21-1.43.08-2.86-.31-4.08-1.03-2.02-1.19-3.44-3.37-3.65-5.71-.02-.5-.03-1-.01-1.49.18-1.9 1.12-3.72 2.58-4.96 1.66-1.44 3.98-2.13 6.15-1.72.02 1.48-.04 2.96-.04 4.44-.99-.32-2.15-.23-3.02.37-.63.41-1.11 1.04-1.36 1.75-.21.51-.15 1.07-.14 1.61.24 1.64 1.82 3.02 3.5 2.87 1.12-.01 2.19-.66 2.77-1.61.19-.33.4-.67.41-1.06.1-1.79.06-3.57.07-5.36.01-4.03-.01-8.05.02-12.07z"/>
    </svg>
  </span>
</a>

										<a href="https://www.instagram.com/vivalanka"
								        aria-label="Instagram" rel="noreferrer"
								        target="_blank"><i class="penci-faicon fa fa-instagram"></i></a>
								</div>
							</div>
							<div id="top-search"
									class="pc-builder-element penci-top-search pcheader-icon top-search-classes ">
									<a style="margin-bottom:10px;" class="search-click pc-button-define-customize"> <i
										class="penciicon-magnifiying-glass"></i>
									</a>
									<!-- <div  class="show-search">
										<form role="search" method="get" class="pc-searchform"
											action="../rcsearch/news">
											<div class="pc-searchform-inner" style="display: flex; align-items: center;">
												<input type="text" class="searchinput ac_input" id ="searchterm5"
													name="q" placeholder="Type and hit enter..."
													autocomplete="on"> <i 
													class="penciicon-magnifiying-glass"
													></i> 
													<input type="submit" class="searchsubmit" value="Search"
                       style="padding: 2px 10px 2px 10px ; background: rgb(239, 239, 239); color: rgb(0, 0, 0); border: none; 
                              border-radius: 0 4px 4px 0; cursor: pointer; white-space: nowrap;
                              font-family: inherit; font-size: inherit; min-width: 80px; min-height: 10px;">
                <i class="penciicon-magnifiying-glass" style="display: none;"></i>
											
											</div>
										</form>
										<a class="search-click close-search"><i
											class="penciicon-close-button"></i></a>
									</div>-->
								</div>
							<div class="pc-builder-element pc-builder-menu pc-dropdown-menu">
								<nav class="no-class normal-click" role="navigation"
									itemscope=""
									itemtype="https://schema.org/SiteNavigationElement">
									
												<ul id="menu-menu-2" class="menu menu-hgb-main">
												
												<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1969"><a href="../">HOME</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1973"><a href="../news/Sinhala.jsp">සිංහල</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1970"><a href="../slcommunity/">COMMUNITY NEWS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../news/pagelist.jsp?categoryid=10">BUSINESS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1975"><a href="../news/pagelist.jsp?categoryid=14">TECHNOLOGY</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1971"><a href="../news/pagelist.jsp?categoryid=11">VIDEOS</a></li>
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1977"><a href="../news/pagelist.jsp?categoryid=102">SPORTS</a></li>
<!--<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1972"><a href="../news/pagelist.jsp?categoryid=12">ENTERTAINMENT</a></li> -->
<li class="menu-item menu-item-type-custom menu-item-object-custom ajax-mega-menu menu-item-1974"><a href="../news/pagelist.jsp?categoryid=45">TAMIL</a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home ajax-mega-menu menu-item-1694"><a href="../slcommunity/">CHARITIES</a></li>
 

<li class="menu-item menu-item-type-post_type_archive menu-item-object-mec-events ajax-mega-menu menu-item-1629"><a href="../slcommunity/events/">EVENTS</a></li>


</ul>     
								</nav>
							</div>
<a rel="noreferrer"
   href="/slcommunity/index.php/login/"
   class="penci-builder penci-builder-button button-1 button-define-style-4 button-shape-customize default"
   style="text-decoration:none; display:inline-block; margin-left:15px; margin-bottom:8px; width:auto; min-width:auto;">
   LOGIN
</a>

							<div
								class="penci-builder-element penci-html-ads penci-html-ads-mobile">
								Copyright 2025 - All Right Reserved</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Add this CSS style block -->
<style>
.penci_header.penci_builder_sticky_header_desktop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
    transform: translateY(-100%);
    transition: transform 0.3s ease-in-out;
    background: #fff; /* Match your navbar background color */
    box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* Optional shadow when visible */
}

/* Ensure content doesn't jump when navbar appears */
.wrapper-boxed {
    transition: padding-top 0.3s ease-in-out;
}
select {
    padding: 8px 12px;
    font-size: 14px;
    border-radius: 4px;
    border: 1px solid #ccc;
    cursor: pointer;
}

select:hover {
    border-color: #2196F3 !important;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

select:focus {
    border-color: #2196F3 !important;
    box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
}

</style>

<!-- Your existing HTML code remains unchanged until the end -->

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Get the top ad section and sticky header
    const topAdSection = document.querySelector('.penci-section.penci-disSticky');
    const stickyHeader = document.querySelector('.penci_header.penci_builder_sticky_header_desktop');
    
    if (topAdSection && stickyHeader) {
        // Calculate the height of the top ad section
        let topAdHeight = topAdSection.offsetHeight;
        
        // Listen for scroll events
        let ticking = false;
        window.addEventListener('scroll', function() {
            if (!ticking) {
                window.requestAnimationFrame(function() {
                    if (window.scrollY > topAdHeight) {
                        // Show the sticky header after scrolling past the top ad
                        stickyHeader.style.transform = 'translateY(0)';
                    } else {
                        // Hide the sticky header when at the top
                        stickyHeader.style.transform = 'translateY(-100%)';
                    }
                    ticking = false;
                });
                ticking = true;
            }
        });

        // Recalculate on resize in case the ad height changes
        window.addEventListener('resize', function() {
            topAdHeight = topAdSection.offsetHeight;
        });
    }
});
</script>