<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="org.json.JSONObject"%>
<%@page import="pickabook.*"%>
<%
	request.setCharacterEncoding("utf-8");
	MemberDB memPro = MemberDB.getInstance();   
	String member_id = request.getParameter("member_id");

	PieChart ppp = PieChart.getInstance();
	String real = ppp.getPieChart(member_id);
	out.print(real);
%>