<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.util.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>

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
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "products";
  MM_editRedirectUrl = "rcproductupdate.jsp";
  String MM_fieldsStr = "product_id|value|catcount|value|agrpcount|value|pgrpcount|value|order_|value|code|value|name|value|thumbnail|value|image|value|price|value|cost|value|desc_|value|weight|value|payment_type|value|taxable|value|active|value|store|value";
  String MM_columnsStr = "product_id|none,none,NULL|catcount|none,none,NULL|agrpcount|none,none,NULL|pgrpcount|none,none,NULL|order_|none,none,NULL|code|',none,''|name|',none,''|thumbnail|',none,''|image|',none,''|price|none,none,NULL|cost|none,none,NULL|desc_|',none,''|weight|none,none,NULL|payment_type|',none,''|taxable|none,1,0|active|none,1,0|store|',none,''";

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
  MM_editRedirectUrl = MM_editRedirectUrl +"?product_id="+MM_fields[1];
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
<!-- InstanceBeginEditable name="head" -->
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>

<!-- tinyMCE -->
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript" src="../jscripts/fulleditor.js"></script>
<!-- /tinyMCE -->
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
            <jsp:include page="adminleftnavi.jsp?screen=rcmerchant" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
<jsp:include page="../custom/storeconfig.jsp" flush="true" />
  <%
  	Random rnp = new Random();
	String newProductId = ""+Math.abs(rnp.nextInt());
	
  %>
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table width="100%">
                <tr valign="baseline"> 
                  <td width="134" align="left" nowrap>&nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td colspan="3" align="left" nowrap><strong>Add new product</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Product id:</td>
                  <td colspan="2"><%=newProductId%></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Order:</td>
                  <td colspan="2"> <input type="text" name="order_" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Code:</td>
                  <td colspan="2"> <input type="text" name="code" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Name:</td>
                  <td colspan="2"> <input type="text" name="name" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Thumbnail image:</td>
                  <td> <input type="text" name="thumbnail" value="../custom/media2/" size="32"> 
                  </td>
                  <td><a href="javascript:;" onClick="MM_openBrWindow('../administrator/upload.jsp?dir=media2','images','toolbar=yes,location=yes,scrollbars=yes,width=500,height=450')"> 
                    </a></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Full-seized image:</td>
                  <td width="165"> <input type="text" name="image" value="../custom/media2/" size="32"> 
                  </td>
                  <td width="187" nowrap>&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Price:</td>
                  <td colspan="2"> <input type="text" name="price" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Cost:</td>
                  <td colspan="2"> <input type="text" name="cost" value="" size="32"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="left" valign="top">Description:</td>
                  <td colspan="2" valign="baseline">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="3" align="left" valign="top" nowrap> <textarea name="desc_" cols="110" rows="60" class="mceEditor" id="desc_" > </textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Weight:</td>
                  <td colspan="2"> <input type="text" name="weight" value="" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Payment type:</td>
                  <td colspan="2"> <select name="payment_type">
                      <option value="onetime" selected>onetime</option>
					  <option value="recurrent" selected>recurrent</option>
					  <option value="variable" selected>variable</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Taxable:</td>
                  <td colspan="2"> <input type="checkbox" name="taxable" value=1 > 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Active:</td>
                  <td colspan="2"> <input type="checkbox" name="active" value=1 > 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Store:</td>
                  <td colspan="2"><input type="text" name="store" value="<%=(String)session.getValue("store")%>" size="32"></td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td colspan="2"> <input name="Update Record" type="submit" id="Update Record" value="Update Record" > 
                  </td>
                </tr>
              </table>

  <input type="hidden" name="product_id" value="<%=newProductId%>" size="32">
  <input type="hidden" name="catcount" value="" size="32">
  <input type="hidden" name="agrpcount" value="" size="32">
  <input type="hidden" name="pgrpcount" value="" size="32">
  
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
