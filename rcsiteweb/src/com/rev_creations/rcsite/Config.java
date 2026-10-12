package com.rev_creations.rcsite;

import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import com.rev_creations.persistence.dao.RcsiteConfig;
import com.rev_creations.util.DBUtil;

public class Config {

private static Properties properties;
private static List<RcsiteConfig> configList;

	public  Config(Properties properties) {
	this.properties = properties;
}
	public static Properties getProperties() {
		return properties;
	}
public static List<RcsiteConfig> getConfigList() {
	return configList;
}

	public static String getValue(String key){
		
		return properties.getProperty(key) ;
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		//Config.loadConfig();

	}
    public static void loadConfig(){
    	
    	RcsiteConfig rcsiteConfig = null;
		  properties = new Properties();

		   try{
			 
			   int[] rowStartIdxAndCount = {0};
			   configList = DBUtil.rcsiteConfigFindAll(rowStartIdxAndCount);
			   Iterator<RcsiteConfig> configIterator=configList.iterator();
			   
			   	while(configIterator.hasNext()){
			   		rcsiteConfig=(RcsiteConfig)configIterator.next();
			  
					if(rcsiteConfig.getConfigKey()!=null && rcsiteConfig.getValue()!=null){
					   properties.put(rcsiteConfig.getConfigKey(), rcsiteConfig.getValue());
					}
			   	}
			   	System.out.println("Config List Size: "+configList.size()+" - Properties Size:"+properties.size());
			   	
		   }catch(Exception e){
			   e.printStackTrace();
		   }
		 
    }
}
