<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat" %>

<%	request.setCharacterEncoding("utf-8");
	String commentnum = request.getParameter("commentnum");
	int comment_num = Integer.parseInt(commentnum);
	
	CommentDB comPro = CommentDB.getInstance();
	int x = comPro.deleteComment(comment_num); //댓글 삭제
	response.getWriter().print(x);
%>