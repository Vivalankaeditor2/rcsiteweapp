<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
//Driver DriverDirCatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnDirCatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnDirCatRecordset = rcsiteDS.getConnection();
PreparedStatement StatementDirCatRecordset = ConnDirCatRecordset.prepareStatement("SELECT * FROM rc_category ORDER BY entry_date DESC");
ResultSet DirCatRecordset = StatementDirCatRecordset.executeQuery();
boolean DirCatRecordset_isEmpty = !DirCatRecordset.next();
boolean DirCatRecordset_hasData = !DirCatRecordset_isEmpty;
Object DirCatRecordset_data;
int DirCatRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
DirCatRecordset_numRows += Repeat1__numRows;
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Web Directory Categories</title>
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
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
            <jsp:include page="adminleftnavi.jsp?screen=directory" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
            <table border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF" class="text">
              <tr> 
                <td width="150">&nbsp;</td>
                <td width="168">&nbsp;</td>
                <td width="165">&nbsp;</td>
              </tr>
              <tr> 
                <td colspan="3"><strong>Web Directory Categories</strong></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr class="title"> 
                <td height="14"><strong>Category Id</strong></td>
                <td><strong>Category Name</strong></td>
                <td><strong>Aproval Status</strong></td>
              </tr>
              <% while ((DirCatRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <tr <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"C8E4FF\" ");}%>> 
                <td><%=(((DirCatRecordset_data = DirCatRecordset.getObject("category_id"))==null || DirCatRecordset.wasNull())?"":DirCatRecordset_data)%></td>
                <td><a href="updatecategory.jsp?category_id=<%=(((DirCatRecordset_data = DirCatRecordset.getObject("category_id"))==null || DirCatRecordset.wasNull())?"":DirCatRecordset_data)%>"><%=(((DirCatRecordset_data = DirCatRecordset.getObject("category_name"))==null || DirCatRecordset.wasNull())?"":DirCatRecordset_data)%></a></td>
                <td><%=(((DirCatRecordset_data = DirCatRecordset.getObject("aproval_status"))==null || DirCatRecordset.wasNull())?"":DirCatRecordset_data)%></td>
              </tr>
              <%
  Repeat1__index++;
  DirCatRecordset_hasData = DirCatRecordset.next();
}
%>
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
DirCatRecordset.close();
StatementDirCatRecordset.close();
ConnDirCatRecordset.close();
%>
