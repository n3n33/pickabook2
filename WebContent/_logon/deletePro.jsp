<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="pickabook.*"%>

<%
	String session_member = (String)session.getAttribute("member_id");
	
	MemberDB member = MemberDB.getInstance();
	int delete = member.deleteMember(session_member);
	
	session.invalidate();

	response.sendRedirect("/pickabook/_logon/loginForm.jsp");

%>
