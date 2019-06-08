<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "pickabook.*, java.util.*,java.text.*, java.io.*" %>
<%@ page import="org.w3c.dom.*, org.xml.sax.*, java.net.*, org.json.*"%>
<%@ page import="javax.xml.transform.dom.*, javax.xml.transform.stream.*, javax.xml.parsers.*, javax.xml.transform.*" %>
<%@ page import="org.json.JSONObject, org.json.XML" %>

<%!
	String clientId = "KL9D8B_VFXsGZnZqO0Ll";//애플리케이션 클라이언트 아이디값";
	String clientSecret = "_xpzeCAAr7";//애플리케이션 클라이언트 시크릿값";	
	
	
	private JSONObject apiIsbn(String isbn) { //한 개의 책 정보 가져오기(네이버)
		JSONObject bookitem = null;

		//도서 API 요청	
		try{
			String apiURL = "https://openapi.naver.com/v1/search/book?query=" + isbn; // json 결과
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
		    StringBuffer responseStr = new StringBuffer();
		    while ((inputLine = br.readLine()) != null) {
		    	responseStr.append(inputLine);
		    }
		    br.close();
		    
		    JSONObject jobj = new JSONObject(responseStr.toString());
		    JSONArray items = new JSONArray(jobj.getJSONArray("items").toString());	
		    bookitem = items.getJSONObject(0); //혹시 여러개 검색됐어도 1번째걸로
 
		}
		catch (Exception e) {
			e.printStackTrace();
		}	
	    return bookitem;  
	}

	private JSONObject apiSearch(String query, int start, int display, String sort) { //책 검색 (search.jsp )	
		JSONObject result = null;
		//도서 API 요청	
		try{	
			String text = URLEncoder.encode(query, "UTF-8");
			String apiURL = "https://openapi.naver.com/v1/search/book?query="+ text + "&start=" + start + "&display=" + display + "&sort=" + sort; // json 결과
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
		    StringBuffer responseStr = new StringBuffer();
		    while ((inputLine = br.readLine()) != null) {
		    	responseStr.append(inputLine);
		    }
		    br.close();
		    
		    result = new JSONObject(responseStr.toString()); //items뽑지 않고 전체 json 리턴
		}
		catch (Exception e) {
			e.printStackTrace();
		}	
	    return result;  
	}


	private JSONObject apiAuthor(String author){ //작가 검색 (bookInfo.jsp )	
		JSONObject result = null;
		//도서 API 요청	
		try{	
			author = URLEncoder.encode(author, "UTF-8");
		    String apiURL = "https://openapi.naver.com/v1/search/book_adv.xml?d_auth=" + author + "&display=5"; // xml 결과 - 상세검색
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
		    result = xmlToJson(responseNaver.toString());
		    return result;
		 
		}
		catch (Exception e) {
			e.printStackTrace();
		}	
	    return null;  
	}
	
	private JSONObject apiPublisher(String publisher){ //출판사 검색 (bookInfo.jsp )	
		JSONObject result = null;
		//도서 API 요청	
		try{	
			publisher = URLEncoder.encode(publisher, "UTF-8");
		    String apiURL = "https://openapi.naver.com/v1/search/book_adv.xml?d_publ=" + publisher + "&display=5&sort=sim"; // xml 결과 - 상세검색
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
		    result = xmlToJson(responseNaver.toString());
		    return result;
		 
		}
		catch (Exception e) {
			e.printStackTrace();
		}	
	    return null;  
	}
	
	private JSONObject xmlToJson(String xmlStr) {
		try {
			JSONObject jobj = XML.toJSONObject(xmlStr);
			jobj = jobj.getJSONObject("rss").getJSONObject("channel");
			return jobj;
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;	
	}
	
	private String convertDocumentToString(Document doc) { //document -> string 으로 변환
		TransformerFactory tf = TransformerFactory.newInstance();
		Transformer transformer;
		try {
			transformer = tf.newTransformer();
			// below code to remove XML declaration  == 아래 코드는 XML 선언문을 없앰
			// transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			
			StringWriter writer = new StringWriter();
			transformer.transform(new DOMSource(doc), new StreamResult(writer));
			String output = writer.getBuffer().toString();
			return output;
		} 
		catch (TransformerException e) {
			e.printStackTrace();
		}
		return null;
	}
	
%>