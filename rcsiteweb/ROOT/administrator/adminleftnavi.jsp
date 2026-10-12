<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<%@ page import="com.rev_creations.rcsite.*" errorPage="" %>
<!-- %@ include file="../custom/config.jsp" %-->
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>
<%
String screen = "email";
if (request.getParameter("screen") !=null) {screen = (String)request.getParameter("screen");}
String naviUrl ="";
%>
<table width="184" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="10" height="19" bgcolor="e8ad03">&nbsp;</td>
          <td width="164" height="19" bgcolor="e8ad03" class="whitetitle">Administrator</td>
          <td width="10" height="19" bgcolor="e8ad03"><img src="../images/left_crn.gif" width="10" height="25" align="bottom"></td>
        </tr>
		        <tr> 
          <td bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
          <td bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="../user/welcome.jsp">My 
            Account </a></font></td>
          <td>&nbsp;</td>
        </tr>
        
        <tr> 
          <td bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
          <td bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="index.jsp">Admin 
            Home </a></font></td>
          <td>&nbsp;</td>
        </tr>
		<tr> 
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td colspan="2" bgcolor="#FFFFFF" class=text><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
                <td class="text"><font face="Tahoma"><a href="../user/logout.jsp">Logout</a></font></td>
              </tr>
			 <tr> 
                <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
                <td class="text"><font face="Tahoma"><a href="memberlist.jsp">Member List</a></font></td>
              </tr>
			  <tr> 
                <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
                <td class="text"><font face="Tahoma"><a href="memberadd.jsp">Add New Member</a></font></td>
              </tr>
			  <tr> 
                <td><img src="../images/bulletyellow.gif" width="4" height="4"></td>
                <td class="text"><font face="Tahoma"><a href="addusertype.jsp">Add 
                  New User Type</a></font></td>
              </tr>
              <tr> 
                <td width="6%"><img src="../images/bulletyellow.gif" width="4" height="4"></td>
                <td width="94%" class="text"><a href="javascript:;" onClick="MM_openBrWindow('notepad.jsp','notepad','toolbar=yes,scrollbars=yes,width=500,height=500')">Note Pad</a></td>
              </tr>
            </table></td>
  </tr>
		</table><!--start add left navi-->
<%
if(Config.getValue("emailcampaignerenabled")!=null &&
			"1".equals(Config.getValue("emailcampaignerenabled").trim())){
 naviUrl ="adminemailleftnavi.jsp?screen=" +screen;
%>	
		<jsp:include page="<%= naviUrl%>" flush="true" />
<%
}
if(Config.getValue("articlesenabled")!=null &&
			"1".equals(Config.getValue("articlesenabled").trim())){
 naviUrl ="adminarticleleftnavi.jsp?screen=" +screen;
%>	
		<jsp:include page="<%= naviUrl%>" flush="true" />
<%
	}

if(Config.getValue("rccommerceenabled")!=null &&
			"1".equals(Config.getValue("rccommerceenabled").trim())){
%>	
	 <table width="100%" border="0" cellpadding="0" cellspacing="0">

		<tr> 
          <td bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
          <td bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="/rccommerce/admin/home/home.do?process=list" )">RC Commerce</a></font></td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td width="5%" bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
          <td width="89%" bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
          <td width="6%"><img src="../images/shim.gif" width="1" height="1"></td>
        </tr>
	</table>
		<%
	}

if(Config.getValue("rcmerchantenabled")!=null &&
			"1".equals(Config.getValue("rcmerchantenabled").trim())){		
 naviUrl ="adminrcmerchantleftnavi.jsp?screen=" +screen;
%>	
		<jsp:include page="<%= naviUrl%>" flush="true" />
<%
	}

if(Config.getValue("webdirectoryenabled")!=null &&
			"1".equals(Config.getValue("webdirectoryenabled").trim())){
 naviUrl ="admindirectoryleftnavi.jsp?screen=" +screen;
%>	
		<jsp:include page="<%= naviUrl%>" flush="true" />
<%
	}

if(Config.getValue("newsenabled")!=null &&
			"1".equals(Config.getValue("newsenabled").trim())){
 naviUrl ="adminnewsleftnavi.jsp?screen=" +screen;
%>	
		<jsp:include page="<%= naviUrl%>" flush="true" />
<%
	}

if(Config.getValue("educationenabled")!=null &&
			"1".equals(Config.getValue("educationenabled").trim())){
 naviUrl ="admineduleftnavi.jsp?screen=" +screen;
%>	
		<jsp:include page="<%= naviUrl%>" flush="true" />
<%	
	}

if(Config.getValue("forumenabled")!=null &&
			"1".equals(Config.getValue("forumenabled").trim())){	
%>	
		<!--end add left navi-->
		 <table width="100%" border="0" cellpadding="0" cellspacing="0">

		<tr> 
          <td bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
          <td bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="../rcforum/admBase/login.page" )">Forum Admin</a></font></td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td width="5%" bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
          <td width="89%" bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
          <td width="6%"><img src="../images/shim.gif" width="1" height="1"></td>
        </tr>
        </table>
<%	
	}

if(Config.getValue("webmailenabled")!=null &&
			"1".equals(Config.getValue("webmailenabled").trim())){	
%>		
         <table width="100%" border="0" cellpadding="0" cellspacing="0">
		 <%	


if(Config.getValue("webmail")!=null ){	
%>		
		 <tr> 
          <td bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
          <td bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="javascript:;" onClick="MM_openBrWindow('<%=Config.getValue("webmail")%>','webmail','toolbar=yes,scrollbars=yes,resizable=yes')">Webmail</a></font></td>
          <td>&nbsp;</td>
        </tr>
 <%	


}else{	
%>	
		<tr> 
          <td bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
          <td bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="javascript:;" onClick="MM_openBrWindow('http://webmail.<%=Config.getValue("shortDomain")%>','webmail','toolbar=yes,scrollbars=yes,resizable=yes')">Webmail</a></font></td>
          <td>&nbsp;</td>
        </tr>
 <%	


}
%>	
		 <tr> 
          <td width="5%" bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
          <td width="89%" bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
          <td width="6%"><img src="../images/shim.gif" width="1" height="1"></td>
        </tr>
         </table>
         <%
	}
	if(true){
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
		 <tr> 
          <td bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
          <td bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="javascript:;" onClick="MM_openBrWindow('<%=Config.getValue("wwwUrl")%>/plesk-stat/webstat/index.html','statistics','toolbar=yes,scrollbars=yes,resizable=yes')">Web Statistics</a></font></td>
          <td>&nbsp;</td>
        </tr>
		 <tr> 
          <td width="5%" bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
          <td width="89%" bgcolor="e8ad03"><img src="../images/shim.gif" width="1" height="1"></td>
          <td width="6%"><img src="../images/shim.gif" width="1" height="1"></td>
        </tr>
         </table>
<%
}
if(Config.getValue("projectenabled")!=null &&
			"1".equals(Config.getValue("projectenabled").trim())){	
%>	
         <table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr> 
          <td bgcolor="#FFFFFF"><img src="../images/nav_rightarrow_off.gif" width="6" height="10"></td>
          <td bgcolor="#FFFFFF" class="title"><font color="#0033FF" face="Tahoma"><a href="../rcproject/timeframe.jsp" )">Project</a></font></td>
          <td>&nbsp;</td>
        </tr>
      </table>
<%} 

if (session.getValue("MM_Username") != null 
 	&& (session.getValue("MM_Username").equals("rcadmin")|| session.getValue("MM_Username").equals("monali")|| session.getValue("MM_Username").equals("dinusha")|| session.getValue("MM_Username").equals("thisara"))) {
 naviUrl ="adminsystemleftnavi.jsp?screen=" +screen;
%>	
		<jsp:include page="<%= naviUrl%>" flush="true" />
<%	
	}  
	%>
	  </td>
  </tr>
  
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
