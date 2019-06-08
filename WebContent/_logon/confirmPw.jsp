<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="pickabook.*" %>

<%
	String passwd = request.getParameter("passwd");
	String session_member = (String)session.getAttribute("member_id");
	MemberDB dbPro = MemberDB.getInstance();
	int check = dbPro.confirmPW(passwd, session_member);
	
	response.setContentType("charset=UTF-8");
	response.getWriter().println(check+"");
%>