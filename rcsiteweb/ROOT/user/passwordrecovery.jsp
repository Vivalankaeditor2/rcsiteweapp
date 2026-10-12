<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,com.rev_creations.mail.*" errorPage="" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="../Connections/dbconnection.jsp" %>

<%
if (session.getValue("store")==null || ((String)session.getValue("store")).equals("")) {
	session.putValue("store", "usa"); 
}
if (request.getParameter("store") !=null && !request.getParameter("store").equals("")) {
	session.putValue("store", (String)request.getParameter("store")); 
}
%>

<%
String store =(String)session.getValue("store");
String dcode =(String)session.getValue("dcode");
%>
<%
String pageMessage="";
if(( request.getParameter("email") !=null) || (request.getParameter("username") !=null)){

%>
<%
String CustomerRecordset__MMColParam = "1";
if (request.getParameter("username") !=null) {CustomerRecordset__MMColParam = (String)request.getParameter("username");}
%>
<%

	String whereClue ="";
	
	if (request.getParameter("email") !=null) {
		 whereClue = "WHERE email = '" + treatStringParam(request.getParameter("email")) + "'";
		}
	if (request.getParameter("username") !=null) {
		 whereClue = "WHERE username = '" + treatStringParam(request.getParameter("username")) + "'";

		}
%>

<%
//Driver DriverCustomerRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCustomerRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCustomerRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCustomerRecordset = ConnCustomerRecordset.prepareStatement("SELECT * FROM rc_customer "+whereClue+ " ");
ResultSet CustomerRecordset = StatementCustomerRecordset.executeQuery();
boolean CustomerRecordset_isEmpty = !CustomerRecordset.next();
boolean CustomerRecordset_hasData = !CustomerRecordset_isEmpty;
Object CustomerRecordset_data;
int CustomerRecordset_numRows = 0;
%>

<% 
		if(CustomerRecordset_hasData){
			 
			pageMessage= (String)CustomerRecordset.getObject("username");
			
			com.rev_creations.mail.SendMailSMTP MailObject = new com.rev_creations.mail.SendMailSMTP();

            String messageText = "Your  " + webName + " username and password are as follows"+
                                 "<P>Username: "+ (String)CustomerRecordset.getObject("username") +
								 "<P>Password: "+ (String)CustomerRecordset.getObject("pword") +
                				 "<P>Thanks" +
								 "<P>Administrator" +  
								 "<P>"+webName;
								 
			String heading =  "Your " + webName + " Username and Password";
			String fromAddress = "info@"+shortDomain;
			String toAddress = (String)CustomerRecordset.getObject("email");;
			String[] emailList = {toAddress};
			
			try{
        		MailObject.SendMail(  messageText, heading, fromAddress, emailList);
				
				pageMessage= " Your password and username has been sent to your email address.";
				response.sendRedirect(response.encodeRedirectURL("login.jsp")+"?dcode="+dcode+"&store="+store+"&pagemessage="+pageMessage);
    			return;
		
			}catch(Exception ex){
		 		pageMessage=ex.toString();
			}
		
 		}else{
			pageMessage= " Sorry!!! No match for the user name or email entered.";
		}


CustomerRecordset.close();
StatementCustomerRecordset.close();
ConnCustomerRecordset.close();


} //end if
%>
<jsp:include page="../custom/storeconfig.jsp" flush="true" />
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
<title>Password Recovery.</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css">
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
</head>

<BODY leftMargin=0 topMargin=0 marginwidth="0" marginheight="0">
<jsp:include page="../custom/rcheader.jsp" flush="true" />
<table width="95%" border="0" cellpadding="0" cellspacing="0" class="text">
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="12%">&nbsp;</td>
                        <td width="87%"><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
                        <td width="1%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                            <tr> 
                                              <td colspan="2"><strong>Forgot password?</strong></td>
                            </tr>
                            <tr valign="top"> 
                              <td width="29%">Enter username</td>
                              <td width="71%"> <form name="form1" method="post" action="">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top"> 
                                      <td width="44%"> <input name="username" type="text" id="username" class="rc_input" ></td>
                                      <td width="56%"> <input type="submit" name="Submit" value="Go" class="rc_button"></td>
                                    </tr>
                                  </table>
                                </form></td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="2"><strong>Forgot username?</strong></td>
                            </tr>
                            <tr valign="top"> 
                              <td>Enter email address</td>
                              <td> 
                                <form name="form1" method="post" action="">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top"> 
                                      <td width="45%"> 
                                        <input name="email" type="text" id="email" class="rc_input" ></td>
                                      <td width="55%"> 
                                        <input type="submit" name="Submit2" value="Go" class="rc_button"> 
                                      </td>
                                    </tr>
                                  </table>
                                </form></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
<jsp:include page="../custom/rcfooter.jsp" flush="true" />
</body>
</html>

