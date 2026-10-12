<%@ page import="org.apache.log4j.Logger"%>

<%

java.text.NumberFormat formatter = new java.text.DecimalFormat("0000000");
try{
endTime = java.util.Calendar.getInstance().getTime(); 
loadTime = endTime.getTime()- startTime.getTime();
loadTimeMap.put("90.finalendTime",endTime);
//System.out.println("loadTime "+loadTime);
	if(loadTime>500){
		String params = " ";
		String ParameterName = "";
		for (java.util.Enumeration e = request.getParameterNames();e.hasMoreElements();) {
			ParameterName = (String) e.nextElement();
			params = params + ParameterName + "="+ request.getParameter(ParameterName);
			
		}
		Logger lgWarn = Logger.getLogger("loadtimeerror");
		com.rev_creations.rcsite.LocationBean locationBeanLoad = (com.rev_creations.rcsite.LocationBean)session.getAttribute("location");
		String locationString =" ";
		if(locationBeanLoad!=null){
			locationString =  locationBeanLoad.getCountryName() + ","+ locationBeanLoad.getRegionName() + ","+ locationBeanLoad.getCity();
		}
		
		String 	logMessage ="   remote ip: "+request.getRemoteAddr()+ " location: "+locationString +	" user-agent: "+ request.getHeader("user-agent")+"\n"+
		"   page: "+request.getLocalName()+  request.getServletPath()+"?"+params+"\n";
		logMessage =logMessage +" total loadTime "+loadTime+" time: " + endTime +"\n";
			Iterator iteratorLoadTime = loadTimeMap.keySet().iterator();
			Object key;
			Object value;
			while(iteratorLoadTime.hasNext()){
				  key   = iteratorLoadTime.next();
				  endTime = (java.util.Date)loadTimeMap.get(key);
			loadTime = endTime.getTime()- startTime.getTime();
startTime =  endTime;
			
		logMessage =logMessage+" loadTime: "+formatter.format(loadTime)+ " "+key +"\n";
		}

		
		lgWarn.warn(logMessage );
		//System.out.println(logMessage);
		
	}
	}catch(Exception e){
	e.printStackTrace();
	}
	%> 
