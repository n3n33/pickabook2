<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "pickabook.*, java.util.*" %>
<%@ page import="java.io.*, javax.xml.transform.dom.*, javax.xml.transform.stream.*, javax.xml.parsers.*, javax.xml.transform.*" %>
<%@ page import="org.w3c.dom.*, org.xml.sax.*, java.net.*, org.json.*"%>
 
 <%
 	//post, book에서 책 검색시 사용
	request.setCharacterEncoding("UTF-8");
 	
 	String clientId = "KL9D8B_VFXsGZnZqO0Ll";//애플리케이션 클라이언트 아이디값";
    String clientSecret = "_xpzeCAAr7";//애플리케이션 클라이언트 시크릿값";
    
	String query = request.getParameter("query"); 
	String display = request.getParameter("display");
	
	String text = URLEncoder.encode(query, "UTF-8");
    String apiURL = "https://openapi.naver.com/v1/search/book?query="+ text + "&display=" + display; // json 결과
    //String apiURL = "https://openapi.naver.com/v1/search/book.xml?query="+ text; // xml 결과
    //String apiURL = "https://openapi.naver.com/v1/search/book_adv.xml?d_isbn=" + isbn; // xml 결과 - 상세검색
    URL url = new URL(apiURL);
    HttpURLConnection con = (HttpURLConnection)url.openConnection();
    con.setRequestMethod("GET");
    con.setRequestProperty("X-Naver-Client-Id", clientId);
    con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
    int responseCode = con.getResponseCode();
    BufferedReader br;
    if(responseCode==200) { // 정상 호출
        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
    } else {  // 에러 발생
        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
    }
    String inputLine;
    StringBuffer responseNaver = new StringBuffer();
    while ((inputLine = br.readLine()) != null) {
       responseNaver.append(inputLine);
    }
    br.close();
    
    //System.out.println(responseNaver);
   
	//Ajax 응답
	response.setContentType("application/json; charset=utf-8");   
	response.getWriter().println(responseNaver);
%>