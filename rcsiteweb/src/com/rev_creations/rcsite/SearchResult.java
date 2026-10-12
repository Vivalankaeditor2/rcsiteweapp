package com.rev_creations.rcsite;

import java.util.List;

import org.apache.solr.common.SolrDocument;

public class SearchResult {
	private SolrDocument mainDocument;
	private List<SolrDocument> mltResults;

	public SearchResult(SolrDocument mainDocument, List<SolrDocument> mltResults) {
		this.mainDocument = mainDocument;
		this.mltResults = mltResults;
	}

	public SolrDocument getMainDocument() {
		return mainDocument;
	}

	public List<SolrDocument> getMltResults() {
		return mltResults;
	}

	public void setMainDocument(SolrDocument mainDocument) {
		this.mainDocument = mainDocument;
	}

	public void setMltResults(List<SolrDocument> mltResults) {
		this.mltResults = mltResults;
	}

}
