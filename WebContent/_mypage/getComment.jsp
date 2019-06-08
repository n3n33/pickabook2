<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
	request.setCharacterEncoding("UTF-8");
	int postnum = Integer.parseInt(request.getParameter("comment_num"));
	String session_member = (String)session.getAttribute("member_id"); 
       
	MemberDB memPro = MemberDB.getInstance();
	PostDB postPro = PostDB.getInstance();
	CommentDB comPro = CommentDB.getInstance();
	CommentData comment = comPro.getComment(postnum);		
%>

<%@ include file="/_layout/comment_layout_inc.jsp" %>