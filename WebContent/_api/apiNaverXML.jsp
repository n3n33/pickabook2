<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "pickabook.*, java.util.*" %>
<%@ page import="java.io.*, javax.xml.transform.dom.*, javax.xml.transform.stream.*, javax.xml.parsers.*, javax.xml.transform.*" %>
<%@ page import="org.w3c.dom.*, org.xml.sax.*, java.net.*, org.json.*"%>
<%!
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
 <%
	request.setCharacterEncoding("UTF-8");
	String contextRoot = request.getContextPath();
	StringBuilder sb = new StringBuilder();
	
	String clientId = "KL9D8B_VFXsGZnZqO0Ll";//애플리케이션 클라이언트 아이디값";
    String clientSecret = "_xpzeCAAr7";//애플리케이션 클라이언트 시크릿값";

    String param = request.getParameter("isbn");
    
    String isbn = URLEncoder.encode(param, "UTF-8");
    //String apiURL = "https://openapi.naver.com/v1/search/book?query="+ text; // json 결과
    //String apiURL = "https://openapi.naver.com/v1/search/book.xml?query="+ text+"&display="+display; // xml 결과
    String apiURL = "https://openapi.naver.com/v1/search/book_adv.xml?d_titl=" + isbn; // xml 결과 - 상세검색
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
    
    //STRING -> DOCUMENT객체
    DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    InputSource is = new InputSource();
    is.setCharacterStream(new StringReader(responseNaver.toString()));
    Document xmlDoc = db.parse(is);
    String xmlStr = convertDocumentToString(xmlDoc);

    System.out.println(xmlStr);
    //Ajax 응답
	//response.setContentType("text/xml; charset=UTF-8");
	//response.getWriter().println(xmlStr);
%>