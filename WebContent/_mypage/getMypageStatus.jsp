<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
	request.setCharacterEncoding("UTF-8");
	String member_id = request.getParameter("member_id");
	
	MemberDB memPro = MemberDB.getInstance();
	int postcount = memPro.getPostCount(member_id);
	int followercount = memPro.getFollowerCount(member_id);
	int followingcount = memPro.getFollowingCount(member_id);
	
	JSONObject jobj = new JSONObject();
	jobj.put("postcount", postcount);
	jobj.put("followercount", followercount);
	jobj.put("followingcount", followingcount);
	
	//Ajax 응답
	response.setContentType("application/json; charset=utf-8");   
	response.getWriter().println(jobj);
%>