<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%
//Driver DriverOptionRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnOptionRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnOptionRecordset = rcsiteDS.getConnection();
PreparedStatement StatementOptionRecordset = ConnOptionRecordset.prepareStatement("SELECT * FROM product_options");
ResultSet OptionRecordset = StatementOptionRecordset.executeQuery();
boolean OptionRecordset_isEmpty = !OptionRecordset.next();
boolean OptionRecordset_hasData = !OptionRecordset_isEmpty;
Object OptionRecordset_data;
int OptionRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
OptionRecordset_numRows += Repeat1__numRows;
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
    <td>option_id</td>
    <td>attri_id</td>
    <td>order_</td>
    <td>code</td>
    <td>prompt</td>
    <td>price</td>
    <td>cost</td>
    <td>image</td>
  </tr>
  <% while ((OptionRecordset_hasData)&&(Repeat1__numRows-- != 0)) { 
  
  	sqlString1= sqlString1+ "insert into product_options (option_id, attri_id, order_, code, prompt, price, cost, image  ) "
		+"values ("+OptionRecordset.getInt("option_id")+" , "
		+OptionRecordset.getInt("attri_id")+" , "
		+OptionRecordset.getInt("order_")+", "
	 	+"'"	+(String)OptionRecordset.getObject("code")+"' , "
	 	+"'"	+(String)OptionRecordset.getObject("prompt")+"', "
	 	+OptionRecordset.getFloat("price")+", "
	 	+OptionRecordset.getFloat("cost")+" , "
		+"'"  +(String)OptionRecordset.getObject("image")+"');"+System.getProperty("line.separator");
  %>
  <tr> 
    <td><%=(((OptionRecordset_data = OptionRecordset.getObject("option_id"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%></td>
    <td><%=(((OptionRecordset_data = OptionRecordset.getObject("attri_id"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%></td>
    <td><%=(((OptionRecordset_data = OptionRecordset.getObject("order_"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%></td>
    <td><%=(((OptionRecordset_data = OptionRecordset.getObject("code"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%></td>
    <td><%=(((OptionRecordset_data = OptionRecordset.getObject("prompt"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%></td>
    <td><%=(((OptionRecordset_data = OptionRecordset.getObject("price"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%></td>
    <td><%=(((OptionRecordset_data = OptionRecordset.getObject("cost"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%></td>
    <td><%=(((OptionRecordset_data = OptionRecordset.getObject("image"))==null || OptionRecordset.wasNull())?"":OptionRecordset_data)%></td>
  </tr>
  <%
  Repeat1__index++;
  OptionRecordset_hasData = OptionRecordset.next();
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
OptionRecordset.close();
StatementOptionRecordset.close();
ConnOptionRecordset.close();
%>
