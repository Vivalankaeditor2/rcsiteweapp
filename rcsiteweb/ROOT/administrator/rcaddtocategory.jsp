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
// *** Insert Record: set variables

if (request.getParameter("MM_insert") != null && request.getParameter("MM_insert").toString().equals("form1")) {

  MM_editDriver     = MM_dbconnection_DRIVER;
  MM_editConnection = MM_dbconnection_STRING;
  MM_editUserName   = MM_dbconnection_USERNAME;
  MM_editPassword   = MM_dbconnection_PASSWORD;
  MM_editTable  = "prodxcat";
  MM_editRedirectUrl = "rcaddtocategory.jsp";
 // String MM_fieldsStr = "category_id|value|product_id|value|order_|value";
  //String MM_columnsStr = "category_id|none,none,NULL|product_id|none,none,NULL|order_|none,none,NULL";
String MM_fieldsStr = "line_id|value|category_id|value|product_id|value|order_|value";
  String MM_columnsStr = "line_id|none,none,NULL|category_id|none,none,NULL|product_id|none,none,NULL|order_|none,none,NULL";

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
    //Driver MM_driver = (Driver)Class.forName(MM_editDriver).newInstance();
    //Connection MM_connection = DriverManager.getConnection(MM_editConnection,MM_editUserName,MM_editPassword);
	Connection MM_connection  = rcsiteDS.getConnection();
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
String CategoryRecordset__MMColParam = "1";
if (request.getParameter("store") !=null) {CategoryRecordset__MMColParam = (String)request.getParameter("store");}
%>
<%
String productId = "1";
if (request.getParameter("product_id") !=null) {productId = (String)request.getParameter("product_id");}
String productName = "1";
if (request.getParameter("product_name") !=null) {productName= (String)request.getParameter("product_name");}

%>
<%
//Driver DriverCategoryRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnCategoryRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnCategoryRecordset = rcsiteDS.getConnection();
PreparedStatement StatementCategoryRecordset = ConnCategoryRecordset.prepareStatement("SELECT * FROM product_categories WHERE store = '" + CategoryRecordset__MMColParam + "'");
ResultSet CategoryRecordset = StatementCategoryRecordset.executeQuery();
boolean CategoryRecordset_isEmpty = !CategoryRecordset.next();
boolean CategoryRecordset_hasData = !CategoryRecordset_isEmpty;
Object CategoryRecordset_data;
int CategoryRecordset_numRows = 0;
%>
<%
//Driver DriverProdCatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnProdCatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnProdCatRecordset = rcsiteDS.getConnection();
PreparedStatement StatementProdCatRecordset = ConnProdCatRecordset.prepareStatement("SELECT * FROM (prodxcat left join product_categories on prodxcat.category_id=product_categories.category_id) WHERE product_id="+productId+"");
//PreparedStatement StatementProdCatRecordset = ConnProdCatRecordset.prepareStatement("SELECT * FROM prodxcat WHERE product_id="+productId+"");
ResultSet ProdCatRecordset = StatementProdCatRecordset.executeQuery();
boolean ProdCatRecordset_isEmpty = !ProdCatRecordset.next();
boolean ProdCatRecordset_hasData = !ProdCatRecordset_isEmpty;
Object ProdCatRecordset_data;
int ProdCatRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = -1;
int Repeat1__index = 0;
ProdCatRecordset_numRows += Repeat1__numRows;
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
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
	<%
		String naviUrl ="producteditnavibar.jsp?product_id=" +productId;
	%>
      <jsp:include page="<%= naviUrl%>" flush="true" /></td>
  </tr>
  <tr>
    <td><table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                    <tr> 
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr bgcolor="#999999"> 
                      <td><font color="#FFFFFF"><strong>Line Id</strong></font></td>
                      <td><font color="#FFFFFF"><strong>Category Id</strong></font></td>
                      <td><font color="#FFFFFF"><strong>Product Id</strong></font></td>
                      <td><font color="#FFFFFF"><strong>Order</strong></font></td>
                      <td><strong><font color="#FFFFFF">Edit</font></strong></td>
                      <td><strong><font color="#FFFFFF">Remove</font></strong></td>
                    </tr>
                    <% while ((ProdCatRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
                    <tr valign="top" <%if (Repeat1__index%2 ==0){out.print("bgcolor=\"CCCCCC\" ");}%> > 
                      <td><%=(((ProdCatRecordset_data = ProdCatRecordset.getObject("prodxcat.line_id"))==null || ProdCatRecordset.wasNull())?"":ProdCatRecordset_data)%></td>
                      <td><%=(((ProdCatRecordset_data = ProdCatRecordset.getObject("product_categories.name"))==null || ProdCatRecordset.wasNull())?"":ProdCatRecordset_data)%></td>
                      <td><%=(((ProdCatRecordset_data = ProdCatRecordset.getObject("prodxcat.product_id"))==null || ProdCatRecordset.wasNull())?"":ProdCatRecordset_data)%></td>
                      <td><%=(((ProdCatRecordset_data = ProdCatRecordset.getObject("prodxcat.order_"))==null || ProdCatRecordset.wasNull())?"":ProdCatRecordset_data)%></td>
                      <td><a href="rcprodcatupdate.jsp?line_id=<%=(((ProdCatRecordset_data = ProdCatRecordset.getObject("line_id"))==null || ProdCatRecordset.wasNull())?"":ProdCatRecordset_data)%>&product_id=<%=(((ProdCatRecordset_data = ProdCatRecordset.getObject("product_id"))==null || ProdCatRecordset.wasNull())?"":ProdCatRecordset_data)%>&store=<%=(((CategoryRecordset_data = CategoryRecordset.getObject("store"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>">Edit</a></td>
                      <td><a href="rcprodcatdelete.jsp?line_id=<%=(((ProdCatRecordset_data = ProdCatRecordset.getObject("line_id"))==null || ProdCatRecordset.wasNull())?"":ProdCatRecordset_data)%>&product_id=<%=(((ProdCatRecordset_data = ProdCatRecordset.getObject("product_id"))==null || ProdCatRecordset.wasNull())?"":ProdCatRecordset_data)%>&store=<%=(((CategoryRecordset_data = CategoryRecordset.getObject("store"))==null || CategoryRecordset.wasNull())?"":CategoryRecordset_data)%>">Remove</a></td>
                    </tr>
                    <%
  Repeat1__index++;
  ProdCatRecordset_hasData = ProdCatRecordset.next();
}
%>
                    <%
  	Random rnp = new Random();
	String newId = ""+Math.abs(rnp.nextInt());
	
  %>
                  </table>
</td>
  </tr>
  <tr>
    <td><form method="post" action="<%=MM_editAction%>" name="form1">
                    <table align="left">
                      <tr>
                        <td colspan="2" align="left" valign="baseline" nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="left" valign="baseline" nowrap><strong>Add 
                          to new category</strong></td>
                      </tr>
                      <tr> 
                        <td align="left" valign="baseline" nowrap>Line id:</td>
                        <td align="left" valign="baseline" nowrap><%=newId%></td>
                      </tr>
                      <tr> 
                        <td align="left" valign="baseline" nowrap>Category:</td>
                        <td valign="baseline"> <select name="category_id">
                            <%
while (CategoryRecordset_hasData) {
%>
                            <option value="<%=((CategoryRecordset.getObject("category_id")!=null)?CategoryRecordset.getObject("category_id"):"")%>"><%=((CategoryRecordset.getObject("name")!=null)?CategoryRecordset.getObject("name"):"")%></option>
                            <%
  CategoryRecordset_hasData = CategoryRecordset.next();
}
CategoryRecordset.close();
CategoryRecordset = StatementCategoryRecordset.executeQuery();
CategoryRecordset_hasData = CategoryRecordset.next();
CategoryRecordset_isEmpty = !CategoryRecordset_hasData;
%>
                          </select> </td>
                      </tr>
                      <tr> 
                        <td align="left" valign="baseline" nowrap>Product id:</td>
                        <td valign="baseline"> <%=productId%></td>
                      </tr>
                      <tr> 
                        <td nowrap align="left">Order:</td>
                        <td valign="baseline"> <input type="text" name="order_" value="" size="10"> 
                        </td>
                      </tr>
                      <tr> 
                        <td align="left" valign="baseline" nowrap>&nbsp;</td>
                        <td valign="baseline"> <input type="submit" value="Insert Record"> 
                        </td>
                      </tr>
                    </table>
   <input type="hidden" name="line_id" value="<%=newId%>" size="32">
   <input type="hidden" name="product_id" value="<%=productId%>" size="32">
  <input type="hidden" name="MM_insert" value="form1">
</form>
</td>
  </tr>
</table>

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
CategoryRecordset.close();
StatementCategoryRecordset.close();
ConnCategoryRecordset.close();
%>
<%
ProdCatRecordset.close();
StatementProdCatRecordset.close();
ConnProdCatRecordset.close();
%>
