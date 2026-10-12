<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
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
  MM_editColumn = "product_id";
  MM_recordId   = "" + request.getParameter("MM_recordId") + "";
  MM_editRedirectUrl = "";
  String MM_fieldsStr = "product_id|value|code|value|order_|value|name|value|price|value|cost|value|weight|value|taxable|value|active|value";
  String MM_columnsStr = "product_id|none,none,NULL|code|',none,''|order_|none,none,NULL|name|',none,''|price|none,none,NULL|cost|none,none,NULL|weight|none,none,NULL|taxable|none,1,0|active|none,1,0";

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
String store =(String)session.getValue("store");
String ProductRecordset__MMColParam =(String)session.getValue("store");
if (request.getParameter("store") !=null) {ProductRecordset__MMColParam = (String)request.getParameter("store");}
if (request.getParameter("storeform") !=null) {ProductRecordset__MMColParam = (String)request.getParameter("storeform");}

%>
<%
//Driver DriverProductRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnProductRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnProductRecordset = rcsiteDS.getConnection();
PreparedStatement StatementProductRecordset = ConnProductRecordset.prepareStatement("SELECT * FROM products WHERE store = '" + ProductRecordset__MMColParam + "' ORDER BY order_ ASC");
ResultSet ProductRecordset = StatementProductRecordset.executeQuery();
boolean ProductRecordset_isEmpty = !ProductRecordset.next();
boolean ProductRecordset_hasData = !ProductRecordset_isEmpty;
Object ProductRecordset_data;
int ProductRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 20;
int Repeat1__index = 0;
ProductRecordset_numRows += Repeat1__numRows;
%>
<%
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int ProductRecordset_first = 1;
int ProductRecordset_last  = 1;
int ProductRecordset_total = -1;

if (ProductRecordset_isEmpty) {
  ProductRecordset_total = ProductRecordset_first = ProductRecordset_last = 0;
}

//set the number of rows displayed on this page
if (ProductRecordset_numRows == 0) {
  ProductRecordset_numRows = 1;
}
%>
<%
// *** Recordset Stats: if we don't know the record count, manually count them

if (ProductRecordset_total == -1) {

  // count the total records by iterating through the recordset
    for (ProductRecordset_total = 1; ProductRecordset.next(); ProductRecordset_total++);

  // reset the cursor to the beginning
  ProductRecordset.close();
  ProductRecordset = StatementProductRecordset.executeQuery();
  ProductRecordset_hasData = ProductRecordset.next();

  // set the number of rows displayed on this page
  if (ProductRecordset_numRows < 0 || ProductRecordset_numRows > ProductRecordset_total) {
    ProductRecordset_numRows = ProductRecordset_total;
  }

  // set the first and last displayed record
  ProductRecordset_first = Math.min(ProductRecordset_first, ProductRecordset_total);
  ProductRecordset_last  = Math.min(ProductRecordset_first + ProductRecordset_numRows - 1, ProductRecordset_total);
}
%>
<% String MM_paramName = ""; %>
<%
// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = ProductRecordset;
int       MM_rsCount = ProductRecordset_total;
int       MM_size = ProductRecordset_numRows;
String    MM_uniqueCol = "";
          MM_paramName = "";
int       MM_offset = 0;
boolean   MM_atTotal = false;
boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);
%>
<%
// *** Move To Record: handle 'index' or 'offset' parameter

if (!MM_paramIsDefined && MM_rsCount != 0) {

  //use index parameter if defined, otherwise use offset parameter
  String r = request.getParameter("index");
  if (r==null) r = request.getParameter("offset");
  if (r!=null) MM_offset = Integer.parseInt(r);

  // if we have a record count, check if we are past the end of the recordset
  if (MM_rsCount != -1) {
    if (MM_offset >= MM_rsCount || MM_offset == -1) {  // past end or move last
      if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  //move the cursor to the selected record
  int i;
  for (i=0; ProductRecordset_hasData && (i < MM_offset || MM_offset == -1); i++) {
    ProductRecordset_hasData = MM_rs.next();
  }
  if (!ProductRecordset_hasData) MM_offset = i;  // set MM_offset to the last possible record
}
%>
<%
// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; ProductRecordset_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    ProductRecordset_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!ProductRecordset_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!ProductRecordset_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  ProductRecordset.close();
  ProductRecordset = StatementProductRecordset.executeQuery();
  ProductRecordset_hasData = ProductRecordset.next();
  MM_rs = ProductRecordset;

  // move the cursor to the selected record
  for (i=0; ProductRecordset_hasData && i < MM_offset; i++) {
    ProductRecordset_hasData = MM_rs.next();
  }
}
%>
<%
// *** Move To Record: update recordset stats

// set the first and last displayed record
ProductRecordset_first = MM_offset + 1;
ProductRecordset_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  ProductRecordset_first = Math.min(ProductRecordset_first, MM_rsCount);
  ProductRecordset_last  = Math.min(ProductRecordset_last, MM_rsCount);
}

// set the boolean used by hide region to check if we are on the last record
MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
%>
<%
// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
String[] MM_removeList = { "index", MM_paramName };

// create the MM_keepURL string
/**  commented out to avoid form variables in the navigation links - ravee
if (request.getQueryString() != null) {
  MM_keepURL = '&' + request.getQueryString();
  for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) {
  int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    if (start >= 0 && MM_keepURL.charAt(start) == '&' &&
        MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') {
      int stop = MM_keepURL.indexOf('&', start + 1);
      if (stop == -1) stop = MM_keepURL.length();
      MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    }
  }
}
*/

// add the Form variables to the MM_keepForm string
/* commented out to avoid form variables in the navigation links - ravee
if (request.getParameterNames().hasMoreElements()) {
  java.util.Enumeration items = request.getParameterNames();
  while (items.hasMoreElements()) {
    String nextItem = (String)items.nextElement();
    boolean found = false;
    for (int i=0; !found && i < MM_removeList.length; i++) {
      if (MM_removeList[i].equals(nextItem)) found = true;
    }
    if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) {
      MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
    }
  }
}
*/
MM_keepForm =" store="+ProductRecordset__MMColParam;
// create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL + MM_keepForm;
if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);
%>
<%
// *** Move To Record: set the strings for the first, last, next, and previous links

String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
{
  String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
  String MM_moveParam = "index=";

  // if the page has a repeated region, remove 'offset' from the maintained parameters
  if (MM_size > 1) {
    MM_moveParam = "offset=";
    int start = MM_keepMove.indexOf(MM_moveParam);
    if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) {
      int stop = MM_keepMove.indexOf('&', start);
      if (start == 0 && stop != -1) stop++;
      if (stop == -1) stop = MM_keepMove.length();
      if (start > 0) start--;
      MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
    }
  }

  // set the strings for the move to links
  StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
  if (MM_keepMove.length() > 0) urlStr.append('&');
  urlStr.append(MM_moveParam);
  MM_moveFirst = urlStr + "0";
  MM_moveLast  = urlStr + "-1";
  MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
  MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
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
    <td><!-- InstanceBeginEditable name="MainEditRegion" --> <strong><%=(String)session.getValue("countryLong")%></strong> 
            <table border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
              <tr valign="baseline"> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr valign="baseline"> 
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Code</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Order</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Name</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Price</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Cost</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Wgt</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Taxable</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Active</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Country code</font></strong></td>
                <td bgcolor="#999999"><strong><font color="#FFFFFF">Update</font></strong></td>
              </tr>
              <% while ((ProductRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
              <form method="post" action="<%=MM_editAction%>" name="form1">
                <tr valign="baseline" <%if (Repeat1__index%2 ==1){out.print("bgcolor=\"CCCCCC\" ");}%>> 
                  <td> 
                    <input type="text" name="code" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("code"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="10"> 
                  </td>
                  <td> 
                    <input type="text" name="order_" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("order_"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="5"> 
                  </td>
                  <td> 
                    <input type="text" name="name" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("name"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32"> 
                  </td>
                  <td> 
                    <input type="text" name="price" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("price"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="5"> 
                  </td>
                  <td> 
                    <input type="text" name="cost" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("cost"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="5"> 
                  </td>
                  <td> 
                    <input type="text" name="weight" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("weight"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="4"> 
                  </td>
                  <td> 
                    <input <%=(((((ProductRecordset_data = ProductRecordset.getObject("taxable"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data).toString().equals(("1").toString()))?"checked":"")%> type="checkbox" name="taxable" value=1 > 
                  </td>
                  <td> 
                    <input <%=(((((ProductRecordset_data = ProductRecordset.getObject("active"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data).toString().equals(("1").toString()))?"checked":"")%> type="checkbox" name="active" value=1 > 
                  </td>
                  <td><%=(((ProductRecordset_data = ProductRecordset.getObject("store"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%></td>
                  <td> 
                    <input type="submit" value="Update "> </td>
                </tr>
                <input type="hidden" name="product_id" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>" size="32">
				<input type="hidden" name="MM_update" value="form1">
                <input type="hidden" name="MM_recordId" value="<%=(((ProductRecordset_data = ProductRecordset.getObject("product_id"))==null || ProductRecordset.wasNull())?"":ProductRecordset_data)%>">
              </form>
              <%
  Repeat1__index++;
  ProductRecordset_hasData = ProductRecordset.next();
}
%>
            </table>
            <p>&nbsp; Records <%=(ProductRecordset_first)%> to <%=(ProductRecordset_last)%> of <%=(ProductRecordset_total)%> </p>
            <table border="0" width="50%" align="center">
              <tr> 
                <td width="23%" align="center"> <% if (MM_offset !=0) { %>
                  <a href="<%=MM_moveFirst%>">First</a> 
                  <% } /* end MM_offset != 0 */ %> </td>
                <td width="31%" align="center"> <% if (MM_offset !=0) { %>
                  <a href="<%=MM_movePrev%>">Previous</a> 
                  <% } /* end MM_offset != 0 */ %> </td>
                <td width="23%" align="center"> <% if (!MM_atTotal) { %>
                  <a href="<%=MM_moveNext%>">Next</a> 
                  <% } /* end !MM_atTotal */ %> </td>
                <td width="23%" align="center"> <% if (!MM_atTotal) { %>
                  <a href="<%=MM_moveLast%>">Last</a> 
                  <% } /* end !MM_atTotal */ %> </td>
              </tr>
            </table>
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
