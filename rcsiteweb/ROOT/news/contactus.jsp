<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,com.rev_creations.mail.*,com.rev_creations.rcsite.*,java.io.*" errorPage="" %>
<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaImpl" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaResponse" %>
<%!
public boolean validateNumeric(String number, String page, HttpServletRequest request, HttpServletResponse response){
boolean result = true;
   if (number.matches("\\d{1,7}")) {
       result = true;
   }else{
       try{
        request.setAttribute("invalidpage",page);
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/invaliddataerror.jsp");
        dispatcher.forward(request, response);
        result= false;
        	}
            catch(Exception ex)
            { ex.printStackTrace();
            }
   }
    return result ;
}
 %>

<%
String articleid = "";
 if(!validateNumeric( request.getParameter("articleid"), "/news/contactus.jsp", request,  response)){return;}
if (request.getParameter("articleid") !=null) {articleid = (String)request.getParameter("articleid");}
String contactUrl ="";
String reCaptchaPublicKey = "6Lc09fISAAAAAFS0L9r6s84uK8awDcIzZ7tHEaY4";
String reCaptchaPrivateKey = "6Lc09fISAAAAAEL3r3QcQfmGTuiyIq55e-3Un7FJ";
%>
<%
if (session.getValue("store")==null || ((String)session.getValue("store")).equals("")) {
	session.putValue("store", "usa"); 
}
if (request.getParameter("store") !=null && !request.getParameter("store").equals("")) {
	session.putValue("store", (String)request.getParameter("store")); 
}

%>
<%@ include file="../custom/config.jsp" %>
<jsp:include page="../custom/storeconfig.jsp" flush="true" />
<%
String messageText="";
String pageMessage="";
String message   =""; 
String company   =""; 
String name      ="";    
String email     ="";   
String street    ="";  
String city      ="";    
String state     ="";   
String postalcode="";
String country   =""; 
String phone     ="";   

if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_update").toString().equals("form1")) {
    	message   = request.getParameter("message");        
		company   = request.getParameter("company");        
		name      = request.getParameter("name");           
		email     = request.getParameter("email");          
		street    = request.getParameter("street");         
		city      = request.getParameter("city");           
		state     = request.getParameter("state");          
		postalcode= request.getParameter("postalcode");     
		country   = request.getParameter("country");        
		phone     = request.getParameter("phone");  
	   
	   String remoteAddr = request.getRemoteAddr();
        ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
        reCaptcha.setPrivateKey(reCaptchaPrivateKey);

        String challenge = request.getParameter("recaptcha_challenge_field");
        String uresponse = request.getParameter("recaptcha_response_field");
        ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);

        if (reCaptchaResponse.isValid()) {
          System.out.print("Answer was entered correctly!");


	com.rev_creations.mail.SendMailSMTP MailObject = new com.rev_creations.mail.SendMailSMTP();
     messageText ="Below is the result of the WHOLESALER request form. "+ 
	 				"<p> Message: "+ message+
					"<p> Company: "+ company+
					"<p> Name: "+ name+
					"<p> Email: "+ email+
					"<p> Street: "+ street+
					"<p> City: "+ city+
					"<p> State: "+ state+
					"<p> Postal Code: "+ postalcode+
					"<p> Country: "+ country+
					"<p> Phone: "+ phone;
					
		String heading = "Data posted to " +webName;
		String fromAddress = Config.getValue("emailaddress1").trim();
		String toAddress = Config.getValue("emailaddress1").trim();
		String[] emailList = {toAddress};
		try{
        	//MailObject.SendMail(  messageText, heading, fromAddress, emailList);
			pageMessage="Your message has been successfully sent. Your request will be reviewed and we will respond promptly. ";
			message   ="";
			company   ="";
			name      ="";
			email     ="";
			street    ="";
			city      ="";
			state     ="";
			postalcode="";
			country   ="";
			phone     ="";
			
		
		}catch(Exception ex){
			
		 pageMessage="Your message could not be sent. Please try again. ";
	
	ex.printStackTrace();
out.println("<!--");
StringWriter sw = new StringWriter();
PrintWriter pw = new PrintWriter(sw);
ex.printStackTrace(pw);
out.print(sw);
sw.close();
pw.close();
out.println(ex.toString());
out.println("-->");

	
		}
		} else {
          System.out.print("Answer is wrong");
          pageMessage="Your answer is not correct. Please try again. ";
		  
        }
					
	}
%>
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
<title>Contact Us.</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
 <script type="text/javascript">
 var RecaptchaOptions = {
    theme : 'white'
 };
 </script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<jsp:include page="../custom/rcheader.jsp" flush="true" />
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                                      <tr>
                                        <td>&nbsp;</td>
                                        <td bgcolor="#FFFFFF">&nbsp;</td>
                                        <td>&nbsp;</td>
                                      </tr>
                                      <tr> 
                                        <td width="4%">&nbsp;</td>
                                        <td width="85%" bgcolor="#FFFFFF"><strong> 
                                          Contact Us</strong></td>
                                        <td width="11%">&nbsp;</td>
                                      </tr>
                                      <tr> 
                                        <td>&nbsp;</td>
                                        <td> <%
 contactUrl ="../news/plainpage.jsp?articleid=" +articleid;
%> <jsp:include page="<%= contactUrl%>" flush="true" /> 
                                        </td>
                                        <td>&nbsp;</td>
                                      </tr>
                                      <tr> 
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                      </tr>
                                      <tr> 
                                        <td>&nbsp;</td>
                                        <td><strong>Send Us A Message</strong></td>
                                        <td>&nbsp;</td>
                                      </tr>
                                      <tr> 
                                        <td>&nbsp;</td>
                                        <td><form name="form1" method="post" action="">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                                              <tr> 
                                                <td width="28%">&nbsp;</td>
                                                <td width="72%"><strong><font color="#FF0000"><%=pageMessage%></font></strong></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2"><strong>Your Message 
                                                  </strong></td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td><textarea name="message" cols="30" rows="5" id="message"><%=message%></textarea></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2"><strong>Contact 
                                                  Information</strong></td>
                                              </tr>
                                              <tr> 
                                                <td nowrap><strong>Company Name: 
                                                  <br>
                                                  </strong></td>
                                                <td><input name="company" type="text" id="company" value="<%=company%>" size="30"></td>
                                              </tr>
                                              <tr> 
                                                <td><strong>Name: </strong></td>
                                                <td><input name="name" type="text" id="name" value="<%=name%>" size="30"></td>
                                              </tr>
                                              <tr> 
                                                <td><strong>E-mail: </strong></td>
                                                <td><input name="email" type="text" id="email" value="<%=email%>" size="30"></td>
                                              </tr>
                                              <tr> 
                                                <td><strong>Street: </strong></td>
                                                <td><input name="street" type="text" id="street" value="<%=street%>" size="30"></td>
                                              </tr>
                                              <tr> 
                                                <td><strong>City: </strong></td>
                                                <td><input name="city" type="text" id="city" value="<%=city%>" size="30"></td>
                                              </tr>
                                              <tr> 
                                                <td><strong>State: </strong></td>
                                                <td><input name="state" type="text" id="state" value="<%=state%>"  size="30"></td>
                                              </tr>
                                              <tr> 
                                                <td><strong>Postal Code:</strong></td>
                                                <td><input name="postalcode" type="text" id="postalcode" value="<%=postalcode%>" size="30"></td>
                                              </tr>
                                              <tr> 
                                                <td><strong>Country: </strong></td>
                                                <td><input name="country" type="text" id="country" value="<%=country%>" size="30"></td>
                                              </tr>
                                              <tr> 
                                                <td><strong>Phone: </strong></td>
                                                <td><input name="phone" type="text" id="phone" value="<%=phone%>" size="30"></td>
                                              </tr>
											 <tr> 
                                                <td><strong>Captcha *:</strong></td>
                                                <td> <%
												  ReCaptcha c = ReCaptchaFactory.newReCaptcha(reCaptchaPublicKey, reCaptchaPrivateKey, false);
												  out.print(c.createRecaptchaHtml(null, null));
												%></td>
                                              </tr>
                                              <tr> 
                                                <td> <input type="hidden" name="MM_update" value="form1"> 
                                                </td>
                                                <td><input type="submit" name="Submit" value="Submit"></td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                            </table>
                                          </form></td>
                                        <td>&nbsp;</td>
                                      </tr>
                                    </table>
<jsp:include page="../custom/rcfooter.jsp" flush="true" />
</body>
</html>
