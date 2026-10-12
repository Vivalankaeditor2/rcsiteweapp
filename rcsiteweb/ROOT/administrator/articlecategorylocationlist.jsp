<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*,com.rev_creations.rcsite.*,com.maxmind.geoip.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String RecordsetLocationCategory__MMColParam = "2";
if (request.getParameter("location_id") !=null) {RecordsetLocationCategory__MMColParam = (String)request.getParameter("location_id");}
%>
<%
//Driver DriverRecordsetLocationCategory = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
Connection ConnRecordsetLocationCategory = rcsiteDS.getConnection(); //DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
PreparedStatement StatementRecordsetLocationCategory = ConnRecordsetLocationCategory.prepareStatement("SELECT * FROM location_article_category l left join (article_category c, geo_location g) on (l.category_id = c.categoryid and l.location_id = g.location_id ) WHERE parentid = " + RecordsetLocationCategory__MMColParam + "");
ResultSet RecordsetLocationCategory = StatementRecordsetLocationCategory.executeQuery();
boolean RecordsetLocationCategory_isEmpty = !RecordsetLocationCategory.next();
boolean RecordsetLocationCategory_hasData = !RecordsetLocationCategory_isEmpty;
Object RecordsetLocationCategory_data;
int RecordsetLocationCategory_numRows = 0;
%>
<%
int Repeat1__numRows = 100;
int Repeat1__index = 0;
RecordsetLocationCategory_numRows += Repeat1__numRows;
%>

<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
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

<table border="1" cellpadding="1" cellspacing="1">
  <tr>
   
    <td>Country</td>
    <td>Region</td>
	 <td>Article Category </td>
  </tr>
  <% 
    LocationBean tempBean;
	  	Location tempLocation;
	  	String regionName;
  while ((RecordsetLocationCategory_hasData)&&(Repeat1__numRows-- != 0)) { 
  
  				tempLocation = new Location();
	
				tempLocation.region = (String)((( RecordsetLocationCategory.getObject("g.region")!=null)? RecordsetLocationCategory.getObject("g.region"):""));
				tempLocation.countryCode =  (String)((( RecordsetLocationCategory.getObject("g.country")!=null)? RecordsetLocationCategory.getObject("g.country"):""));
				tempBean = new LocationBean(tempLocation);
				regionName = tempBean.getRegionName();
				%>
  <tr>
    <td><%=(((RecordsetLocationCategory_data = RecordsetLocationCategory.getObject("g.country"))==null || RecordsetLocationCategory.wasNull())?"":RecordsetLocationCategory_data)%></td>
    <td><%=(((RecordsetLocationCategory_data = regionName)==null)?"Country":RecordsetLocationCategory_data)%></td>
	 <td><%=(((RecordsetLocationCategory_data = RecordsetLocationCategory.getObject("c.title"))==null || RecordsetLocationCategory.wasNull())?"":RecordsetLocationCategory_data)%></td>
  </tr>
  <%
  Repeat1__index++;
  RecordsetLocationCategory_hasData = RecordsetLocationCategory.next();
}
%>
</table>
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
RecordsetLocationCategory.close();
StatementRecordsetLocationCategory.close();
ConnRecordsetLocationCategory.close();
%>
