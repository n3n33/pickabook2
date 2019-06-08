<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="pickabook.*" %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat, org.json.*" %>

<%   
	request.setCharacterEncoding("utf-8");
	String param = request.getParameter("param");
	JSONObject jobj = new JSONObject(param); //받은 파라메터를 다시 -> json으로
	
	BookData book = new BookData();
	book.setType(jobj.getString("type"));
	book.setIsbn(jobj.getString("isbn"));
	BookDB bookPro = BookDB.getInstance();
	bookPro.updateBook(book); //포스트 수정
	
	String res = "";
	if(jobj.getString("type").equals("wish"))
		res = "0";
	else if(jobj.getString("type").equals("ing"))
		res = "1";
	else if(jobj.getString("type").equals("read"))
		res = "2";
	
	response.getWriter().println(res); //변경항 서재 type 리턴
%>