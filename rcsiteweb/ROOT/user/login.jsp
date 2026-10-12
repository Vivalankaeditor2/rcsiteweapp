<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%
if (session.getValue("store")==null || ((String)session.getValue("store")).equals("")) {
	session.putValue("store", "usa"); 
}
if (request.getParameter("store") !=null && !request.getParameter("store").equals("")) {
	session.putValue("store", (String)request.getParameter("store")); 
}
String pageMessage = "";
if (request.getParameter("pagemessage") !=null) {pageMessage = (String)request.getParameter("pagemessage");}
String ad ="";
  String accde = request.getParameter("accessdenied");

// set the form action variable
String MM_editAction = "../user/loginnew.jsp";
if (request.getQueryString() != null && request.getQueryString().length() > 0) {
  MM_editAction += "?" + request.getQueryString(); //if remove accessdenied redirect is not working. -Jan 15 2012
}

// *** Validate request to log in to this site.
String MM_LoginAction = request.getRequestURI();
if (request.getQueryString() != null && request.getQueryString().length() > 0) {
 MM_LoginAction += "?" + request.getQueryString(); //if remove accessdenied redirect is not working. -Jan 15 2012
}
String MM_valUsername=request.getParameter("username");
if (MM_valUsername != null) {


  String MM_fldUserAuthorization="type";
  String MM_redirectLoginSuccess="welcome.jsp";
  String MM_redirectLoginFailed="../user/login.jsp?pagemessage=Invalid%20Username/Password.%20";
  String MM_redirectLogin=MM_redirectLoginFailed;
  boolean inputError = false;
  	if(request.getParameter("username").length()==0
  		||request.getParameter("password")== null
		||request.getParameter("password").length()==0){
		inputError = true;
	}
  if(!inputError){
  
//  Driver MM_driverUser = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//  Connection MM_connUser = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
   Connection MM_connUser = rcsiteDS.getConnection();
  String MM_pSQL = "SELECT username, customer, pword, consultant";
  if (!MM_fldUserAuthorization.equals("")) MM_pSQL += "," + MM_fldUserAuthorization;
  MM_pSQL += " FROM rc_customer WHERE username=\'" + MM_valUsername.replaceAll("'", " ") + "\' AND pword=\'" + request.getParameter("password").toString().replaceAll("'", " ") + "\'";
  PreparedStatement MM_statementUser = MM_connUser.prepareStatement(MM_pSQL);
  ResultSet MM_rsUser = MM_statementUser.executeQuery();
  boolean MM_rsUser_isNotEmpty = MM_rsUser.next();
  if (MM_rsUser_isNotEmpty) {
    // username and password match - this is a valid user
    session.putValue("MM_Username", MM_valUsername);
	                session.setAttribute("username", MM_valUsername);
                	session.setAttribute("customer", MM_rsUser.getString("customer"));
                	session.setAttribute("memberType", MM_rsUser.getString("type"));
					if(MM_rsUser.getString("consultant")!=null){
						session.setAttribute("dcode", MM_rsUser.getString("consultant"));
						session.setAttribute("dcodechecker", MM_rsUser.getString("consultant"));
					}else if(session.getValue("dcode")!=null){
						session.setAttribute("dcodechecker", session.getValue("dcode"));
					}
    if (!MM_fldUserAuthorization.equals("")) {
      session.putValue("MM_UserAuthorization", MM_rsUser.getString(MM_fldUserAuthorization).trim());
    } else {
      session.putValue("MM_UserAuthorization", "");
    }
  //System.out.println(request.getParameter("accessdenied"));
    if ((request.getParameter("accessdenied") != null) && true) {
	    if ((request.getParameter("accessdenied").indexOf("dcode")>0) ) {
			ad = request.getParameter("accessdenied");
			String s1="";
    		String s2="";
    		String s3="dcode="+session.getValue("dcode");
    		int start = ad.indexOf("dcode");
    		int end ;

    		if(ad.indexOf("%26",start)>-1)  {
      			end = ad.indexOf("%26",start);
   		 	}else {
      			end = ad.length();
   			 }

   			 s1=ad.substring(0,start);
    		s2=ad.substring(end);
    		ad=s1+s2+s3;
	
      		MM_redirectLoginSuccess = ad;
			
		}else {
			MM_redirectLoginSuccess =request.getParameter("accessdenied");
		}
	   }
	 if(MM_rsUser.getString("type").equalsIgnoreCase("CONSULTANT")){
  			MM_redirectLoginSuccess="../administrator/index.jsp"; 
  		}else if(MM_rsUser.getString("type").equalsIgnoreCase("ADMINISTRATOR")){
  			MM_redirectLoginSuccess="../administrator/index.jsp"; 
		}
    MM_redirectLogin=MM_redirectLoginSuccess;
  }
  MM_rsUser.close();
  MM_connUser.close();
  
  }
  
  response.sendRedirect(response.encodeRedirectURL(MM_redirectLogin));
  String dcode =(String)session.getValue("dcode");
   dcode =(String)session.getAttribute("dcode");
  return;
}
String store =(String)session.getValue("store");
String dcode =(String)session.getValue("dcode");
%><jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en"> 
<head>
<title>Login</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />

</head>

<BODY leftMargin=0 topMargin=0 marginwidth="0" marginheight="0">
<jsp:include page="../custom/rcheader.jsp" flush="true" />
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                      <tr> 
                        <td width="41%">&nbsp;</td>
                        <td width="8%">&nbsp;</td>
                        <td width="51%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
                      </tr>
                      <tr> 
                        <td valign="top"><form action="<%=MM_LoginAction%>" method="POST" name="form1">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                              <tr> 
                                <td colspan="2"><b>Existing Customers</b></td>
                              </tr>
                              <tr> 
                                <td width="26%" align="left">UserName:</td>
                                <td width="74%"><div class="rc_input_space"> <input name="username" type="text" id="username" size="15" class="rc_input" ></div></td>
                              </tr>
                              <tr> 
                                <td align="left">Password:</td>
                                <td><div class="rc_input_space"> <input name="password" type="password" id="password" size="15" class="rc_input" ></div></td>
                              </tr>
                              <tr> 
                                <td height="24" align="left">&nbsp;</td>
                                <td><div class="rc_input_space"><input type="submit" name="Submit2" value="Login" class="rc_button"></div></td>
                              </tr>
                              <tr> 
                                <td colspan="2"><span ><a  class="rc_text_link" href="passwordrecovery.jsp?dcode=<%=dcode%>&store=<%=store%>">Forgot 
                                  your password/username ?</a></span></td>
                              </tr>
                            </table>
                          </form></td>

					    			  
                    </table>
<jsp:include page="../custom/rcfooter.jsp" flush="true" />
</body>
</html>
