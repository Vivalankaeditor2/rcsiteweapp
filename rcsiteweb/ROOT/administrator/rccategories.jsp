<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
String CategoryRecordset__MMColParam =(String)session.getValue("store");
if (request.getParameter("store") !=null) {CategoryRecordset__MMColParam = (String)request.getParameter("store");}

%>
<%
//Driver DriverCategoryRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCategoryRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCategoryRecordset  = rcsiteDS.getConnection();
PreparedStatement StatementCategoryRecordset = ConnCategoryRecordset.prepareStatement("SELECT * FROM product_categories WHERE store = '" + CategoryRecordset__MMColParam + "' ORDER BY order_ ASC");
ResultSet CategoryRecordset = StatementCategoryRecordset.executeQuery();
boolean CategoryRecordset_isEmpty = !CategoryRecordset.next();
boolean CategoryRecordset_hasData = !CategoryRecordset_isEmpty;
Object CategoryRecordset_data;
int CategoryRecordset_numRows = 0;
%>
<%
int Repeat1__numRows =100;
int Repeat1__index = 0;
CategoryRecordset_numRows += Repeat1__numRows;
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
            <jsp:include page="adminleftnavi.jsp?screen=rcmerchant" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
		 <%
  	Random rnp = new Random();
	String newId = ""+Math.abs(rnp.nextInt());
	
  %>
            <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td height="22" colspan="4"><strong>Product Categories</strong></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td colspan="2"><strong><%=(String)session.getValue("countryLong")%></strong></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr valign="top" bgcolor="#999999"> 
                <td><strong><font color="#FFFFFF">Category Id</font></strong></td>
                <td><strong><font color="#FFFFFF">Parent Id</font></strong></td>
                <td><strong><font color="#FFFFFF">Order</font></strong></td>
                <td><strong><font color="#FFFFFF">Code</font></strong></td>
                <td><strong><font color="#FFFFFF">Name</font></strong></td>
                <td><strong><font color="#FFFFFF">Active</font></strong></td>
                <td><strong><font color="#FFFFFF">Store</font></strong></td>
                <td><strong><font color="#FFFFFF">Edit</font></strong></td>
                <td><strong><font color="#FFFFFF">Delete</font></strong></td>
              </tr>
              <% while ((CategoryRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <tr valign="top" <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"CCCCCC\" ");}%>> 
                <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("category_id"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
                <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("parent_id"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
                <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("order_"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
                <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("code"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
                <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("name"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
                <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("active"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
                <td><%=(((CategoryRecordset_data = CategoryRecordset.getObject("store"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%></td>
                <td><a href="rccategoryupdate.jsp?category_id=<%=(((CategoryRecordset_data = CategoryRecordset.getObject("category_id"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>">Edit</a></td>
                <td><a href="rccategorydelete.jsp?category_id=<%=(((CategoryRecordset_data = CategoryRecordset.getObject("category_id"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>">Delete</a></td>
              </tr>
              <%
  Repeat1__index++;
  CategoryRecordset_hasData = CategoryRecordset.next();
}
%>
            </table>
<form method="post" action="rccategoryinsert.jsp" name="form1">
              <table align="left">
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td colspan="2" align="left" nowrap><strong>Add new category</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Category id:</td>
                  <td><%=newId%>
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Parent id:</td>
                  <td> <input type="text" name="parent_id" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Order:</td>
                  <td> <input type="text" name="order_" value="" size="32"> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Code:</td>
                  <td> <input type="text" name="code" value="" size="32"> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Name:</td>
                  <td> <input type="text" name="name" value="" size="32"> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Active:</td>
                  <td> <input type="checkbox" name="active" value=1 > </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Store:</td>
                  <td> <input type="text" name="store" value="<%=(String)session.getValue("store")%>" size="32"> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td> <input type="submit" value="Insert Record"> </td>
                </tr>
              </table>
<input type="hidden" name="category_id" value="<%=newId%>" size="32"> 
  <input type="hidden" name="agrpcount" value="" size="32">
  <input type="hidden" name="MM_insert" value="form1">
</form>
<p>&nbsp;</p>
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
CategoryRecordset.close();
StatementCategoryRecordset.close();
ConnCategoryRecordset.close();
%>
