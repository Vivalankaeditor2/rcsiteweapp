package com.rev_creations.util;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Collections;
import java.net.URL;


import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

import com.rev_creations.persistence.interfaces.ArticlesFacadeRemote;





public class ServiceLocator {

	//private static InitialContext jpaContext;
	private static ServletContext servletContext = null;
	private static ArticlesFacadeRemote articlesFacadeRemote = null;
	private Map cache; //used to hold references to EJBHomes/JMS Resources for re-use

	private static ServiceLocator me;
	
	public  ServiceLocator(ServletContext aServletContext){
		servletContext = aServletContext;
	}
	
	public static InitialContext getJPAContext() {

		InitialContext jpaContext = null;
		
		jpaContext = (InitialContext) servletContext.getAttribute("jpaContext");
		if (jpaContext == null) {
			try {

				Hashtable env = new Hashtable();
				env.put(Context.INITIAL_CONTEXT_FACTORY,
						"org.jnp.interfaces.NamingContextFactory");
				env.put(Context.PROVIDER_URL, "localhost:1099");
				env.put(Context.URL_PKG_PREFIXES,
						"org.jboss.naming:org.jnp.interfaces");
				jpaContext = new InitialContext(env);
				servletContext.setAttribute("jpaContext", jpaContext);

			} catch (Exception ex) {
				ex.printStackTrace();
				System.out.println("ERROR: getJPAContext()  "
						+ ex.getMessage());
			}
		}
		return jpaContext;
	}

	public static ArticlesFacadeRemote getArticlesFacadeRemote() {

		if (articlesFacadeRemote == null) {
			try {

				articlesFacadeRemote = (ArticlesFacadeRemote) getJPAContext()
						.lookup("ArticlesFacade/remote");
			} catch (Exception ex) {
				ex.printStackTrace();
				System.out.println("ERROR: getArticlesFacadeRemote()" + ex.getMessage());
			}

		}
		return articlesFacadeRemote;
	}
	
}
