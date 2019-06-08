<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="pickabook.*" %>

<%
	String user_id = request.getParameter("user_id");
	MemberDB dbPro = MemberDB.getInstance();
	int check = dbPro.confirmID(user_id);
	
	response.setContentType("charset=UTF-8");
	response.getWriter().println(check+"");
%>