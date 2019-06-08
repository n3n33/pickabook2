<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="pickabook.*" %>
<%@ page import = "java.sql.Timestamp" %>

<%	request.setCharacterEncoding("utf-8");
	String param = request.getParameter("postnum");
	int postnum = Integer.parseInt(param);

	PostDB postPro = PostDB.getInstance();
	postPro.deletePost(postnum); //포스트 삭제
	
	//ajax
	response.getWriter().println("");
%>
