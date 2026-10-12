<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,com.rev_creations.mail.*" errorPage="" %>
<%@ page import="java.util.*, javax.servlet.*,javax.activation.*,java.io.*,java.text.*,java.lang.*"%>
<%@ include file="../custom/config.jsp" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String pageMessage ="";
String emailId = "";
if (request.getParameter("emailid") !=null) { emailId = (String)request.getParameter("emailid");}
  
 String fromEmail = "";
if (request.getParameter("fromemail") !=null) { fromEmail = (String)request.getParameter("fromemail");}
String toRadio = "single";
if (request.getParameter("toradio") !=null) { toRadio = (String)request.getParameter("toradio");}

String singleAddress = "";
if (request.getParameter("singleaddress") !=null) { singleAddress = (String)request.getParameter("singleaddress");}
String groupAddress = "";
if (request.getParameter("groupaddress") !=null) { groupAddress = (String)request.getParameter("groupaddress");}

String subject = "";
if (request.getParameter("subject") !=null) { subject = (String)request.getParameter("subject");}
String emailBody = "";
if (request.getParameter("emailbody") !=null) { emailBody = (String)request.getParameter("emailbody");}
String letterHead= "";
if (request.getParameter("letterhead") !=null) { letterHead= (String)request.getParameter("letterhead");}

String header= "";
//if (request.getParameter("header") !=null) { header= (String)request.getParameter("header");}
String footer= "";
//if (request.getParameter("footer") !=null) { footer= (String)request.getParameter("footer");}

String description= "";
if (request.getParameter("description") !=null) { description= (String)request.getParameter("description");}
String folder= "save";
if (request.getParameter("folderradiogroup") !=null) { folder= (String)request.getParameter("folderradiogroup");}
String toEmail = "";
if (toRadio.equals("single")){toEmail=singleAddress;}
else {toEmail=groupAddress;}
String type= "";
if (request.getParameter("type") !=null) { type= (String)request.getParameter("type");}
Random rand = new Random();

%>
<%
// *** Edit Operations: declare variables

// set the form action variable
String MM_editAction = request.getRequestURI();
if (request.getQueryString() != null && request.getQueryString().length() > 0) {
  MM_editAction += "?" + request.getQueryString();
}

// connection information
String MM_editDriver = null, MM_editConnection = null, MM_editUserName = null, MM_editPassword = null;

// redirect information
String MM_editRedirectUrl = null;

// query string to execute
StringBuffer MM_editQuery = null;

// boolean to abort record edit
boolean MM_abortEdit = false;

// table information
String MM_editTable = null, MM_editColumn = null, MM_recordId = null;

// form field information
String[] MM_fields = null, MM_columns = null;

String  to_email = null;
String  from_email = null;
%>
<%
if(letterHead.equals("use"))
{
%>
<%
String HeaderRecordset__MMColParam = "1";
if (request.getParameter("ui_id") !=null) {HeaderRecordset__MMColParam = (String)request.getParameter("ui_id");}
%>
<%
//Driver DriverHeaderRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnHeaderRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnHeaderRecordset = rcsiteDS.getConnection();
PreparedStatement StatementHeaderRecordset = ConnHeaderRecordset.prepareStatement("SELECT * FROM webui WHERE ui_id = " + HeaderRecordset__MMColParam + "");
ResultSet HeaderRecordset = StatementHeaderRecordset.executeQuery();
while(HeaderRecordset.next())
         {
			header = HeaderRecordset.getString("email_header");
			footer=  HeaderRecordset.getString("email_footer");
	}
boolean HeaderRecordset_isEmpty = !HeaderRecordset.next();
boolean HeaderRecordset_hasData = !HeaderRecordset_isEmpty;
Object HeaderRecordset_data;
int HeaderRecordset_numRows = 0;
%>
<%
HeaderRecordset.close();
StatementHeaderRecordset.close();
ConnHeaderRecordset.close();
%>
<%
emailBody = header + emailBody + footer;
}// end adding header and footer
%>
<%
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "email";
  MM_editRedirectUrl = "emailcompose.jsp";
  String MM_fieldsStr = "emailid|value|entered_date|value|from_name|value|from_email|value|to_name|value|to_email|value|subject|value|type|value|attachment|value|message|value|description|value|folder|value|user|value";
  String MM_columnsStr = "emailid|none,none,NULL|entered_date|',none,NULL|from_name|',none,''|from_email|',none,''|to_name|',none,''|to_email|',none,''|subject|',none,''|type|',none,''|attachment|',none,''|message|',none,''|description|',none,''|folder|',none,''|user|',none,''";
  

  
  // create the MM_fields and MM_columns arrays
  java.util.StringTokenizer tokens = new java.util.StringTokenizer(MM_fieldsStr,"|");
  MM_fields = new String[tokens.countTokens()];
  for (int i=0; tokens.hasMoreTokens(); i++) MM_fields[i] = tokens.nextToken();

  tokens = new java.util.StringTokenizer(MM_columnsStr,"|");
  MM_columns = new String[tokens.countTokens()];
  for (int i=0; tokens.hasMoreTokens(); i++) MM_columns[i] = tokens.nextToken();

  // set the form values
  for (int i=0; i+1 < MM_fields.length; i+=2) {
    MM_fields[i+1] = ((request.getParameter(MM_fields[i])!=null)?(String)request.getParameter(MM_fields[i]):"");
  }
  emailId = MM_fields[1];
  to_email = MM_fields[11];
  from_email =  MM_fields[7];
  from_email = webName +"< "+ from_email + ">";
  folder = MM_fields[23];
  subject = MM_fields[13];
  emailBody = MM_fields[19];
 
  // append the query string to the redirect URL
  if (MM_editRedirectUrl.length() != 0 && request.getQueryString() != null) {
    MM_editRedirectUrl += ((MM_editRedirectUrl.indexOf('?') == -1)?"?":"&") + request.getQueryString();
  }
}
%>
<%
// *** Insert Record: construct a sql insert statement and execute it

if (request.getParameter("MM_insert") != null) {

  // create the insert sql statement
  StringBuffer MM_tableValues = new StringBuffer(), MM_dbValues = new StringBuffer();
  for (int i=0; i+1 < MM_fields.length; i+=2) {
    String formVal = MM_fields[i+1];
    String elem;
    java.util.StringTokenizer tokens = new java.util.StringTokenizer(MM_columns[i+1],",");
    String delim    = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    String altVal   = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    String emptyVal = ((elem = (String)tokens.nextToken()) != null && elem.compareTo("none")!=0)?elem:"";
    if (formVal.length() == 0) {
      formVal = emptyVal;
    } else {
      if (altVal.length() != 0) {
        formVal = altVal;
      } else if (delim.compareTo("'") == 0) {  // escape quotes
        StringBuffer escQuotes = new StringBuffer(formVal);
        for (int j=0; j < escQuotes.length(); j++)
          if (escQuotes.charAt(j) == '\'') escQuotes.insert(j++,'\'');
        formVal = "'" + escQuotes + "'";
      } else {
        formVal = delim + formVal + delim;
      }
    }
    MM_tableValues.append((i!=0)?",":"").append(MM_columns[i]);
    MM_dbValues.append((i!=0)?",":"").append(formVal);
  }
  MM_editQuery = new StringBuffer("insert into " + MM_editTable);
  MM_editQuery.append(" (").append(MM_tableValues.toString()).append(") values (");
  MM_editQuery.append(MM_dbValues.toString()).append(")");
  
  if (!MM_abortEdit) {
    // finish the sql and execute it
    //Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
   //Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection = rcsiteDS.getConnection();
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(MM_editQuery.toString());
    MM_editStatement.executeUpdate();
    MM_connection.close();
//start email sending	
	 if(folder.equals("send"))
      {
        SendMailSMTP MailObject = new SendMailSMTP();
		//SendBulkMailSMTP MailObject = new SendBulkMailSMTP();
        String messageText = emailBody;
		String[] emailList ={""};
	//	String failedEmailAddr = "";
		int failedCounter =0;
	//	String sentEmailAddr ="";
		int sentCounter =0;
	//	String errorMessage ="no error";
		String addressString = "";
		if (request.getParameter("to_radio") !=null) {toRadio = (String)request.getParameter("to_radio");}
		
		if (toRadio.equals("single")){
		 	addressString=to_email.trim();
		}else{//end single
%>
	<%

			String CustomerRecordset__MMColParam = to_email;
					//if (request.getParameter("type") !=null) {CustomerRecordset__MMColParam = (String)request.getParameter("type");}
%>
<%
			//Driver DriverCustomerRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
			//Connection ConnCustomerRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
			Connection ConnCustomerRecordset = rcsiteDS.getConnection();
//PreparedStatement StatementCustomerRecordset = ConnCustomerRecordset.prepareStatement("SELECT DISTINCT email FROM customer  WHERE type = '" + CustomerRecordset__MMColParam + "'");
			PreparedStatement StatementCustomerRecordset = ConnCustomerRecordset.prepareStatement("SELECT distinct rc_customer.email  FROM (rc_customer  left join preferences on rc_customer.username=preferences.username )  WHERE  rc_customer.type = '" + CustomerRecordset__MMColParam  + "' " +
					"AND  (preferences.pref1 is null or preferences.pref1='YES' )" );
			ResultSet CustomerRecordset = StatementCustomerRecordset.executeQuery();
			boolean CustomerRecordset_isEmpty = !CustomerRecordset.next();
			boolean CustomerRecordset_hasData = !CustomerRecordset_isEmpty;
			Object CustomerRecordset_data;
			int CustomerRecordset_numRows = 0;
%>

<%
			addressString=(String)((CustomerRecordset.getObject("rc_customer.email")!=null)?CustomerRecordset.getObject("rc_customer.email"):"");
			CustomerRecordset_hasData = CustomerRecordset.next();
			while (CustomerRecordset_hasData) {
				try{
					emailList[0]=(String)((CustomerRecordset.getObject("rc_customer.email")!=null)?CustomerRecordset.getObject("rc_customer.email"):"");
	           
					addressString = addressString + ", " +emailList[0] ;
					
				}catch(Exception ex){
					//System.out.println("db addrr exception");
				}
  				CustomerRecordset_hasData = CustomerRecordset.next();
			}   
			CustomerRecordset.close();
			StatementCustomerRecordset.close();
			ConnCustomerRecordset.close();
		}//end group
%>	
		
<%
		
					MM_editRedirectUrl = "emailauto.jsp";
					String failedEmailAddr = addressString;
					String sentEmailAddr ="start sending";
					String errorMessage ="pass preview";
					pageMessage ="Sending emails.";
			
							
				
						//Driver DriverReportRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
						//Connection ConnReportRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
						Connection ConnReportRecordset = rcsiteDS.getConnection();
					                  
						PreparedStatement emailReportStatement = ConnReportRecordset.prepareStatement("insert into email_report (emailid,sent_emails, failed_emails, error_mesg) values("+emailId+",'"+ sentEmailAddr+"','"+ failedEmailAddr+"','"+errorMessage+"')");
   					 	emailReportStatement.executeUpdate();
						ConnReportRecordset.close();
					
						response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl)+"?emailid="+emailId+"&pagemessage="+pageMessage);
                        return;	

		
		
		}//end send
      
            

    // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0) {
      response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl)+"?pagemessage="+pageMessage);
      return;
    }//redirect
  //}
  
   }//if ! abort

}//if insert
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript" src="../jscripts/fulleditor.js"></script>
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
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table width="100%" align="center">
                <tr valign="baseline"> 
                  <td width="23%" align="left" nowrap>&nbsp;</td>
                  <td width="77%"> </td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap class="title">From:</td>
                  <td><%=fromEmail%></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap class="title">To:</td>
                  <td><%=toEmail%></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap class="title">Subject:</td>
                  <td><%=subject%></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap class="title">Message:</td>
                  <td>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td colspan="2" align="left" valign="top" nowrap class="text"> 
                  <textarea name="message" id="message" cols="70" rows="30" class="mceEditor" ><%=emailBody%></textarea>
					</td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap class="title">Description:</td>
                  <td><%=description%></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap class="title">Action:</td>
                  <td><%=folder%></td>
                </tr>
                <tr valign="baseline"> 
                  <td align="left" nowrap class="title">&nbsp;</td>
                  <td> <input type="submit" value="Insert / Send Email" > 
                  </td>
                </tr>
              </table>
  <input type="hidden" name="emailid" value="<%=rand.nextInt(1000000000)%>" size="32">
  <input type="hidden" name="entered_date" value="" size="32">
  <input type="hidden" name="from_name" value="" size="32">
  <input type="hidden" name="from_email" value="<%=fromEmail%>" size="32">
  <input type="hidden" name="to_name" value="" size="32">
  <input type="hidden" name="to_email" value="<%=toEmail%>" size="32">
  <input type="hidden" name="subject" value="<%=subject%>" size="32">
  <input type="hidden" name="type" value="<%=type%>" size="32">
  <input type="hidden" name="attachment" value="" size="32">
  <input type="hidden" name="folder" value="<%=folder%>" size="32">
   <input type="hidden" name="user" value="<%=(String)session.getValue("dcode")%>" size="32">
  <input type="hidden" name="description" value="<%=description%>" size="32">
  
  <input type="hidden" name="to_radio" value="<%=toRadio%>" size="32"> 
  <input type="hidden" name="MM_insert" value="form1">
	
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

