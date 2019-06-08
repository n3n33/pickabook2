<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat" %>

<%	request.setCharacterEncoding("utf-8");
	String member_id = request.getParameter("member_id"); 
	String follower_id =(String)session.getAttribute("member_id"); //나 자신
	
	FollowData follow = new FollowData();
	follow.setMember_id(member_id);
	follow.setFollower_id(follower_id);
	follow.setFollow_date(new Timestamp(System.currentTimeMillis()));
	
	FollowDB followPro = FollowDB.getInstance();
	followPro.insertFollow(follow);
%>