<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.io.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%
try{
%>
<%
String ArtiCatRecordset__MMColParam = "1";
if (request.getParameter("parentid") !=null) {ArtiCatRecordset__MMColParam = (String)request.getParameter("parentid");}
%>
<%
Driver DriverArtiCatRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
Connection ConnArtiCatRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
PreparedStatement StatementArtiCatRecordset = ConnArtiCatRecordset.prepareStatement("SELECT categoryid, category_name FROM article_category WHERE parentid = " + ArtiCatRecordset__MMColParam + " AND active='yes' ORDER BY priority DESC");
																				//	"SELECT *                          FROM (product_options left join product_attributes on product_options.attri_id=product_attributes.attribute_id) WHERE product_attributes.prod_id = " + OptionRecordset__MMColParam + ""	
ResultSet ArtiCatRecordset = StatementArtiCatRecordset.executeQuery();
boolean ArtiCatRecordset_isEmpty = !ArtiCatRecordset.next();
boolean ArtiCatRecordset_hasData = !ArtiCatRecordset_isEmpty;
Object ArtiCatRecordset_data;
int ArtiCatRecordset_numRows = 0;
%>
<%
int Repeat1__numRows = 5;
int Repeat1__index = 0;
ArtiCatRecordset_numRows += Repeat1__numRows;
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
 <tr> 
                <td height="22" valign="top" bgcolor="#C22929"> <div class="whitetitle" style="margin-left:5px; margin-top:3px "><img src="../custom/images/sym2.jpg" alt="" align="absmiddle" style="margin-right:5px"/>Menu</div></td>
              </tr>
              <tr> 
                <td height="100%" valign="top" background="http://www2.vivalanka.com/custom/images/left_px.jpg"> 
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
        <% while ((ArtiCatRecordset_hasData)&&(Repeat1__numRows-- != 0)) { %>
        <tr> 
          <td width="15%" height="17" align="center" valign="middle" ><img src="../custom/images/square.jpg" alt=""  hspace="5" vspace="5"/></td>
          <td width="85%"><strong class="text"><a class=menu href="../news/pagelist.jsp?categoryid=<%=(((ArtiCatRecordset_data = ArtiCatRecordset.getObject("categoryid"))==null || ArtiCatRecordset.wasNull())?"":ArtiCatRecordset_data)%>"><%=(((ArtiCatRecordset_data = ArtiCatRecordset.getObject("category_name"))==null || ArtiCatRecordset.wasNull())?"":ArtiCatRecordset_data)%></a></strong></td>
        </tr>
        <%
  Repeat1__index++;
  ArtiCatRecordset_hasData = ArtiCatRecordset.next();
}
%>
        
        <tr> 
          <td align="right">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
                      </td>
              </tr>
                  </table>
<%
ArtiCatRecordset.close();
StatementArtiCatRecordset.close();
ConnArtiCatRecordset.close();
%>
<%
}catch(Exception ex){
out.println("Error");
}
%>
