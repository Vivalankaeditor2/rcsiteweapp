package com.rev_creations.rcsite;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;

import javax.servlet.ServletContext;


import com.rev_creations.persistence.dao.ArticleCategory;
import com.rev_creations.persistence.dao.Articles;
import com.rev_creations.persistence.dao.RcsiteConfig;
import com.rev_creations.persistence.interfaces.ArticlesFacadeRemote;
import com.rev_creations.util.ServiceLocator;

public class ArticlePageGenerator extends TimerTask {
	static ServletContext servletContext = null;
	public static EntityManagerFactory entityManagerFactory = null;
	public static EntityManager entityManager = null;
	
	public static Timer newsPageTimer = null;
	public static long newsPageTimerPeriod = 1000 * 60 * 1;
	public static Hashtable<String, GeneratorSetting> categoryLimitTable   = new Hashtable<String, GeneratorSetting>();
	public static boolean initialized = false;
	public static Map<String, List<Articles>> articleListMap =  null;
	public static Map<String, List<SearchResult>> searchResultListMap =  null;
	public static Map<String, ArticleCategory> articleCategoryMap =  null;
	public static Map<String, String> articleCategoryGroupMap =  null;
	
	/*
	 * map that allow get category group from single category
	 */
	public static Map<String, String> articleCategorySingleMap =  null;
	
	public static Map<String, String> getArticleCategoryGroupMap() {
		if(articleCategoryGroupMap ==null){
			articleCategoryGroupMap =  new HashMap<String, String>();
		}
		return articleCategoryGroupMap;
	}

	public synchronized static void initialize(ServletContext servletContext) {
		initialized =true;

		articleListMap =  new HashMap<String, List<Articles>>();
		searchResultListMap = new HashMap<String, List<SearchResult>>();
		articleCategoryMap =  new HashMap<String, ArticleCategory>();
		articleCategoryGroupMap =  new HashMap<String, String>();
		articleCategorySingleMap =  new HashMap<String, String>();
		
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.SECOND, 5);
		categoryLimitTable.put("7", new GeneratorSetting(150,15,calendar.getTime()));
		//calendar.add(Calendar.MINUTE, 2);
		categoryLimitTable.put("8", new GeneratorSetting(20,16,calendar.getTime()));
		//calendar.add(Calendar.MINUTE, 2);
		categoryLimitTable.put("10", new GeneratorSetting(20,17,calendar.getTime()));
		//calendar.add(Calendar.MINUTE, 2);
		categoryLimitTable.put("11", new GeneratorSetting(20,18,calendar.getTime()));
	//	calendar.add(Calendar.MINUTE, 2);
		categoryLimitTable.put("13", new GeneratorSetting(20,19,calendar.getTime()));
//		calendar.add(Calendar.MINUTE, 2);
		categoryLimitTable.put("14", new GeneratorSetting(20,20,calendar.getTime()));
//		calendar.add(Calendar.MINUTE, 2);
	//	categoryLimitTable.put("15", new GeneratorSetting(60,21,calendar.getTime()));
		
		loadCategoryLimitTable();
	
	}
	
	public static void loadCategoryLimitTable(){
		 categoryLimitTable   = new Hashtable<String, GeneratorSetting>();
		String categories ="";
		String categoryID = "";
		Calendar calendar = Calendar.getInstance();
		List<RcsiteConfig> configList = Config.getConfigList();
		
	      if( configList!=null){
	    	  RcsiteConfig rcsiteConfig ;
	    	  String key="";
	    	  String category = "";
	    	  int categoryLimit =5;
	    	  int categoryInterval =20;
	    	  
		      Iterator iter = configList.iterator();
		      while(iter.hasNext()){
		    	  rcsiteConfig = (RcsiteConfig)iter.next();
		    	  key = rcsiteConfig.getConfigKey();
		    	  if(key.startsWith("categorylimit.")){
		    		  
		    		  category = key.substring("categorylimit.".length());
		    		  categoryLimit = Integer.parseInt(Config.getValue(key));
		    		  
		    		  key = key.replace("limit", "interval");
		    		  categoryInterval = Integer.parseInt(Config.getValue(key));
//		    		  calendar.add(Calendar.MINUTE, 2);
		    		  categoryLimitTable.put(category, 
		    				  new GeneratorSetting(categoryLimit, categoryInterval, calendar.getTime()));
		    	  }
		    	  

		      }
	      }
		
		String log4jconfigfilepath= Config.getValue("categorylimit.8");
		 Config.getValue("categoryinterval.8");
		GeneratorSetting generatorSetting;
		try {
			String[] categoryArray = null;
			Enumeration<String> enumu = categoryLimitTable.keys();
			while (enumu.hasMoreElements()) {
			    categoryID = enumu.nextElement();
			    categories = categories +","+ categoryID;
			    generatorSetting = categoryLimitTable.get(categoryID);
			    
			    //add single categories to map
			    categoryArray = categoryID.split(",");
			    for (int i = 0; i< categoryArray.length ; i++) {
			    	articleCategorySingleMap.put(categoryArray[i], categoryID);
					System.out.println("articleCategorySingleMap: "+ categoryArray[i] +" - " +categoryID);
			    }
			}
			categories = categories.substring(categories.indexOf(",")+1) ;
			createArticleCategoryMap(categories);
		    System.out.println("initial ArticleCategoryList created: " +categories);
			
		} catch (RuntimeException re) {
			re.printStackTrace();
		}
	}
	
	@Override
	public void run() {
		generateArticlePage();
	}

	
	public static List<Articles>  getArticleList(String categories) {
		List<Articles> articleList = null;
		
		if(articleListMap!=null && articleListMap.get(categories)!=null){
			articleList = articleListMap.get(categories);
		}else{
			//articleList =  createArticleList(categories);
		}
		return articleList;
	}
	
	public static List<SearchResult>  getSearchResultList(String categories) {
		List<SearchResult> searchResultList = null;
		System.out.println("getSearchResultList :"+ categories);
		if(searchResultListMap!=null && searchResultListMap.get(categories)!=null){ 
			
			searchResultList = searchResultListMap.get(categories);
		}else{
			//articleList =  createArticleList(categories);
		}
		return searchResultList;
	}
	
	private static List<Articles>  createArticleList(String categories, int limit) throws Exception{
		List<Articles> articleList = null;
		ArticlesFacadeRemote articlesFacadeRemote = null;
		
		
		articlesFacadeRemote = ServiceLocator.getArticlesFacadeRemote();
		articleList = articlesFacadeRemote.findForCategories(categories, limit);

		
		return articleList;
		
	}
	
	private static List<SearchResult>  createSearchResultList(String categories, int limit, boolean parentCategoryFlag) throws Exception{
		List<SearchResult> searchResultList = null;
		RCSearchFacade rcSearchFacade = new RCSearchFacade();
		RCSearchFacade.setSearchURL(Config.getValue("search.url"));
		rcSearchFacade.setParentCategory(parentCategoryFlag);
		searchResultList =  rcSearchFacade.findForCategories(categories , new Integer(limit));
		
		return searchResultList;
		
	}
	private static List<Articles>  createArticleList(String categories) {
		String[] categoryArray = categories.split(",");
		int[] category =  new int[categoryArray.length];
	    Integer categoryLimit = 0;
		Query query ;
		List<Articles> articleList = null;
		
		boolean error = false;
	
		String queryString = "";
		
		
		if(categoryLimitTable.get(categories) != null){
			categoryLimit =  categoryLimitTable.get(categories).getLimit();
		}else{
			categoryLimit = new Integer(60);
			//return articleList;
		}
		try{
		//articleList = createArticleList( categories, categoryLimit);
		
		} catch (Exception re) {
			error = true;
			re.printStackTrace();
		}
		if(true){
		try {
			queryString = "select model from Articles model WHERE ( " ;
			for (int i = 0; i< categoryArray.length ; i++) {
				category[i] =  Integer.parseInt(categoryArray[i]);
				queryString = queryString+ "  model.categoryid = :categoryidValue"+i + " OR";
			}
			queryString = queryString.substring(0, queryString.lastIndexOf("OR"));
			queryString = queryString +" ) AND model.aprovalStatus <> '0' ORDER BY model.articleId DESC" ;

			query = getEntityManager().createQuery(queryString);
		
			for (int i = 0; i< categoryArray.length ; i++) {
				query.setParameter("categoryidValue"+i, new Integer(category[i]));
			}
			
			query.setMaxResults(categoryLimit);
			articleList = query.getResultList();
		
		} catch (RuntimeException re) {
			re.printStackTrace();
		} 
		}
		return articleList;
	}
	
	
	private static List<SearchResult>  createSearchResultList(String categories, boolean parentCategoryFlag) {

	    Integer categoryLimit = 0;
		List<SearchResult> searchResultList = null;
	
		
		if(categoryLimitTable.get(categories) != null){
			categoryLimit =  categoryLimitTable.get(categories).getLimit();
		}else{
			categoryLimit = new Integer(60);
		}
		
		try{
			searchResultList = createSearchResultList( categories, categoryLimit, parentCategoryFlag);
		
		} catch (Exception re) {
			re.printStackTrace();
		}
		
		return searchResultList;
	}

	
@SuppressWarnings({ "null", "unchecked" })
public static List<ArticleCategory>  getArticleCategoryMap(String categories) {
			String[] categoryArray = categories.split(",");
			ArticleCategory articleCategory = null;
			
			String newCategories="";
			List<ArticleCategory> articleCategoryList = new ArrayList<ArticleCategory>();
			List<ArticleCategory> newArticleCategoryList =null;

			if(articleCategoryMap== null){
				articleCategoryMap =  new HashMap<String, ArticleCategory>();
			}
		
			for (int i = 0; i< categoryArray.length ; i++) {
				articleCategory = articleCategoryMap.get(categoryArray[i]);
				if(articleCategory!=null){
					articleCategoryList.add(articleCategory);
				}else{
					newCategories = categoryArray[i]+","+newCategories;
				}
			}
			
			if(newCategories.length()>0){
				newCategories =newCategories.substring(0, newCategories.lastIndexOf(","));
				newArticleCategoryList = createArticleCategoryMap(newCategories);
				
				if(newArticleCategoryList!=null){
					articleCategoryList.addAll(newArticleCategoryList);
				}
			}
			
			return articleCategoryList;
		}
	
	
@SuppressWarnings({ "null", "unchecked" })
public static List<ArticleCategory>  createArticleCategoryMap(String categories) {
		String[] categoryArray = categories.split(",");
		ArticleCategory articleCategory = null;
		
		List<ArticleCategory> articleCategoryList = new ArrayList<ArticleCategory>();
		Iterator articleCategoryIterator=null;
		Query query ;
		String queryString = "";
		if(articleCategoryMap== null){
			articleCategoryMap =  new HashMap<String, ArticleCategory>();
		}

		try {
			queryString = "select model from ArticleCategory model WHERE categoryid in( "+categories +" )" ;
			query = getEntityManager().createQuery(queryString);
			
			articleCategoryList = query.getResultList();
			
			 articleCategoryIterator=articleCategoryList.iterator();
		   		while(articleCategoryIterator.hasNext()){
		   			articleCategory=(ArticleCategory)articleCategoryIterator.next();
		   			articleCategoryMap.put(""+articleCategory.getCategoryid(), articleCategory);
		   		}

		} catch (RuntimeException re) {
			re.printStackTrace();
		} 

		return articleCategoryList;
	}

	private static void  generateArticlePage() {
		String categoryID;
		boolean parentCategoryFlag = false;
		int createdNumber =0;
	
		List<Articles> articleList = null;
		List<SearchResult> searchResultList = null;
		Calendar calendar = Calendar.getInstance();
		Calendar intervalCalendar = null;
		GeneratorSetting generatorSetting= null;
		servletContext.setAttribute("newsListTime", calendar.getTimeInMillis());
		try {
		//	entityManager.close();
			
			try {

				Enumeration<String> enumu = categoryLimitTable.keys();
				 System.out.print("categoryIDs: ");
				while (enumu.hasMoreElements()) {
				    categoryID = enumu.nextElement();
				  //  categoryLimit = (Integer) categoryLimitTable.get(categoryID);
				    generatorSetting = categoryLimitTable.get(categoryID);
				    System.out.print(": " +categoryID +" : ");
				    if(generatorSetting.getNextTime().before(calendar.getTime())){
				    	if(createdNumber <= 14){
				    		createdNumber++;
				    		
				    		if(categoryID.contains("search")) {
				    			if(categoryID.contains("parent")) { //ex. categoryinterval.search.parent.wp.0
				    				parentCategoryFlag = true;
				    				categoryID = categoryID.substring(14);
				    			}else { // ex.  categoryinterval.search.90
				    				parentCategoryFlag = false;
				    				categoryID = categoryID.substring(7);
				    			}
				    			searchResultList = createSearchResultList(categoryID,parentCategoryFlag);
				    			searchResultListMap.put(categoryID, searchResultList);
				    		}else {
						    	articleList = createArticleList(categoryID);
						    	articleListMap.put(categoryID, articleList);
				    		}
					    	
					    	intervalCalendar= Calendar.getInstance();
					    	intervalCalendar.add(Calendar.MINUTE, generatorSetting.getInterval());
					    	generatorSetting.setNextTime(intervalCalendar.getTime());
					    	System.out.println("created categoryID: " +categoryID +" : ");
				    	}else{
					    	System.out.println("skipped categoryID: " +categoryID +" : ");
					    }
				    	
				    }
				    
				}
			} catch (RuntimeException re) {
				re.printStackTrace();
			} 
			System.out.println((new Date())+" generateNewsPage() method.");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static EntityManager  getEntityManager() {
		try {
	
			if (entityManagerFactory == null || !entityManagerFactory.isOpen()) {
				entityManagerFactory = Persistence.createEntityManagerFactory("rcsitewebPU");
				entityManager = entityManagerFactory.createEntityManager();
			}
			
			if (entityManager == null || !entityManager.isOpen()) {
				entityManager = entityManagerFactory.createEntityManager();
			}
			
		} catch (RuntimeException re) {
			re.printStackTrace();
		} 
		
		return entityManager;
	}
	
	public synchronized static void start(ServletContext servletContext) {
		
		if(newsPageTimer !=null){
			 newsPageTimer.cancel();
			}
		ArticlePageGenerator.servletContext = servletContext;
		newsPageTimer = new Timer();
		ArticlePageGenerator articlePageGenerator = new ArticlePageGenerator();

		// get a calendar to initialize the start time
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MINUTE, 1);
		Date startTime = calendar.getTime();
	
		// schedule the task to run hourly
		newsPageTimer.scheduleAtFixedRate(articlePageGenerator, startTime,	newsPageTimerPeriod);

	}

	public static void main(String[] args) {

		//ArticlePageGenerator articlePageGenerator = new ArticlePageGenerator();
		//articlePageGenerator.generateArticlePage();
		Map articleCategoryGroupMap = new HashMap();
		for(int i= 0; i<5; i++ ){
			
			
			articleCategoryGroupMap.put("7", i);
			
		}
	}
/*
	public void contextDestroyed(ServletContextEvent arg0) {
		entityManagerFactory.close();
		
	}

	public void contextInitialized(ServletContextEvent sce) {
		entityManagerFactory = Persistence.createEntityManagerFactory("rcsitewebPU");
		servletContext = sce.getServletContext();
		servletContext.setAttribute("entityManagerFactory", entityManagerFactory);
	
	}
	*/
	
	/*
	public static void generateNewsPage(ServletContext servletContext) {
		ArticlePageGenerator.servletContext = servletContext;
		generateNewsPage();
	}
	*/
}
