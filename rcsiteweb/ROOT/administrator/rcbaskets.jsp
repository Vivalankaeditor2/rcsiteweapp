<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String OrderRecordset__MMColParam = "1";
if (request.getParameter("order_id") !=null) {OrderRecordset__MMColParam = (String)request.getParameter("order_id");}
%>
<%
//Driver DriverOrderRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnOrderRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnOrderRecordset  = rcsiteDS.getConnection();
PreparedStatement StatementOrderRecordset = ConnOrderRecordset.prepareStatement("SELECT * FROM orders ");//WHERE order_id = " + OrderRecordset__MMColParam + "");
ResultSet OrderRecordset = StatementOrderRecordset.executeQuery();
boolean OrderRecordset_isEmpty = !OrderRecordset.next();
boolean OrderRecordset_hasData = !OrderRecordset_isEmpty;
Object OrderRecordset_data;
int OrderRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 1000;
int Repeat1__index = 0;
OrderRecordset_numRows += Repeat1__numRows;
%>

<html lang="en">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
<table border="1" cellpadding="0" cellspacing="0">
  <tr> 
    <td>order_id</td>
    <td>batch_id</td>
    <td>processed</td>
    <td>date</td>
    <td>login</td>
    <td>ship_fname</td>
    <td>ship_lname</td>
    <td>ship_email</td>
    <td>ship_comp</td>
    <td>ship_phone</td>
    <td>ship_fax</td>
    <td>ship_addr</td>
    <td>ship_city</td>
    <td>ship_state</td>
    <td>ship_zip</td>
    <td>ship_cntry</td>
    <td>bill_fname</td>
    <td>bill_lname</td>
    <td>bill_email</td>
    <td>bill_comp</td>
    <td>bill_phone</td>
    <td>bill_fax</td>
    <td>bill_addr</td>
    <td>bill_city</td>
    <td>bill_state</td>
    <td>bill_zip</td>
    <td>bill_cntry</td>
    <td>tax</td>
    <td>shipping</td>
    <td>ship_id</td>
    <td>ship_data</td>
    <td>pay_id</td>
    <td>pay_data</td>
    <td>affil_code</td>
    <td>total</td>
    <td>pay_sectyp</td>
    <td>pay_seckey</td>
    <td>pay_secdat</td>
    <td>store</td>
    <td>store2</td>
  </tr>
  <% while ((OrderRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr> 
    <td><a href="rcorderdetails.jsp?order_id=<%=(((OrderRecordset_data = OrderRecordset.getObject("order_id"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%>"><%=(((OrderRecordset_data = OrderRecordset.getObject("order_id"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></a></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("batch_id"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("processed"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("date"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("login"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_fname"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_lname"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_email"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_comp"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_phone"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_fax"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_addr"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_city"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_state"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_zip"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_cntry"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_fname"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_lname"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_email"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_comp"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_phone"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_fax"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_addr"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_city"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_state"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_zip"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("bill_cntry"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("tax"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("shipping"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_id"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("ship_data"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_id"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_data"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("affil_code"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("total"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_sectyp"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_seckey"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("pay_secdat"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("store"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
    <td><%=(((OrderRecordset_data = OrderRecordset.getObject("store2"))==null || OrderRecordset.wasNull())?"":OrderRecordset_data)%></td>
  </tr>
  <%
  Repeat1__index++;
  OrderRecordset_hasData = OrderRecordset.next();
}
%>
</table>

</body>
</html>
<%
OrderRecordset.close();
StatementOrderRecordset.close();
ConnOrderRecordset.close();
%>
