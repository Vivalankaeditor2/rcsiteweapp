<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.maxmind.geoip.Location"%>
<%@page import="com.rev_creations.rcsite.LocationUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.SortedMap"%>
<%@page import="com.rev_creations.rcsite.LocationBean"%>
<%@page import="com.maxmind.geoip.regionName"%>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%

String countryCode = null;
String regionCode = null;
if (request.getParameter("countryCode") !=null) {
	countryCode = (String)request.getParameter("countryCode");
	countryCode = treatStringParam(countryCode);
}else if(session.getAttribute("location") !=null){
	countryCode = ((LocationBean)session.getAttribute("location")).getCountryCode();
	regionCode = ((LocationBean)session.getAttribute("location")).getRegion() ;
}


%>
<%
String locationidRegion = null;
String locationid = "";

if (request.getParameter("region") !=null ) {



		locationidRegion = (String)request.getParameter("region");
		locationid = locationidRegion.substring(0,locationidRegion.indexOf(":"));
		regionCode = locationidRegion.substring(locationidRegion.indexOf(":")+1);
		
		//Cookie locationCookie = new Cookie("locationid", locationid);
		//locationCookie.setMaxAge(365 * 24 * 60 * 60);
		//locationCookie.setPath("/");
		//response.addCookie(locationCookie);
		Location location = new Location();
		location.countryCode = countryCode;
		location.region = regionCode;
		LocationBean locationBean = new LocationBean(location);
		session.setAttribute("location", locationBean);
session.removeAttribute("localNewsCategories");
session.removeAttribute("localFeaturesCategories");




Connection ConnRecordsetLocationCategory = rcsiteDS.getConnection();
PreparedStatement StatementRecordsetLocationCategory = ConnRecordsetLocationCategory.prepareStatement("SELECT * FROM location_article_category WHERE location_id = " + locationid + " ORDER BY id DESC");
ResultSet RecordsetLocationCategory = StatementRecordsetLocationCategory.executeQuery();
boolean RecordsetLocationCategory_isEmpty = !RecordsetLocationCategory.next();
boolean RecordsetLocationCategory_hasData = !RecordsetLocationCategory_isEmpty;
Object RecordsetLocationCategory_data;
int RecordsetLocationCategory_numRows = 0;

		String url = "articlecategorylocationadd.jsp?locationid="+locationid;
		if( RecordsetLocationCategory_hasData){
			url = "articlecategorylocationupdate.jsp?locationid="+locationid;
		}
		
  		response.sendRedirect(response.encodeRedirectURL(url));
  		return;
}
%>

<%
String whereClue = " ";
if(countryCode!=null){
whereClue = "WHERE country = '" + countryCode + "' ";
}
%>
<%
//Driver DriverLocationRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnLocationRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnLocationRecordset  = rcsiteDS.getConnection();
PreparedStatement StatementLocationRecordset = ConnLocationRecordset.prepareStatement("SELECT location_id, region FROM geo_location "+whereClue+ " ORDER BY region ASC");
ResultSet LocationRecordset = StatementLocationRecordset.executeQuery();
boolean LocationRecordset_isEmpty = !LocationRecordset.next();
boolean LocationRecordset_hasData = !LocationRecordset_isEmpty;
Object LocationRecordset_data;
int LocationRecordset_numRows = 0;
%>

<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_jumpMenuGo(selName,targ,restore){ //v3.0
  var selObj = MM_findObj(selName); if (selObj) MM_jumpMenu(targ,selObj,restore);
}
//-->
</script>




<!-- InstanceEndEditable -->
</head>

<body>
<table width="100%" border="0" cellpadding="2"  cellspacing="0" bgcolor="e8ad03">
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
        <tr bgcolor="e8ad03"> 
          <td width="13%">&nbsp;</td>
          <td width="67%">&nbsp;<!--%=bannerCode%--></td>
          <td width="20%">&nbsp;</td>
  </tr>
  <tr valign="top"> 
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --> 
            <jsp:include page="adminleftnavi.jsp?screen=news" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->

<form action="" method="post">
<p>Change your location
  <p>Country: 
    <select name="country" onChange="MM_jumpMenu('parent',this,1)">
      <%
      		LocationUtil locationUtil = (LocationUtil)session.getServletContext().getAttribute("locationUtil");
			SortedMap  countryMap =locationUtil.getCountryMap();
			Iterator iterator = countryMap.keySet().iterator();
			Object key;
			Object value;
			while(iterator.hasNext()){
				  key   = iterator.next();
				  value = countryMap.get(key);

	%>
      <option <%=(key.equals(countryCode)?"selected":"") %> value="articlecategorylocation.jsp?countryCode=<%=key%>"><%=value%></option>
     <%

			}

	%>
    </select>
    <br/>
<%if(countryCode!=null){


%>
Region/Province:  
<select name="region" id="region">
  <%
	  LocationBean tempBean;
	  	Location tempLocation;
	  	String regionName;
		while (LocationRecordset_hasData) {
				tempLocation = new Location();
	
				tempLocation.region = (String)(((LocationRecordset.getObject("region")!=null)?LocationRecordset.getObject("region"):""));
				tempLocation.countryCode = countryCode;
				tempBean = new LocationBean(tempLocation);
				regionName = tempBean.getRegionName();
				if(regionName!=null && regionName.length()>0){
		%>
  				<option <%=(tempLocation.region.equals(regionCode)?"selected":"") %>  value="<%=((LocationRecordset.getObject("location_id")!=null)?LocationRecordset.getObject("location_id"):"")%>:<%=tempLocation.region%>"><%=regionName%></option>
 		 <%
				}
  				LocationRecordset_hasData = LocationRecordset.next();
		}
LocationRecordset.close();
LocationRecordset = StatementLocationRecordset.executeQuery();
LocationRecordset_hasData = LocationRecordset.next();
LocationRecordset_isEmpty = !LocationRecordset_hasData;
%>
</select>
<%}%>
  </p>
  <%=locationid%>
  <p>
    <input type="submit" name="Submit" value="Submit"> 
  </p>
</form>

<!-- InstanceEndEditable --></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td height="84">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table></td>
  </tr>
</table>

</body>
<!-- InstanceEnd --></html>
<%
LocationRecordset.close();
StatementLocationRecordset.close();
ConnLocationRecordset.close();
%>
