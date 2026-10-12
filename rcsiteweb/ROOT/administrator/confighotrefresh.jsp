<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@page import="com.rev_creations.rcsite.Config,java.util.*,com.rev_creations.persistence.dao.*,com.rev_creations.rcsite.ArticlePageGenerator"%>
<%@page import="com.rev_creations.util.DBUtil"%>
<!--%@ include file="../custom/config.jsp" %-->
<%@ include file="checkadminlogin.jsp" %>
<%//System.out.println("111");
                RcsiteConfig rcsiteConfig = null;
				//System.out.println("222");
                if (request.getParameter("MM_update") != null &&
    					request.getParameter("MM_update").toString().equals("form1")){
						//System.out.println("3333");
                	DBUtil.entityManager.close();
                	Config.loadConfig();
                	ArticlePageGenerator.loadCategoryLimitTable();
                }
				//System.out.println("4444");
                List<RcsiteConfig> configList = Config.getConfigList();
				//System.out.println("55555");
				
                Iterator<RcsiteConfig> configIterator= null;
				if(configList!=null){
				  configIterator=configList.iterator();
				 }
				//System.out.println("66666");

%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Refresh Configuration</title>
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
            <jsp:include page="adminleftnavi.jsp?screen=system" flush="true" /> 
            <!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" --> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
              <tr> 
                <td width="5%">&nbsp;</td> 
                <td width="42%" valign="top">&nbsp;</td> 
                <td width="9%" valign="top">&nbsp;</td> 
                <td width="35%" valign="top">&nbsp;</td> 
                <td width="9%">&nbsp;</td> 
              </tr> 
              <tr> 
                <td>&nbsp;</td> 
                <td colspan="4" valign="top"><strong>Configuration</strong></td> 
              </tr> 
              <tr> 
                <td>&nbsp;</td> 
                <td colspan="4" valign="top"> <table width="400" border="0" cellspacing="0" cellpadding="0"> 
                    <%//System.out.println("77777");
					   	while(configIterator!= null && configIterator.hasNext()){
						//System.out.println("888888");
			   				rcsiteConfig=(RcsiteConfig)configIterator.next();
			 // System.out.println("8999999");
							if(rcsiteConfig.getHotConfigurable()!=null && rcsiteConfig.getHotConfigurable().intValue()==1){
						%> 
                    <tr> 
                      <td style="white-space:nowrap" width="35%" ><a href="configupdate.jsp?key=<%=rcsiteConfig.getConfigKey()%>">Edit </a>&nbsp;&nbsp;<%=rcsiteConfig.getConfigKey()%></td> 
                      <td><%=rcsiteConfig.getValue()%></td> 
                    </tr> 
                    	<%
							}
			   			}
                 	%> 
                    <tr> 
                      <td>&nbsp;</td> 
                      <td>&nbsp;</td> 
                    </tr> 
                    <tr> 
                      <td>&nbsp;</td> 
                      <td>&nbsp;</td> 
                    </tr> 
                  </table></td> 
              </tr> 
              <tr> 
                <td>&nbsp;</td> 
                <td colspan="4" valign="top"><form name="form1" method="post" action=""> 
                    <input name="refreshconfig" type="submit" id="refreshconfig" value="Refresh Config"> 
                    <input type="hidden" name="MM_update" value="form1">
                  </form></td> 
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
