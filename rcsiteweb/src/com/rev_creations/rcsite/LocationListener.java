package com.rev_creations.rcsite;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class LocationListener implements HttpSessionListener{

	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public void sessionCreated(HttpSessionEvent se) {
		HttpSession session = se.getSession();
		System.out.println("session created" );
		//add session id, time to log table
		
	}

	public void sessionDestroyed(HttpSessionEvent se) {
		
		HttpSession session = se.getSession();
		System.out.println("session destroyed" );
		//add (end time - 30min), log location and ip addess to database
		// TODO Auto-generated method stub
		
	}

}
