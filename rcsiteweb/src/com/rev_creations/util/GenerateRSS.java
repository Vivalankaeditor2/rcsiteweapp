package com.rev_creations.util;

import com.rev_creations.rcsite.Config;
import com.sun.syndication.feed.synd.*;
import com.sun.syndication.io.SyndFeedOutput;
import java.io.FileWriter;
import java.io.Writer;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
 
//import net.thepostmodern.fatima.blog.*;
//import net.thepostmodern.fatima.sql.ConnectionFactory;
 
 
/**
 * @author   bbjwerner
 */
public class GenerateRSS {
	
	public static void main(String[] args) {
		GenerateRSS generateRSS = new GenerateRSS();
		generateRSS.generateBlogRSS("rss_2.0", "testrrs");
	}
	
	private static final DateFormat DATE_PARSER = new SimpleDateFormat("yyyy-MM-dd");
	private static String fileName = null;
	private static String feedType = null;
    private final List entries = new ArrayList();
	private final List categories = new ArrayList();
    SyndEntry entry;
    SyndContent description;
	SyndCategory category;
 
	/**
	 * This method generates a seperate RSS feed for all categories in blog
	 * @param feedType The type of feed you wish to generate (RSS2.0, atom, ect.).
	 * @param fileName Filename will be category.xml, and this entry does nothing to override this.
	 */
	public void generateCategoryRSS(String Type, String Name) {
		feedType = Type;
		fileName = Name;
		populateCategoryArray();
	}
	
	/**
	 * This method generates the RSS feeds for a complete blog with categories
	 * @param Type The type of feed you wish to generate (RSS2.0, atom, ect.).
	 * @param Name The filename to write out the format to.
	 */
	public void generateBlogRSS(String Type, String Name) {
		feedType = Type;
		fileName = Name;
		this.populateArray();
	}
        
        	/**
	 * This method generates the RSS feeds for podcasting based on category (i.e. Podcast)
	 * @param Category The category to run as containing podcast content.
	 * @param Name The filename to write out the format to.
	 */
        public void generatePodcastRSS(String Category, String Name) {
		feedType = "rss2.0";
		fileName = Name;
		this.populatePodcastArray(Category);
	}
	
	public GenerateRSS() {
	    
	}
	
	private void populateArray() {
 
	  //  final ConnectionFactory thisFactory = new ConnectionFactory();
		ResultSet blogEntries = null;
		ResultSet blogInfo = null;
		
	    try {
		
		
		blogEntries =executeStatement("SELECT * FROM articles ORDER BY article_id DESC limit 10");
	//	blogInfo = executeStatement("SELECT * FROM blog_info");
		blogEntries.first();
		//blogInfo.first();
		while (!blogEntries.isAfterLast()) {
		    
		  this.addEntry(blogEntries.getString("title"), "/blog/BlogEntry.jsp?id=" + blogEntries.getString("article_id"), blogEntries.getString("entry_date"), blogEntries.getString("dcode"), "category", blogEntries.getString("author_name"));
		  blogEntries.next();
		}
		
		
		this.doSyndication("name", "url/blog", "description", "copyright",fileName);
		System.out.println("Did Syndication");
		
		}
		
		catch (Exception ex) {
			
			 System.out.println("SQLException: " + ex.getMessage());
		}
		
		finally {
		    
		    try {blogEntries.close(); } catch (Exception ex) { System.out.println("SQLException: " + ex.getMessage()); }
		    try {blogInfo.close(); } catch (Exception ex) { System.out.println("SQLException: " + ex.getMessage()); }
		  //  Close();
		}
	}
	
	private void populateCategoryArray() {
 
	   // final ConnectionFactory thisFactory = new ConnectionFactory();
		ResultSet blogEntries = null;
		ResultSet blogInfo = null;
		ResultSet blogCategories = null;
		try {
		
		blogCategories = executeStatement("SELECT * FROM blog_categories");
		blogInfo = executeStatement("SELECT * FROM blog_info");
		blogInfo.first();
		blogCategories.first();
		while (!blogCategories.isAfterLast()) {
		    
		    blogEntries = executeStatement("SELECT * FROM blog_entry WHERE category = '" + blogCategories.getString("id") + "' ORDER BY id DESC");
			blogEntries.first();
			//System.out.println("************ Doing category: " + CategoryBean.getCategory(blogCategories.getString("id")));
			
			while (!blogEntries.isAfterLast()) {  
	//		  this.addEntry(blogEntries.getString("title"),blogInfo.getString("url") + "/blog/BlogEntry.jsp?id=" + blogEntries.getString("id"), blogEntries.getString("date"), blogEntries.getString("teaser"), CategoryBean.getCategory(blogEntries.getString("category")), blogEntries.getString("author"));
			  blogEntries.next();
			
			}
			
			final String XMLfile = ((fileName + blogCategories.getString("category")) + ".xml");
			this.doSyndication(blogCategories.getString("title"), blogInfo.getString("url") + "/blog/BlogbyCategory.jsp?id=" + blogCategories.getString("id"), blogCategories.getString("description"), blogInfo.getString("copyright"), XMLfile);
			this.entries.clear();
			blogCategories.next();
		}
		
	} 
		
		catch (Exception ex) {
			
			 System.out.println("Category SQLException: " + ex.getMessage());
		}
		
		finally {
		    
		    try {blogEntries.close(); } catch (Exception ex) { System.out.println("SQLException: " + ex.getMessage()); }
		    try {blogInfo.close(); } catch (Exception ex) { System.out.println("SQLException: " + ex.getMessage()); }
		    try {blogCategories.close(); } catch (Exception ex) { System.out.println("SQLException: " + ex.getMessage()); }
		   // thisFactory.Close();
		}
		
	}
	
	private void populatePodcastArray(String category_string) {
	    
	  //  final ConnectionFactory thisFactory = new ConnectionFactory();
		ResultSet podEntries = null;
		ResultSet blogInfo = null;
		
	    try {
		
		
	    podEntries = executeStatement("SELECT * FROM podcasts");
		blogInfo = executeStatement("SELECT * FROM blog_info");
		podEntries.first();
		blogInfo.first();
		while (!podEntries.isAfterLast()) {
		    
		  this.addPodCast(podEntries.getString("title"),blogInfo.getString("url") + "/blog/radio/" + podEntries.getString("filename"),podEntries.getString("date"), podEntries.getString("description"), category_string, podEntries.getString("author"));
		  podEntries.next();
		}
		
		
		this.doSyndication(blogInfo.getString("name"), blogInfo.getString("url"), blogInfo.getString("description"), blogInfo.getString("copyright"),fileName);
		System.out.println("Did Syndication");
		
		}
		
		catch (Exception ex) {
			
			 System.out.println("SQLException: " + ex.getMessage());
		}
		
		finally {
		    
		    try {podEntries.close(); } catch (Exception ex) { System.out.println("SQLException: " + ex.getMessage()); }
		    try {blogInfo.close(); } catch (Exception ex) { System.out.println("SQLException: " + ex.getMessage()); }
		    //thisFactory.Close();
		}
		
	}
 
	/**
	 * This method adds an entry to the ArrayList() which will be published when GenerateRSS()
	 * is called.
	 * <p>
	 * @param title The title of the blog entry (not the blog itself)
	 * @param link The PermaLink that will point to your entry
	 * @param date The date of the blog entry
	 * @param blogContent The content or synopsis you wish to publish
	 * @param cat The category of the entry. This has been added to integrate 
	 *        with Technorati and match WordPress functionality
	 * @param author The author of the entry to be published.
	 * 
	 */
	private void addEntry(String title, String link, String date, String blogContent, String cat, String author) {
		
		try {
 
        entry = new SyndEntryImpl();
	    entry.setAuthor(author);
        entry.setTitle(title);
        entry.setLink(link);
        entry.setPublishedDate(DATE_PARSER.parse(date));
        description = new SyndContentImpl();
        description.setType("text/plain");
        description.setValue(blogContent);
        entry.setDescription(description);
	    category = new SyndCategoryImpl();
		category.setName(cat);
		categories.add(category);
		entry.setCategories(categories);
		categories.remove(category);
		entries.add(entry);
		
		}
		
        catch (Exception ex) {
            ex.printStackTrace();
            System.out.println("ERROR: "+ex.getMessage());
                             }
		
	}
	
	private void addPodCast(String title, String mp3link, String date, String blogContent, String cat, String author) {
		
		try {
 
        entry = new SyndEntryImpl();
	entry.setAuthor(author);
        entry.setTitle(title);
        entry.setLink(mp3link);
        entry.setPublishedDate(DATE_PARSER.parse(date));
        description = new SyndContentImpl();
        description.setType("text/plain");
        description.setValue(blogContent);
        entry.setDescription(description);
	    category = new SyndCategoryImpl();
		category.setName(cat);
		categories.add(category);
		entry.setCategories(categories);
		categories.remove(category);
		entries.add(entry);
		
		}
		
        catch (Exception ex) {
            ex.printStackTrace();
            System.out.println("ERROR: "+ex.getMessage());
                             }
		
	}
	
	
	/**
	 * This method is called last after you have added all your entries and have specified your
	 * feed type and filename. This actually does the work
	 * <p>
	 * NOTE: This has static content entered in to the fields! You must have access to the source
	 * code edit this method or else you will be publishing content as the Post Modern Banter Blog
	 * Yes, I should change this immediately. Ideally, it would take values from the web.xml file itself.
	 * <p>
	 * @throws Exception
	 */
	private void doSyndication(String title, String link, String description_loc, String copyright, String xml) {
		
 
		
            try {
 
                final SyndFeed feed = new SyndFeedImpl();
                feed.setFeedType(feedType);
 
                feed.setTitle(title);
                feed.setLink(link);
                feed.setDescription(description_loc);
			   feed.setCopyright(copyright);
				
                feed.setEntries(entries);
			   
 
                final Writer writer = new FileWriter(xml);
                final SyndFeedOutput output = new SyndFeedOutput();
                output.output(feed,writer);
                writer.close();
 
                System.out.println("************* The feed has been written to the file ["+xml+"]");
 
            }
			
            catch (Exception ex) {
                ex.printStackTrace();
                System.out.println("ERROR: "+ex.getMessage());
                                 }
        
	}
	
	public ResultSet executeStatement(String sql){
		System.setProperty("rcsite.config", "F://myeclipse80work//rcsiteweb//config//rcsite.config");
		Config.loadConfig();
		String MM_dbconnection_DRIVER = "org.gjt.mm.mysql.Driver";
		String MM_dbconnection_USERNAME = com.rev_creations.rcsite.Config.getValue("databaseusername");
		String MM_dbconnection_PASSWORD = com.rev_creations.rcsite.Config.getValue("databasepassword");
		String MM_dbconnection_STRING = "jdbc:mysql://localhost/"+com.rev_creations.rcsite.Config.getValue("database")+"";
		
		java.sql.ResultSet LocationRecordset = null;
		java.sql.Driver DriverLocationRecordset = null;
		java.sql.Connection ConnLocationRecordset = null;
		java.sql.PreparedStatement StatementLocationRecordset = null;
		try{
		DriverLocationRecordset = (java.sql.Driver)Class.forName(MM_dbconnection_DRIVER).newInstance();
		ConnLocationRecordset = java.sql.DriverManager.getConnection(MM_dbconnection_STRING,MM_dbconnection_USERNAME,MM_dbconnection_PASSWORD);
		StatementLocationRecordset = ConnLocationRecordset.prepareStatement(sql);
		 LocationRecordset = StatementLocationRecordset.executeQuery();
		}catch(Exception e){
			
		}finally{
			try{
			//LocationRecordset.close();
			//StatementLocationRecordset.close();
			//ConnLocationRecordset.close();
			}catch(Exception e){
				
			}
		}
		return LocationRecordset;
	}
}

