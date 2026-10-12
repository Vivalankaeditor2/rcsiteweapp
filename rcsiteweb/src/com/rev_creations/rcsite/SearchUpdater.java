package com.rev_creations.rcsite;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.servlet.ServletContext;


import java.util.Base64;

public class SearchUpdater extends TimerTask {
	static ServletContext servletContext = null;
	static String username = "rcsite";
	static String  password = "rcsite";
	static String  urlString = "http://rcsiteweb:8080/search/dataimport?command=delta-import";
	public static EntityManagerFactory entityManagerFactory = null;
	public static EntityManager entityManager = null;
	
	public static Timer searchUpdaterTimer = null;
	public static long searchUpdaterPeriod = 1000 * 10 * 15;

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		start();

	}
	@Override
	public void run() {
		System.out.println((new Date()).toString());

		
		try{
			URL url = new URL(urlString);
			URLConnection uc = url.openConnection();
			String userpass = username + ":" + password;
			String basicAuth = "Basic " + new String( Base64.getEncoder().encode(userpass.getBytes()));
		
			uc.setRequestProperty ("Authorization", basicAuth);
			//InputStream in = uc.getInputStream();
			BufferedReader  in = new BufferedReader(new InputStreamReader(
                    uc.getInputStream()));

			 String inputLine;
		        while ((inputLine = in.readLine()) != null) {
		            System.out.println(inputLine);
		         }
		        
		        in.close();

	
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public synchronized static void start() {
		if(Config.getConfigList()!=null && Config.getConfigList().size()>0){
			username 	= Config.getValue("search.admin.username");
			password 	= Config.getValue("search.admin.password");
			urlString 	= Config.getValue("wwwUrl")+"/rcsearch/dataimport?command=delta-import";
			searchUpdaterPeriod = Long.parseLong(Config.getValue("search.searchUpdaterPeriod"))*1000*60;
		}
		
		if(searchUpdaterTimer !=null){
			searchUpdaterTimer.cancel();
			}
		//HTTPPostScheduler.servletContext = servletContext;
		searchUpdaterTimer = new Timer();
		
		SearchUpdater searchUpdater = new SearchUpdater();
		// get a calendar to initialize the start time
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MINUTE, 1);
		Date startTime = calendar.getTime();
	
		// schedule the task to run hourly
		searchUpdaterTimer.scheduleAtFixedRate(searchUpdater, startTime,	searchUpdaterPeriod);

	}
	
	public synchronized static void stop() {
		if(searchUpdaterTimer !=null){
			searchUpdaterTimer.cancel();
			}
	}

}
