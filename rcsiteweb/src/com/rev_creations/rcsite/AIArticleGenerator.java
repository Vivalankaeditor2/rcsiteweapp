package com.rev_creations.rcsite;
 
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.rev_creations.persistence.dao.Articles;
import com.theokanning.openai.completion.chat.ChatCompletionRequest;
import com.theokanning.openai.completion.chat.ChatCompletionResult;
import com.theokanning.openai.completion.chat.ChatMessage;
import com.theokanning.openai.completion.chat.ChatMessageRole;
import com.theokanning.openai.service.OpenAiService;

import org.json.JSONArray;
import org.json.JSONObject;

import me.vacuity.ai.sdk.claude.ClaudeClient;
import me.vacuity.ai.sdk.claude.entity.ChatMessageContent;
//import me.vacuity.ai.sdk.claude.entity.ChatMessage;
import me.vacuity.ai.sdk.claude.exception.VacSdkException;
import me.vacuity.ai.sdk.claude.request.ChatRequest;
import me.vacuity.ai.sdk.claude.response.ChatResponse;
 
public class AIArticleGenerator {
    private static String apiKey ;
    private static String apiKeyClaude ;

 
    private int     maxTokens = 3000 ;
    private String	model  ="gpt-4o";//"gpt-3.5-turbo-0613"    ;
    private String	modelClaude  ="claude-3-opus-20240229";
    private  String systemRoleContent = "You are an assistant that generates news articles for a news website. Please include Title:, Description: and Content: in seperate lines. limit to 300 words.";
    //systemRoleContent = "You are an assistant that generates news articles for a news website. Please write it in both English and Sinhala languages. Include \"Title\", \"Description\" and \"Content\" in a single json document with Language attribute. limit to 150 words.";    
     
    private String	prompt     ;
    private String	Article    ;
    private String	articleCategory  ;
    private double	temperature  = .2 ;
    private String	generatorMode ; 
    private String  newsStyle;
    private long    timeout = 100;

 
 
	public static String getApiKeyClaude() {
		return apiKeyClaude;
	}

	public static void setApiKeyClaude(String apiKeyClaude) {
		AIArticleGenerator.apiKeyClaude = apiKeyClaude;
	}

	public String getModelClaude() {
		return modelClaude;
	}

	public void setModelClaude(String modelClaude) {
		this.modelClaude = modelClaude;
	}

	public long getTimeout() {
		return timeout;
	}

	public void setTimeout(long timeout) {
		this.timeout = timeout;
	}

	public String getNewsStyle() {
		return newsStyle;
	}

	public void setNewsStyle(String newsStyle) {
		this.newsStyle = newsStyle;
	}

	public void setApiKey(String apiKey) {
		this.apiKey = apiKey;
	}
 
	public int getMaxTokens() {
		return maxTokens;
	}
 
	public void setMaxTokens(int maxTokens) {
		this.maxTokens = maxTokens;
	}
 
	public String getModel() {
		return model;
	}
 
	public void setModel(String model) {
		this.model = model;
	}
 
	public String getSystemRoleContent() {
		return systemRoleContent;
	}
 
	public void setSystemRoleContent(String systemRoleContent) {
		this.systemRoleContent = systemRoleContent;
	}
 
	public String getPrompt() {
		return prompt;
	}
 
	public void setPrompt(String prompt) {
		this.prompt = prompt;
	}
 
	public String getArticle() {
		return Article;
	}
 
	public void setArticle(String article) {
		Article = article;
	}
 
	public String getArticleCategory() {
		return articleCategory;
	}
 
	public void setArticleCategory(String articleCategory) {
		this.articleCategory = articleCategory;
	}
 
	public double getTemperature() {
		return temperature;
	}
 
	public void setTemperature(double temperature) {
		this.temperature = temperature;
	}
 
	public String getGeneratorMode() {
		return generatorMode;
	}
 
	public void setGeneratorMode(String generatorMode) {
		this.generatorMode = generatorMode;
	}
	 public Articles getNewsArticle(String userRoleContent, boolean generatorMode) {
		 return getNewsArticle(systemRoleContent, userRoleContent, generatorMode);
	 }
	 public Articles getNewsArticle(String systemRoleContent, String userRoleContent, boolean generatorMode) {
		  Articles articles = new Articles();
		 if(generatorMode!= true) {
			 articles = this.getTestNewsArticle() ;
		 }else {
 
	        OpenAiService service = new OpenAiService(apiKey, Duration.ofSeconds(30));
	        List<ChatMessage> messages = new ArrayList<>();
	        ChatMessage systemMessage = new ChatMessage(ChatMessageRole.SYSTEM.value(), systemRoleContent);
	        messages.add(systemMessage);
 
 
	        ChatMessage firstMsg = new ChatMessage(ChatMessageRole.USER.value(), userRoleContent);
	        messages.add(firstMsg);
 
 
	            ChatCompletionRequest chatCompletionRequest = ChatCompletionRequest
	                    .builder()
	                    .model(model)
	                    .messages(messages)
	                     .n(new Integer(1))
	                    .maxTokens(new Integer(maxTokens))
	                    .logitBias(new HashMap<>()).temperature(new Double(temperature))
	                    .build();


 
	        ChatCompletionResult result = service.createChatCompletion(chatCompletionRequest);
	        System.out.println("result :"+ result);

	        if (result != null && result.getChoices() != null && !result.getChoices().isEmpty()) {
	            String response = result.getChoices().get(0).toString();
	            String title = extractSection(response, "Title:");
	            String description = extractSection(response, "Description:");
	            String content = extractSection(response, "Content:");
 
	            content = content.replaceAll("\n", "<br>");
	            content = content.substring(0, content.lastIndexOf(","));
	            articles.setTitle(title);
	            articles.setDescription(description);
	            articles.setDetails(content);

	        } else {
	        	articles = null;
	        }
		 }
		 return articles;
	    }
	 public Map<String, Object> translateArticle(String systemRoleContent, String userRoleContent, boolean generatorMode) {
		  Articles article = new Articles();
		  String result =null;
		  ChatResponse response = null;
		  Map<String, Object> resultMap = new HashMap<>();
		  String shortDescription ="";
		  
		 if(generatorMode!= true) {
			 result = this.getTestJsonResults() ;
		 }else {

			    ClaudeClient client = new ClaudeClient(apiKeyClaude , Duration.ofSeconds(timeout));
			    List<me.vacuity.ai.sdk.claude.entity.ChatMessage> messages = new ArrayList<>();
			    messages.add(new me.vacuity.ai.sdk.claude.entity.ChatMessage("user", userRoleContent));
			    System.out.println("systemRoleContent : " + systemRoleContent );
			    System.out.println("userRoleContent : " + userRoleContent );
			    ChatRequest request = ChatRequest.builder()
			            .model(modelClaude)
			            .system(systemRoleContent)
			            .messages(messages)
			            .maxTokens(maxTokens)
			            .build();

			    try {
			    	response = client.chat(request);
			        System.out.println(response);
			    } catch (VacSdkException e) {
			        if (e.getDetail() != null) {
			            System.out.println(e.getDetail().getError().getMessage());
			        }
			    }
			    
			    List<ChatMessageContent> contents = response.getContent();
	            for (ChatMessageContent messageContent : contents) {
	                if ("tool_use".equals(messageContent.getType())) {
	                	
	                } else {
	                    System.out.println(messageContent.getText());
	                    result = messageContent.getText();
	                    
	                }
	            }
	            System.out.println(result);
	        
		 }
		 resultMap =extractMap(result);
		
		 return resultMap;

	    }
	 
	 public Map<String, Object> extractMap( String jsonString){
		 Articles article = new Articles();
		
		  Map<String, Object> resultMap = new HashMap<>();
		  String shortDescription ="";
	      
	      String language ="";
	      String title ="";
         String description = "";
         String content = "";
		 if (jsonString != null ) {
	        	
	        	
	        	jsonString ="["+jsonString+"]";
	        	JSONArray jsonArticles = new JSONArray(jsonString);
	            JSONObject jsonArticle = null;
	            for (int i = 0; i < jsonArticles.length(); i++) {
	                jsonArticle = jsonArticles.getJSONObject(i);
	                article = new Articles();

	               
	                title = jsonArticle.getString("Title");
	                description = jsonArticle.getString("Description");
	                content = jsonArticle.getString("Content");
	                content = content.replaceAll("\n", "<br>");
	                shortDescription = jsonArticle.getString("ShortDescription");

	                
	                article.setTitle(title);
	                article.setDescription(description);
	                article.setDetails(content);	               

	            }	        
	            article.setTitle(title);
	            article.setDescription(description);
	            article.setDetails(content);

	        } else {
	        	article = null;
	        }
		    resultMap.put("ShortDescription", shortDescription);
		    resultMap.put("Articles", article);
		  //  System.out.println("ShortDescription:" + shortDescription);
		    return resultMap;
		 
	 }
	 public Map<String, Object>  getNewsArticles(String userRoleContent, boolean generatorMode) {
		 return getNewsArticles(systemRoleContent, userRoleContent, generatorMode);
	 } 
	 public Map<String, Object>  getNewsArticles(String systemRoleContent, String userRoleContent, boolean generatorMode) {
		 Articles[] articlesArray = new Articles[2];
		 Map<String, Object> resultMap = new HashMap<>();
		 String jsonString ="";
		  Articles article = null;
			  
		 if(generatorMode!= true) {
			 jsonString = this.getTestJsonResults() ;
			 
		 }else {
 
	        OpenAiService service = new OpenAiService(apiKey, Duration.ofSeconds(30));
	        List<ChatMessage> messages = new ArrayList<>();
	        ChatMessage systemMessage = new ChatMessage(ChatMessageRole.SYSTEM.value(), systemRoleContent);
	        messages.add(systemMessage);
 
 
	        ChatMessage firstMsg = new ChatMessage(ChatMessageRole.USER.value(), userRoleContent);
	        messages.add(firstMsg);
 
 
	            ChatCompletionRequest chatCompletionRequest = ChatCompletionRequest
	                    .builder()
	                    .model(model)
	                    .messages(messages)
	                     .n(new Integer(1))
	                    .maxTokens(new Integer(maxTokens))
	                    .logitBias(new HashMap<>()).temperature(new Double(temperature))
	                    .build();


 
	        ChatCompletionResult result = service.createChatCompletion(chatCompletionRequest);
//	        System.out.println("result :"+ result);
	        
	        String language ="";
	        String title ="";
            String description = "";
            String content = "";

	        if (result != null && result.getChoices() != null && !result.getChoices().isEmpty()) {
	            String response = result.getChoices().get(0).toString();
	            
	            jsonString = response.substring(response.indexOf("{"), response.lastIndexOf("}")+1);
	            
	            
	            /*
	            
	            jsonString ="["+jsonString+"]";	            
	            
	            JSONArray jsonArticles = new JSONArray(jsonString);
	            JSONObject jsonArticle = null;
	            
	            
	            for (int i = 0; i < jsonArticles.length(); i++) {
	                jsonArticle = jsonArticles.getJSONObject(i);
	                article = new Articles();

	                language = jsonArticle.getString("Language");
	                title = jsonArticle.getString("Title");
	                description = jsonArticle.getString("Description");
	                content = jsonArticle.getString("Content");
	                content = content.replaceAll("\n", "<br>");

	                
	                article.setTitle(title);
	                article.setDescription(description);
	                article.setDetails(content);
	                articlesArray[i] = article;

	            }
	            */
	            
	        } else {
	        	resultMap = null;
	        }
		 }
		 resultMap = extractMap(jsonString);
		 return resultMap;
	    }
 
	    private String extractSection(String text, String sectionHeader) {
	        int startIndex = text.indexOf(sectionHeader);
	        if (startIndex == -1) return null;
 
	        startIndex += sectionHeader.length();
	        int endIndex = text.indexOf("\n", startIndex);

	        if (endIndex == -1) endIndex = text.length();
	        if("Content:".contains(sectionHeader)) {
	        	endIndex = text.indexOf("name=", startIndex);
	        	if(endIndex <0) {
	        		endIndex = text.length();
	        	}
	        }else {
	        }
	        return text.substring(startIndex, endIndex).trim();
	    }
	    
	    private String getTestJsonResults() {
	    	String jsonString = "";
	    	jsonString = "";
	    	return jsonString;
	    	
	    }
	    private Articles getTestNewsArticle() {
	    	Articles articles = new Articles();
	    	articles.setTitle("Test title");
            articles.setDescription("Test description Test description  Test description  Test description  Test description  Test description  Test description. ");
            articles.setDetails("Test content Test content Test content Test content Test content Test content Test content Test content Test content Test content Test content "
            		+ "Test content Test content Test content Test content .");
            return articles;
	    }
	    private Articles[] getTestNewsArticles() {
	    	Articles[] articlesArray = new Articles[2];
	    	Articles articles = new Articles();
	    	articles.setTitle("Test title");
            articles.setDescription("Test description Test description  Test description  Test description  Test description  Test description  Test description. ");
            articles.setDetails("Test content Test content Test content Test content Test content Test content Test content Test content Test content Test content Test content "
            		+ "Test content Test content Test content Test content .");
            articlesArray[0] = articles;
            
            articles.setTitle("");
            articles.setDescription("");
            articles.setDetails("");
            
            articlesArray[1] = articles;
            return articlesArray;
            
	    }

	    public static void main(String[] args) {
	    	Map<String, Object> aiResultMap;

	    	String theApiKey = "";	    	

	    	String theApiKeyClaude = "";
	    	
	        String systemRoleContent = "You are an assistant that generates news articles for a news website. Please include Title:, Description: and Content: in seperate lines. Write it in both English and Sinhala languages. limit to 300 words.";
	        systemRoleContent = "Please translate to Sinhala. You are an assistant that generates news articles for a news website. Please include Title:, Description: and Content: in seperate lines. limit to 300 words.";
	        String userRoleContent = "Please write a short descriptive news article.";
	        userRoleContent = userRoleContent +"A campaign that promised much but delivered so little "     
	       +"  Since winning the ICC T-20 World Cup in 2014, Sri Lanka had blown hot and cold in ICC events over the last ten years. But heading into this year�s "
	       + "T-20 showdown in the Caribbean and the United States, there was lot of hope. But it was all back to square one after";
	       
	        AIArticleGenerator aiArticleGenerator = new AIArticleGenerator();
	        aiArticleGenerator.setApiKeyClaude(theApiKeyClaude);
	        aiArticleGenerator.setApiKey(theApiKey);
	        aiArticleGenerator.setTemperature(.1);	      
	        
	        systemRoleContent = "You are an assistant that generates news articles for a news website. Include \"Title\", \"Description\", \"Content\" and \"ShortDescription\" in a single json document. limit  to 150 words and ShortDescription to 50 charactores ";
	        if(false) {
	        	systemRoleContent = "Please translate to Sinhala. "+ systemRoleContent ;
		        aiResultMap = aiArticleGenerator.translateArticle(systemRoleContent, userRoleContent, true);

	        }else  {
	        	aiResultMap = aiArticleGenerator.getNewsArticles(systemRoleContent,userRoleContent, true);

	        }
	        
	        if (aiResultMap != null) {
	        	 Articles article = (Articles)aiResultMap.get("Articles");
			     String shortDescription =(String) aiResultMap.get("ShortDescription");

	            System.out.println("Title: " + article.getTitle());
	            System.out.println("Description: " + article.getDescription());
	            System.out.println("Content: " + article.getDetails());
	            System.out.println("ShortDescription: " + shortDescription);

	        } else {
	            System.out.println("Failed to fetch the news article.");
	        }
	    }

 
}