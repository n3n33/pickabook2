<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="pickabook.*" %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat, org.json.*" %>

<%   
	request.setCharacterEncoding("utf-8");
	String intro = request.getParameter("intro");
	String session_member = (String)session.getAttribute("member_id");
	
	MemberDB memPro = MemberDB.getInstance();
	memPro.updateIntro(intro, session_member);
	
	response.getWriter().println("");
%>