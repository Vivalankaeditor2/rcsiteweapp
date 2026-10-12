<%
   if(!(request.getHeader("host").startsWith("qa.")||request.getHeader("host").startsWith("www.")|| request.getHeader("host").startsWith("rcsiteweb"))){
	String oldURL =request.getHeader("host")+request.getRequestURI();
   		String newURL ="https://www."+request.getHeader("host")+request.getRequestURI();
  	 	if (request.getQueryString() != null) {
			oldURL =oldURL+"?" + request.getQueryString();
  	 		newURL = newURL + "?" + request.getQueryString();
  	 		}
			 System.out.println("oldURL: " +oldURL);
  	 	System.out.println("newURL:" +newURL);
		//response.setStatus(301);
		//response.setHeader( "Location", newURL );
		//response.setHeader( "Connection", "close" );
if(request.getHeader("user-agent").contains("facebook")){
java.util.Enumeration headerNames = request.getHeaderNames();
while(headerNames.hasMoreElements()) {
  String headerName = (String)headerNames.nextElement();
  System.out.print("headerName: " + headerName);
  System.out.println(" value: " + request.getHeader(headerName));
}
}
	}
%>
<%@page import="com.rev_creations.rcsite.GeneratorSetting"%><%String MM_dbconnection_DRIVER = "com.mysql.jdbc.Driver";
java.util.Date endTime2 = java.util.Calendar.getInstance().getTime(); 
java.util.SortedMap loadTimeMap2 = new java.util.TreeMap();
			String MM_dbconnection_USERNAME = com.rev_creations.rcsite.Config
					.getValue("databaseusername");
			String MM_dbconnection_PASSWORD = com.rev_creations.rcsite.Config
					.getValue("databasepassword");
			String MM_dbconnection_STRING = "jdbc:mysql://localhost/"
					+ com.rev_creations.rcsite.Config.getValue("database") + "?relaxAutoCommit=true&emulateLocators=true&autoReconnect=true&characterEncoding=UTF-8";

			String userAgent = request.getHeader("user-agent");

			javax.sql.DataSource rcsiteDS = null;

			rcsiteDS = (javax.sql.DataSource) getServletContext().getAttribute(
					"rcsiteDS");
			if (rcsiteDS == null) {
				try {

					javax.naming.Context context = new javax.naming.InitialContext();
					javax.naming.Context envCtx = (javax.naming.Context) context
							.lookup("java:comp/env");
					rcsiteDS = (javax.sql.DataSource) envCtx
							.lookup("jdbc/rcsite");
					System.out.println("jdbc/rcsite looked up");
				} catch (Exception e) {
					System.out.println("Error occurred " + e);
				}

				getServletContext().setAttribute("rcsiteDS", rcsiteDS);
			}

endTime2 = java.util.Calendar.getInstance().getTime(); 
loadTimeMap2.put("11.endrcsiteDS",endTime2);
			
// *************** start news only pages**************//
		if(com.rev_creations.rcsite.Config.getValue("pagecaching")!=null &&
			"1".equals(com.rev_creations.rcsite.Config.getValue("pagecaching").trim())){
			if(!com.rev_creations.rcsite.ArticlePageGenerator.initialized){
				 	com.rev_creations.rcsite.ArticlePageGenerator.initialize(session.getServletContext());
			}

		}
		javax.persistence.EntityManager entityManager = null;
		entityManager = com.rev_creations.rcsite.ArticlePageGenerator.getEntityManager();
// *************** end news only pages**************//

//***********start determining location*****************//
if(com.rev_creations.rcsite.Config.getValue("locationenabled")!=null &&
	"1".equals(com.rev_creations.rcsite.Config.getValue("locationenabled").trim())){
	
			String ip = request.getParameter("ip");
			if (ip != null && ip.length() > 0) {
				session.removeAttribute("location");
			} else {
				ip = request.getRemoteAddr();
			}

			if (session.getServletContext().getAttribute("locationUtil") == null) {
				com.rev_creations.rcsite.LocationUtil locationUtil = new com.rev_creations.rcsite.LocationUtil();
				session.getServletContext().setAttribute("locationUtil",
						locationUtil);
			}

			if (userAgent != null
					&& (userAgent.toLowerCase().contains("java")
							|| userAgent.toLowerCase().contains("twitterbot")
							|| userAgent.toLowerCase().contains("facebook.com")
							|| userAgent.toLowerCase().contains("baidu")
							|| userAgent.toLowerCase().contains("yandex")
							|| userAgent.toLowerCase().contains("yahoo.com") 
							|| userAgent.toLowerCase().contains("bing.com")
							|| userAgent.toLowerCase().contains("crawler")
							|| userAgent.toLowerCase().contains("bot.htm")
							|| userAgent.toLowerCase().contains("majestic")
							|| userAgent.toLowerCase().contains("google")
							||userAgent.toLowerCase().contains("flipboard"))) {
				com.maxmind.geoip.Location location = null;
				com.rev_creations.rcsite.LocationBean locationBean = null;
			//	System.out.println("user-agent === " + userAgent);
				location = new com.maxmind.geoip.Location();
				location.countryCode = "CA";
				location.countryName = "Canada";
				location.region = "ON";
				location.city = "Toronto";
				locationBean = new com.rev_creations.rcsite.LocationBean(
						location);
				session.setAttribute("location", locationBean);
				session.setAttribute("localNewsCategories", "17,19");
				session.setAttribute("localFeaturesCategories", "33");
				
endTime2 = java.util.Calendar.getInstance().getTime(); 
loadTimeMap2.put("12.endlocationuserAgent",endTime2);	

			}
			
			if (session.getAttribute("location") == null) {
				Cookie[] cookies = request.getCookies();
				com.maxmind.geoip.Location location = null;
				//com.rev_creations.rcsite.LocationBean locationBean = null;
				String locationid = null;
				if (cookies != null) { //see if location id is in the cookies
					for (int i = 0; i < cookies.length; i++) {
						System.out.println("cookie name: "
								+ cookies[i].getName() + "="
								+ cookies[i].getValue());
						if ("locationid".equalsIgnoreCase(cookies[i].getName())) {
							locationid = cookies[i].getValue();
						}
					}
endTime2 = java.util.Calendar.getInstance().getTime(); 
loadTimeMap2.put("12.endlocationcookiesiteration",endTime2);	
				}//end see if location id is in the cookies
				if (locationid != null && locationid.trim().length() > 0) { //location id found in cookies

					// get location from database
					location = new com.maxmind.geoip.Location();
					
					java.sql.Connection ConnLocationRecordset = rcsiteDS.getConnection();
					
					java.sql.PreparedStatement StatementLocationRecordset = ConnLocationRecordset
							.prepareStatement("SELECT country, region FROM geo_location where location_id ="+ locationid + " ORDER BY country ASC");
					java.sql.ResultSet LocationRecordset = StatementLocationRecordset.executeQuery();
					String regionNameLable = "";
					String regionCode = "";

					while (LocationRecordset.next()) {
						location.countryCode = (String) ((LocationRecordset
								.getObject("country") != null) ? LocationRecordset
								.getObject("country")
								: "");
						regionCode = (String) (((LocationRecordset
								.getObject("region") != null) ? LocationRecordset
								.getObject("region")
								: ""));
					}
					LocationRecordset.close();
					StatementLocationRecordset.close();
					ConnLocationRecordset.close();

					regionCode = regionCode.trim();
					if (regionCode.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+")) {
						java.text.NumberFormat formatter = new java.text.DecimalFormat(
								"##00");
						int i = Integer.parseInt(regionCode);
						regionCode = formatter.format(i);

					}
					if (regionCode != null && !regionCode.equalsIgnoreCase("0")
							&& regionCode.length() > 0) {
						regionNameLable = com.maxmind.geoip.regionName
								.regionNameByCode(location.countryCode,
										regionCode);

					}
					location.region = regionCode;
endTime2 = java.util.Calendar.getInstance().getTime(); 
loadTimeMap2.put("13.endlocationcookies",endTime2);	
				} else { //location id not found in cookies 
					// get location from geoip 
					com.rev_creations.rcsite.LocationUtil locationUtil = (com.rev_creations.rcsite.LocationUtil) session
							.getServletContext().getAttribute("locationUtil");
					location = locationUtil.getLocation(ip);
endTime2 = java.util.Calendar.getInstance().getTime(); 
loadTimeMap2.put("14.endlocationIP",endTime2);	
				}

				com.rev_creations.rcsite.LocationBean locationBean = null;
				locationBean = new com.rev_creations.rcsite.LocationBean(location);
				
				System.out.println((new java.util.Date()) + " ip " + ip	+ " locationid " + locationid + ","	+ locationBean.getCountryName() + ","
						+ locationBean.getRegionName() + ","+ locationBean.getCity());
				session.setAttribute("location", locationBean);

	}
}
		//***********************end determining location***************//	
endTime2 = java.util.Calendar.getInstance().getTime(); 
loadTimeMap2.put("15.endlocation",endTime2);		
		
	// *************** start getting local news and local features categories and save them in the session.******************//
if(com.rev_creations.rcsite.Config.getValue("locationenabled")!=null &&
	"1".equals(com.rev_creations.rcsite.Config.getValue("locationenabled").trim()) &&
	com.rev_creations.rcsite.Config.getValue("newsenabled")!=null &&
	"1".equals(com.rev_creations.rcsite.Config.getValue("newsenabled").trim())){
	
	if (session.getAttribute("localNewsCategories") == null) {
		String localNewsCategories1 = null;
		String localFeaturesCategories1 = null;
		String regionCode1 = "";
		String countryCode1 = "";
	 
			if (((com.rev_creations.rcsite.LocationBean) session
					.getAttribute("location")).getRegion() != null) {
				regionCode1 = ((com.rev_creations.rcsite.LocationBean) session
						.getAttribute("location")).getRegion().trim();
			}

			if (regionCode1.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+")) {
				java.text.NumberFormat formatter = new java.text.DecimalFormat(
						"##0");
				int i = Integer.parseInt(regionCode1);
				regionCode1 = formatter.format(i);

			}
			countryCode1 = ((com.rev_creations.rcsite.LocationBean) session.getAttribute("location")).getCountryCode();
								
			localNewsCategories1 = com.rev_creations.rcsite.ArticlePageGenerator.getArticleCategoryGroupMap().get("local_"+countryCode1+"_"+regionCode1);
			localFeaturesCategories1 = com.rev_creations.rcsite.ArticlePageGenerator.getArticleCategoryGroupMap().get("feature_"+countryCode1+"_"+regionCode1);
			//System.out.println("localNewsCategories aaaaaaaaaaaaaaaaa"+localNewsCategories1);
			//System.out.println("localNewsCategories ddddddddddddddddd"+session.getAttribute("localNewsCategories"));
			if(localNewsCategories1 == null || localNewsCategories1.length() <=0){
			    localNewsCategories1 = "7,";
	            localFeaturesCategories1 ="";
				
				String whereClue1 = "select a.category_id, b.parentid from location_article_category as a inner join article_category as b on a.category_id = b.categoryid "
						+ " where b.parentid <> 5 and location_id in ( "
						+ "select location_id from geo_location where "
						+ " ( country ='"
						+ ((com.rev_creations.rcsite.LocationBean) session
								.getAttribute("location")).getCountryCode()
						+ "' "
						+ " and region ='') "
						+ " or (country ='"
						+ ((com.rev_creations.rcsite.LocationBean) session
								.getAttribute("location")).getCountryCode()
						+ "' " + " and region ='" + regionCode1 + "' )) ";
//System.out.println("whereClue1whereClue1 " + whereClue1);
				java.sql.Connection ConnArticleRecordset1 = rcsiteDS.getConnection();
				java.sql.PreparedStatement StatementArticleRecordset1 = ConnArticleRecordset1.prepareStatement(whereClue1);
				java.sql.ResultSet ArticleRecordset1 = StatementArticleRecordset1.executeQuery();
				boolean ArticleRecordset_isEmpty1 = !ArticleRecordset1.next();
				boolean ArticleRecordset_hasData1 = !ArticleRecordset_isEmpty1;
				Object ArticleRecordset_data1;
				int ArticleRecordset_numRows1 = 0;

				int Repeat1__numRows1 = 5;
				int Repeat1__index1 = 0;
				ArticleRecordset_numRows1 += Repeat1__numRows1;
			
				if (ArticleRecordset_hasData1) {
					localNewsCategories1 = "";
					while ((ArticleRecordset_hasData1)) {
						Repeat1__numRows1--;
						
						if (ArticleRecordset1.getObject("b.parentid") != null
							&& ArticleRecordset1.getInt("b.parentid") == 2) {
							 localNewsCategories1 = localNewsCategories1
										+ ArticleRecordset1.getObject("category_id")
											+ ",";
						} else {
								 localFeaturesCategories1 = localFeaturesCategories1
											+ ArticleRecordset1.getObject("category_id")
											+ ",";
						}
						Repeat1__index1++;
						ArticleRecordset_hasData1 = ArticleRecordset1.next();
					}
				}
				localNewsCategories1 = localNewsCategories1.substring(0,localNewsCategories1.lastIndexOf(","));
				com.rev_creations.rcsite.ArticlePageGenerator.getArticleCategoryGroupMap().put("local_"+countryCode1+"_"+regionCode1, localNewsCategories1 );
				
				if(!"7".equals(localNewsCategories1)){
					//com.rev_creations.rcsite.ArticlePageGenerator.categoryLimitTable.put(localNewsCategories1,new GeneratorSetting(60,22));
			    }
				
				if(localFeaturesCategories1!=null && localFeaturesCategories1.length()>0){
					localFeaturesCategories1 = localFeaturesCategories1.substring(0,localNewsCategories1.lastIndexOf(","));
				   	com.rev_creations.rcsite.ArticlePageGenerator.getArticleCategoryGroupMap().put("feature_"+countryCode1+"_"+regionCode1, localFeaturesCategories1);
					//com.rev_creations.rcsite.ArticlePageGenerator.categoryLimitTable.put(localFeaturesCategories1,new GeneratorSetting(60,23));
				}
				
				ConnArticleRecordset1.close();
				StatementArticleRecordset1.close();
				ArticleRecordset1.close();
			}
			
			session.setAttribute("localNewsCategories",localNewsCategories1);
			if(localFeaturesCategories1!=null && localFeaturesCategories1.length()>0){
				session.setAttribute("localFeaturesCategories",localFeaturesCategories1);
			}
		}
 }
// *************** end getting local news categories and save them in the session.******************//
endTime2 = java.util.Calendar.getInstance().getTime(); 
loadTimeMap2.put("17.localNews",endTime2);
			%>
<%!public String treatStringParam(String param) {

		param = param.replaceAll("'", " ");
		param = param.replaceAll("\\(", " ");
		param = param.replaceAll("\\)", " ");
		param = param.replaceAll("\"", " ");
		param = param.replaceAll("\\*", " ");
		param = param.replaceAll("\\[", " ");
		param = param.replaceAll("\\]", " ");
		param = param.replaceAll("%", " ");
		param = param.replaceAll(";", " ");

		return param;
	}%><%!public String removeSmallWords(String param) {
		if (param != null) {
			param = param.toLowerCase();

			param = param.replaceAll(" the ", " ");
			param = param.replaceAll(" on ", " ");
			param = param.replaceAll(" a ", " ");
			param = param.replaceAll(" in ", " ");
			param = param.replaceAll(" to ", " ");
			param = param.replaceAll(" of ", " ");
			param = param.replaceAll(" or ", " ");
			param = param.replaceAll(" was ", " ");
			param = param.replaceAll(" were ", " ");
			param = param.replaceAll(" is ", " ");
			param = param.replaceAll(" if ", " ");
			param = param.replaceAll(" does ", " ");
			param = param.replaceAll(" not ", " ");
			param = param.replaceAll(" off ", " ");
			param = param.replaceAll(" will ", " ");
			param = param.replaceAll(" that ", " ");
			param = param.replaceAll(" an ", " ");
			param = param.replaceAll(" it ", " ");
			param = param.replaceAll(" its ", " ");
			param = param.replaceAll(" has ", " ");
			param = param.replaceAll(" have ", " ");
			param = param.replaceAll(" had ", " ");
		}
		return param;
	}%><%!public String shortenString(String param, int lenght) {
		if (param != null) {
			param = param.replaceAll("\\<.*?>", "");
			param = param.replaceAll("&nbsp;", " ");
			if (param.length() > lenght) {
				param = param.substring(0, lenght - 1);

			}
		}
		return param;
	}%><%!public boolean validateNumeric(String number, String page,
			HttpServletRequest request, HttpServletResponse response) {
		boolean result = true;
		if (number.matches("\\d{1,9}")) {
			result = true;
		} else {
			try {
				request.setAttribute("invalidpage", page);
				RequestDispatcher dispatcher = getServletContext()
						.getRequestDispatcher(
								"/errorpages/invaliddataerror.jsp");
				dispatcher.forward(request, response);
				result = false;
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}%>
	
	<% 
// Check if country is passed in the URL
String leftTopCategroy = com.rev_creations.rcsite.Config
.getValue("leftTopCategroy.default");
String rightTopCategroy = com.rev_creations.rcsite.Config
.getValue("rightTopCategroy.default");
String rightBotomCategroy =com.rev_creations.rcsite.Config
.getValue("rightBotomCategroy.index");
String rightCharityCatgroy =com.rev_creations.rcsite.Config
.getValue("rightCharityCatgroy.default");
String middleTopCatgroy = com.rev_creations.rcsite.Config
.getValue("middleTopCatgroy.default");
String middleMiddleCatgroy =com.rev_creations.rcsite.Config
.getValue("middleMiddleCatgroy.default");
String leftBottomCategroy =com.rev_creations.rcsite.Config
.getValue("leftBottomCategroy.index");

String country = request.getParameter("country");

if (country != null && !country.isEmpty()) {
    // User manually selected a country from the menu
    if (country.equals("CA")){
        //leftTopCategroy = "wp.20";
        rightTopCategroy=com.rev_creations.rcsite.Config
				.getValue("rightTopCategroy.CA");
        leftTopCategroy =com.rev_creations.rcsite.Config
				.getValue("leftTopCategroy.CA");
        rightBotomCategroy=com.rev_creations.rcsite.Config
				.getValue("rightBotomCategroy.worldnews");
        //rightCharityCatgroy ="56";
        rightCharityCatgroy =com.rev_creations.rcsite.Config
				.getValue("rightCharityCatgroy.CA");
        middleTopCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleTopCatgroy.CA");
        middleMiddleCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleMiddleCatgroy.CA");
        leftBottomCategroy = com.rev_creations.rcsite.Config
				.getValue("leftBottomCategroy.worldnews");

    }else if (country.equals("USA")){
        //leftTopCategroy = "wp.19";
        leftTopCategroy =com.rev_creations.rcsite.Config
					.getValue("leftTopCategroy.USA");
        rightTopCategroy=com.rev_creations.rcsite.Config
				.getValue("rightTopCategroy.USA");
        rightBotomCategroy=com.rev_creations.rcsite.Config
				.getValue("rightBotomCategroy.worldnews");
        rightCharityCatgroy =com.rev_creations.rcsite.Config
				.getValue("rightCharityCatgroy.USA");
        middleTopCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleTopCatgroy.USA");
        middleMiddleCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleMiddleCatgroy.USA");
        leftBottomCategroy = com.rev_creations.rcsite.Config
				.getValue("leftBottomCategroy.worldnews");
    }else if (country.equals("AUS")){
        leftTopCategroy = com.rev_creations.rcsite.Config
				.getValue("leftTopCategroy.AUS");
        rightTopCategroy=com.rev_creations.rcsite.Config
				.getValue("rightTopCategroy.AUS");
        rightBotomCategroy=com.rev_creations.rcsite.Config
				.getValue("rightBotomCategroy.worldnews");
        rightCharityCatgroy =com.rev_creations.rcsite.Config
				.getValue("rightCharityCatgroy.AUS");
        //middleTopCatgroy = "95,98";
        middleTopCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleTopCatgroy.AUS");
        middleMiddleCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleMiddleCatgroy.AUS");
        leftBottomCategroy = com.rev_creations.rcsite.Config
				.getValue("leftBottomCategroy.worldnews");
        
    }else if (country.equals("NZ")){
        leftTopCategroy = com.rev_creations.rcsite.Config
				.getValue("leftTopCategroy.NZ");
        rightTopCategroy=com.rev_creations.rcsite.Config
				.getValue("rightTopCategroy.NZ");
        rightBotomCategroy=com.rev_creations.rcsite.Config
				.getValue("rightBotomCategroy.worldnews");
        rightCharityCatgroy =com.rev_creations.rcsite.Config
				.getValue("rightCharityCatgroy.NZ");
        middleTopCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleTopCatgroy.NZ");
        middleMiddleCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleMiddleCatgroy.NZ");
        leftBottomCategroy = com.rev_creations.rcsite.Config
				.getValue("leftBottomCategroy.worldnews");
    }else if (country.equals("UK")){
        leftTopCategroy = com.rev_creations.rcsite.Config
				.getValue("leftTopCategroy.UK");
        rightTopCategroy=com.rev_creations.rcsite.Config
				.getValue("rightTopCategroy.UK");
        rightBotomCategroy=com.rev_creations.rcsite.Config
				.getValue("rightBotomCategroy.worldnews");
        rightCharityCatgroy =com.rev_creations.rcsite.Config
				.getValue("rightCharityCatgroy.UK");
        middleTopCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleTopCatgroy.UK");
        middleMiddleCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleMiddleCatgroy.UK");
        leftBottomCategroy = com.rev_creations.rcsite.Config
				.getValue("leftBottomCategroy.worldnews");
    }else if(country.equals("LK")){
    	leftTopCategroy = com.rev_creations.rcsite.Config
				.getValue("leftTopCategroy.default");
    	rightTopCategroy=com.rev_creations.rcsite.Config
				.getValue("rightTopCategroy.default");
    	rightBotomCategroy=com.rev_creations.rcsite.Config
				.getValue("rightBotomCategroy.index");
    	rightCharityCatgroy =com.rev_creations.rcsite.Config
				.getValue("rightCharityCatgroy.default");
    	middleTopCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleTopCatgroy.default");
    	middleMiddleCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleMiddleCatgroy.default");
    	leftBottomCategroy = com.rev_creations.rcsite.Config
				.getValue("leftBottomCategroy.index");
    }else{
    	leftTopCategroy = com.rev_creations.rcsite.Config
				.getValue("leftTopCategroy.default");
    	rightTopCategroy=com.rev_creations.rcsite.Config
				.getValue("rightTopCategroy.default");
    	rightBotomCategroy=com.rev_creations.rcsite.Config
				.getValue("rightBotomCategroy.index");
    	rightCharityCatgroy =com.rev_creations.rcsite.Config
				.getValue("rightCharityCatgroy.default");
    	middleTopCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleTopCatgroy.default");
    	middleMiddleCatgroy = com.rev_creations.rcsite.Config
				.getValue("middleMiddleCatgroy.default");
    	leftBottomCategroy = com.rev_creations.rcsite.Config
				.getValue("leftBottomCategroy.index");
    }
}

// Store in request attribute so other includes can access it
request.setAttribute("leftTopCategroy", leftTopCategroy);
request.setAttribute("rightTopCategroy", rightTopCategroy);
request.setAttribute("rightBotomCategroy", rightBotomCategroy);
request.setAttribute("rightCharityCatgroy", rightCharityCatgroy);
request.setAttribute("middleTopCatgroy", middleTopCatgroy);
request.setAttribute("middleMiddleCatgroy", middleMiddleCatgroy);
request.setAttribute("leftBottomCategroy", leftBottomCategroy);

%>