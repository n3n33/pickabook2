<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, org.json.*" %>

<%   request.setCharacterEncoding("utf-8");
   
   String session_member = (String)session.getAttribute("member_id");
   String isbn = request.getParameter("isbn");//받은 파라메터를 다시 -> json으로
   String type = request.getParameter("type");
   
   BookData book = new BookData();
   book.setType(type);
   book.setIsbn(isbn);
   book.setMember_id(session_member);
   book.setBook_date(new Timestamp(System.currentTimeMillis()));
   
   BookDB bookPro = BookDB.getInstance();
   bookPro.insertBook(book); //book에 삽입
   
   response.getWriter().println(""); //추가한 서재 type 리턴
%>