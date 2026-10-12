<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String singleAddress = null;
if (request.getParameter("singleaddress") !=null) {singleAddress = (String)request.getParameter("singleaddress");}

%>
<%
String EmailRecordset__MMColParam = "template";
if (request.getParameter("folder") !=null) {EmailRecordset__MMColParam = (String)request.getParameter("folder");}
%>
<%
Connection ConnEmailRecordset = rcsiteDS.getConnection();
PreparedStatement StatementEmailRecordset = ConnEmailRecordset.prepareStatement("SELECT emailid, subject, folder FROM email WHERE (folder = '" + EmailRecordset__MMColParam + "' Or folder ='save') AND user='"+(String)session.getValue("dcode")+"' ORDER BY folder ASC");
ResultSet EmailRecordset = StatementEmailRecordset.executeQuery();
boolean EmailRecordset_isEmpty = !EmailRecordset.next();
boolean EmailRecordset_hasData = !EmailRecordset_isEmpty;
Object EmailRecordset_data;
int EmailRecordset_numRows = 0;
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<TITLE>Herbalife Independent Distributor.</TITLE>
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
              <jsp:include page="adminleftnavi.jsp" flush="true" />
              <!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<form name="form1" method="post" action="emailcompose.jsp">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr> 
              <td width="10%">&nbsp;</td>
              <td width="17%">&nbsp;</td>
              <td width="73%">&nbsp;</td>
            </tr>
            <tr> 
              <td>&nbsp;</td>
              <td class="text">&nbsp;</td>
              <td class="text">&nbsp;</td>
            </tr>
            <tr> 
              <td>&nbsp;</td>
              <td class="text"><strong>To:</strong></td>
              <td class="text"><%=singleAddress%></td>
            </tr>
            <tr> 
              <td>&nbsp;</td>
              <td nowrap class="text"><strong>Select an email:</strong></td>
              <td class="text"> <select name="emailid" id="emailid">
                  <option value="1">New Email</option>
                  <%
while (EmailRecordset_hasData) {
%>
                  <option value="<%=((EmailRecordset.getObject("emailid")!=null)?EmailRecordset.getObject("emailid"):"")%>"><%=((EmailRecordset.getObject("folder")!=null)?EmailRecordset.getObject("folder"):"")%>: 
                  <%=((EmailRecordset.getObject("subject")!=null)?EmailRecordset.getObject("subject"):"")%></option>
                  <%
  EmailRecordset_hasData = EmailRecordset.next();
}
EmailRecordset.close();
EmailRecordset = StatementEmailRecordset.executeQuery();
EmailRecordset_hasData = EmailRecordset.next();
EmailRecordset_isEmpty = !EmailRecordset_hasData;
%>
                </select> <input type="submit" name="Submit" value="Continue"></td>
            </tr>
            <tr> 
              <td>&nbsp;</td>
              <td class="text">&nbsp;</td>
              <td class="text"> <input name="singleaddress" type="hidden" id="singleaddress" value="<%=singleAddress%>"></td>
            </tr>
          </table>
</form>
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
EmailRecordset.close();
StatementEmailRecordset.close();
ConnEmailRecordset.close();
%>
