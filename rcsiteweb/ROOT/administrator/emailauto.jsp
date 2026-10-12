<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.io.*,com.rev_creations.mail.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

<%
String emailId ="1";
if (request.getParameter("emailid") !=null) 
	{emailId = (String)request.getParameter("emailid");
	}
%>
<%
String to_email = "";
String  from_email = "";
String subject ="";
String MM_editRedirectUrl ="";
String pageMessage ="";
String sentEmail = "" ;
String  failedEmail = " ";
%>
<%
//Driver Driver = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection Conn = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection Conn = rcsiteDS.getConnection();
%>

<%
//Driver DriverReportRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnReportRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
//PreparedStatement StatementReportRecordset = ConnReportRecordset.prepareStatement("SELECT * FROM email_report WHERE emailid ="+emailId+" ORDER BY reportid DESC");
PreparedStatement StatementReportRecordset = Conn.prepareStatement("SELECT * FROM email_report WHERE emailid ="+emailId+" ORDER BY reportid DESC");
ResultSet ReportRecordset = StatementReportRecordset.executeQuery();
boolean ReportRecordset_isEmpty = !ReportRecordset.next();
boolean ReportRecordset_hasData = !ReportRecordset_isEmpty;
Object ReportRecordset_data;

%>
<%
//Driver DriverEmailRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnEmailRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
//PreparedStatement StatementEmailRecordset = ConnEmailRecordset.prepareStatement("SELECT * FROM email WHERE emailid = " + emailId + "");
PreparedStatement StatementEmailRecordset = Conn.prepareStatement("SELECT * FROM email WHERE emailid = " + emailId + "");
ResultSet EmailRecordset = StatementEmailRecordset.executeQuery();
Object EmailRecordset_data;
boolean b =EmailRecordset.next();
String emailBody = "email body";
%>
<%

      from_email = (String)(((EmailRecordset_data = EmailRecordset.getObject("from_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data);

      subject =(String)(((EmailRecordset_data = EmailRecordset.getObject("subject"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data);
      emailBody =(String)(((EmailRecordset_data = EmailRecordset.getObject("message"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data);
      failedEmail =(String)(((EmailRecordset_data = ReportRecordset.getObject("failed_emails"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data);

/*
ByteArrayOutputStream baos = new ByteArrayOutputStream(1024);
ByteArrayOutputStream baosF = new ByteArrayOutputStream(1024);
try
            {
               	BufferedInputStream bisF = new BufferedInputStream( ReportRecordset.getBinaryStream("failed_emails") );
				BufferedInputStream bis = new BufferedInputStream( EmailRecordset.getBinaryStream("message") );
			   	byte bindataF[]= new byte[10000] ;
			    byte bindata[]= new byte[100000] ;
				
               int bytesreadF = 0;
			   int bytesread = 0;

            // Make sure its not a NULL value in the column:
            if ( !ReportRecordset.wasNull() ) {

               if ( (bytesread = bis.read(bindata,0,bindata.length)) != -1 ) {

                  // Write out 'bytesread' bytes to the writer instance:
                  baos.write(bindata,0,bytesread);
				  emailBody = baos.toString();

               } else {

                  // When the read() method returns -1 we've hit the end of the stream,
                  // so now we can get our bytes out of the writer object:
                  //allBytesInBlob = baos.getBytes();
				 emailBody = baos.toString();
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
*/			
			
			
		MM_editRedirectUrl = "emailcompose.jsp";
		com.rev_creations.mail.SendMailSMTP MailObject = new com.rev_creations.mail.SendMailSMTP();
	    String messageText = emailBody;
		String[] emailList ={""};
		String failedEmailAddr = "";
		String sentEmailAddr ="";
		String errorMessage ="no error";
		String addressString = "";
		from_email =webName +"<"+ from_email + ">";
		
		
		addressString=failedEmail.trim();
		int endOfData = addressString.length();
		
		int cData = addressString.indexOf(",");
//System.out.println("cData1:" +cData); 	
		if(cData>-1){
			endOfData= cData;
//System.out.println("cData2:" +cData);
		}
		

		String emailAddress ="";
		boolean validAddress= true;
		boolean doAgain= true;

		try{

				emailAddress =addressString.substring(0,endOfData);
				emailAddress =emailAddress.trim();
				if((emailAddress.indexOf(".")>0)&&(emailAddress.indexOf("@")>0)&&(emailAddress.length()>5)){
						emailList[0] =emailAddress;
//System.out.println("emailAddress valid:" +emailAddress);						
				}else{
//System.out.println("emailAddress invalid:" +emailAddress);						
						failedEmailAddr = ", "+ emailAddress ;
						errorMessage = "invalid format";
						validAddress= false;
				}
					
			}catch(Exception ex){
//System.out.println("emailAddress exception:" +emailAddress);				
					failedEmailAddr =", "+  emailList[0] ;
					errorMessage = "String Eexc:" +ex.toString() ;
					validAddress= false;
			}
					
			if(validAddress){
					try{

				MailObject.SendMail(  messageText, subject, from_email, emailList);
	System.out.println((new java.util.Date())+" 1. sent to:" +emailList[0]);
						sentEmailAddr = emailList[0] ;
					}catch(Exception ex){
					System.out.println((new java.util.Date())+" 2. Exception");
					ex.printStackTrace();
						failedEmailAddr =", "+  emailList[0] ;
						errorMessage = "LastSingleEexc:" +ex.toString() ;
					}
			}//end if -validAddress
			
			if((addressString.length()>endOfData)&& (addressString.indexOf(".")>-1)&&(addressString.indexOf("@")>-1)&&(addressString.length()>5) ){
			  		addressString= addressString.substring(endOfData+1);
			}else{
			  		addressString ="";
			  		doAgain =false;
			}
			
			  
			  	pageMessage ="Sent to: "+sentEmailAddr+".  Check email report.";
				failedEmailAddr =addressString+failedEmailAddr;
//	System.out.println("	pageMessage1:" +pageMessage);						
				try{
						System.out.println((new java.util.Date())+" 3. before insert");
						//Driver DriverReportRecordset2 = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
						//Connection ConnReportRecordset2 = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
						errorMessage = errorMessage.replace(' ','\b');
					                  
						PreparedStatement emailReportStatement = Conn.prepareStatement("insert into email_report (emailid,sent_emails, failed_emails, error_mesg) values("+emailId+",'"+ sentEmailAddr+"','"+ failedEmailAddr+"','"+errorMessage+"')");
 					 	emailReportStatement.executeUpdate();
							System.out.println((new java.util.Date())+" 4. after insert");
									emailReportStatement.close();
									System.out.println((new java.util.Date())+" 5. after emailReportStatement.close(");
			//ConnReportRecordset2.close();

				}catch(Exception ex){
				System.out.println((new java.util.Date())+" 6. Exception");
				ex.printStackTrace();
				pageMessage ="Sent to: "+sentEmailAddr+". Report not enterd. ";
				}
//System.out.println("doAgain:" +doAgain);
if(!doAgain){
			ReportRecordset.close();
			StatementReportRecordset.close();
			//ConnReportRecordset.close();
			Conn.close();
			
			EmailRecordset.close();
			StatementEmailRecordset.close();
			//ConnEmailRecordset.close();
			
			pageMessage="Check email report. ";
			response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl)+"?pagemessage="+pageMessage);
            return;
}
					
	
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
<meta http-equiv="refresh" content="300">
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
            

            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><font color="#FF0000"><%=pageMessage%></font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><img src="../images/sending.gif" width="180" height="40"></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="6%">&nbsp;</td>
                <td width="90%"><strong>Sending to:</strong></td>
                <td width="4%">&nbsp;</td>
              </tr>
              <tr valign="top"> 
                <td>&nbsp;</td>
                <td> <%=failedEmailAddr%></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><strong>From: </strong><%=from_email%></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><strong>Subject:</strong> <%=subject%></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><strong><!--Email:--></strong></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td><!-- % = emailBody % --></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>

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
try{
System.out.println((new java.util.Date())+" 7. before close");
ReportRecordset.close();
StatementReportRecordset.close();
//ConnReportRecordset.close();
%>
<%
EmailRecordset.close();
StatementEmailRecordset.close();
//ConnEmailRecordset.close();
Conn.close();
System.out.println((new java.util.Date())+" 8. after close");
				}catch(Exception ex){
				System.out.println((new java.util.Date())+" 9. Exception");
				ex.printStackTrace();
				
				}
%>
