<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
<%
    //JSP code
   request.setCharacterEncoding("UTF-8");
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   String session_member = (String)session.getAttribute("member_id"); 
   String member_id = request.getParameter("member_id"); 
   String type = request.getParameter("type"); 
   
   //책 뿌리기   
   BookDB bookPro = BookDB.getInstance();
   List<BookData> booklist = null;
   booklist = bookPro.getBookList(member_id, type);
    
   if(booklist == null){%>
      추가된 책이 없습니다. 책을 등록해보세요
   <%}
   else {%>
      <div class="ui five cards">
      <%for(int i=0 ; i < booklist.size() ; i++){
         BookData book = booklist.get(i);  

         JSONObject bookitem = apiIsbn(book.getIsbn());%>
         
         <div class="card" id="<%=book.getIsbn()%>">
	         <div class="ui blurring dimmable image">
	           <div class="ui dimmer">
	           <div class="content">
	           <%if(session_member.equals(member_id)){%>
	              <button class="circular ui icon button book-edit-btn"><i class="edit icon"></i></button>
	              <button class="circular ui icon button book-delete-btn"><i class="trash icon"></i></button>
	           <%}%>
	           </div>
	           </div>        
	           <img src="<%=bookitem.get("image").toString().replace("type=m1", "")%>" onerror="this.src='/pickabook/image/book_alt.png';" style="height: 250px;">
			</div>       
			<div class="content" style="height: 57px;">
		      <a class="ui tiny header bookpage-book-title" href="/pickabook/_browse/bookInfo.jsp?isbn=<%=book.getIsbn()%>">
		      	<%=bookitem.getString("title")%>
		      </a>
		      <div class="meta">
		        <div class="bookpage-book-date"><%=sdf.format(book.getBook_date())%></div>
		      </div>
			</div>   
		  </div>         
      <%}%>
       </div>
   <%} 
   
%>