<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat" %>

<%	request.setCharacterEncoding("utf-8");
	String session_member = (String)session.getAttribute("member_id");
	String isbn = request.getParameter("isbn");
	
	BookDB bookPro = BookDB.getInstance();
	bookPro.deleteBook(session_member, isbn);
	
	response.getWriter().println("");
%>