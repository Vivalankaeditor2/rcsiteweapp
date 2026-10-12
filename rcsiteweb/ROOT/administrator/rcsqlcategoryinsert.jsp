<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
//Driver DriverCategoryRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCategoryRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCategoryRecordset  = rcsiteDS.getConnection();
PreparedStatement StatementCategoryRecordset = ConnCategoryRecordset.prepareStatement("SELECT * FROM product_categories");
ResultSet CategoryRecordset = StatementCategoryRecordset.executeQuery();
boolean CategoryRecordset_isEmpty = !CategoryRecordset.next();
boolean CategoryRecordset_hasData = !CategoryRecordset_isEmpty;
Object CategoryRecordset_data;
int CategoryRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
CategoryRecordset_numRows += Repeat1__numRows;
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
    <td>category_id</td>
    <td>parent_id</td>
    <td>agrpcount</td>
    <td>order_</td>
    <td>code</td>
    <td>name</td>
    <td>active</td>
    <td>store</td>
  </tr>
  <% while ((CategoryRecordset_hasData)&&(Repeat1__numRows-- != 0)) { 
    	sqlString1= sqlString1+ "insert into product_categories (category_id, parent_id, agrpcount, order_, code, name, active, store ) "
		+"values ("+CategoryRecordset.getInt("category_id")+" , "
		+CategoryRecordset.getInt("parent_id")+" , "
		+CategoryRecordset.getInt("agrpcount")+", "
		+CategoryRecordset.getInt("order_")+", "
	 	+"'"	+(String)CategoryRecordset.getObject("code")+"' , "
	 	+"'"	+(String)CategoryRecordset.getObject("name")+"', "
	 	+CategoryRecordset.getInt("active")+", "
		+"'"  +(String)CategoryRecordset.getObject("store")+"');"+System.getProperty("line.separator");
  %>
  <tr> 
    <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("category_id"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
    <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("parent_id"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
    <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("agrpcount"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
    <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("order_"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
    <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("code"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
    <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("name"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
    <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("active"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
    <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("store"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
  </tr>
  <%
  Repeat1__index++;
  CategoryRecordset_hasData = CategoryRecordset.next();
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
CategoryRecordset.close();
StatementCategoryRecordset.close();
ConnCategoryRecordset.close();
%>
