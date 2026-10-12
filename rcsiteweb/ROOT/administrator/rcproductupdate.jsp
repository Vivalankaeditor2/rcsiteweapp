<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*, java.io.*" errorPage="" %>
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
// *** Update Record: set variables

if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_update").toString().equals("form1") &&
    request.getParameter("MM_recordId") != null) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "products";
  MM_editColumn = "code";
  MM_recordId   = "'" + request.getParameter("MM_recordId") + "'";
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
  if (MM_editRedirectUrl.length() != 0 && request.getQueryString() != null) {
    MM_editRedirectUrl += ((MM_editRedirectUrl.indexOf('?') == -1)?"?":"&") + request.getQueryString();
  }
}
%>
<%
// *** Update Record: construct a sql update statement and execute it

if (request.getParameter("MM_update") != null &&
    request.getParameter("MM_recordId") != null) {

  // create the update sql statement
  MM_editQuery = new StringBuffer("update ").append(MM_editTable).append(" set ");
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
    MM_editQuery.append((i!=0)?",":"").append(MM_columns[i]).append(" = ").append(formVal);
  }
  MM_editQuery.append(" where ").append(MM_editColumn).append(" = ").append(MM_recordId);
  
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
<%
String ProductRecordset__MMColParam = "1";
if (request.getParameter("product_id") !=null) {ProductRecordset__MMColParam = (String)request.getParameter("product_id");}
String productId = ProductRecordset__MMColParam;
%>
<%
//Driver DriverProductRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnProductRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnProductRecordset = rcsiteDS.getConnection();
PreparedStatement StatementProductRecordset = ConnProductRecordset.prepareStatement("SELECT * FROM products WHERE product_id = '" + ProductRecordset__MMColParam + "'");
ResultSet ProductRecordset = StatementProductRecordset.executeQuery();

String productDescr = "";
ByteArrayOutputStream ByteoutDetails = new ByteArrayOutputStream(1024);
    try
    {
        BufferedInputStream ByteinDetails = new BufferedInputStream( ProductRecordset.getBinaryStream("desc_") );
        byte ByteIndata[]= new byte[100000] ;
        int Bytesread = 0;
        // Make sure its not a NULL value in the column:
        if ( !ProductRecordset.wasNull() )
        {
            if ( (Bytesread = ByteinDetails.read(ByteIndata,0,ByteIndata.length)) != -1 )
            {
                // Write out 'bytesread' bytes to the writer instance:
                ByteoutDetails.write(ByteIndata,0,Bytesread);
                productDescr = ByteoutDetails.toString();
            }
            else
            {
                // When the read() method returns -1 we've hit the end of the stream,
                // so now we can get our bytes out of the writer object:
                //allBytesInBlob = baos.getBytes();
                productDescr = ByteoutDetails.toString();
            }
        }
    }
    catch(Exception ex)
    {
        // The driver could not handle this as a BLOB...
        // Fallback to default (and slower) byte[] handling
        // byte[] bytes = Recordset1.getBytes(1);
        productDescr = "error" ;
    }



boolean ProductRecordset_isEmpty = !ProductRecordset.next();
boolean ProductRecordset_hasData = !ProductRecordset_isEmpty;
Object ProductRecordset_data;
int ProductRecordset_numRows = 0;
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
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
<%
String naviUrl ="producteditnavibar.jsp?product_id=" +productId;
%>	
		<jsp:include page="<%= naviUrl%>" flush="true" />
<form method="post" action="<%=MM_editAction%>" name="form1">
              <table width="100%" align="center">
                <tr valign="baseline"> 
                  <td colspan="3" align="left" nowrap><strong>Update Product Details</strong></td>
                </tr>
                <tr valign="baseline"> 
                  <td width="26%" align="left" nowrap>Order:</td>
                  <td colspan="2"> <input type="text" name="order_" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("order_"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Code:</td>
                  <td colspan="2"> <input type="text" name="code" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("code"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Name:</td>
                  <td colspan="2"> <input type="text" name="name" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("name"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Thumbnail:</td>
                  <td width="33%"> <input type="text" name="thumbnail" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("thumbnail"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                  <td width="41%">&nbsp;</td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Image:</td>
                  <td colspan="2"> <input type="text" name="image" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("image"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Price:</td>
                  <td colspan="2"> <input type="text" name="price" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("price"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Cost:</td>
                  <td colspan="2"> <input type="text" name="cost" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("cost"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr> 
                  <td nowrap align="left" valign="top">Desc:</td>
                  <td colspan="2" valign="baseline">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="3" align="left" valign="top" nowrap> <textarea name="desc_" cols="110" rows="60" class="mceEditor" id="desc_">
           					<%
							if(productDescr.equalsIgnoreCase("error")){
							out.print((((ProductRecordset_data = ProductRecordset.getObject("desc_"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data));
							}else {out.print(productDescr);}%></textarea> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Weight:</td>
                  <td colspan="2"> <input type="text" name="weight" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("weight"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Payment type:</td>
                  <td colspan="2"> <select name="payment_type">
                      <option value="onetime"  <%=(("onetime".toString().equals((((ProductRecordset_data = ProductRecordset.getObject("payment_type"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)))?"SELECTED":"")%>>onetime</option>
                      <option value="recurrent"  <%=(("recurrent".toString().equals((((ProductRecordset_data = ProductRecordset.getObject("payment_type"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)))?"SELECTED":"")%>>recurrent</option>
					  <option value="variable"  <%=(("variable".toString().equals((((ProductRecordset_data = ProductRecordset.getObject("payment_type"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)))?"SELECTED":"")%>>variable</option>
                    </select> </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Taxable:</td>
                  <td colspan="2"> <input <%=(((((ProductRecordset_data = ProductRecordset.getObject("taxable"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data).toString().equals(("1").toString()))?"checked":"")%> type="checkbox" name="taxable" value=1 > 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Active:</td>
                  <td colspan="2"> <input <%=(((((ProductRecordset_data = ProductRecordset.getObject("active"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data).toString().equals(("1").toString()))?"checked":"")%> type="checkbox" name="active" value=1 > 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">Store:</td>
                  <td colspan="2"> <input type="text" name="store" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("store"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                </tr>
                <tr valign="baseline"> 
                  <td nowrap align="left">&nbsp;</td>
                  <td colspan="2"> <input name="Update Record" type="submit" id="Update Record" value="Update Record" onclick="return onSubmitCompose(1,this);"> 
                  </td>
                </tr>
              </table>
  <input type="hidden" name="product_id" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32">
  <input type="hidden" name="catcount" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("catcount"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32">
  <input type="hidden" name="agrpcount" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("agrpcount"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32">
  <input type="hidden" name="pgrpcount" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("pgrpcount"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32">
  <input type="hidden" name="MM_update" value="form1">
  <input type="hidden" name="MM_recordId" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("code"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>">


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
<%
ProductRecordset.close();
StatementProductRecordset.close();
ConnProductRecordset.close();
%>
