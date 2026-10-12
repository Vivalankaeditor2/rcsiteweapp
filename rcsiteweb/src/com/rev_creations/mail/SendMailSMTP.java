package com.rev_creations.mail;
/*
Some SMTP servers require a username and password authentication before you
can use their Server for Sending mail. This is most common with couple
of ISP's who provide SMTP Address to Send Mail.

This Program gives any example on how to do SMTP Authentication
(User and Password verification)

This is a free source code and is provided as it is without any warranties and
it can be used in any your code for free.

Author : Sudhir Ancha
*/

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.*;

import com.rev_creations.rcsite.Config;

import java.util.*;
import java.io.*;

/*
  To use this program, change values for the following three constants,

    SMTP_HOST_NAME -- Has your SMTP Host Name
    SMTP_AUTH_USER -- Has your SMTP Authentication UserName
    SMTP_AUTH_PWD  -- Has your SMTP Authentication Password

  Next change values for fields

  emailMsgTxt  -- Message Text for the Email
  emailSubjectTxt  -- Subject for email
  emailFromAddress -- Email Address whose name will appears as "from" address

  Next change value for "emailList".
  This String array has List of all Email Addresses to Email Email needs to be sent to.


  Next to run the program, execute it as follows,

  SendMailUsingAuthentication authProg = new SendMailUsingAuthentication();

*/

public class SendMailSMTP
{

    private static final String SMTP_HOST_NAME =  Config.getValue("emailhost").trim();
    private static final String SMTP_PORT =  Config.getValue("emailport").trim();
    private static final String SMTP_AUTH_USER = Config.getValue("emailaddress1").trim();
    private static final String SMTP_AUTH_PWD  = Config.getValue("emailpassword1").trim();
    private static final String SMTP_AUTH  = Config.getValue("emailauthenticate").trim();

   
    // Add List of Email address to who email needs to be sent to
    //private static final String[] emailList = {"chumith@yahoo.com", "chumiths@bellsouth.net"};
    public void SendMail( String htmlMmessage, String emailSubjectTxt, 
    		String emailFromAddress,
            String[] emailList,  String attachement) throws Exception{  
    	String plainMessage =stripHTML(htmlMmessage);
    	postMail( emailList, emailSubjectTxt, htmlMmessage, plainMessage, emailFromAddress, attachement);
    }
    
    public void SendMail( String htmlMmessage, String emailSubjectTxt, String plainMessage,String emailFromAddress,
                            String[] emailList) throws Exception{  
        postMail( emailList, emailSubjectTxt, htmlMmessage, plainMessage, emailFromAddress, null);
    }

    public void SendMail( String htmlMmessage, String emailSubjectTxt, String emailFromAddress,
            String[] emailList) throws Exception{  
    	String plainMessage =stripHTML(htmlMmessage);
		postMail( emailList, emailSubjectTxt, htmlMmessage, plainMessage, emailFromAddress, null);
	}

    public void postMail( String recipients[ ], String subject, String htmlMmessage, String plainMessage,
                            String from, String attachement ) throws MessagingException
    {
        boolean debug = false;

         //Set the host smtp address
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST_NAME);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", SMTP_AUTH);

        Authenticator auth = new SMTPAuthenticator();
        Session session = Session.getInstance(props, auth);

        session.setDebug(debug);

        // create a message
        Message msg = new MimeMessage(session);

        // set the from and to address
        InternetAddress addressFrom = new InternetAddress(from);
        msg.setFrom(addressFrom);

        InternetAddress[] addressTo = new InternetAddress[recipients.length];
        for (int i = 0; i < recipients.length; i++)
        {
            addressTo[i] = new InternetAddress(recipients[i]);
        }
        msg.setRecipients(Message.RecipientType.TO, addressTo);
        htmlMmessage = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n"+
        "<html>\n"+
        "<head>\n"+
        "<title>"+subject+"</title>\n"+
        "</head>\n"+
		"<body>\n"+
        htmlMmessage +"\n</body>\n</html>";

        // Setting the Subject and Content Type
        msg.setSubject(subject);
        msg.setSentDate(new Date());
        
       // 
               
        Multipart mp = new MimeMultipart("alternative");
        BodyPart htmlPart = new MimeBodyPart();
        BodyPart textPart = new MimeBodyPart();
        BodyPart attachementPart = new MimeBodyPart();
        
        if(plainMessage.length()>0 && htmlMmessage.length()>0 ){
        	

        textPart.setText(plainMessage); // sets type to "text/plain"
        htmlPart.setContent(htmlMmessage, "text/html");

        // Collect the Parts into the MultiPart
        mp.addBodyPart(textPart);
        mp.addBodyPart(htmlPart);
        if(attachement!=null){
            DataSource source = new FileDataSource(attachement);

            attachementPart.setDataHandler(new DataHandler(source));

            attachementPart.setFileName(attachement.substring(attachement.lastIndexOf(System.getProperty("file.separator"))));
        	mp.addBodyPart(attachementPart);
        }
        // Put the MultiPart into the Message
        msg.setContent(mp);
        }else  if(plainMessage.length()>0 ){
        	msg.setContent(plainMessage,"text/plain");
        }else {
        	msg.setContent(htmlMmessage,"text/html");
        }
        // Finally, send the message!
       
        Transport.send(msg);
    }


/**
* SimpleAuthenticator is used to do simple authentication
* when the SMTP server requires it.
*/
private class SMTPAuthenticator extends javax.mail.Authenticator
{

    public PasswordAuthentication getPasswordAuthentication()
    {
        String username = SMTP_AUTH_USER;
        String password = SMTP_AUTH_PWD;
        return new PasswordAuthentication(username, password);

    }
}

public static void main(String[] args) {
	
	com.rev_creations.mail.SendMailSMTP MailObject = new com.rev_creations.mail.SendMailSMTP();
	String heading = "Data posted to ";
	String fromAddress = "billing@vivalanka.com";
	String toAddress =  "billing@vivalanka.com";
	String[] emailList = {toAddress};
	try{
    	MailObject.SendMail(  "messageText", heading, fromAddress, emailList);
		//pageMessage="Your information has been successfully sent. Your request will be reviewed and we will respond promptly. ";
	
	}catch(Exception ex){
		
	// pageMessage="Your message could not be sent. Please try again. ";

ex.printStackTrace();



	}
}
private String stripHTML(String source)
{
    try
    {
        String result;

        // Remove HTML Development formatting
        // Replace line breaks with space
        // because browsers inserts space
        result = source.replaceAll("\r", " ");
        // Replace line breaks with space
        // because browsers inserts space
        result = result.replaceAll("\n", " ");
        // Remove step-formatting
        result = result.replaceAll("\t", "");
        // Remove repeating spaces because browsers ignore them
        result = result.replaceAll("( )+", " ");

       /* // Remove the header (prepare first by clearing attributes)
        result = result.replaceAll( "<( )*head([^>])*>","<head>");
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        result = result.replaceAll(
                 @"(<( )*(/)( )*head( )*>)","</head>",
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        result = result.replaceAll(
                 "(<head>).*(</head>)",string.Empty,
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        // remove all scripts (prepare first by clearing attributes)
        result = result.replaceAll(
                 @"<( )*script([^>])*>","<script>",
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        result = result.replaceAll(
                 @"(<( )*(/)( )*script( )*>)","</script>",
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //result = result.replaceAll(
        //         @"(<script>)([^(<script>\.</script>)])*(</script>)",
        //         string.Empty,
        //         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        result = result.replaceAll(
                 @"(<script>).*(</script>)",string.Empty,
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        // remove all styles (prepare first by clearing attributes)
        result = result.replaceAll(
                 @"<( )*style([^>])*>","<style>",
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        result = result.replaceAll(
                 @"(<( )*(/)( )*style( )*>)","</style>",
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        result = result.replaceAll(
                 "(<style>).*(</style>)",string.Empty,
                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
*/
        // insert tabs in spaces of <td> tags
        result = result.replaceAll("<( )*td([^>])*>","\t");
               
        // insert line breaks in places of <BR> and <LI> tags
        result = result.replaceAll("<( )*br( )*>","\r");
               
        result = result.replaceAll("<( )*li( )*>","\r");
              

        // insert line paragraphs (double line breaks) in place
        // if <P>, <DIV> and <TR> tags
        result = result.replaceAll("<( )*div([^>])*>","\r\r");
                 
        result = result.replaceAll("<( )*tr([^>])*>","\r\r");
           
        result = result.replaceAll("<( )*p([^>])*>","\r\r");
            
        // Remove remaining tags like <a>, links, images,
        // comments etc - anything that's enclosed inside < >
        result = result.replaceAll("<[^>]*>"," ");
                

        // replace special characters:
        result = result.replaceAll(" "," ");
                
        result = result.replaceAll("&bull;"," * ");
               
        result = result.replaceAll("&lsaquo;","<");
             
        result = result.replaceAll("&rsaquo;",">");
                 
        result = result.replaceAll("&trade;","(tm)");
                
        result = result.replaceAll("&frasl;","/");
          
        result = result.replaceAll("&lt;","<");
              
        result = result.replaceAll("&gt;",">");
         
        result = result.replaceAll("&copy;","(c)");
        
        result = result.replaceAll("&reg;","(r)");
        // Remove all others. More can be added, see
        // http://hotwired.lycos.com/webmonkey/reference/special_characters/
        result = result.replaceAll("&(.{2,6});", " ");
                

        // for testing
        //result.replaceAll(
        //       this.txtRegex.Text,string.Empty,
        //      

        // make line breaking consistent
        result = result.replaceAll("\n", "\r");

        // Remove extra line breaks and tabs:
        // replace over 2 breaks with 2 and over 4 tabs with 4.
        // Prepare first to remove any whitespaces in between
        // the escaped characters and remove redundant tabs in between line breaks
        result = result.replaceAll("(\r)( )+(\r)","\r\r");
                
        result = result.replaceAll("(\t)( )+(\t)","\t\t");
                
        result = result.replaceAll("(\t)( )+(\r)","\t\r");
                
        result = result.replaceAll("(\r)( )+(\t)","\r\t");
                
        // Remove redundant tabs
        result = result.replaceAll("(\r)(\t)+(\r)","\r\r");
                
        // Remove multiple tabs following a line break with just one tab
        result = result.replaceAll("(\r)(\t)+","\r\t");
                
        // Initial replacement target string for line breaks
        String breaks = "\r\r\r";
        // Initial replacement target string for tabs
        String tabs = "\t\t\t\t\t";
        for (int index=0; index<result.length(); index++)
        {
            result = result.replaceAll(breaks, "\r\r");
            result = result.replaceAll(tabs, "\t\t\t\t");
            breaks = breaks + "\r";
            tabs = tabs + "\t";
        }

        // That's it.
        return result;
    }
    catch (Exception e)
    {
       // MessageBox.Show("Error");
        return source;
    }
}

}


