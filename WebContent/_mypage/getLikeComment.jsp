<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
	request.setCharacterEncoding("UTF-8");
	int postnum = Integer.parseInt(request.getParameter("postnum"));
	
	PostDB postPro = PostDB.getInstance();
	int likecount = postPro.getLikeCount(postnum);
	int commentcount = postPro.getCommentCount(postnum);
	
	JSONObject jobj = new JSONObject();
	jobj.put("likecount", likecount);
	jobj.put("commentcount", commentcount);
	
	//Ajax 응답
	response.setContentType("application/json; charset=utf-8");   
	response.getWriter().println(jobj);
%>