package com.rev_creations.rcsite;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.apache.solr.common.params.ModifiableSolrParams;
import org.apache.solr.common.params.MoreLikeThisParams;
import org.apache.solr.common.util.NamedList;

import com.rev_creations.persistence.dao.Articles;

public class RCSearchFacade {

	static String searchURL = "";
	boolean isParentCategory = true;

	public void setParentCategory(boolean isParentCategory) {
		this.isParentCategory = isParentCategory;
	}

	public static void setSearchURL(String searchURL) {
		RCSearchFacade.searchURL = searchURL;
	}

	public RCSearchFacade() {
		// add searchParams string array
	}

	public List<SearchResult> findForCategories(String categories, Integer categoryLimit) {
		ModifiableSolrParams searchParams = new ModifiableSolrParams();
		searchParams.set("qt", "/news");

		searchParams.set("fl",
				"id,title,description,url,categoryid,category,thumbnail,lastModified,content,parent_categoryid,start_date,end_date,site,image");
		if (isParentCategory) {
			searchParams.set("fq", "parent_categoryid:" + categories);
		} else {
			searchParams.set("fq", "categoryid:" + categories);
		}
		searchParams.set("rows", categoryLimit);
		// params.set("fq", "recent:[2020-05-09T00:00:00Z TO
		// 2024-05-09T00:00:00Z+1DAY]");
		searchParams.set(MoreLikeThisParams.MLT, true);
		searchParams.set("mlt.fl", "title,content"); // Fields to use for similarity
		searchParams.set("mlt.mindf", 1); // Minimum document frequency
		searchParams.set("mlt.mintf", 1); // Minimum term frequency
		searchParams.set("mlt.minwl", 3); // Minimum word length
		searchParams.set("mlt.count", 5); // Number of MLT results
		return findDocuments(searchParams);

	}

	public static List<SearchResult> findDocuments(ModifiableSolrParams searchParams) {
		SolrServer searchServer = new HttpSolrServer(searchURL);
		QueryResponse searchResponse = null;
		SolrDocumentList mainDocumentList = null;
		NamedList<Object> mltResponse = null;
		SearchResult searchResult = null;
		List<SearchResult> searchResultList = new ArrayList<>();
		List<SolrDocument> tempMLTDocList = new ArrayList<>();
		SolrDocumentList mltDocumentList = null;

		String uniqueId = "";
		try {
			searchResponse = searchServer.query(searchParams);
		} catch (Exception e) {
			e.printStackTrace();
		}

		mainDocumentList = searchResponse.getResults();

		for (SolrDocument tempMainDoc : mainDocumentList) {
			mltDocumentList = null;
			tempMLTDocList = new ArrayList<>();
			uniqueId = (String) tempMainDoc.getFieldValue("id");
			mltResponse = (NamedList<Object>) searchResponse.getResponse().get("moreLikeThis");

			if (mltResponse != null && mltResponse.size() > 0) {
				mltDocumentList = (SolrDocumentList) mltResponse.get(uniqueId);
				if (mltDocumentList != null) {
					tempMLTDocList.addAll(mltDocumentList);
				}
			}
			searchResult = new SearchResult(tempMainDoc, tempMLTDocList);
			searchResultList.add(searchResult);
		}
		return searchResultList;
	}

	public static List<Articles> findArticles(ModifiableSolrParams searchParams) {
		SolrServer searchServer = new HttpSolrServer(searchURL);
		QueryResponse searchResponse = null;
		try {
			searchResponse = searchServer.query(searchParams);
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<SolrDocument> documentList = searchResponse.getResults();
		List<Articles> articleList = new ArrayList<Articles>();
		Articles article = null;

		for (Iterator iterator = documentList.iterator(); iterator.hasNext();) {

			article = new Articles();

			SolrDocument document = (SolrDocument) iterator.next();
			article.setTitle((String) document.getFieldValue("title"));
			article.setDescription((String) document.getFieldValue("description"));
			article.setUrl((String) document.getFieldValue("url"));
			article.setThumbnail((String) document.getFieldValue("thumbnail"));
			article.setCategoryid((Integer) document.getFieldValue("categoryid"));
			article.setEntryDate(
					new java.sql.Timestamp(((java.util.Date) document.getFieldValue("lastModified")).getTime()));
			articleList.add(article);

		}
		return articleList;
	}

	public static void main(String[] args) {

		RCSearchFacade rcSearchFacade = new RCSearchFacade();
		List<SolrDocument> mltResults = null;
		rcSearchFacade.setSearchURL("https://www.vivalanka.com/rcsearch");
		rcSearchFacade.setParentCategory(false);
		List<SearchResult> documentList = rcSearchFacade.findForCategories("90", new Integer(3));

		for (Iterator<SearchResult> iterator = documentList.iterator(); iterator.hasNext();) {

			SearchResult searchResults = (SearchResult) iterator.next();
			SolrDocument document = searchResults.getMainDocument();

			System.out.println("title = " + document.getFieldValue("title"));
			System.out.println("description = " + document.getFieldValue("description"));
			System.out.println("id  = " + document.getFieldValue("id"));
			System.out.println("url = " + document.getFieldValue("url"));
			System.out.println("categoryid = " + document.getFieldValue("categoryid"));
			System.out.println("category = " + document.getFieldValue("category"));
			System.out.println("thumbnail = " + document.getFieldValue("thumbnail"));
			System.out.println("image = " + document.getFieldValue("image"));
			System.out.println("lastModified = " + document.getFieldValue("lastModified"));
			System.out.println("parent_categoryid = " + document.getFieldValue("parent_categoryid"));
			System.out.println("start_date = " + document.getFieldValue("start_date"));
			System.out.println("end_date = " + document.getFieldValue("end_date"));
			System.out.println("site = " + document.getFieldValue("site"));

			String dispalyDate = (new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy"))
					.format((document.getFieldValue("lastModified")));

			System.out.println("dispalyDate = " + dispalyDate);

			mltResults = searchResults.getMltResults();
			for (SolrDocument mltDocument : mltResults) {
				System.out.println("		mlt title = " + mltDocument.getFieldValue("title"));
				System.out.println("		mlt url = " + document.getFieldValue("url"));
				System.out.println("-------------");

				System.out.println("========++++++=====================");
			}
		}

	}

}
