<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
//Driver DriverAttributeRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnAttributeRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnAttributeRecordset  = rcsiteDS.getConnection();
PreparedStatement StatementAttributeRecordset = ConnAttributeRecordset.prepareStatement("SELECT * FROM product_attributes");
ResultSet AttributeRecordset = StatementAttributeRecordset.executeQuery();
boolean AttributeRecordset_isEmpty = !AttributeRecordset.next();
boolean AttributeRecordset_hasData = !AttributeRecordset_isEmpty;
Object AttributeRecordset_data;
int AttributeRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 100;
int Repeat1__index = 0;
AttributeRecordset_numRows += Repeat1__numRows;
%>

<html lang="en">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td>attribute_id</td>
    <td>prod_id</td>
    <td>default_code</td>
    <td>order_</td>
    <td>code</td>
    <td>type</td>
    <td>attemp_id</td>
    <td>prompt</td>
    <td>price</td>
    <td>cost</td>
    <td>required</td>
    <td>image</td>
  </tr>
  <% while ((AttributeRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr> 
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("attribute_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("prod_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("default_code"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("order_"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("code"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("type"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("attemp_id"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("prompt"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("price"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("cost"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("required"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
    <td><%=(((AttributeRecordset_data = AttributeRecordset.getObject("image"))==null || AttributeRecordset.wasNull())?"":AttributeRecordset_data)%></td>
  </tr>
  <%
  Repeat1__index++;
  AttributeRecordset_hasData = AttributeRecordset.next();
}
%>
</table>

</body>
</html>
<%
AttributeRecordset.close();
StatementAttributeRecordset.close();
ConnAttributeRecordset.close();
%>
