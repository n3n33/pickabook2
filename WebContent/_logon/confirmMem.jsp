<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="pickabook.*"%>


<%
	String member_id = request.getParameter("member_id");
	MemberDB dbPro = MemberDB.getInstance();
	int check = dbPro.findMember_id(member_id);

	response.setContentType("charset=UTF-8");
	response.getWriter().println(check + "");

%>