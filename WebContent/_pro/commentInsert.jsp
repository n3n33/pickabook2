<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, org.json.*" %>

<%	request.setCharacterEncoding("utf-8");
	//사용자 요청 수신 및 분석 
	String param = request.getParameter("param");	
	JSONObject jobj = new JSONObject(param); //받은 파라메터를 다시 -> json으로
	String session_member =(String)session.getAttribute("member_id");
	
	CommentData comment = new CommentData();
	comment.setContent(jobj.getString("content"));
	comment.setComment_date(new Timestamp(System.currentTimeMillis()));
	comment.setMember_id(session_member);
	comment.setPost_num(jobj.getInt("postnum"));	
	
	CommentDB comPro = CommentDB.getInstance();
	int comment_num = comPro.insertComment(comment); //댓글 삽입후 -> comment_num받기
	response.getWriter().print(comment_num);
%>