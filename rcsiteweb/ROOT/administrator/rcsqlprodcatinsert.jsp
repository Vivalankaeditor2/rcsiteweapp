<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%
//Driver DriverProdxcatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnProdxcatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnProdxcatRecordset = rcsiteDS.getConnection();
PreparedStatement StatementProdxcatRecordset = ConnProdxcatRecordset.prepareStatement("SELECT * FROM prodxcat");
ResultSet ProdxcatRecordset = StatementProdxcatRecordset.executeQuery();
boolean ProdxcatRecordset_isEmpty = !ProdxcatRecordset.next();
boolean ProdxcatRecordset_hasData = !ProdxcatRecordset_isEmpty;
Object ProdxcatRecordset_data;
int ProdxcatRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
ProdxcatRecordset_numRows += Repeat1__numRows;
%>
<%
String sqlString1 ="";

%>

<html lang="en">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td>line_id</td>
    <td>category_id</td>
    <td>product_id</td>
    <td>order_</td>
  </tr>
  <% while ((ProdxcatRecordset_hasData)&&(Repeat1__numRows-- != 0)) { 
  	sqlString1= sqlString1+ "insert into prodxcat (line_id, category_id, product_id, order_ ) "
		+"values ("+ProdxcatRecordset.getObject("line_id")+" , "
		+ProdxcatRecordset.getObject("category_id")+" , "
		+ProdxcatRecordset.getObject("product_id")+", "
		+ProdxcatRecordset.getObject("order_")+");"+System.getProperty("line.separator");

  %>
  <tr> 
    <td><%=(((ProdxcatRecordset_data = ProdxcatRecordset.getObject("line_id"))==null || ProdxcatRecordset.wasNull())?"":ProdxcatRecordset_data)%></td>
    <td><%=(((ProdxcatRecordset_data = ProdxcatRecordset.getObject("category_id"))==null || ProdxcatRecordset.wasNull())?"":ProdxcatRecordset_data)%></td>
    <td><%=(((ProdxcatRecordset_data = ProdxcatRecordset.getObject("product_id"))==null || ProdxcatRecordset.wasNull())?"":ProdxcatRecordset_data)%></td>
    <td><%=(((ProdxcatRecordset_data = ProdxcatRecordset.getObject("order_"))==null || ProdxcatRecordset.wasNull())?"":ProdxcatRecordset_data)%></td>
  </tr>
  <%
  Repeat1__index++;
  ProdxcatRecordset_hasData = ProdxcatRecordset.next();
}
%>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><textarea name="textarea" cols="75" rows="25"><%=sqlString1%></textarea></td>
  </tr>
</table>
</body>
</html>
<%
ProdxcatRecordset.close();
StatementProdxcatRecordset.close();
ConnProdxcatRecordset.close();
%>
