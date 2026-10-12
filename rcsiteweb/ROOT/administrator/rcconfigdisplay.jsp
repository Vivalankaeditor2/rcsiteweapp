<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

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
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
    <td width="4%">&nbsp;</td>
    <td width="27%">&nbsp;</td>
    <td width="69%">&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td colspan="2"><strong>Configuration Summary for <%=session.getValue("countryLong")%></strong></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Country</td>
    <td><%=session.getValue("countryLong")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Country Code</td>
    <td><%=session.getValue("countryShort")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Currency Symbol</td>
    <td><%=session.getValue("currencySymbol")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Currency Code</td>
    <td><%=session.getValue("currencyCode")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Weight Unit</td>
    <td><%=session.getValue("weightUnit")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Shipping Method</td>
    <td><%=session.getValue("shippingMethod")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Packaging</td>
    <td><%=session.getValue("currencySymbol")%><%=session.getValue("packaging")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Shipping Rate</td>
    <td><%=session.getValue("shipping")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Payment Method</td>
    <td><%=session.getValue("payMethod")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
                <td nowrap>Tax Rate</td>
    <td><%=session.getValue("taxRate")%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
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
