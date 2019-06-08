<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_layout/session.jsp" %> 
<%@ page import="pickabook.*, java.util.*"%>

<%
   request.setCharacterEncoding("UTF-8");
   
   String query = request.getParameter("query");
   if(query == null || query.equals("")){
	   response.sendRedirect("/pickabook/_main/main.jsp");
   	return;
   }
   
   String sort = request.getParameter("sort");
   if(sort == null){
	   sort = "sim";
   }
%>
<jsp:include page="/_layout/header.jsp" flush="false"/>

<div class="ui top container">

	<!-- 결과 : 사용자 -->
<%   
	   MemberDB memPro = MemberDB.getInstance();
	   List<MemberData> memList = null;
	   memList = memPro.searchMembers(query);
%>
	<div class="div-border-style" style="padding: 1.5em;">
		<div><b>'<%=query %>'</b> 에 대한 검색결과</div>
		<div class="ui divider" style="border: 1px dashed rgba(34,36,38,.15);"></div>
		<% if(memList == null){ %>
			<div class="ui sub header">사 람 (<span class="pickabook-main-color"><%=0%></span>)</div>
		<%	}
			else{
				int val = 0;
				if(memList.size() > 11) 
					val = 11;
				else
					val = memList.size();%>
				<div class="ui sub header margin-bottom">사 람 (<span class="pickabook-main-color"><%=memList.size()%></span>)</div>
				<div class="margin-bottom" style="width: 100%; text-align: justify;">
<%
				for(int i=0 ; i < val; i++){
					MemberData member = memList.get(i);	%>		
					<div class="ui tiny image">				
						<a href="/pickabook/_mypage/post.jsp?user_id=<%=member.getUser_id()%>">
							<img class="ui centered circular image mypost-profileimg" src="<%=member.getProfile_img()%>">
						</a>
						<div class="ui center aligned header" style="margin-top: 5px; font-size: 14px;">
							<a href="/pickabook/_mypage/post.jsp?user_id=<%=member.getUser_id()%>"><%=member.getUser_id()%></a>
						</div>				
					</div>
			<% 	} %>
				</div>
				<%if(memList.size() > 11){ %>
					<div class="ui sub center aligned header">
						<a href="" class="search-user-more-btn">더보기</a>
					</div>
				<%} %>				
		<% } %>	
	</div>
	
	<!-- 검색 : 탭 -->
	<div class="ui pointing secondary menu">
	  <a class="item active" data-tab="first">도서</a>
	  <a class="item" data-tab="second">포스트</a>
	</div>
	
	<div class="ui tab basic segment active search-tab-book" data-tab="first"></div>
	<div class="ui tab basic segment search-tab-post" data-tab="second"></div>
	
</div><!-- end of 전체 container  -->

<!-- 모달 -->

<!-- 사용자 더보기 모달 -->
<div class="ui tiny modal" id="search-user-more-modal" style="height: 570px;"></div>

<script src="/pickabook/assets/mypage.js"></script>
<script>
$(document).ready(function(){
	getSearchBooks();
	getSearchPosts();
	
	$('.menu .item').tab();	
	   
   //무한 스크롤 - 도서부분만
    $(window).scroll(function() {
        if ($(window).scrollTop() >= $(document).height() - $(window).height()- 1) {
			start += display;
			getSearchBooks(); 
        }
    });

});

//getSearchBooks()가 쓸 전역변수
var query = '<%=query%>';
var start = 1;
var display = 7;
var sort = '<%=sort%>';

//getSearchPosts()가 쓸 전역변수
var p_start = 0;
var p_end = 5;

//검색된 포스트 더보기
$(document).on('click','.search-post-more',function(e){
	e.preventDefault();
	var a_tag = $(this);
	var loader = a_tag.find('.search-post-more-loader'); //로더	
	loader.addClass('active');
	var obj = {'query' : query, 'start': p_start, 'end' : p_end};
	var myJSON = JSON.stringify(obj);
	$.post('/pickabook/_search/getSearchPosts.jsp', {param: myJSON}, function(data){	    	
		setTimeout(function(){ 
			loader.removeClass('active');	
			$('.search-tab-post').find('.search-post-item-parent').append($(data).find('.search-post-item'));	
			$('.search-post-end').html($(data).siblings('.search-post-end').html());	
			applyAfterSearch();						
			p_start += p_end;
		}, 500); //딜레이
	});
});

</script>
</body>
</html>