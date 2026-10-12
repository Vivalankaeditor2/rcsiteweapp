<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>

<%
String ProductRecordset__MMColParam = "1";
if (request.getParameter("product_id") !=null) {ProductRecordset__MMColParam = (String)request.getParameter("product_id");}
%>
<%
Connection ConnProductRecordset = rcsiteDS.getConnection();
PreparedStatement StatementProductRecordset = ConnProductRecordset.prepareStatement("SELECT * FROM products WHERE product_id = '" + ProductRecordset__MMColParam + "'");
ResultSet ProductRecordset = StatementProductRecordset.executeQuery();
boolean ProductRecordset_isEmpty = !ProductRecordset.next();
boolean ProductRecordset_hasData = !ProductRecordset_isEmpty;
Object ProductRecordset_data;
int ProductRecordset_numRows = 0;
%>
<table class="rcadmin_list_table" width="100%" cellpadding="0" cellspacing="0" >
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="4" bgcolor="#999999"><font color="#FFFFFF"><strong><%=(((ProductRecordset_data = ProductRecordset.getObject("name"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></strong></font></td>
  </tr>
  <tr align="center" bgcolor="#CCCCCC"> 
    <td width="25%"><a href="rcproductupdate.jsp?product_id=<%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>">Product 
      Details</a></td>
    <td width="25%" bgcolor="#CCCCCC"><a href="rcattributeinsert.jsp?product_id=<%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>&product_name=<%=(((ProductRecordset_data = ProductRecordset.getObject("name"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>"> 
      Attributes</a></td>
    <td width="25%"><a href="rcoptioninsert.jsp?prod_id=<%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>">Options</a></td>
    <td width="25%"><a href="rcaddtocategory.jsp?store=<%=(((ProductRecordset_data = ProductRecordset.getObject("store"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>&product_id=<%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>&product_name=<%=(((ProductRecordset_data = ProductRecordset.getObject("name"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>&product_id=<%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>&product_name=<%=(((ProductRecordset_data = ProductRecordset.getObject("name"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>">Categories</a></td>
  </tr>
</table>

<%
ProductRecordset.close();
StatementProductRecordset.close();
ConnProductRecordset.close();
%>