<%@page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/TrainingConnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
// *** Edit Operations: declare variables

// set the form action variable
String MM_editRedirectUrl = "trainaddporgramusertype.jsp";
String MM_editAction = request.getRequestURI();

// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1"))
{


    String Programid = "";
  // set the form values
    if (request.getParameter("select") != null)
    {
        Programid = (String)request.getParameter("select");
        session.setAttribute("programid",Programid);
    }


  // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0)
    {
        response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl));
        return;
    }
}
%>




<%
//Driver DriverTrainingProgramDetails = (Driver)Class.forName(MM_TrainingConnection_DRIVER).newInstance();
//Connection ConnTrainingProgramDetails = DriverManager.getConnection(MM_TrainingConnection_STRING,MM_TrainingConnection_USERNAME,MM_TrainingConnection_PASSWORD);
Connection ConnTrainingProgramDetails = rcsiteDS.getConnection();
PreparedStatement StatementTrainingProgramDetails = ConnTrainingProgramDetails.prepareStatement("SELECT programid, programname  FROM training_program");
ResultSet TrainingProgramDetails = StatementTrainingProgramDetails.executeQuery();
boolean TrainingProgramDetails_isEmpty = !TrainingProgramDetails.next();
boolean TrainingProgramDetails_hasData = !TrainingProgramDetails_isEmpty;
Object TrainingProgramDetails_data;
int TrainingProgramDetails_numRows = 0;
%>

<%@ include file="../custom/config.jsp" %>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->
<link href="../css/styles.css" rel="stylesheet" type="text/css">
<!-- InstanceEndEditable -->
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
            <table width="75%" border="0" class="text">
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td> <strong>Select the Training Program</strong></td>
              </tr>
              <tr> 
                <td> <form name="form1"  method="post" action="<%=MM_editAction%>">
                    <table width="100%" class="text">
                      <tr> 
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                        <td > <div align="center"> 
                            <select name="select">
                              <%
while (TrainingProgramDetails_hasData)
{
%>
                              <option value="<%=((TrainingProgramDetails.getObject("programid")!=null)?TrainingProgramDetails.getObject("programid"):"")%>"><%=((TrainingProgramDetails.getObject("programname")!=null)?TrainingProgramDetails.getObject("programname"):"")%></option>
                              <%
  TrainingProgramDetails_hasData = TrainingProgramDetails.next();
}
TrainingProgramDetails.close();
TrainingProgramDetails = StatementTrainingProgramDetails.executeQuery();
TrainingProgramDetails_hasData = TrainingProgramDetails.next();
TrainingProgramDetails_isEmpty = !TrainingProgramDetails_hasData;
%>
                            </select>
                          </div></td>
                      </tr>
                      <tr> 
                        <td> <div align="center"> 
                            <input type="submit" name="Submit" value="Add Usertype & Category">
                          </div></td>
                      </tr>
                      <input type="hidden" name="MM_insert" value="form1">
                    </table>
                  </form></td>
              </tr>
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
TrainingProgramDetails.close();
StatementTrainingProgramDetails.close();
ConnTrainingProgramDetails.close();
%>
