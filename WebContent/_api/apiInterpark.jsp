<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "pickabook.*, java.util.*,java.text.*, java.io.*" %>
<%@ page import="org.w3c.dom.*, org.xml.sax.*, java.net.*, org.json.*"%>
 
 <%
 	//포스트 작성 - 카테고리번호 검색하려고 사용
 	
	request.setCharacterEncoding("UTF-8");

 	String key = "97AC61D2397609D08353A1D97C2ADA28D704E577D69F0F26B3D3DE7148D1130D";
 	String output = "json";
 	String query = request.getParameter("isbn");
 	//String query = "9788992717199";
 	String queryType = "isbn";
 	
	//인터파크 사이트에서 도서 요청
	String str = String.format("http://book.interpark.com/api/search.api?key=%s&output=%s&query=%s&queryType=%s", 
			key, output, query, queryType);
	URL url = new URL(str);	
	
	BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream()));
    String inputLine;
    StringBuffer responseStr = new StringBuffer();
    while ((inputLine = br.readLine()) != null) {
    	responseStr.append(inputLine);
    }
    br.close();
   
	//Ajax 응답
	response.setContentType("application/json; charset=utf-8");   
	response.getWriter().println(responseStr);
%>