<%@ page language="java" import="java.sql.*,java.util.*,com.rev_creations.persistence.dao.*" contentType="text/html; charset=UTF-8"%>
<%@page import="com.maxmind.geoip.Location"%>
<%@page import="com.rev_creations.rcsite.*"%>
<%@ include file="../Connections/dbconnection.jsp"%>
<%
	String localNewsCategories = (String) session.getAttribute("localNewsCategories");
	String localFeaturesCategories = (String)session.getAttribute("localFeaturesCategories");
	List newsSummaryList = null;
	int Repeat1__numRows;
	Articles newsSummary;
	Articles thubnailSummary;
	Calendar calendar = new GregorianCalendar();
    String countryCode = ((LocationBean)session.getAttribute("location")).getCountryCode();
	calendar.add(Calendar.MONTH, -3);
	int columns =3;
if (request.getParameter("columns") !=null) {columns = Integer.parseInt((String)request.getParameter("columns"));}

%>

<div class="threelines1" id="largebox">
       
		<% Iterator itr;

int contentLength = 0;
				
       
         		
         		newsSummaryList = ArticlePageGenerator.getArticleList("12");
				if(newsSummaryList != null && newsSummaryList.size()>0){
				       thubnailSummary = null;
				        for(int index = 0; index < newsSummaryList.size(); index++){
                         	thubnailSummary=(Articles)newsSummaryList.get(index);
                         	if (thubnailSummary.getThumbnail() != null && thubnailSummary.getThumbnail().length()>5 ){
                         	
                         		break;
                         	}else{
								thubnailSummary = null;
							}
                         	
                        }
                       
	    %><div id="box1" >
			<div class="whitetitle greyheading" style="width:95%;"> Entertainment</div>
	      <%if(thubnailSummary != null && thubnailSummary.getTitle() != null ){ contentLength = contentLength + thubnailSummary.getTitle().length()+60;%>
	     <div class="newssummarylist"><div class ='rc_pagelist_image'><a href="../newspage/<%=thubnailSummary.getArticleId()%>ai-<%=thubnailSummary.getAlias()%>" ><img  border="0" width="120" height="74" src="<%=thubnailSummary.getThumbnail()%>"/></a></div><% if(thubnailSummary.getAlias() !=null  ){%><a href="../newspage/<%=thubnailSummary.getArticleId()%>ai-<%=thubnailSummary.getAlias()%>"><%=thubnailSummary.getTitle()%></a><%
										                                  }else{%><a href="../news/page.jsp?articleid=<%=thubnailSummary.getArticleId()%>"><%=thubnailSummary.getTitle()%></a><%}%></div>
        <%          }
					Repeat1__numRows = 10;
					itr = newsSummaryList.iterator();
					while (itr.hasNext() && Repeat1__numRows >= 0 && contentLength <300) {
						newsSummary = (Articles) itr.next();
						Repeat1__numRows--;
						contentLength = contentLength + newsSummary.getTitle().length() +30;
						
						if(newsSummary.getTitle() != null && !(thubnailSummary != null && thubnailSummary.getArticleId() ==newsSummary.getArticleId()) ){
						
       %><div class="newslist"><% if(newsSummary.getAlias() !=null  ){%><a href="../newspage/<%=newsSummary.getArticleId()%>ai-<%=newsSummary.getAlias()%>"><%=newsSummary.getTitle()%></a><%
										                                  }else{%><a href="../news/page.jsp?articleid=<%=newsSummary.getArticleId()%>"><%=newsSummary.getTitle()%></a><%}%></div>
        <%	     		}
					}
	   	%><div style="height:22px;"><a	href="../news/pagelist.jsp?categoryid=12">More&gt;&gt;</a> </div>
		 </div>
        <%} contentLength = 0;
		newsSummaryList = ArticlePageGenerator.getArticleList("14");
				if(newsSummaryList != null && newsSummaryList.size()>0){
				       thubnailSummary = null;
				        for(int index = 0; index < newsSummaryList.size(); index++){
                         	thubnailSummary=(Articles)newsSummaryList.get(index);
                         	if (thubnailSummary.getThumbnail() != null && thubnailSummary.getThumbnail().length()>5 ){
                         	
                         		break;
                         	}else{
								thubnailSummary = null;
							}
                         	
                        }
                       
	    %><div id="box2" >
			<div class="whitetitle greyheading" style="width:100%"> Technology</div>
	      <%if(thubnailSummary != null && thubnailSummary.getTitle() != null ){ contentLength = contentLength + thubnailSummary.getTitle().length()+60;%>
	     	<div class="newssummarylist"><div class ='rc_pagelist_image'><a href="../newspage/<%=thubnailSummary.getArticleId()%>ai-<%=thubnailSummary.getAlias()%>" ><img  border="0" width="120" height="74" src="<%=thubnailSummary.getThumbnail()%>" alt="<%=thubnailSummary.getTitle()%>"/></a></div><% if(thubnailSummary.getAlias() !=null  ){%><a href="../newspage/<%=thubnailSummary.getArticleId()%>ai-<%=thubnailSummary.getAlias()%>"><%=thubnailSummary.getTitle()%></a><%
										                                  }else{%><a href="../news/page.jsp?articleid=<%=thubnailSummary.getArticleId()%>"><%=thubnailSummary.getTitle()%></a><%}%></div>
        <%          }
					Repeat1__numRows = 10;
					itr = newsSummaryList.iterator();
					while (itr.hasNext() && Repeat1__numRows >= 0 && contentLength <300) {
						newsSummary = (Articles) itr.next();
						Repeat1__numRows--;
						contentLength = contentLength + newsSummary.getTitle().length()+30;
						
						if(newsSummary.getTitle() != null && !(thubnailSummary != null && thubnailSummary.getArticleId() ==newsSummary.getArticleId()) ){
						
       %><div class="newslist" style="clear:both;"><% if(newsSummary.getAlias() !=null  ){%><a href="../newspage/<%=newsSummary.getArticleId()%>ai-<%=newsSummary.getAlias()%>"><%=newsSummary.getTitle()%></a><%
										                                  }else{%><a href="../news/page.jsp?articleid=<%=newsSummary.getArticleId()%>"><%=newsSummary.getTitle()%></a><%}%></div>
        <%	     		}
					}
	   	%><div style="width:269px; height:22px;"><a	href="../news/pagelist.jsp?categoryid=14">More&gt;&gt;</a> </div>
		 </div>
        <%} 
		if(columns>= 3){
		contentLength = 0;
		newsSummaryList = ArticlePageGenerator.getArticleList("10");
				if(newsSummaryList != null && newsSummaryList.size()>0){
				       thubnailSummary = null;
				        for(int index = 0; index < newsSummaryList.size(); index++){
                         	thubnailSummary=(Articles)newsSummaryList.get(index);
                         	if (thubnailSummary.getThumbnail() != null && thubnailSummary.getThumbnail().length()>5 ){
                         	
                         		break;
                         	}else{
								thubnailSummary = null;
							}
                         	
                        }
                       
	    %><div id="box3" >
			<div class="whitetitle greyheading" style="width:100%;">Business</div>
	      <%if(thubnailSummary != null && thubnailSummary.getTitle() != null ){ contentLength = contentLength + thubnailSummary.getTitle().length()+ 60; %>
	     <div class="newssummarylist"><div class ='rc_pagelist_image'><a href="../newspage/<%=thubnailSummary.getArticleId()%>ai-<%=thubnailSummary.getAlias()%>" ><img  border="0" width="120" height="74" src="<%=thubnailSummary.getThumbnail()%>" alt="<%=thubnailSummary.getTitle()%>"/></a></div><% if(thubnailSummary.getAlias() !=null  ){%><a href="../newspage/<%=thubnailSummary.getArticleId()%>ai-<%=thubnailSummary.getAlias()%>"><%=thubnailSummary.getTitle()%></a><%
										                                  }else{%><a href="../news/page.jsp?articleid=<%=thubnailSummary.getArticleId()%>"><%=thubnailSummary.getTitle()%></a><%}%></div>
        <%          }
					Repeat1__numRows = 10;
					itr = newsSummaryList.iterator();
					while (itr.hasNext() && Repeat1__numRows >= 0 && contentLength <300) {
						newsSummary = (Articles) itr.next();
						Repeat1__numRows--;
						contentLength = contentLength + newsSummary.getTitle().length()+30;
						
						if(newsSummary.getTitle() != null && !(thubnailSummary != null && thubnailSummary.getArticleId() ==newsSummary.getArticleId()) ){
						
       %><div class="newslist"><% if(newsSummary.getAlias() !=null  ){%><a href="../newspage/<%=newsSummary.getArticleId()%>ai-<%=newsSummary.getAlias()%>"><%=newsSummary.getTitle()%></a><%
										                                  }else{%><a href="../news/page.jsp?articleid=<%=newsSummary.getArticleId()%>"><%=newsSummary.getTitle()%></a><%}%></div>
        <%	     		}
					}
	   	%><div style="width:269px; height:22px;"><a	href="../news/pagelist.jsp?categoryid=10">More&gt;&gt;</a> </div>
		</div>
        <%} 
		} //end 3rd collmn
		%>
</div>