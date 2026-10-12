package com.rev_creations.util;

import java.io.*;
import java.util.List;
import java.util.logging.Level;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;

import org.apache.log4j.Logger;
import org.hibernate.CacheMode;

import com.rev_creations.persistence.dao.RcsiteConfig;

/**
  * Class with some utility methods
  *
  *
  @author 
  @version 0.1.1
  @see 
  
  */
 

public class DBUtil {
	
	public static EntityManagerFactory entityManagerFactory = null;
	public static EntityManager entityManager = null;
	static Logger logger = Logger.getLogger(DBUtil.class);
	
	/**
	 * Find all RcsiteConfig entities.
	 * 
	 * @param rowStartIdxAndCount
	 *            Optional int varargs. rowStartIdxAndCount[0] specifies the the
	 *            row index in the query result-set to begin collecting the
	 *            results. rowStartIdxAndCount[1] specifies the the maximum
	 *            count of results to return.
	 * @return List<RcsiteConfig> all RcsiteConfig entities
	 */
	@SuppressWarnings("unchecked")
	public static List<RcsiteConfig> rcsiteConfigFindAll(final int... rowStartIdxAndCount) {
		logger.debug("finding all RcsiteConfig instances");
		try {
			
			final String queryString = "select model from RcsiteConfig model";
			Query query = getEntityManager().createQuery(queryString);
			if (rowStartIdxAndCount != null && rowStartIdxAndCount.length > 0) {
				int rowStartIdx = Math.max(0, rowStartIdxAndCount[0]);
				if (rowStartIdx > 0) {
					query.setFirstResult(rowStartIdx);
				}

				if (rowStartIdxAndCount.length > 1) {
					int rowCount = Math.max(0, rowStartIdxAndCount[1]);
					if (rowCount > 0) {
						query.setMaxResults(rowCount);
					}
				}
			}
			
			query.setHint("org.hibernate.cacheMode", CacheMode.REFRESH);
			query.setHint("org.hibernate.cacheable", false);
			return query.getResultList();
		} catch (RuntimeException re) {
			logger.error("find all RcsiteConfig failed");
			throw re;
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
} 