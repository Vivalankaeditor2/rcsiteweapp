<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.text.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
String OrderRecordset__MMColParam = "1";
if (request.getParameter("order_id") !=null) {OrderRecordset__MMColParam = (String)request.getParameter("order_id");}
%>
<%
String orderNo="Not Paid";
if (request.getParameter("order_no") !=null) {orderNo = (String)request.getParameter("order_no");}
%>
<%
//Driver DriverOrderRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnOrderRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnOrderRecordset = rcsiteDS.getConnection();
PreparedStatement StatementOrderRecordset = ConnOrderRecordset.prepareStatement("SELECT * FROM (order_charges left join orders on order_charges.order_id=orders.order_id) WHERE order_charges.order_id = " + OrderRecordset__MMColParam + " AND order_charges.order_no ='"+orderNo+"' ");
ResultSet OrderRecordset = StatementOrderRecordset.executeQuery();
boolean OrderRecordset_isEmpty = !OrderRecordset.next();
boolean OrderRecordset_hasData = !OrderRecordset_isEmpty;
Object OrderRecordset_data;
int OrderRecordset_numRows = 0;
%>
<%
String ItemRecordset__MMColParam = OrderRecordset__MMColParam;
if (request.getParameter("order_id") !=null) {ItemRecordset__MMColParam = (String)request.getParameter("order_id");}
%>
<%
//Driver DriverItemRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnItemRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnItemRecordset = rcsiteDS.getConnection();
PreparedStatement StatementItemRecordset = ConnItemRecordset.prepareStatement("SELECT line_id, product_id, code, name,  price, SUM(quantity) as qty ,attri_code, opt_code  FROM order_items  WHERE order_id = " + ItemRecordset__MMColParam + " GROUP BY product_id, opt_code");
ResultSet ItemRecordset = StatementItemRecordset.executeQuery();
boolean ItemRecordset_isEmpty = !ItemRecordset.next();
boolean ItemRecordset_hasData = !ItemRecordset_isEmpty;
Object ItemRecordset_data;
int ItemRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
ItemRecordset_numRows += Repeat1__numRows;
%>
<%
float quantity =0;
float price=0;
float subTotal = OrderRecordset.getFloat("total");
float shipping =OrderRecordset.getFloat("shipping");
float tax = OrderRecordset.getFloat("tax");
float grandTotal =subTotal+ shipping+ tax;

NumberFormat nf0= NumberFormat.getNumberInstance();
NumberFormat nf2 = NumberFormat.getNumberInstance();
nf0.setMaximumFractionDigits(0);
nf0.setMinimumFractionDigits(0);
nf2.setMaximumFractionDigits(2);
nf2.setMinimumFractionDigits(2);

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
            <a href="rcorders.jsp"><strong>&lt;&lt;Back</strong></a><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                    <tr bgcolor="#FFFFFF"> 
                      <td align="default">&nbsp;</td>
                      <td align="default">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="default">Order No:</td>
                      <td align="default"><%=orderNo%></td>
                    </tr>
                    <tr> 
                      <td align="default" width="50%">Date</td>
                      <td align="default" width="50%"><%=(((OrderRecordset_data = OrderRecordset.getObject("order_charges.payment_datetime"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
                    </tr>
                  </table></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
        <tr valign="top" bgcolor="#0000FF"> 
          <td width="99" nowrap><font color="#FFFFFF"><strong>Ship To:</strong></font></td>
          <td>&nbsp;</td>
          <td width="4%"><font color="#FFFFFF">&nbsp;</font></td>
          <td width="99" nowrap><font color="#FFFFFF"><strong>Bill To:</strong></font></td>
          <td>&nbsp;</td>
        </tr>
        <tr valign="top"> 
          <td width="99" nowrap><strong>Name:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_fname"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("ship_lname"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> </td>
          <td width="4%">&nbsp;</td>
          <td width="99" nowrap><strong>Name:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_fname"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("bill_lname"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
        <tr valign="top"> 
          <td width="99" nowrap><strong>Email Address:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_email"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
          <td width="4%">&nbsp;</td>
          <td width="99" nowrap><strong>Email Address:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_email"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
        <tr valign="top"> 
          <td width="99" nowrap><strong>Phone Number:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_phone"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
          <td width="4%">&nbsp;</td>
          <td width="99" nowrap><strong>Phone Number:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_phone"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
        <tr valign="top"> 
          <td width="99" nowrap><strong>Fax Number:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_fax"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
          <td width="4%">&nbsp;</td>
          <td width="99" nowrap><strong>Fax Number:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_fax"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
        <tr valign="top"> 
          <td width="99" nowrap><strong>Company:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_comp"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
          <td width="4%">&nbsp;</td>
          <td width="99" nowrap><strong>Company:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_comp"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
        <tr valign="top"> 
          <td width="99" nowrap><strong>Address:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_addr"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("ship_city"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("ship_state"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("ship_zip"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("ship_cntry"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> </td>
          <td width="4%">&nbsp;</td>
          <td width="99" nowrap><strong>Address:</strong></td>
          <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_addr"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("bill_city"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("bill_state"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("bill_zip"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> <%=(((OrderRecordset_data = OrderRecordset.getObject("bill_cntry"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%> </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
        <tr class="text"> 
          <td bgcolor="#0000FF">&nbsp;</td>
          <td bgcolor="#0000FF">&nbsp;</td>
          <td bgcolor="#0000FF"><strong><font color="#FFFFFF">Code</font></strong></td>
          <td bgcolor="#0000FF"><strong><font color="#FFFFFF">Product</font></strong></td>
          <td bgcolor="#0000FF"><strong><font color="#FFFFFF">Quantity</font></strong></td>
          <td align="right" bgcolor="#0000FF"><strong><font color="#FFFFFF">Price/Ea.</font></strong></td>
          <td align="right" bgcolor="#0000FF"><font color="#FFFFFF"><strong>Total</strong></font></td>
        </tr>
        <% while ((ItemRecordset_hasData)&&(Repeat1__numRows-- != 0)) { 
 		price = ItemRecordset.getFloat("price");
 		quantity = ItemRecordset.getFloat("qty");

 
 
  %>
        <tr valign="top"> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><%=(((ItemRecordset_data = ItemRecordset.getObject("code"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
          <td><%=(((ItemRecordset_data = ItemRecordset.getObject("name"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
          <td align="center"><%=nf0.format(quantity)%></td>
          <td align="right"><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_data"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%><%=nf2.format(price)%></td>
          <td align="right"><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_data"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%><%=nf2.format(price*quantity)%></td>
        </tr>
        <tr> 
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp<%=(((ItemRecordset_data = ItemRecordset.getObject("attri_code"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%> <%=(((ItemRecordset_data = ItemRecordset.getObject("opt_code"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
          <td valign="top">&nbsp;</td>
          <td align="right" valign="top">&nbsp;</td>
          <td align="right">&nbsp;</td>
        </tr>
        <%
  Repeat1__index++;
  ItemRecordset_hasData = ItemRecordset.next();
}


%>
        <tr valign="top"> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td></td>
          <td align="right">Shipping:<%=(((OrderRecordset_data = OrderRecordset.getObject("ship_data"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
          <td align="right"><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_data"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%><%=nf2.format(shipping)%></td>
        </tr>
        <tr valign="top"> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td></td>
          <td align="right">Tax:</td>
          <td align="right"><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_data"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%><%=nf2.format(tax)%></td>
        </tr>
        <tr> 
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
          <td valign="top"></td>
          <td align="right" valign="top" bgcolor="#0000FF"><font color="#FFFFFF"><strong>Total:</strong></font></td>
          <td align="right" bgcolor="#0000FF"><strong><font color="#FFFFFF"><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_data"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%><%=nf2.format(grandTotal)%></font></strong></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left">&nbsp;</td>
  </tr>
  <tr> 
    <td align="left">
<table width="50%" border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
        <tr> 
          <td align="default" width="36%">Customer Username:</td>
          <td align="default" width="64%"><%=(((OrderRecordset_data = OrderRecordset.getObject("login"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
        <tr> 
          <td align="default" width="36%">Payment Type:</td>
          <td align="default" width="64%"><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_sectyp"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
        <tr> 
          <td align="default" width="36%">Store:</td>
          <td align="default" width="64%"><%=(((OrderRecordset_data = OrderRecordset.getObject("store"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
        <tr> 
          <td align="default" width="36%">Consultant:</td>
          <td align="default" width="64%"><%=(((OrderRecordset_data = OrderRecordset.getObject("store2"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
        </tr>
      </table></td>
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
OrderRecordset.close();
StatementOrderRecordset.close();
ConnOrderRecordset.close();
%>
<%
ItemRecordset.close();
StatementItemRecordset.close();
ConnItemRecordset.close();
%>
