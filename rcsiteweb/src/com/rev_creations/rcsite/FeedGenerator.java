package com.rev_creations.rcsite;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.lang.reflect.Array;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.rev_creations.persistence.dao.Articles;
import com.rev_creations.persistence.dao.FeedChannel;
import com.rev_creations.persistence.interfaces.ArticlesFacadeRemote;
import com.sun.syndication.feed.synd.SyndCategory;
import com.sun.syndication.feed.synd.SyndCategoryImpl;
import com.sun.syndication.feed.synd.SyndContent;
import com.sun.syndication.feed.synd.SyndContentImpl;
import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndEntryImpl;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.feed.synd.SyndFeedImpl;
import com.sun.syndication.io.SyndFeedOutput;

public class FeedGenerator extends HttpServlet {
	DateFormat DATE_PARSER = new SimpleDateFormat("yyyy-MM-dd");

	/**
	 * Constructor of the object.
	 */
	public FeedGenerator() {
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
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int items =10;
      int categoryid =7;
      try{
    	  if(request.getParameter("categoryid")!=null){
    	  categoryid = Integer.parseInt(request.getParameter("categoryid"));
    	  }
    	  if(request.getParameter("items")!=null){
    		  items = Integer.parseInt(request.getParameter("items")); 
    	  }
    	  
      }catch (Exception ex) {
    	  ex.printStackTrace();
      }
      
		String feedType = "rss_2.0";
		//feedType = "atom_1.0";
		ArrayList entries = new ArrayList();
		ArrayList articles = new ArrayList();
		ArticlesFacadeRemote articlesFacadeRemote = null;
		String path = request.getContextPath();
		String basePath = request.getScheme() + "://" + request.getServerName()
				+ ":" + request.getServerPort() + path + "/";

		try {
			Hashtable env = new Hashtable();
			env.put(Context.INITIAL_CONTEXT_FACTORY,
					"org.jnp.interfaces.NamingContextFactory");
			env.put(Context.PROVIDER_URL, "localhost:1099");
			env.put(Context.URL_PKG_PREFIXES,
					"org.jboss.naming:org.jnp.interfaces");
			InitialContext ctx = new InitialContext(env);

			articlesFacadeRemote = (ArticlesFacadeRemote) ctx
					.lookup("ArticlesFacade/remote");
			int intarray[] = { 0, items };
			articles = (ArrayList) articlesFacadeRemote.findForWeb("categoryid",
					new Integer(categoryid), intarray);
			final SyndFeed feed = new SyndFeedImpl();
			
			feed.setEncoding("ISO-8859-1");
			//feed.setUri("dfaf");
			//feed.setEncoding("UTF-8");
			feed.setFeedType(feedType);
			feed.setTitle("VivaLanka.com Sri Lanka Latest News.");
			feed.setLink(basePath);
			feed.setDescription("Current and up to date news and events for global Sri Lankan community.");
			feed.setCopyright("Copyright 2010 VivaLanka.com");
			feed.setEntries(getEntries(articles, basePath));
			final SyndFeedOutput output = new SyndFeedOutput();

			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			output.output(feed, out);
			out.flush();
			out.close();
		}catch (Exception ex) {
			ex.printStackTrace();
			System.out.println("ERROR: " + ex.getMessage());
		}
	}

	/**
	 * This method adds an entry to the ArrayList() which will be published when
	 * GenerateRSS() is called.
	 * <p>
	 * 
	 * @param title
	 *            The title of the blog entry (not the blog itself)
	 * @param link
	 *            The PermaLink that will point to your entry
	 * @param date
	 *            The date of the blog entry
	 * @param blogContent
	 *            The content or synopsis you wish to publish
	 * @param cat
	 *            The category of the entry. This has been added to integrate
	 *            with Technorati and match WordPress functionality
	 * @param author
	 *            The author of the entry to be published.
	 * 
	 */
	private ArrayList getEntries(ArrayList articles, String basePath) {
		ArrayList entries = new ArrayList();
		SyndEntry entry;
		SyndContent description;
	
		SyndCategory category;
		List categories = new ArrayList();
		Articles article = null;
		for (Iterator itr = articles.iterator(); itr.hasNext();) {
			try {
				article = (Articles) itr.next();
				entry = new SyndEntryImpl();
				entry.setAuthor(article.getAuthorName());

				
				
				entry.setTitle(replaceHTMLEntity(article.getTitle()));

				
				entry.setLink(basePath + "news/page.jsp?articleid="
						+ article.getArticleId());
				entry.setPublishedDate(article.getEntryDate());
				description = new SyndContentImpl();
				description.setType("text/html");
				description.setValue(replaceHTMLEntity(article.getDescription()));
				entry.setDescription(description);
				category = new SyndCategoryImpl();
				category.setName(article.getCategoryid().toString());
				categories.add(category);
				entry.setCategories(categories);
				categories.remove(category);
				entries.add(entry);
			}catch (Exception ex) {
				ex.printStackTrace();
				System.out.println("ERROR: " + ex.getMessage());
			}
		}
		return entries;
	}
	
	public String  replaceHTMLEntity(String text){
		//text = text.replaceAll("&", "&amp;");
		//text = text.replaceAll("’", "&#39;");
		//text = text.replaceAll("'", "&#39;");
		//text = text.replaceAll("’", "&quot;");
		
		//text = text.replaceAll("<", "&lt;");
		//text = text.replaceAll(">", "&gt;");
		
		return text;
	}

	/**
	 * The doPost method of the servlet. <br>
	 * 
	 * This method is called when a form has its tag value method equals to
	 * post.
	 * 
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

	/**
	 * Initialization of the servlet. <br>
	 * 
	 * @throws ServletException
	 *             if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
