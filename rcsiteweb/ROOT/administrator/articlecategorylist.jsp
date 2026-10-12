<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%

String ArtCatListRecordset__MMColParam = "main";
if (request.getParameter("level") !=null) {ArtCatListRecordset__MMColParam = (String)request.getParameter("level");}
%>
<%
//Driver DriverArtCatListRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnArtCatListRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnArtCatListRecordset = rcsiteDS.getConnection();
PreparedStatement StatementArtCatListRecordset = ConnArtCatListRecordset.prepareStatement("SELECT * FROM article_category WHERE level <> '" + ArtCatListRecordset__MMColParam + "' AND level <> 'hidden' ORDER BY categoryid ASC");
ResultSet ArtCatListRecordset = StatementArtCatListRecordset.executeQuery();
boolean ArtCatListRecordset_isEmpty = !ArtCatListRecordset.next();
boolean ArtCatListRecordset_hasData = !ArtCatListRecordset_isEmpty;
Object ArtCatListRecordset_data;
int ArtCatListRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
ArtCatListRecordset_numRows += Repeat1__numRows;
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
              <jsp:include page="adminleftnavi.jsp?screen=article" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
            <table width="100%" border="0" cellpadding="0" cellspacing="1" class="text">
              <tr> 
                <td>&nbsp;</td>
				<td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td width="80">&nbsp;</td>
                <td width="80">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
				<td ><strong>category ID</strong></td>
                <td nowrap><strong>category name</strong></td>
                <td><strong>title</strong></td>
                <td><strong>level</strong></td>
                <td width="80"><strong>priority</strong></td>
                <td width="80"><strong>active</strong></td>
                <td>&nbsp;</td>
              </tr>
              <% while ((ArtCatListRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <tr <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"C8E4FF\" ");}%>  > 
                <td><%=Repeat1__index+1%></td>
				 <td><%=(((ArtCatListRecordset_data = ArtCatListRecordset.getObject("categoryid"))==null || ArtCatListRecordset.wasNull())?"":ArtCatListRecordset_data)%></td>
                <td><%=(((ArtCatListRecordset_data = ArtCatListRecordset.getObject("category_name"))==null || ArtCatListRecordset.wasNull())?"":ArtCatListRecordset_data)%></td>
                <td><%=(((ArtCatListRecordset_data = ArtCatListRecordset.getObject("title"))==null || ArtCatListRecordset.wasNull())?"":ArtCatListRecordset_data)%></td>
                <td><%=(((ArtCatListRecordset_data = ArtCatListRecordset.getObject("level"))==null || ArtCatListRecordset.wasNull())?"":ArtCatListRecordset_data)%></td>
                <td width="80"><%=(((ArtCatListRecordset_data = ArtCatListRecordset.getObject("priority"))==null || ArtCatListRecordset.wasNull())?"":ArtCatListRecordset_data)%></td>
                <td width="80"><%=(((ArtCatListRecordset_data = ArtCatListRecordset.getObject("active"))==null || ArtCatListRecordset.wasNull())?"":ArtCatListRecordset_data)%></td>
                <td><a href="articleupdatecategory.jsp?categoryid=<%=(((ArtCatListRecordset_data = ArtCatListRecordset.getObject("categoryid"))==null || ArtCatListRecordset.wasNull())?"":ArtCatListRecordset_data)%>">Edit</a></td>
              </tr>
              <%
  Repeat1__index++;
  ArtCatListRecordset_hasData = ArtCatListRecordset.next();
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
ArtCatListRecordset.close();
StatementArtCatListRecordset.close();
ConnArtCatListRecordset.close();
%>
