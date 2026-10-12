<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
// *** Edit Operations: declare variables

// set the form action variable
String MM_editAction = request.getRequestURI();
if (request.getQueryString() != null && request.getQueryString().length() > 0) {
  String queryString = request.getQueryString();
  String tempStr = "";
  for (int i=0; i < queryString.length(); i++) {
    if (queryString.charAt(i) == '<') tempStr = tempStr + "&lt;";
    else if (queryString.charAt(i) == '>') tempStr = tempStr + "&gt;";
    else if (queryString.charAt(i) == '"') tempStr = tempStr +  "&quot;";
    else tempStr = tempStr + queryString.charAt(i);
  }
  MM_editAction += "?" + tempStr;
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
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {


  MM_editTable  = "coupons";
  MM_editRedirectUrl = "couponslist.jsp";
  String MM_fieldsStr = "CODE|value|EXP_DATE|value|AMOUNT|value|PERCENT|value|MAX_REDEEM|value|MIN_STOTAL|value|TAX|value|PROD|value|PMIN_QTY|value|PQUAN|value|PMAX_QTY|value|PRODUCTS|value|PSTOTAL|value|REDEEMED|value|CPN_MORE|value|CPN_MAX|value|ONE_CUST|value|PROD_EXCLD|value|NOTES|value|ZIP|value|ZIP_LIST|value|FREE_SHIP|value|FSHIP_METH|value|PMIN_SUB|value|MAX_DISCNT|value|STATE|value|STATE_LIST|value|CNTRY|value|CNTRY_LIST|value|AVLGRP|value|PRCGRP|value";
  String MM_columnsStr = "CODE|',none,''|EXP_DATE|',none,NULL|AMOUNT|none,none,NULL|PERCENT|none,none,NULL|MAX_REDEEM|none,none,NULL|MIN_STOTAL|none,none,NULL|TAX|none,none,NULL|PROD|none,none,NULL|PMIN_QTY|none,none,NULL|PQUAN|none,none,NULL|PMAX_QTY|none,none,NULL|PRODUCTS|',none,''|PSTOTAL|none,none,NULL|REDEEMED|none,none,NULL|CPN_MORE|none,none,NULL|CPN_MAX|none,none,NULL|ONE_CUST|none,none,NULL|PROD_EXCLD|none,none,NULL|NOTES|',none,''|ZIP|none,none,NULL|ZIP_LIST|',none,''|FREE_SHIP|none,none,NULL|FSHIP_METH|',none,''|PMIN_SUB|none,none,NULL|MAX_DISCNT|none,none,NULL|STATE|none,none,NULL|STATE_LIST|',none,''|CNTRY|none,none,NULL|CNTRY_LIST|',none,''|AVLGRP|none,none,NULL|PRCGRP|none,none,NULL";

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
   // Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
  //  Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	 Connection MM_connection = rcsiteDS.getConnection();
    PreparedStatement MM_editStatement = MM_connection.prepareStatement(MM_editQuery.toString());
    MM_editStatement.executeUpdate();
    MM_connection.close();

    // redirect with URL parameters
    if (MM_editRedirectUrl.length() != 0) {
      response.sendRedirect(response.encodeRedirectURL(MM_editRedirectUrl));
      return;
    }
  }
}
%>

<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
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
            <jsp:include page="adminleftnavi.jsp?screen=rcmerchant" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
	<br/>	<br/>	<br/>
<form method="post" action="<%=MM_editAction%>" name="form1">
  <table align="center">
      <tr align="left" valign="baseline">
      <td colspan="2" nowrap><strong class="title"> Add Coupon a Code </strong></td>
      </tr>
    <tr valign="baseline">
      <td align="right" nowrap class="title">CODE:</td>
      <td>
        <input type="text" name="CODE" value="" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td align="right" nowrap class="title">AMOUNT:</td>
      <td>
        <input type="text" name="AMOUNT" value="" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td align="right" nowrap class="title">PERCENT:</td>
      <td>
        <input type="text" name="PERCENT" value="" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td align="right" nowrap class="title">PRODUCTS:</td>
      <td>
        <textarea name="PRODUCTS" cols="32" rows="5"></textarea>
      </td>
    </tr>
    <tr valign="baseline">
      <td align="right" nowrap class="title">NOTES:</td>
      <td>
        <input type="text" name="NOTES" value="" size="32">
      </td>
    </tr>
    <tr valign="baseline">
      <td align="right" nowrap class="title">&nbsp;</td>
      <td>
        <p>
          <input type="hidden" name="ZIP" value="" size="32">
          <input type="hidden" name="ZIP_LIST" value="" size="32">
          <input type="hidden" name="FREE_SHIP" value="" size="32">
          <input type="hidden" name="FSHIP_METH" value="" size="32">
          <input type="hidden" name="PMIN_SUB" value="" size="32">
          <input type="hidden" name="MAX_DISCNT" value="" size="32">
          <input type="hidden" name="STATE" value="" size="32">
          <input type="hidden" name="STATE_LIST" value="" size="32">
          <input type="hidden" name="CNTRY" value="" size="32">
          <input type="hidden" name="CNTRY_LIST" value="" size="32">
          <input type="hidden" name="AVLGRP" value="" size="32">
          <input type="hidden" name="PRCGRP" value="" size="32">
		  <input type="hidden" name="MAX_REDEEM" value="" size="32">
          <input type="hidden" name="EXP_DATE" value="" size="32">
        </p>
        <p>            <input type="hidden" name="MIN_STOTAL" value="" size="32">
            <input type="hidden" name="TAX" value="0" size="32">
            <input type="hidden" name="PROD" value="" size="32">
            <input type="hidden" name="PMIN_QTY" value="" size="32">
            <input type="hidden" name="PQUAN" value="" size="32">
            <input type="hidden" name="PMAX_QTY" value="" size="32">
            <input type="hidden" name="PSTOTAL" value="" size="32">
            <input type="hidden" name="CPN_MORE" value="" size="32">
            <input type="hidden" name="ONE_CUST" value="" size="32">
            <input type="hidden" name="PROD_EXCLD" value="" size="32">
            <input type="hidden" name="CPN_MAX" value="" size="32">
			 <input type="hidden" name="REDEEMED" value="" size="32">
        </p></td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">&nbsp;</td>
      <td>
        <input type="submit" value="Insert record">
      </td>
    </tr>
  </table>
  <input type="hidden" name="MM_insert" value="form1">
</form>
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
