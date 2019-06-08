<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<div class="<%=comment.getComment_num()%>">
	<a class="comment-writer" href="/pickabook/_mypage/post.jsp?user_id=<%=memPro.getUser_id(comment.getMember_id())%>"> 
		<%=memPro.getUser_id(comment.getMember_id())%>
	</a>
	<span class="comment-input-edit toggle1"><%=comment.getContent()%></span>
	<span class="comment-input-edit" style="display:none;">
		<div class="ui mini input toggle2">
		  <input type="text" value="<%=comment.getContent()%>">
		</div>
	</span>
	<%if(session_member.equals(comment.getMember_id())){%>
	  <span class="smaller-font">
		<a href="" class="comment-edit gray-font comment-toggle-btn1">수정</a>	
		<a href="" class="comment-update gray-font comment-toggle-btn1" style="display:none;">수정</a>	   	   			
		<a href="" class="comment-delete gray-font comment-toggle-btn2">삭제</a>	   	   	
		<a href="" class="comment-cancel gray-font comment-toggle-btn2" style="display:none;">취소</a>		
	  </span>
	<%} %>
</div>