<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.util.*,java.net.*,java.io.*,java.text.*,org.apache.log4j.Logger,com.rev_creations.rcsite.*" errorPage="" %>
<%@page import="java.util.Date"%>
<%@page import="sun.misc.BASE64Decoder"%>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<jsp:include page="../custom/storeconfig.jsp" flush="true" />
<%
String loggerRoot =  Config.getValue("webName").replaceAll("\\.","-")+": PayPalReceiver:";
Logger logger = Logger.getLogger(loggerRoot);
// read post from PayPal system and add 'cmd'
String papalNotification = "";

Enumeration en = request.getParameterNames();
String str = "cmd=_notify-validate";


while(en.hasMoreElements()){
	String paramName = (String)en.nextElement();
	String paramValue = request.getParameter(paramName);
	papalNotification = papalNotification+ "&" + paramName + "=" + paramValue;
	str = str + "&" + paramName + "=" + URLEncoder.encode(paramValue);
	
	System.out.println(paramName +"="+ paramValue );
}

 //Once user authorized the application, FB returns the following parameter
        String signedReq = request.getParameter("signed_request");

        if(signedReq == null)
        {
            System.out.println("ERROR: Unable to retrieve signed_request parameter");
        
        }

        int count = 0;
        String payload = null;
        
        //The parameter contains encoded signature and payload separated by ‘.’
        StringTokenizer st = new StringTokenizer(signedReq,".");    
        
        //Retrieve payload (Note: encoded signature is used for internal verification and it is optional)
        while (st.hasMoreTokens())
        {
            if(count == 1)
            {
                payload = st.nextToken();
                break;
            }
            else
                st.nextToken();           

            count++;
        }

        //Initialize Base64 decoder
        BASE64Decoder decoder = new BASE64Decoder();
        
        //Replace special character in payload as indicated by FB
        payload = payload.replace("-", "+").replace("_", "/").trim();
        
        //Decode payload
        try 
        {
            byte[] decodedPayload = decoder.decodeBuffer(payload);
            payload = new String(decodedPayload, "UTF8");
            System.out.println("payload =========" +payload);
        } 
        catch (IOException e) 
        {
            System.out.println("ERROR: Unable to perform Base64 Decode");
       
        }

        //JSON Decode - payload
        /*
        try 
        {
            JSONObject payloadObject = new JSONObject(payload);
            String facebookId = "" + payloadObject.get("user_id"); //Retrieve user ID
            String oauthToken = "" + payloadObject.get("oauth_token"); //Retrieve oauth token
        } 
        catch (JSONException e) 
        {
            System.out.println("ERROR: Unable to perform JSON decode");
            
        }
*/
     
//logger.info("Notification getQueryString from PayPal  ="+papalNotification);
//logger.info("Notification param to PayPal "+str);

// post back to PayPal system to validate
// NOTE: change http: to https: in the following URL to verify using SSL (for increased security).
// using HTTPS requires either Java 1.4 or greater, or Java Secure Socket Extension (JSSE)
// and configured for older versions.
URL u = null;
	
	if("test".equalsIgnoreCase(Config.getValue("rcmerchant.storeMode"))) {
	 	u = new URL("https://developers.facebook.com");
		//System.out.println("Paypal Test URL");
	}else{
		u = new URL("https://developers.facebook.com");
	//	System.out.println("Paypal Production URL");
	}

URLConnection uc = u.openConnection();
uc.setDoOutput(true);
uc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
PrintWriter pw = new PrintWriter(uc.getOutputStream());
pw.println(str);
pw.close();

BufferedReader in = new BufferedReader(
new InputStreamReader(uc.getInputStream()));
String res = in.readLine();
in.close();


// assign posted variables to local variables
String itemName 		= request.getParameter("item_name");
String itemNumber 		= request.getParameter("item_number");
String paymentStatus 	= request.getParameter("payment_status");
String paymentAmountString 	= request.getParameter("mc_gross");
String paymentCurrency 	= request.getParameter("mc_currency");
String txnId 			= request.getParameter("txn_id");
String receiverEmail 	= request.getParameter("receiver_email");
String payerEmail 		= request.getParameter("payer_email");
String orderId			=request.getParameter("custom");
String paymentDateString=request.getParameter("payment_date");
String txnType 			=request.getParameter("txn_type");
String subscrId			=request.getParameter("subscr_id");
String verifySign		=request.getParameter("verify_sign"); 
String payerId			=request.getParameter("payer_id");
String ipnTrackId		=request.getParameter("ipn_track_id");

boolean sendEmails = false;
boolean txnIdFound = false;
boolean orderIdFound = false;
float paymentAmount =0;
Timestamp paymentDate = null;
int orderIdInt =0;
String sqlString ="";




//logger.info("Verification response from PayPal: "+res);
//check notification validation

if(("VERIFIED".equals(res) && ("web_accept".equals(txnType) ||"subscr_payment".equals(txnType) ) )
//|| "test".equalsIgnoreCase(Config.getValue("rcmerchant.storeMode"))
																	) {
	try{
		paymentAmount = Float.parseFloat(paymentAmountString);
	}catch(Exception ex){
		logger.error("paymentAmountString parsing error "+papalNotification,ex);
	}
	try{
		orderIdInt = Integer.parseInt(orderId);
	}catch(Exception ex){
		logger.error("orderId parsing error "+papalNotification,ex);
	}
	
	try{
	//17:51:36 Jan 14, 2012 PST
		DateFormat formatter = new SimpleDateFormat("HH:mm:ss MMM dd',' yyyy Z");
		java.util.Date paymentDateTemp = (Date)formatter.parse(paymentDateString);
		
		paymentDate = new Timestamp(paymentDateTemp.getTime());
	}catch(Exception ex){
		logger.error("Date parsing error "+papalNotification,ex);
	}

	Connection MM_connection  = rcsiteDS.getConnection();
	PreparedStatement MM_Statement = null;


/*
Confirm that the "payment_status" is "Completed," since IPNs are also sent for other results 
			such as "Pending" or "Failed"
Validate that the "receiver_email" is an email address registered in your PayPal account, 
			to prevent the payment from being sent to a fraudster's account
	
Check that the "txn_id" is not a duplicate to prevent a fraudster from using reusing an old, 
			completed transaction
SELECT order_no, order_charges.order_id, orders.order_id, charge_id
FROM (orders left join order_charges on order_charges.order_id=orders.order_id)
where (charge_id =1 or orders.order_id ='1390954916' )

order_charges
add column create_datetime timestamp
add column txn_id varchar(100)  =3DY54566UT116712L
add column payment_datetime datetime  = 17:51:36 Jan 14, 2012 PST
add column payment_details tinytext – all param
add column txn_type varchar(50)  =subscr_payment
add column payment_status varchar(50)  =Completed
add column reference1  varchar(100), subscr_id=I-AAWV3B12NKF5
add column reference2  varchar(100), verify_sign                   =AfhkDkYrbjpYBAcJGSuyxXscNPHzAN2juY5SQtadkH2gE-wzVQlIScS1
add column reference3  varchar(100), payer_id=695HNZZ23695L
add column reference4  varchar(100), payer_email=ca_cus_1296322386_per@msn.com
add column reference5  varchar(100), ipn_track_id=19LqwAMqYa.98Q3xnvpgIw
add column reference6  varchar(100),
add column reference7  varchar(100),
add column reference8  varchar(100),
add column reference9  varchar(100),
add column reference10  varchar(100),

Check other transaction details such as the item number and price to confirm that the price has not been changed
*/
	sqlString = "SELECT order_no, order_charges.order_id, orders.order_id,  order_charges.txn_id "
						+"FROM (orders left join order_charges on order_charges.order_id=orders.order_id)"
						+"where (order_charges.txn_id =? or orders.order_id =?)";
	
	MM_Statement = MM_connection.prepareStatement(sqlString);
	
	MM_Statement.setString(1, txnId);
	MM_Statement.setInt(2,orderIdInt);
		
	ResultSet MM_Recordset = MM_Statement.executeQuery();
	boolean MM_Recordset_isEmpty = !MM_Recordset.next();
	boolean MM_Recordset_hasData = !MM_Recordset_isEmpty;
	Object MM_Recordset_data;
	int MM_Recordset_numRows = 0;
	
	int Repeat1__numRows = -1;
	int Repeat1__index = 0;
	//ItemRecordset_numRows += Repeat1__numRows;

	while ((MM_Recordset_hasData)&&(Repeat1__numRows-- != 0)) { 
	
		if(txnId.equalsIgnoreCase(MM_Recordset.getString("order_charges.txn_id"))){
			txnIdFound = true; //duplicate notification no need to enter to order charge; log error.
		}
		if(orderId.equalsIgnoreCase(MM_Recordset.getString("orders.order_id"))){
			orderIdFound = true; //valid order; enter to order charge table; else log error.
		}
		Repeat1__index++;
  		MM_Recordset_hasData = MM_Recordset.next();
	
	}
	
	if(!txnIdFound && orderIdFound ){
		MM_Statement.close();
		sqlString= "insert into order_charges (`order_id`,`charge_id`,`module_id`,`type`,`desc_`, `amount`,`disp_amt`,"
        			+"`tax_exempt`,"//`create_datetime`, 
        											+"`reference10` ,`txn_id`,`payment_datetime`,`payment_details`,`txn_type`,`payment_status`,"
        			+"`reference1`,`reference2`,`reference3`,`reference4`,`reference5`,`reference6`,`reference7`,"
        			+"`reference8`,`reference9` ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        			
		MM_Statement = MM_connection.prepareStatement(sqlString);

		
		MM_Statement.setString(1, orderId);
		MM_Statement.setInt(2,1);
		MM_Statement.setInt(3,1);
		MM_Statement.setString(4,"type");
		MM_Statement.setString(5,"desc_");
		MM_Statement.setFloat(6,paymentAmount);
		MM_Statement.setFloat(7,paymentAmount);
        MM_Statement.setInt(8,0);
       // MM_Statement.setDate(9,new java.sql.Date()); time stamp
        MM_Statement.setString(9,"reference10");
        MM_Statement.setString(10,txnId);
        MM_Statement.setTimestamp(11,paymentDate);//payment_datetime`,
        MM_Statement.setString(12,papalNotification);
        MM_Statement.setString(13,txnType);
        MM_Statement.setString(14,paymentStatus);
        MM_Statement.setString(15,subscrId); //subscr_id
        MM_Statement.setString(16,verifySign);// verify_sign 
        MM_Statement.setString(17,payerId); //reference3`,
        MM_Statement.setString(18,payerEmail);//reference4`,
        MM_Statement.setString(19,ipnTrackId);//reference5`,
        MM_Statement.setString(20,receiverEmail);//reference6`,
        
        if(!(receiverEmail!= null && receiverEmail.equalsIgnoreCase(Config.getValue("rcmerchant.billingEmail")))){
 			MM_Statement.setString(21,"check receiver email"); //reference7
 			logger.error("invalid receiver email "+receiverEmail);
		}else{
			MM_Statement.setString(21,"reference7");
		}
       
        MM_Statement.setString(22,"reference8");
        MM_Statement.setString(23,"reference9");
        //MM_Statement.setString(24,"reference10");
               	
	    MM_Statement.executeUpdate();
	    
	    if("Completed".equalsIgnoreCase(paymentStatus)){
	         sendEmails = true; 
	    }
		
	}else{
		logger.error("duplicate txnId or invalid orderId " +papalNotification);
	}		
    
	if(sendEmails){
%>


<%
	}
	
	MM_Recordset.close();
	MM_Statement.close();
    MM_connection.close();
	
}else if("VERIFIED".equals(res)){
  logger.error("VERIFIED response from PayPal but not a payment " +papalNotification);
}else if(res.equals("INVALID")) {
// log for investigation
//out.println("loged for investigation");
logger.error("INVALID response from PayPal " +papalNotification);

}else {
// error
//out.println("error");
//logger.error("error response from PayPal "+papalNotification);
}
%>

<html lang="en">
<head>
<title>Received</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
Rev-creations, Inc. News Poster App.
</body>
</html>
