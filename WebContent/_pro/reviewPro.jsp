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
	String isbn = request.getParameter("isbn");
	String member_id = request.getParameter("member_id");
	String content = request.getParameter("content");
	String review_date = request.getParameter("review_date");
	
	review.setIsbn(isbn);
	review.setMember_id(member_id);
	review.setContent(content);
	review.setReview_date(new Timestamp(System.currentTimeMillis()));
	
	ReviewDB comment = ReviewDB.getInstance();
	comment.insertReview(review);
	
	response.sendRedirect("/pickabook/_browse/bookInfo.jsp?isbn=" + isbn);
%>