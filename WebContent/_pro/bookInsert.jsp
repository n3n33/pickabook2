<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>

<%	request.setCharacterEncoding("utf-8");
	
	String session_member = (String)session.getAttribute("member_id");
	String type = request.getParameter("type");
	String isbn = request.getParameter("book-add-isbn");
	String datestr = request.getParameter("book-add-date");
	Date book_date = new SimpleDateFormat("yyyy-MM-dd").parse(datestr);

	BookDB bookPro = BookDB.getInstance();
	BookData book = new BookData();
	book.setMember_id(session_member);
	book.setIsbn(isbn);
	book.setBook_date(new Timestamp(book_date.getTime()));
	book.setType(type);
	bookPro.insertBook(book); //book에 삽입
	
	String res = "";
	if(type.equals("wish"))
		res = "0";
	else if(type.equals("ing"))
		res = "1";
	else if(type.equals("read"))
		res = "2";
	
	response.getWriter().println(res); //추가한 서재 type 리턴
%>