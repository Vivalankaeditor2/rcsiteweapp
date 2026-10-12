<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String ItemRecordset__MMColParam = "1";
if (request.getParameter("order_id") !=null) {ItemRecordset__MMColParam = (String)request.getParameter("order_id");}
%>
<%
//Driver DriverItemRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnItemRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnItemRecordset = rcsiteDS.getConnection();
PreparedStatement StatementItemRecordset = ConnItemRecordset.prepareStatement("SELECT * FROM order_items ORDER BY order_id DESC ");// WHERE order_id = " + ItemRecordset__MMColParam + "");
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

<html lang="en">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
<table border="1" cellpadding="0" cellspacing="0">
  <tr> 
    <td>line_id</td>
    <td>order_id</td>
    <td>product_id</td>
    <td>code</td>
    <td>name</td>
    <td>price</td>
    <td>weight</td>
    <td>taxable</td>
    <td>upsold</td>
    <td>quantity</td>
    <td>attri_id</td>
    <td>attri_code</td>
    <td>attri_prompt</td>
    <td>opt_id</td>
    <td>opt_code</td>
    <td>opt_prompt</td>
    <td>opt_price</td>
    <td>data</td>
    <td>data_long</td>
    <td>store</td>
  </tr>
  <% while ((ItemRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr> 
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("line_id"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("order_id"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("product_id"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("code"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("name"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("price"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("weight"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("taxable"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("upsold"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("quantity"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("attri_id"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("attri_code"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("attri_prompt"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("opt_id"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("opt_code"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("opt_prompt"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("opt_price"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("data"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("data_long"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
    <td><%=(((ItemRecordset_data = ItemRecordset.getObject("store"))==null || ItemRecordset.wasNull())?"":ItemRecordset_data)%></td>
  </tr>
  <%
  Repeat1__index++;
  ItemRecordset_hasData = ItemRecordset.next();
}
%>
</table>

</body>
</html>
<%
ItemRecordset.close();
StatementItemRecordset.close();
ConnItemRecordset.close();
%>
