<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String sessionCheck = (String)session.getAttribute("member_id");
	if(sessionCheck == null || sessionCheck.equals("")){
		response.sendRedirect("/pickabook/_logon/loginForm.jsp");
		return;
	}
%>
