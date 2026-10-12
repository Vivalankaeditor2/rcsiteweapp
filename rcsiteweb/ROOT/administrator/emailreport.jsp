<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.io.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String whereClue ="";
boolean reSend =true;
String ReportRecordset__MMColParam = "1";
if (request.getParameter("emailid") !=null) 
	{ReportRecordset__MMColParam = (String)request.getParameter("emailid");
	whereClue = "WHERE emailid = " + ReportRecordset__MMColParam ;
	}
%>
<%
String ReportRecordset__MMColParam2 = "1";
if (request.getParameter("reportid") !=null) 
	{ReportRecordset__MMColParam2 = (String)request.getParameter("reportid");
		whereClue = "WHERE reportid = " + ReportRecordset__MMColParam2;
		reSend = false;
	}
%>
<%
String emailId =ReportRecordset__MMColParam;
%>
<%
//Driver DriverReportRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnReportRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnReportRecordset = rcsiteDS.getConnection();
PreparedStatement StatementReportRecordset = ConnReportRecordset.prepareStatement("SELECT * FROM email_report "+whereClue + " ORDER BY reportid DESC");
ResultSet ReportRecordset = StatementReportRecordset.executeQuery();
boolean ReportRecordset_isEmpty = !ReportRecordset.next();
boolean ReportRecordset_hasData = !ReportRecordset_isEmpty;
Object ReportRecordset_data;
int ReportRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 100;
int Repeat1__index = 0;
ReportRecordset_numRows += Repeat1__numRows;
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
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --> 
            <jsp:include page="adminleftnavi.jsp?screen=email" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
            <table width="349" border="0" cellpadding="0" cellspacing="0" class="text">
              <tr> 
                <td width="1">&nbsp;</td>
                <td width="80">&nbsp;</td>
                <td width="80">&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td class="title">Email Report </td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td width="80"><strong>reportid</strong></td>
                <td width="80"><strong>emailid</strong></td>
              </tr>
              <% while ((ReportRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <tr> 
                <td>&nbsp;</td>
                <td width="80"><a href="emailreport.jsp?reportid=<%=(((ReportRecordset_data = ReportRecordset.getObject("reportid"))==null || ReportRecordset.wasNull())?"":ReportRecordset_data)%>"><%=(((ReportRecordset_data = ReportRecordset.getObject("reportid"))==null || ReportRecordset.wasNull())?"":ReportRecordset_data)%></a></td>
                <td width="80"><%=(((ReportRecordset_data = ReportRecordset.getObject("emailid"))==null || ReportRecordset.wasNull())?"":ReportRecordset_data)%></td>
              </tr>
              <%
 
 
  Repeat1__index++;
  ReportRecordset_hasData = ReportRecordset.next();
}

ReportRecordset.close();
ReportRecordset = StatementReportRecordset.executeQuery();
 ReportRecordset_isEmpty = !ReportRecordset.next();
int i=0;
int reportId =0;
while(i<1)
{  
i++;
reportId=ReportRecordset.getInt("reportid");

 /*
 try
            {
               	BufferedInputStream bisF = new BufferedInputStream( ReportRecordset.getBinaryStream("failed_emails") );
				BufferedInputStream bis = new BufferedInputStream( ReportRecordset.getBinaryStream("sent_emails") );
			   	byte bindataF[]= new byte[10000] ;
			    byte bindata[]= new byte[10000] ;
				
               int bytesreadF = 0;
			   int bytesread = 0;

            // Make sure its not a NULL value in the column:
            if ( !ReportRecordset.wasNull() ) {

               if ( (bytesread = bis.read(bindata,0,bindata.length)) != -1 ) {

                  // Write out 'bytesread' bytes to the writer instance:
                  baos.write(bindata,0,bytesread);
				  sentEmail = baos.toString();

               } else {

                  // When the read() method returns -1 we've hit the end of the stream,
                  // so now we can get our bytes out of the writer object:
                  //allBytesInBlob = baos.getBytes();
				 sentEmail = baos.toString();
				  }
				  
				  if ( (bytesreadF = bisF.read(bindataF,0,bindataF.length)) != -1 ) {

                  // Write out 'bytesread' bytes to the writer instance:
                  baosF.write(bindataF,0,bytesreadF);
				  failedEmail= baosF.toString();

               } else {

                  // When the read() method returns -1 we've hit the end of the stream,
                  // so now we can get our bytes out of the writer object:
                  //allBytesInBlob = baos.getBytes();
				failedEmail= baosF.toString();
				  }
            }
			}
            catch(Exception ex)
            { ex.printStackTrace();
               // The driver could not handle this as a BLOB...
               // Fallback to default (and slower) byte[] handling
              // byte[] bytes = Recordset1.getBytes(1);
			  sentEmail = " Error - Please try latter." ;
            }
			
			System.out.print("failedEmail");
				*/		
}

%>
            </table>
<%
if(reSend){
%>
<form name="form1" method="post" action="emailresend.jsp">
              <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td class="title">Last report for this email.</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><strong>Report ID</strong></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><%=reportId%></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><strong>Sent Emails To:</strong></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><%=(((ReportRecordset_data = ReportRecordset.getObject("sent_emails"))==null || ReportRecordset.wasNull())?"":ReportRecordset_data)%></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td width="6%">&nbsp;</td>
                  <td width="90%"><strong>Failed Email Addresses:</strong></td>
                  <td width="4%">&nbsp;</td>
                </tr>
                <tr valign="top"> 
                  <td>&nbsp;</td>
                  <td> <textarea name="toemail" cols="60" rows="10"  id="toemail" ><%=(((ReportRecordset_data = ReportRecordset.getObject("failed_emails"))==null || ReportRecordset.wasNull())?"":ReportRecordset_data)%></textarea></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><strong>Send same email to failed email addresses.</strong></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td> <input type="submit" name="Submit" value="Submit"> <input name="emailid" type="hidden" id="emailid" value="<%=emailId%>"> 
                  </td>
                 
                </tr>
              </table>
</form>
<%
}else{
%>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
              <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                            
                <tr> 
                  <td>&nbsp;</td>
                  <td><%=reportId%></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><strong>Sent Emails To:</strong></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><%=(((ReportRecordset_data = ReportRecordset.getObject("sent_emails"))==null || ReportRecordset.wasNull())?"":ReportRecordset_data)%></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td width="6%">&nbsp;</td>
                  <td width="90%"><strong>Failed Email Addresses:</strong></td>
                  <td width="4%">&nbsp;</td>
                </tr>
                <tr valign="top"> 
                  <td>&nbsp;</td>
                  
                <td><%=(((ReportRecordset_data = ReportRecordset.getObject("failed_emails"))==null || ReportRecordset.wasNull())?"":ReportRecordset_data)%></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
            </table>

<%
}
%>
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
ReportRecordset.close();
StatementReportRecordset.close();
ConnReportRecordset.close();
%>
