<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.ReviewDB"%>

<%
	request.setCharacterEncoding("utf-8");
%>

<jsp:useBean id="review" class="pickabook.ReviewData">
	<jsp:setProperty name="review" property="*" />
</jsp:useBean>

<%
	String content = request.getParameter("content");	
	int review_num = Integer.parseInt(request.getParameter("review_num"));

	ReviewDB comment = ReviewDB.getInstance();
	comment.updateReview(content, review_num);
%>