<%@ page import="java.util.*"%>
<%
String store="usa";

if((String)session.getValue("store")!=null && (!((String)session.getValue("store")).equals(""))){
store =(String)session.getValue("store");
}

if (request.getParameter("store") !=null && !request.getParameter("store").equals("")) {
	store = (String)request.getParameter("store");
}
if (request.getParameter("store") !=null && request.getParameter("store").equals("null")) {
	store ="usa";// (String)request.getParameter("store");
}

if (session.getValue("order_id") != null && !session.getValue("order_id").equals("")) {
 	
}else{
Random rn = new Random();
	String orderId = ""+Math.abs(rn.nextInt());
	session.putValue("order_id", orderId);
	
}
%>

<%
String countryShort; 
String countryLong ;
String currencySymbol;
String currencyCode;
String weightUnit;
String shippingMethod;
String packaging;
String shipping ;
String payMethod;

String headerBG="#0000FF";
String listBG="#C8E4FF";
String numberOfStores="6";
String discounting="true";

if(store.equalsIgnoreCase("cnd")){
	countryShort ="CND";
	countryLong ="CANADA";
	currencySymbol="CN$";
	currencyCode="CAD";
	weightUnit ="kg";
	shippingMethod="UPS/FedEx";
	packaging ="7";
	shipping =".07";
	payMethod="PayPal (All major credit card types.)";
 
}else if(store.equalsIgnoreCase("uk")){
	countryShort ="UK";
	countryLong ="UNITED KINGDOM";
	currencySymbol="£";
	currencyCode="GBP";
	weightUnit ="kg";
	shippingMethod="Packaging + Free Express Freight";
	packaging ="5";
	shipping ="0";
	payMethod="PayPal (All major credit card types.)";
 
}else if(store.equalsIgnoreCase("nl")){
	countryShort ="NL";
	countryLong ="NETHERLANDS";
	currencySymbol="€";
	currencyCode="EUR";
	weightUnit ="kg";
	shippingMethod="Packaging + Free Express Freight";
	packaging ="0";
	shipping ="0";
	payMethod="PayPal (All major credit card types.)";
 
}else if(store.equalsIgnoreCase("it")){
	countryShort ="IT";
	countryLong ="ITALY";
	currencySymbol="€";
	currencyCode="EUR";
	weightUnit ="kg";
	shippingMethod="Packaging +  Freight";
	packaging ="0";
	shipping ="0";
	payMethod="PayPal (All major credit card types.)";
 
}else if(store.equalsIgnoreCase("de")){
	countryShort ="DE";
	countryLong ="GERMANY";
	currencySymbol="€";
	currencyCode="EUR";
	weightUnit ="kg";
	shippingMethod="Packaging + Freight";
	packaging ="0";
	shipping ="0";
	payMethod="PayPal (All major credit card types.)";
 
}else if(store.equalsIgnoreCase("es")){
	countryShort ="ES";
	countryLong ="SPAIN";
	currencySymbol="€";
	currencyCode="EUR";
	weightUnit ="kg";
	shippingMethod="Packaging + Freight";
	packaging ="0";
	shipping ="0";
	payMethod="PayPal (All major credit card types.)";
 
}else if(store.equalsIgnoreCase("fr")){
	countryShort ="FR";
	countryLong ="FRANCE";
	currencySymbol="€";
	currencyCode="EUR";
	weightUnit ="kg";
	shippingMethod="Packaging + Freight";
	packaging ="0";
	shipping ="0";
	payMethod="PayPal (All major credit card types.)";
 
}else{
store="usa";
countryShort ="USA"; 
countryLong ="United States";
currencySymbol="$";
currencyCode="USD";
weightUnit ="pounds";
shippingMethod="FedEx Home Delivery";
packaging ="7";
shipping =".07";
payMethod="PayPal";
}

session.putValue("store", store);
session.putValue("countryShort", countryShort);
session.putValue("countryLong", countryLong);
session.putValue("currencySymbol", currencySymbol);
session.putValue("currencyCode", currencyCode);
session.putValue("weightUnit", weightUnit);
session.putValue("shippingMethod", shippingMethod);
session.putValue("packaging", packaging);
session.putValue("shipping", shipping); 
session.putValue("payMethod", payMethod);
session.putValue("headerBG", headerBG);
session.putValue("numberOfStores", numberOfStores);
session.putValue("discounting", discounting);
session.putValue("listBG", listBG);
	
/********************/

String dcode ="preferred";
String billingEmail ;

if((String)session.getValue("dcode")!=null && (!((String)session.getValue("dcode")).equals(""))){
		dcode =(String)session.getValue("dcode");
}
if (request.getParameter("dcode") !=null && !request.getParameter("dcode").equals("")) {
	dcode = (String)request.getParameter("dcode");
}
if (request.getParameter("dcode") !=null && request.getParameter("dcode").equals("null")) {
	dcode = "preferred"; //(String)request.getParameter("dcode");
}


String dcodechecker = (String)session.getValue("dcodechecker");
	if(dcode != null && dcodechecker != null && !dcodechecker.equalsIgnoreCase("") ){
		dcode = dcodechecker; 
		
	}




 if(dcode.equalsIgnoreCase("cool")) {
		billingEmail ="billing@vivalanka.com";
}else
 {      dcode ="preferred";
		billingEmail ="billing@vivalanka.com";
}

session.putValue("dcode", dcode);
session.putValue("billingEmail", billingEmail);




session.setMaxInactiveInterval(3600);


%>
