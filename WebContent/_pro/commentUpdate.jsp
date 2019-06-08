<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, org.json.*" %>

<%	request.setCharacterEncoding("utf-8");
	//사용자 요청 수신 및 분석 
	String commentnum = request.getParameter("commentnum");	
	int comment_num = Integer.parseInt(commentnum);
	String content = request.getParameter("content");	
	
	
	CommentDB comPro = CommentDB.getInstance();
	int x = comPro.updateComment(comment_num, content); //댓글 수정
	response.getWriter().print(x);
%>