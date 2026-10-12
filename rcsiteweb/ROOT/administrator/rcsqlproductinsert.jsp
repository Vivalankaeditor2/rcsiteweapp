<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%
String store = "cnd";
String whereClue="";
if (request.getParameter("store") !=null) {
store= (String)request.getParameter("store");
whereClue=" WHERE store='"+store+"'";
}

%>
<%
//Driver DriverProductRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnProductRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnProductRecordset = rcsiteDS.getConnection();
PreparedStatement StatementProductRecordset = ConnProductRecordset.prepareStatement("SELECT * FROM products" +whereClue+" ORDER BY order_ ASC ");
ResultSet ProductRecordset = StatementProductRecordset.executeQuery();
boolean ProductRecordset_isEmpty = !ProductRecordset.next();
boolean ProductRecordset_hasData = !ProductRecordset_isEmpty;
Object ProductRecordset_data;
int ProductRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
ProductRecordset_numRows += Repeat1__numRows;
%>
<%
String sqlString1 ="";
String sqlString2 =""; 
%>

<html lang="en">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>

<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td><select name="store" id="store">
          <option value="cnd">Canada</option>
          <option value="uk">UK</option>
        </select>
        <input type="submit" name="Submit" value="Go"></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
<table border="0" cellpadding="0" cellspacing="0">
  <tr> 
    product_id, catcount, agrpcount, pgrpcount, order_, code, name, thumbnail, image, price, cost, desc_, weight, payment_type, taxable, active,store
  </tr>
  <% while ((ProductRecordset_hasData)&&(Repeat1__numRows-- != 0)) { 
  
  	sqlString1= sqlString1+ "insert into products (product_id, catcount, agrpcount, pgrpcount, order_, code, name, thumbnail, image, price, cost, desc_, weight, payment_type, taxable, active,store) "
		+"values ("+ProductRecordset.getInt("product_id")+" , "
		+ProductRecordset.getInt("catcount")+" , "
		+ProductRecordset.getInt("agrpcount")+" , "
		 +ProductRecordset.getInt("pgrpcount")+" , "
	 	+ProductRecordset.getInt("order_")+" , "
	 	+"'"	+(String)ProductRecordset.getObject("code")+"', "
	 	+"'"+(String)ProductRecordset.getObject("name")+"' , "
	 	+"'"+(String)ProductRecordset.getObject("thumbnail")+"' , "
	 	+"'"+(String)ProductRecordset.getObject("image")+"' , "
	 	+ProductRecordset.getFloat("price")+" , "
	 	+ProductRecordset.getFloat("cost")+	 " , "
		+"'"+(String)ProductRecordset.getObject("desc_")+ "' , "
		+ProductRecordset.getFloat("weight")+" , "
		+"'"+(String)ProductRecordset.getObject("payment_type")+"' , "
		+ProductRecordset.getInt("taxable")+" , "
		+ProductRecordset.getInt("active")+" , "
		+"'"+(String)ProductRecordset.getObject("store")+"');"+System.getProperty("line.separator");

  %>
  <tr valign="top"> 
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("catcount"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("agrpcount"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("pgrpcount"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("order_"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("code"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("name"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("thumbnail"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("image"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("price"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("cost"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("desc_"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("weight"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("payment_type"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("taxable"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("active"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
    <td><%=(((ProductRecordset_data = ProductRecordset.getObject("store"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
  </tr>
  <%
  Repeat1__index++;
  ProductRecordset_hasData = ProductRecordset.next();
}
%>
</table>

<p>&nbsp;</p><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>dsfg</td>
  </tr>
  <tr>
    <td>
<textarea name="textarea" cols="75" rows="25"> <%=sqlString1%></textarea></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
</html>
<%
ProductRecordset.close();
StatementProductRecordset.close();
ConnProductRecordset.close();
%>
