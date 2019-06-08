<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="pickabook.*" %>
<%@ page import = "java.sql.Timestamp" %>

<%
	request.setCharacterEncoding("UTF-8");
	String session_member = (String)session.getAttribute("member_id"); 
	String param = request.getParameter("postnum");
	int postnum = Integer.parseInt(param);

	LikePostDB likePro = LikePostDB.getInstance();
	likePro.deleteLike(session_member, postnum);//좋아요 테이블에서 삭제    
	response.getWriter().println();
%>
