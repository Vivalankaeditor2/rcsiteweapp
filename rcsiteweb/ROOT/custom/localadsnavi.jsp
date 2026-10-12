<%@ page language="java"	import="java.sql.*,java.util.*,com.rev_creations.persistence.dao.*,com.rev_creations.rcsite.*,javax.persistence.*,org.apache.log4j.Logger,java.util.*,com.rev_creations.rcsite.ArticlePageGenerator"%>
<%@ include file="../Connections/dbconnection.jsp"%><%
String adCountryCode = "";
int Repeat1__numRows;
try{
	List adList = null;
	Articles ad;
	String categories =null;
	
	adCountryCode = ((LocationBean) session
			.getAttribute("location")).getCountryCode();
	if (adCountryCode == null || adCountryCode.length() <= 0) {
		adCountryCode = "US";
	}
	
	categories = ArticlePageGenerator.getArticleCategoryGroupMap().get("ads_"+adCountryCode);

	if(categories == null || categories.length() <=0){
	
			String regionCode3 = "";
		if (((LocationBean) session.getAttribute("location")).getRegion() != null) {
			regionCode3 = ((com.rev_creations.rcsite.LocationBean) session.getAttribute("location")).getRegion().trim();
		}

		if (regionCode3.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+")) {
			java.text.NumberFormat formatter = new java.text.DecimalFormat("##0");
			int i = Integer.parseInt(regionCode3);
			regionCode3 = formatter.format(i);
		}
		
		categories = "36,";
		String whereClue2 = "select a.category_id from location_article_category as a inner join article_category as b on a.category_id = b.categoryid "
				+ " where b.parentid = 5 and location_id in ( "
				+ "select location_id from geo_location where "
				+ " ( country ='"
				+ ((com.rev_creations.rcsite.LocationBean) session
						.getAttribute("location")).getCountryCode()
				+ "' "
				+ " and region ='') "
				+ " or (country ='"
				+ ((com.rev_creations.rcsite.LocationBean) session
						.getAttribute("location")).getCountryCode()
				+ "' " + " and region ='" + regionCode3 + "' )) ";	

		Connection ConnArtiCatRecordset = rcsiteDS.getConnection();
		PreparedStatement StatementArtiCatRecordset = ConnArtiCatRecordset
				.prepareStatement(whereClue2);

		ResultSet ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();

		boolean ArtiCatRecordset_isEmpty = !ArtiCatRecordset.next();
		boolean ArtiCatRecordset_hasData = !ArtiCatRecordset_isEmpty;
		Object ArtiCatRecordset_data;
		int ArtiCatRecordset_numRows = 0;

		if (ArtiCatRecordset_hasData) {
			while (ArtiCatRecordset_hasData) {
				categories = ArtiCatRecordset.getInt("a.category_id")+ "," + categories;
				ArtiCatRecordset_hasData = ArtiCatRecordset.next();
			}
		}

		categories = categories.substring(0, categories.lastIndexOf(","));

		ArtiCatRecordset.close();
		StatementArtiCatRecordset.close();
		ConnArtiCatRecordset.close();
		
	//ArticlePageGenerator.categoryLimitTable.put(categories,new GeneratorSetting(30,60*12)); 
	ArticlePageGenerator.getArticleCategoryGroupMap().put("ads_"+adCountryCode,categories);
	}
	adList = ArticlePageGenerator.getArticleList(categories);
	%>
    <div>
		  <div class="redheading whitetitle"> Sponsored Links </div>
           <div style="text-align:center; padding-top:10px;">
    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 160x600 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:160px;height:600px"
     data-ad-client="ca-pub-1991368893626594"
     data-ad-slot="2216991212"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
    <%
	if (adList != null && !adList.isEmpty()) {
%><% 
		        Repeat1__numRows = 5;
				Iterator itr = adList.iterator();
				String  encodedUrl ="";
				while (itr.hasNext()  && Repeat1__numRows > 0) {
					ad = (Articles) itr.next();
					Repeat1__numRows--;%>
		 <div class ="newslist"><% if(ad.getAlias() !=null  ){%><a href="../newspage/<%=ad.getArticleId()%>ai-<%=ad.getAlias()%>"><%=ad.getTitle()%></a><%
			          }else{%><a href="../news/page.jsp?articleid=<%=ad.getArticleId()%>"><%=ad.getTitle()%></a><%}%></div><%
					  }%>
		 <div class="text" style="margin-left:120px; "><a href="/news/pagelist.jsp?categoryid=<%=categories%>">More&gt;&gt;</a></div>
<%
	}
}catch(Exception ex){
		Logger lgErr = Logger.getLogger("localadsnavi");
		lgErr.error("remote ip: "+request.getRemoteAddr()+" adCountryCode: " +adCountryCode ,ex);
}%>
</div>