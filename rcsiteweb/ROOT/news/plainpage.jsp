<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.io.*" errorPage="" %>
<%@ include file="../Connections/dbconnection.jsp" %>
<%
try{
%>
<%
String ArticleRecordset__MMColParam = "1";
if(!validateNumeric( request.getParameter("articleid"), "/news/contactus.jsp", request,  response)){return;}
if (request.getParameter("articleid") !=null) {ArticleRecordset__MMColParam = (String)request.getParameter("articleid");}
%>
<%
Driver DriverArticleRecordset = (Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
Connection ConnArticleRecordset = DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
PreparedStatement StatementArticleRecordset = ConnArticleRecordset.prepareStatement("SELECT *  FROM articles  WHERE article_id = " + ArticleRecordset__MMColParam + "");
String text = "Sorry...Article could not be found." ;
String authorIntro = " ";
ByteArrayOutputStream baos = new ByteArrayOutputStream(1024);
ByteArrayOutputStream baosAu = new ByteArrayOutputStream(1024);
ResultSet ArticleRecordset = StatementArticleRecordset.executeQuery();
while(ArticleRecordset.next())
         {
            try
            {
               BufferedInputStream bisAu = new BufferedInputStream( ArticleRecordset.getBinaryStream("author_intro") );
				BufferedInputStream bis = new BufferedInputStream( ArticleRecordset.getBinaryStream("details") );
			   byte bindataAu[]= new byte[1000] ;
			    byte bindata[]= new byte[10000] ;
				
               int bytesreadAu = 0;
			   int bytesread = 0;

            // Make sure its not a NULL value in the column:
            if ( !ArticleRecordset.wasNull() ) {

               if ( (bytesread = bis.read(bindata,0,bindata.length)) != -1 ) {

                  // Write out 'bytesread' bytes to the writer instance:
                  baos.write(bindata,0,bytesread);
				  text = baos.toString();

               } else {

                  // When the read() method returns -1 we've hit the end of the stream,
                  // so now we can get our bytes out of the writer object:
                  //allBytesInBlob = baos.getBytes();
				 text = baos.toString();
				  }
				  
				  if ( (bytesreadAu = bisAu.read(bindataAu,0,bindataAu.length)) != -1 ) {

                  // Write out 'bytesread' bytes to the writer instance:
                  baosAu.write(bindataAu,0,bytesreadAu);
				  authorIntro= baosAu.toString();

               } else {

                  // When the read() method returns -1 we've hit the end of the stream,
                  // so now we can get our bytes out of the writer object:
                  //allBytesInBlob = baos.getBytes();
				authorIntro= baosAu.toString();
				  }
            }
			}
            catch(Exception ex)
            {
               // The driver could not handle this as a BLOB...
               // Fallback to default (and slower) byte[] handling
              // byte[] bytes = Recordset1.getBytes(1);
			  text = " Error - Please try latter." ;
            }
		}
ArticleRecordset.close();
StatementArticleRecordset.close();
		
StatementArticleRecordset = ConnArticleRecordset.prepareStatement("SELECT *  FROM articles  WHERE article_id = " + ArticleRecordset__MMColParam + "");		
ArticleRecordset = StatementArticleRecordset.executeQuery();
boolean ArticleRecordset_isEmpty = !ArticleRecordset.next();
boolean ArticleRecordset_hasData = !ArticleRecordset_isEmpty;
Object ArticleRecordset_data;
int ArticleRecordset_numRows = 0;


%>


 <table width="100%" border="0" align="left" cellpadding="0" cellspacing="0" class="text">
                                      <tr> 
                                        <td width="2%"><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
                                        <td width="98%">&nbsp;</td>
                                      </tr>

                                      <tr> 
                                        <td height="44"><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
                                        <td> <p><%= text%></p></td>
                                      </tr>
                                      <tr> 
                                        <td><font face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
                                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="text">
                                            <tr> 
                                              <td width="31%"><div align="right"></div></td>
                                              <td width="69%"><%=(((ArticleRecordset_data = ArticleRecordset.getObject("author_name"))==null || ArticleRecordset.wasNull())?"":ArticleRecordset_data)%></td>
                                            </tr>
                                            <tr> 
                                              <td>&nbsp;</td>
                                              <td><%=authorIntro%>&nbsp</td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                    </table>

<%
ArticleRecordset.close();
StatementArticleRecordset.close();
ConnArticleRecordset.close();
%>

<%
}catch(Exception ex){
ex.printStackTrace();
out.print(".");
}
%>
