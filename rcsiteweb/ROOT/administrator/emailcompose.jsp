<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.io.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%@ include file="../custom/config.jsp" %>
<%@ include file="checkadminlogin.jsp" %>
<%
String EmailRecordset__MMColParam = "1";
if (request.getParameter("emailid") !=null) {EmailRecordset__MMColParam = (String)request.getParameter("emailid");}
%>
<%
String pageMessage = "";
if (request.getParameter("pagemessage") !=null) {pageMessage = (String)request.getParameter("pagemessage");}

%>
<%
String singleAddress = null;
if (request.getParameter("singleaddress") !=null) {singleAddress = (String)request.getParameter("singleaddress");}

%>
<%
//Driver DriverEmailRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection ConnEmailRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection ConnEmailRecordset = rcsiteDS.getConnection();
PreparedStatement StatementEmailRecordset = ConnEmailRecordset.prepareStatement("SELECT *  FROM email  WHERE emailid = " + EmailRecordset__MMColParam + "");
ResultSet EmailRecordset = StatementEmailRecordset.executeQuery();
/*
String emailBody = "";
    ByteArrayOutputStream ByteoutDetails = new ByteArrayOutputStream(1024);
	
while(EmailRecordset.next())
{
    try
    { 	 
        BufferedInputStream ByteinDetails = new BufferedInputStream( EmailRecordset.getBinaryStream("message") );
        
		byte ByteIndata[]= new byte[100000] ;
        int Bytesread = 0;
        // Make sure its not a NULL value in the column:
        if ( !EmailRecordset.wasNull() )
        {
            if ( (Bytesread = ByteinDetails.read(ByteIndata,0,ByteIndata.length)) != -1 )
            {
                // Write out 'bytesread' bytes to the writer instance:
                ByteoutDetails.write(ByteIndata,0,Bytesread);
                emailBody = ByteoutDetails.toString();
            }
            else
            {
                // When the read() method returns -1 we've hit the end of the stream,
                // so now we can get our bytes out of the writer object:
                //allBytesInBlob = baos.getBytes();
                emailBody = ByteoutDetails.toString();
            }
        }
    }
    catch(Exception ex)
    {
        // The driver could not handle this as a BLOB...
        // Fallback to default (and slower) byte[] handling
        // byte[] bytes = Recordset1.getBytes(1);
        emailBody = " Error - Please try latter."  + ex.toString();
	
    }
}
*/
boolean EmailRecordset_isEmpty = !EmailRecordset.next();
boolean EmailRecordset_hasData = !EmailRecordset_isEmpty;
Object EmailRecordset_data;
int EmailRecordset_numRows = 0;

//EmailRecordset.close();

//EmailRecordset = StatementEmailRecordset.executeQuery();
//EmailRecordset_hasData = EmailRecordset.next();
//EmailRecordset_isEmpty = !EmailRecordset_hasData;
%>
<%
if(singleAddress==null){
singleAddress =(String)(((EmailRecordset_data = EmailRecordset.getObject("to_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data);
}


%>
<%
//Driver Driverusertypeecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
//Connection Connusertypeecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
Connection Connusertypeecordset = rcsiteDS.getConnection();
PreparedStatement Statementusertypeecordset = Connusertypeecordset.prepareStatement("SELECT * FROM usertype ORDER BY usertypeid ASC");
ResultSet usertypeecordset = Statementusertypeecordset.executeQuery();
boolean usertypeecordset_isEmpty = !usertypeecordset.next();
boolean usertypeecordset_hasData = !usertypeecordset_isEmpty;
Object usertypeecordset_data;
int usertypeecordset_numRows = 0;
%>
<html lang="en"><!-- InstanceBegin template="/Templates/admintemplate.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<script language="javascript" type="text/javascript" src="../jscripts/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript" src="../jscripts/fulleditor.js"></script>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/styles.css" rel="stylesheet" type="text/css"> 
<!-- InstanceBeginEditable name="head" -->


<link href="../css/styles.css" rel="stylesheet" type="text/css">
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
          <td height="453"><!-- InstanceBeginEditable name="LeftNaviEditRegion" --><jsp:include page="adminleftnavi.jsp?screen=email" flush="true" /><!-- InstanceEndEditable --></td>
    <td><!-- InstanceBeginEditable name="MainEditRegion" -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td valign="top">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="13%" valign="top">&nbsp;</td>
                <td width="87%"><font color="#FF0000"><%=pageMessage%></font></td>
              </tr>
              <tr> 
                <td width="30" valign="top">&nbsp;</td>
                <td><form name="form1" id="form1" method="post" action="emailpreview.jsp">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                      <tr> 
                        <td width="11%" valign="top">&nbsp;</td>
                        <td width="89%"></td>
                      </tr>
                      <tr> 
                        <td valign="top">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td valign="top" class="title">From:</td>
                        <%
						String email1= Config.getValue("emailaddress1").trim();
						String email2= "noreply@"+shortDomain;//(String)session.getValue("username")+"@"+shortDomain;
						//String email3= (String)session.getValue("dcode")+"@"+shortDomain;
						%>
                        <td><select name="fromemail" id="fromemail">
							<option value="<%=email1%>" <%=((email1.toString().equals((((EmailRecordset_data = EmailRecordset.getObject("from_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)))?"SELECTED":"")%>><%=email1%></option>
                            <option value="<%=email2%>" <%=((email2.toString().equals((((EmailRecordset_data = EmailRecordset.getObject("from_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)))?"SELECTED":"")%>><%=email2%></option>
                         
                            <%
while (EmailRecordset_hasData) {
%>
                            <option value="<%=((EmailRecordset.getObject("from_email")!=null)?EmailRecordset.getObject("from_email"):"")%>" <%=(((EmailRecordset.getObject("from_email")).toString().equals(((((EmailRecordset_data = EmailRecordset.getObject("from_email"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)).toString()))?"SELECTED":"")%> ><%=((EmailRecordset.getObject("from_email")!=null)?EmailRecordset.getObject("from_email"):"")%></option>
                            <%
  EmailRecordset_hasData = EmailRecordset.next();
}
EmailRecordset.close();
EmailRecordset = StatementEmailRecordset.executeQuery();
EmailRecordset_hasData = EmailRecordset.next();
EmailRecordset_isEmpty = !EmailRecordset_hasData;
%>
                          </select></td>
                      </tr>
                      <tr> 
                        <td valign="top" class="title">To:</td>
                        <td><table width="377" class="text">
                            <tr> 
                              <td width="23"><label> 
                                <input name="toradio" type="radio" value="single" checked>
                                </label></td>
                              <td width="80">Single Email</td>
                              <td width="258"><input name="singleaddress" type="text" id="singleaddress" value="<%=singleAddress%>"></td>
                            </tr>
                            <tr> 
                              <td><label> 
                                <input type="radio" name="toradio" value="group">
                                </label></td>
                              <td>Group Email</td>
                              <td><select name="groupaddress" id="groupaddress">
                                  <%
while (usertypeecordset_hasData) {
%>
                                  <option value="<%=((usertypeecordset.getObject("usertypename")!=null)?usertypeecordset.getObject("usertypename"):"")%>"><%=((usertypeecordset.getObject("usertypename")!=null)?usertypeecordset.getObject("usertypename"):"")%></option>
                                  <%
  usertypeecordset_hasData = usertypeecordset.next();
}
usertypeecordset.close();
usertypeecordset = Statementusertypeecordset.executeQuery();
usertypeecordset_hasData = usertypeecordset.next();
usertypeecordset_isEmpty = !usertypeecordset_hasData;
%>
                                </select></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td valign="top" class="title">Subject:</td>
                        <td><input name="subject" type="text" id="subject" value="<%=(((EmailRecordset_data = EmailRecordset.getObject("subject"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%>" size="50" maxlength="50"></td>
                      </tr>
                      <tr> 
                        <td valign="top" class="title">Message:</td>
                        <td valign="top">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="2" valign="top"> 
                          <!-- <textarea name="emailbody" cols="50" rows="20" id="emailbody"></textarea> -->

                            
                          <textarea name="emailbody" id="emailbody" cols="70" rows="30" class="mceEditor"> <%=(((EmailRecordset_data = EmailRecordset.getObject("message"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></textarea></td>
                      </tr>
                      <tr> 
                        <td valign="top">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td valign="top" class="title">Email Type:</td>
                        <td><select name="type" id="type">
                            <option value="Customer Service" <%=(("Customer Service".toString().equals((((EmailRecordset_data = EmailRecordset.getObject("type"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)))?"SELECTED":"")%>>Customer 
                            Service</option>
                            <option value="Distributer Support" <%=(("Distributer Support".toString().equals((((EmailRecordset_data = EmailRecordset.getObject("type"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)))?"SELECTED":"")%>>Distributer 
                            Support</option>
                            <option value="Business" <%=(("Business".toString().equals((((EmailRecordset_data = EmailRecordset.getObject("type"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)))?"SELECTED":"")%>>Business</option>
                            <option value="News Letter" <%=(("News Letter".toString().equals((((EmailRecordset_data = EmailRecordset.getObject("type"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)))?"SELECTED":"")%>>News 
                            Letter</option>
                            <%
while (EmailRecordset_hasData) {
%>
                            <option value="<%=((EmailRecordset.getObject("type")!=null)?EmailRecordset.getObject("type"):"")%>" <%=(((EmailRecordset.getObject("type")).toString().equals(((((EmailRecordset_data = EmailRecordset.getObject("type"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)).toString()))?"SELECTED":"")%> ><%=((EmailRecordset.getObject("type")!=null)?EmailRecordset.getObject("type"):"")%></option>
                            <%
  EmailRecordset_hasData = EmailRecordset.next();
}
EmailRecordset.close();
EmailRecordset = StatementEmailRecordset.executeQuery();
EmailRecordset_hasData = EmailRecordset.next();
EmailRecordset_isEmpty = !EmailRecordset_hasData;
%>
                          </select></td>
                      </tr>
                      <tr> 
                        <td colspan="2" valign="top" class="title">Use Letter 
                          Head: 
                          <input name="letterhead" type="checkbox" id="letterhead" value="use"></td>
                      </tr>
                      <tr> 
                        <td valign="top" class="title">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td valign="top" class="title"> <p>Description (max. 230 
                            characters)</p></td>
                        <td><textarea name="description" cols="30" rows="2" id="description"><%=(((EmailRecordset_data = EmailRecordset.getObject("description"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data)%></textarea></td>
                      </tr>
                      <tr> 
                        <td valign="top" class="title">Action</td>
                        <td><table width="200" class="text">
                            <tr> 
                              <td><label> 
                                <input <%=(((((EmailRecordset_data = EmailRecordset.getObject("folder"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data).toString().equals(("send").toString()))?"CHECKED":"")%> type="radio" name="folderradiogroup" value="send">
                                Send</label></td>
                            </tr>
                            <tr> 
                              <td><label> 
                                <input <%=(((((EmailRecordset_data = EmailRecordset.getObject("folder"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data).toString().equals(("save").toString()))?"CHECKED":"")%> type="radio" name="folderradiogroup" value="save">
                                Save Draft</label></td>
                            </tr>
                            <tr> 
                              <td><label> 
                                <input <%=(((((EmailRecordset_data = EmailRecordset.getObject("folder"))==null || EmailRecordset.wasNull())?"":EmailRecordset_data).toString().equals(("template").toString()))?"CHECKED":"")%> type="radio" name="folderradiogroup" value="template">
                                Save as a template</label></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td valign="top">&nbsp;</td>
                        <td><input name="header" type="hidden" id="header" value=""> 
                          <input name="footer" type="hidden" id="footer" value=""></td>
                      </tr>
                      <tr> 
                        <td valign="top">&nbsp;</td>
                        <td><input name="preview" type="submit" id="preview" value="Preview" ></td>
                      </tr>
                    </table>
   
                  </form></td>
              </tr>
              <tr> 
                <td valign="top">&nbsp;</td>
                <td></td>
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
EmailRecordset.close();
StatementEmailRecordset.close();
ConnEmailRecordset.close();
%>
<%
usertypeecordset.close();
Statementusertypeecordset.close();
Connusertypeecordset.close();
%>

