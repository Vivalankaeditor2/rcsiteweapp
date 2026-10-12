<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<%
String screen = "email";
if (request.getParameter("screen") !=null) {screen = (String)request.getParameter("screen");}
%>
<table width="184" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td><img src="../images/shim.gif" width="1" height="1"></td>
  </tr>
  <tr> 
    <td width="6" bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
    <td bgcolor="#FFFFFF" class="title"><a href="rcadmin.jsp">RC 
      Merchant</a></td>
    <td width="5%">&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
    <td><img src="../images/shim.gif" width="1" height="1"></td>
  </tr>
  <%
   if ((screen!= null)&&(screen.equals("rcmerchant")))
    {
	%>
  <tr> 
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td colspan="2" bgcolor="#FFFFFF" class=text><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><font face="Tahoma"><a href="rcorders.jsp">Order 
            List</a></font></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text">Shopping Baskets</td>
        </tr>
        <%  
		
			String userName = (String) session.getAttribute("username");
			String memberType = (String) session.getAttribute("memberType");
		//	if ((userName != null)&&(memberType!=null)&&(memberType.equals("ADMINISTRATOR"))){
		%>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="rcproductinsert.jsp">Add 
            Products </a></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="rcproductlist.jsp">Product 
            List/Edit</a></td>
        </tr>
        <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="rccategoryinsert.jsp">Add 
            Product Categories</a></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="rccategories.jsp">Product 
            Category List/Edit</a></td>
        </tr>
		 <tr> 
          <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td class="text"><a href="couponsadd.jsp">Add Coupons</a></td>
        </tr>
        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="couponslist.jsp">Coupons List/Edit</a></td>
        </tr>
		        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="javascript:;" onClick="MM_openBrWindow('upload.jsp?dir=media2','images','toolbar=yes,scrollbars=yes,width=500,height=500')">images/files upload</a></td>
        </tr>
		   
		        <tr> 
          <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
          <td width="94%" class="text"><a href="rcconfigdisplay.jsp">Configuration 
            Summary</a></td>
        </tr>
        <tr> 
          <td colspan="2">
	<%	  
	int numberOfStores=Integer.parseInt((String)session.getValue("numberOfStores"));
	if(numberOfStores > 1){
	%> 
	<jsp:include page="rcstoreselectionmenu.jsp" flush="true" />
	<%
	  }
	  %></td>
        </tr>
        <%
	//	}
		%>
      </table></td>
  </tr>
  <%
     }//end of email menu
   %>
   
</table>
