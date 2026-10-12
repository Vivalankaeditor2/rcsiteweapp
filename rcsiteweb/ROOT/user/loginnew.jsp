<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" %>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<%@ include file="../Connections/dbconnection.jsp" %>

<%
String pageMessage = "";
if (request.getParameter("pagemessage") !=null) {pageMessage = (String)request.getParameter("pagemessage");}
String ad ="";

if (request.getParameter("consultant") !=null && request.getParameter("consultant").length()>0 ) {
	session.putValue("dcode",request.getParameter("consultant"));
}else{
	session.putValue("dcode","preferred");
}
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
%>
<%
// *** Redirect if username exists
String MM_flag="MM_insert";
boolean inputError = false;
if (request.getParameter(MM_flag) != null) {
 	String MM_dupKeyRedirect="../user/login.jsp?dcode="+(String)session.getValue("dcode");
  	String MM_rsKeyConnection=MM_dbconnection_STRING;
	if(request.getParameter("username").length()==0
		||request.getParameter("customer").length()==0 ){
		pageMessage ="Invalid Username or Public Name";
		inputError = true;
	}
	
	if(request.getParameter("pword")== null
		||request.getParameter("pword").length()==0
		||request.getParameter("pword2").length()==0
		||(!request.getParameter("pword").equals(request.getParameter("pword2")))){
		pageMessage ="Invalid Password";
		inputError = true;
	}
	//	\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b

	Pattern p = Pattern.compile(".+@.+\\.[a-z]+");
	Matcher m = p.matcher(request.getParameter("email"));
	if(!m.matches()){
		pageMessage ="Invalid Email";
		inputError = true;
	}

if(!inputError){
  String MM_dupKeyUsernameValue = request.getParameter("username");
   String MM_dupKeyCustomerValue = request.getParameter("customer");
  String MM_dupKeySQL = "SELECT username FROM rc_customer WHERE username='" +  treatStringParam(MM_dupKeyUsernameValue) + "' OR customer='" + treatStringParam(MM_dupKeyCustomerValue) + "'";
  Driver MM_rsKeyDriver = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
  Connection MM_rsKeyConn = DriverManager.getConnection(MM_rsKeyConnection,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
  PreparedStatement MM_rsKeyStatement = MM_rsKeyConn.prepareStatement(MM_dupKeySQL);
  ResultSet MM_rsKey = MM_rsKeyStatement.executeQuery();
  boolean MM_rsKey_isEmpty = !MM_rsKey.next();
  MM_rsKey.close(); // Close the recordset - we have all the info we need.
  MM_rsKeyConn.close();
     if (!MM_rsKey_isEmpty) {
   	pageMessage="Username/Public Name in use. Please try another one. " + MM_dupKeyUsernameValue+"/"+MM_dupKeyCustomerValue;
   	inputError = true;
   	}
 }
 
  
  if (inputError) {
    // the username was found - can not add the requested username
    String MM_qsChar = "?";
    if (MM_dupKeyRedirect.indexOf("?") >= 0) MM_qsChar = "&";
    MM_dupKeyRedirect = MM_dupKeyRedirect + MM_qsChar + "pagemessage="+pageMessage;
    response.sendRedirect(response.encodeRedirectURL(MM_dupKeyRedirect));
    return;
  }
}
%>
<%
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form2")) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "rc_customer";
  MM_editRedirectUrl = "/user/welcome.jsp?dcode="+(String)session.getValue("dcode");
//  String MM_fieldsStr = "username|value|pword|value|customer|value|age|value|gender|value|email|value|address|value|height_feet|value|height_inches|value|starting_weight|value|goal_weight|value|goal_date_value|value|goal_date_name|value|start_size|value|goal_size|value|high_bp|value|heart_conditions|value|food_allergies|value|other_medical|value|nursing|value|happy_energy|value|appetite_problem|value|water_glasses|value|favorite_foods|value|drink_coffee|value|drink_soda|value|drink_alcohol|value|smoking|value|consultant|value";
//  String MM_columnsStr = "username|',none,''|pword|',none,''|customer|',none,''|age|none,none,NULL|gender|',none,''|email|',none,''|address|',none,''|height_feet|none,none,NULL|height_inches|none,none,NULL|starting_weight|none,none,NULL|goal_weight|none,none,NULL|goal_date_value|none,none,NULL|goal_date_name|',none,''|start_size|none,none,NULL|goal_size|none,none,NULL|high_bp|',none,''|heart_conditions|',none,''|food_allergies|',none,''|other_medical|',none,''|nursing|',none,''|happy_energy|',none,''|appetite_problem|',none,''|water_glasses|none,none,NULL|favorite_foods|',none,''|drink_coffee|',none,''|drink_soda|',none,''|drink_alcohol|',none,''|smoking|',none,''|consultant|',none,''";
  String MM_fieldsStr = "username|value|pword|value|customer|value|email|value";
  String MM_columnsStr = "username|',none,''|pword|',none,''|customer|',none,''|email|',none,''";

  
 // String MM_fieldsStr = "username|value|pword|value|customer|value|email|value|type|value|consultant|value";
//  String MM_columnsStr = "username|',none,''|pword|',none,''|customer|',none,''|email|',none,''|type|',none,''|consultant|',none,''";

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
    MM_fields[i+1] = treatStringParam( MM_fields[i+1]);
  }
 
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
  MM_editQuery.append(" (").append(MM_tableValues.toString()).append(",age,gender,address,height_feet,height_inches,starting_weight,goal_weight,goal_date_value,goal_date_name,start_size,goal_size,high_bp,heart_conditions,food_allergies,other_medical,nursing,happy_energy,appetite_problem,water_glasses,favorite_foods,drink_coffee,drink_soda,drink_alcohol,smoking,type,consultant) values (");
  MM_editQuery.append(MM_dbValues.toString()).append(",NULL,'','',NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,'','','','','','','',NULL,'','','','','','NEW','"+(String)session.getAttribute("dcode")+"')");

  if (!MM_abortEdit) {
    // finish the sql and execute it
    Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
    Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(MM_editQuery.toString());
    MM_editStatement.executeUpdate();
    MM_connection.close();

    				session.putValue("MM_Username",request.getParameter("username"));
	                session.setAttribute("username", request.getParameter("username"));
                	session.setAttribute("customer",  request.getParameter("customer"));
                	session.setAttribute("memberType", request.getParameter("type"));
					session.setAttribute("MM_UserAuthorization", request.getParameter("type"));
					
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
	
      		MM_editRedirectUrl = ad;
			
		}else {
			MM_editRedirectUrl =request.getParameter("accessdenied");
		}
	   }

    // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0) {
      response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl));
      return;
    }
  }
}
%>
<jsp:include page="../custom/storeconfig.jsp" flush="true" />
<jsp:include page="/custom/rcdoctype.jsp" flush="true" />
<html lang="en">
<head>
<title>Login</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../custom/rchtmlhead.jsp" flush="true" />
</head>

<BODY leftMargin=0 topMargin=0 marginwidth="0" marginheight="0">
<jsp:include page="../custom/rcheader.jsp" flush="true" />
<jsp:include page="../custom/navibar.jsp" flush="true" />
<form method="post" action="<%=MM_editAction%>" name="form2">
                      <table align="center" class="text">
                        <tr valign="baseline"> 
                          <td colspan="2" align="left" nowrap><font color="#FF0000"><strong><%=pageMessage%></strong></font></td>
                        </tr>
                        <tr valign="baseline"> 
                          <td height="40" colspan="2" align="left" nowrap><strong>Create New 
                            Account</strong></td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="left">Username:</td>
                          <td> <input name="username" type="text" value="" size="20" maxlength="15"> 
                          </td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="left">Password:</td>
                          <td> <input name="pword" type="password" value="" size="20" maxlength="15"> 
                          </td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="left">Name</td>
                          <td> <input name="customer" type="text" value="" size="32" maxlength="50"> 
                          </td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="left">Email :</td>
                          <td> <input name="email" type="text" value="" size="32" maxlength="50"> 
                          </td>
                        </tr>
                        <tr valign="baseline"> 
                          <td nowrap align="left">&nbsp;</td>
                          <td> <input type="submit" value="Login"> </td>
                        </tr>
                      </table>
  <input type="hidden" name="type" value="NEW" size="32">
  <input type="hidden" name="consultant" value="<%=(String)session.getValue("dCode")%>" size="32">
  <input type="hidden" name="MM_insert" value="form2">
   
   <input type="hidden" name="age" value="" size="32">
  <input type="hidden" name="gender" value="" size="32">
  <input type="hidden" name="address" value="" size="32">
  <input type="hidden" name="height_feet" value="" size="32">
  <input type="hidden" name="height_inches" value="" size="32">
  <input type="hidden" name="starting_weight" value="" size="32">
  <input type="hidden" name="goal_weight" value="" size="32">
  <input type="hidden" name="goal_date_value" value="" size="32">
  <input type="hidden" name="goal_date_name" value="" size="32">
  <input type="hidden" name="start_size" value="" size="32">
  <input type="hidden" name="goal_size" value="" size="32">
  <input type="hidden" name="high_bp" value="" size="32">
  <input type="hidden" name="heart_conditions" value="" size="32">
  <input type="hidden" name="food_allergies" value="" size="32">
  <input type="hidden" name="other_medical" value="" size="32">
  <input type="hidden" name="nursing" value="" size="32">
  <input type="hidden" name="happy_energy" value="" size="32">
  <input type="hidden" name="appetite_problem" value="" size="32">
  <input type="hidden" name="water_glasses" value="" size="32">
  <input type="hidden" name="favorite_foods" value="" size="32">
  <input type="hidden" name="drink_coffee" value="" size="32">
  <input type="hidden" name="drink_soda" value="" size="32">
  <input type="hidden" name="drink_alcohol" value="" size="32">
  <input type="hidden" name="smoking" value="" size="32">


  
</form>
<p>&nbsp;</p>
<jsp:include page="../custom/rcfooter.jsp" flush="true" />
</body>
</html>
