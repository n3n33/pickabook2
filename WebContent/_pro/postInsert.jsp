<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, org.json.*" %>

<%	request.setCharacterEncoding("utf-8");
	String member_id =(String)session.getAttribute("member_id");
	
	//사용자 요청 수신 및 분석 
	String param = request.getParameter("param");	
	JSONObject jobj = new JSONObject(param); //받은 파라메터를 다시 -> json으로
	
	PostData post = new PostData();
	post.setMember_id(member_id);
	post.setContent(jobj.getString("content"));
	post.setPost_date(new Timestamp(System.currentTimeMillis()));	
	PostDB postPro = PostDB.getInstance();
	int post_num = postPro.insertPost(post); //게시글 삽입후 -> post_num 받아오기
	
	if(jobj.getInt("kind") == 2){ //독후감이면
		PostBookData pbook = new PostBookData();
		pbook.setPost_num(post_num);
		pbook.setIsbn(jobj.getString("isbn"));
		pbook.setBook_title(jobj.getString("title"));
		pbook.setStar_rate(jobj.getInt("star-rate"));	
		pbook.setCategory_num(jobj.getInt("categoryNum"));
		postPro.insertPostBook(pbook); //독후감 삽입

		TaggedDB tagPro = TaggedDB.getInstance();
		TaggedData tagged = null;
		JSONArray tagArr = jobj.getJSONArray("tags");
		for(int i=0; i < tagArr.length(); i++){
			tagged = new TaggedData();
			tagged.setPost_num(post_num);
			tagged.setTag_num(tagArr.getInt(i));			
			tagPro.insertTagged(tagged); //태그 삽입
		}				
	}
	
	//ajax
	response.getWriter().println(post_num);	
%>