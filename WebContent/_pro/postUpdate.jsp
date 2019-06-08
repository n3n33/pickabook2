<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="pickabook.*" %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, org.json.*" %>

<%	request.setCharacterEncoding("utf-8");
	String param = request.getParameter("param");
	JSONObject jobj = new JSONObject(param); //받은 파라메터를 다시 -> json으로
	int postnum = jobj.getInt("postnum");

	PostDB postPro = PostDB.getInstance();
	PostData post = new PostData();
	post.setPost_num(postnum);
	post.setContent(jobj.getString("content"));
	postPro.updatePost(post); //포스트 수정
	
	if(jobj.getInt("kind") == 2){ //독후감이면
		PostBookData pbook = new PostBookData();
		pbook.setPost_num(postnum);
		pbook.setStar_rate(jobj.getInt("star-rate"));	
		postPro.updatePostBook(pbook); //독후감 수정
		
		TaggedDB tagPro = TaggedDB.getInstance();
		List<TaggedData> taggedList = null;
		TaggedData tagged = null;
		JSONArray tagArr = jobj.getJSONArray("tags");
		taggedList = new ArrayList<TaggedData>();
		for(int i=0; i < tagArr.length(); i++){
			tagged = new TaggedData();
			tagged.setPost_num(postnum);
			tagged.setTag_num(tagArr.getInt(i));
			taggedList.add(tagged);
		}			
		tagPro.updateTagged(taggedList, postnum); //태그 수정

	}
	
	//ajax
	response.getWriter().println("");
%>
