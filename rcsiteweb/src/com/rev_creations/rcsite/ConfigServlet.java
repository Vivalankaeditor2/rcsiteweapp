package com.rev_creations.rcsite;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

import com.rev_creations.util.ServiceLocator;

public class ConfigServlet extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public ConfigServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		 String realpath =  getServletConfig().getServletContext().getRealPath("..");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out
				.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");
		out.print("    This is ");
		out.print(this.getClass());
		out.println(", using the GET method");
		out.println("realpath: "+ realpath);
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out
				.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");
		out.print("    This is ");
		out.print(this.getClass());
		out.println(", using the POST method");
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}

	/**
	 * Returns information about the servlet, such as 
	 * author, version, and copyright. 
	 *
	 * @return String information about this servlet
	 */
	public String getServletInfo() {
		return "This is my default servlet created by Eclipse";
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		   try {
			 Config.loadConfig();

			   LocationUtil locationUtil = new LocationUtil();
			   getServletContext().setAttribute("locationUtil", locationUtil);
			  
			   String log4jconfigfilepath= Config.getValue("log4jconfigfilepath");
			   DOMConfigurator.configure(log4jconfigfilepath);
			   

		   } catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		   } 
		   
		   if(Config.getValue("pagecaching")!=null &&
					"1".equals(com.rev_creations.rcsite.Config.getValue("pagecaching").trim())){
									
					   try {
							 
							   
							   Calendar calendar = Calendar.getInstance();
							   ServiceLocator serviceLocator = new ServiceLocator(getServletContext());
							     getServletContext().setAttribute("newsListTime", calendar.getTimeInMillis());
								 ArticlePageGenerator.start(getServletContext());
								 System.out.println("news timer created.");
							   
						   } catch (Exception e) {
							   System.out.println("********** news timer creating ERROR **********.");
							   e.printStackTrace();
							// TODO: handle exception
						   } 
					}
		   if(Config.getValue("searchenabled")!=null &&
					"1".equals(com.rev_creations.rcsite.Config.getValue("searchenabled").trim())){
		   try {
				 
				   
			   		SearchUpdater.start();
					System.out.println("Search Update timer created.");
				   
			   } catch (Exception e) {
				   System.out.println("******Search Update timer creating ERROR *********.");
				   e.printStackTrace();
				
			   } 
		   }
	}      
	         


}
