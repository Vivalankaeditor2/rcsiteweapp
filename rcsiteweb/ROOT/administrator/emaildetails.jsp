<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*, java.io.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
String EmailRecordset__MMColParam = "1";
if (request.getParameter("emailid") !=null) {EmailRecordset__MMColParam = (String)request.getParameter("emailid");}
%>

<%
//Driver DriverEmailRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnEmailRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnEmailRecordset = rcsiteDS.getConnection();
PreparedStatement StatementEmailRecordset = ConnEmailRecordset.prepareStatement("SELECT *  FROM email   WHERE emailid = " + EmailRecordset__MMColParam + "");
ResultSet EmailRecordset = StatementEmailRecordset.executeQuery();
/*
String emailBody = "";
    ByteArrayOutputStream ByteoutDetails = new ByteArrayOutputStream(1024);
while(EmailRecordset.next())
{
    try
    {
        BufferedInputStream ByteinDetails = new BufferedInputStream( EmailRecordset.getBinaryStream("message") );
        byte ByteIndata[]= new byte[100000] ;
        int Bytesread = 0;
        // Make sure its not a NULL value in the column:
        if ( !EmailRecordset.wasNull() )
        {
            if ( (Bytesread = ByteinDetails.read(ByteIndata,0,ByteIndata.length)) != -1 )
            {
                // Write out 'bytesread' bytes to the writer instance:
                ByteoutDetails.write(ByteIndata,0,Bytesread);
                emailBody = ByteoutDetails.toString();
            }
            else
            {
                // When the read() method returns -1 we've hit the end of the stream,
                // so now we can get our bytes out of the writer object:
                //allBytesInBlob = baos.getBytes();
                emailBody = ByteoutDetails.toString();
            }
        }
    }
    catch(Exception ex)
    {
        // The driver could not handle this as a BLOB...
        // Fallback to default (and slower) byte[] handling
        // byte[] bytes = Recordset1.getBytes(1);
        emailBody = " Error - Please try latter  222." ;
    }
}
*/
boolean EmailRecordset_isEmpty = !EmailRecordset.next();
boolean EmailRecordset_hasData = !EmailRecordset_isEmpty;
Object EmailRecordset_data;
int EmailRecordset_numRows = 0;

//EmailRecordset.close();
//EmailRecordset = StatementEmailRecordset.executeQuery();
//EmailRecordset_hasData = EmailRecordset.next();
//EmailRecordset_isEmpty = !EmailRecordset_hasData;
%>

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
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --><jsp:include page="adminleftnavi.jsp?screen=email" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
  
            <table border="0" align="center" class="text">
              <tr>
                <td align="default" valign="top" class="title">&nbsp;</td>
                <td align="default">&nbsp;</td>
              </tr>
              <tr> 
                <td width="10%" align="default" valign="top" class="title">Date:</td>
                <td align="default" width="50%"><%=(((EmailRecordset_data = EmailRecordset.getObject("entered_date"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></td>
              </tr>
              <tr> 
                <td width="10%" align="default" valign="top" class="title">From:</td>
                <td align="default" width="50%"><%=(((EmailRecordset_data = EmailRecordset.getObject("from_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></td>
              </tr>
              <tr> 
                <td width="10%" align="default" valign="top" class="title">To:</td>
                <td align="default" width="50%"><%=(((EmailRecordset_data = EmailRecordset.getObject("to_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></td>
              </tr>
              <tr> 
                <td width="10%" align="default" valign="top" class="title">Subject</td>
                <td align="default" width="50%"><%=(((EmailRecordset_data = EmailRecordset.getObject("subject"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></td>
              </tr>
              <tr> 
                <td align="default" valign="top" class="title">Message</td>
                <td align="default">&nbsp;</td>
              </tr>
              <tr> 
                <td colspan="2" align="default" valign="top" class="text"><%=(((EmailRecordset_data = EmailRecordset.getObject("message"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></td>
              </tr>
              <tr> 
                <td width="10%" align="default" valign="top" class="title">Description</td>
                <td align="default" width="50%"><%=(((EmailRecordset_data = EmailRecordset.getObject("description"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></td>
              </tr>
              <tr> 
                <td width="10%" align="default" valign="top" class="title">Type</td>
                <td align="default" width="50%"><%=(((EmailRecordset_data = EmailRecordset.getObject("type"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></td>
              </tr>
              <tr> 
                <td width="10%" align="default" valign="top" class="title">Folder</td>
                <td align="default" width="50%"><%=(((EmailRecordset_data = EmailRecordset.getObject("folder"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></td>
              </tr>
              <tr> 
                <td align="default" valign="top" class="title">&nbsp;</td>
                <td align="default" class="title"><a href="emailcompose.jsp?<%="emailid=" + (((EmailRecordset_data = EmailRecordset.getObject("emailid"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data) %>">Retrieve</a></td>
              </tr>
              <tr> 
                <td align="default" valign="top" class="title">&nbsp;</td>
                <%
					  if((EmailRecordset.getObject("folder")!=null)&&(!EmailRecordset.getObject("folder").equals("send"))){
					  %>
                <td width="20" align="default"><div align="left"><a href="emailedit.jsp?<%="emailid="+ (((EmailRecordset_data = EmailRecordset.getObject("emailid"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>" class="title">Edit</a></div></td>
                <%
					  }
					  %>
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
EmailRecordset.close();
StatementEmailRecordset.close();
ConnEmailRecordset.close();
%>

