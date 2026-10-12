package com.rev_creations.rcsite;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NewsPage {
	public static List getNewsList() {
		return newsList;
	}

	public static void setNewsList(List newsList) {
		NewsPage.newsList = newsList;
	}

	private static Map adListMap = new HashMap();
	private static List adList = new ArrayList();
	
	private static List newsSummaryList = new ArrayList();
	private static List localNewsSummaryList = new ArrayList();
	private static List localFeaturesSummaryList = new ArrayList();
	private static Map newsSummaryListMap = new HashMap();
	
	private static List newsList = new ArrayList();

}
