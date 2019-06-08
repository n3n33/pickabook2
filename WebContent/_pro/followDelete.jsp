<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat" %>

<%	request.setCharacterEncoding("utf-8");
	String member_id = request.getParameter("member_id");
	String follower_id =(String)session.getAttribute("member_id"); //나 자신
	
	FollowDB followPro = FollowDB.getInstance();
	followPro.deleteFollow(member_id, follower_id);
	response.getWriter().println("");
%>