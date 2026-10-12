<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%@ include file="../user/ldaputil.jsp" %>
<%
//Driver DriverTypeRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnTypeRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnTypeRecordset = rcsiteDS.getConnection();
PreparedStatement StatementTypeRecordset = ConnTypeRecordset.prepareStatement("SELECT usertypename FROM usertype");
ResultSet TypeRecordset = StatementTypeRecordset.executeQuery();
boolean TypeRecordset_isEmpty = !TypeRecordset.next();
boolean TypeRecordset_hasData = !TypeRecordset_isEmpty;
Object TypeRecordset_data;
int TypeRecordset_numRows = 0;
%>
<%
String MemberRecordset__MMColParam = "null";
if (request.getParameter("searchterm") !=null) {MemberRecordset__MMColParam = (String)request.getParameter("searchterm");}
%>
<%
String MemberRecordset__MMColParam2 = "null";
if (request.getParameter("usertype") !=null) {MemberRecordset__MMColParam2 = (String)request.getParameter("usertype");}
String whereClue =" WHERE type<>'ADMINISTRATOR' AND type<>'CONSULTANT' ";

if(MemberRecordset__MMColParam2 != "null" ){
whereClue = "WHERE type = '" + MemberRecordset__MMColParam2 + "' ";
   }
if(MemberRecordset__MMColParam != "null" ){
whereClue = "WHERE (email LIKE '%" + MemberRecordset__MMColParam + "%' OR rc_customer.username LIKE '%" + MemberRecordset__MMColParam + "%'OR customer LIKE '%" + MemberRecordset__MMColParam + "%') "+" AND type<>'ADMINISTRATOR' AND type<>'CONSULTANT'";
}

%>
<%
//Driver DriverMemberRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnMemberRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnMemberRecordset = rcsiteDS.getConnection();
PreparedStatement StatementMemberRecordset = ConnMemberRecordset.prepareStatement("SELECT *  FROM (rc_customer  left join preferences on rc_customer.username=preferences.username ) " +whereClue );
ResultSet MemberRecordset = StatementMemberRecordset.executeQuery();
boolean MemberRecordset_isEmpty = !MemberRecordset.next();
boolean MemberRecordset_hasData = !MemberRecordset_isEmpty;
Object MemberRecordset_data;
int MemberRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
MemberRecordset_numRows += Repeat1__numRows;
%><html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
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
            <jsp:include page="adminleftnavi.jsp?screen=" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
          <tr>
    <td>&nbsp;</td>
    <td>
<form name="form2" method="post" action="">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="11%">&nbsp;</td>
            <td width="11%">&nbsp;</td>
            <td width="78%">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>
<select name="usertype" id="usertype">
                <%
while (TypeRecordset_hasData) {
%>
                <option value="<%=((TypeRecordset.getObject("usertypename")!=null)?TypeRecordset.getObject("usertypename"):"")%>"><%=((TypeRecordset.getObject("usertypename")!=null)?TypeRecordset.getObject("usertypename"):"")%></option>
                <%
  TypeRecordset_hasData = TypeRecordset.next();
}
TypeRecordset.close();
TypeRecordset = StatementTypeRecordset.executeQuery();
TypeRecordset_hasData = TypeRecordset.next();
TypeRecordset_isEmpty = !TypeRecordset_hasData;
%>
              </select></td>
            <td><input type="submit" name="Submit2" value="Select"></td>
          </tr>
        </table>
      </form></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
<form name="form1" method="post" action="memberlist.jsp">
                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                  <tr>
      <td width="14%">&nbsp;</td>
      <td width="10%">&nbsp;</td>
      <td width="76%">&nbsp;</td>
    </tr>
    <tr>
                    <td><strong>Search a member:</strong></td>
      <td><input name="searchterm" type="text" id="searchterm"></td>
      <td><input type="submit" name="Submit" value="Search"></td>
    </tr>
   
  </table>
</form></td>
  </tr>
</table>

<table border="0" cellpadding="0" cellspacing="1">
  <tr class="title"> 
    <td>no</td>
    <td>Username</td>
    <td>Name</td>
	<td>User Type</td>
    <td>Email</td>
  </tr>
  <% while ((MemberRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
  <tr class="text" <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"C8E4FF\" ");}%>> 
    <td><%=Repeat1__index+1%></td>
    <td><%=(((MemberRecordset_data = MemberRecordset.getObject("rc_customer.username"))==null || MemberRecordset.wasNull())?"":MemberRecordset_data)%></td>
    <td><%=(((MemberRecordset_data = MemberRecordset.getObject("customer"))==null || MemberRecordset.wasNull())?"":MemberRecordset_data)%></td>
    <td><%=(((MemberRecordset_data = MemberRecordset.getObject("type"))==null || MemberRecordset.wasNull())?"":MemberRecordset_data)%><a href="changeusertype.jsp?username=<%=(((MemberRecordset_data = MemberRecordset.getObject("rc_customer.username"))==null || MemberRecordset.wasNull())?"":MemberRecordset_data)%>">Change</a></td>
	<td><a href="emailselector.jsp?singleaddress=<%=(((MemberRecordset_data = MemberRecordset.getObject("email"))==null || MemberRecordset.wasNull())?"":MemberRecordset_data)%>"><%=(((MemberRecordset_data = MemberRecordset.getObject("email"))==null || MemberRecordset.wasNull())?"":MemberRecordset_data)%></a></td>
  </tr>
  <%
  /*
  try{
  	addLDAPUser(MemberRecordset.getString("rc_customer.username"), MemberRecordset.getString("rc_customer.customer"),MemberRecordset.getString("rc_customer.email"),MemberRecordset.getString("rc_customer.pword"));
  }catch(Exception e){
  	e.printStackTrace();
  }
  */
  Repeat1__index++;
  MemberRecordset_hasData = MemberRecordset.next();
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
TypeRecordset.close();
StatementTypeRecordset.close();
ConnTypeRecordset.close();
%>
<%
MemberRecordset.close();
StatementMemberRecordset.close();
ConnMemberRecordset.close();
%>
