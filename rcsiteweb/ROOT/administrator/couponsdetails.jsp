<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
String Coupons__MMColParam = "1";
if (request.getParameter("CODE") !=null) {Coupons__MMColParam = (String)request.getParameter("CODE");}
%>

<%
//Driver DriverCoupons = (Driver)Class.forName(MM_RevCrea_DRIVER).newInstance();
//Connection ConnCoupons = DriverManager.getConnection(MM_RevCrea_STRING,MM_RevCrea_USERNAME,MM_RevCrea_PASSWORD);
Connection ConnCoupons = rcsiteDS.getConnection();
PreparedStatement StatementCoupons = ConnCoupons.prepareStatement("SELECT * FROM coupons WHERE CODE = '" + Coupons__MMColParam + "'  ORDER BY CODE ASC");
ResultSet Coupons = StatementCoupons.executeQuery();
boolean Coupons_isEmpty = !Coupons.next();
boolean Coupons_hasData = !Coupons_isEmpty;
Object Coupons_data;
int Coupons_numRows = 0;
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
            <jsp:include page="adminleftnavi.jsp?screen=rcmerchant" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
	<br/>	<br/>	<br/>
  <table align="center" border="1">
    <tr>
    <td colspan="2" align="left" class="title">Coupon Code Details</td>
    </tr>
  <tr>
    <td width="50%" align="left" class="title">CODE</td>
    <td align="left" width="50%"><%=(((Coupons_data = Coupons.getObject("CODE"))==null || Coupons.wasNull())?"":Coupons_data)%></td>
  </tr>
  <tr>
    <td width="50%" align="left" class="title">AMOUNT</td>
    <td align="left" width="50%"><%=(((Coupons_data = Coupons.getObject("AMOUNT"))==null || Coupons.wasNull())?"":Coupons_data)%></td>
  </tr>
  <tr>
    <td width="50%" align="left" class="title">PERCENT</td>
    <td align="left" width="50%"><%=(((Coupons_data = Coupons.getObject("PERCENT"))==null || Coupons.wasNull())?"":Coupons_data)%></td>
  </tr>
  <tr>
    <td width="50%" align="left" class="title">PRODUCTS</td>
    <td align="left" width="50%"><%=(((Coupons_data = Coupons.getObject("PRODUCTS"))==null || Coupons.wasNull())?"":Coupons_data)%></td>
  </tr>
  <tr>
    <td width="50%" align="left" class="title">NOTES</td>
    <td align="left" width="50%"><%=(((Coupons_data = Coupons.getObject("NOTES"))==null || Coupons.wasNull())?"":Coupons_data)%></td>
  </tr>
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
Coupons.close();
StatementCoupons.close();
ConnCoupons.close();
%>

