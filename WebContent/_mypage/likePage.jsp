<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_layout/session.jsp"%>
<%@ include file="/_api/apiInclude.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	String pageTitle = "좋아요";
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String session_user = (String) session.getAttribute("user_id");
	String session_member = (String) session.getAttribute("member_id");

%>

<jsp:include page="/_layout/header.jsp" flush="false"/>
	<div class="ui top container">

	<jsp:include page="/_layout/mypage.jsp" flush="false">
		<jsp:param name="pageTitle" value="<%=pageTitle%>" />
		<jsp:param name="member_id" value="<%=session_member%>" />
	</jsp:include>

		<div id="likePage-post-list"></div>

</div>

<script src="/pickabook/assets/mypage.js"></script>
<script>

$(document).ready(function() {
	getLikePosts();

});

var start = 0;
var end = 5;

function getLikePosts()
{ 	
	var obj = {'start': start, 'end' : end};
	var myJSON = JSON.stringify(obj);
	$('#likePage-post-list').load('/pickabook/_mypage/getLikePosts.jsp', {param: myJSON}, function(data){
       applyAfterLikePost();
       start += end;
	});
}

//좋아요한 포스트 더보기
$(document).on('click','.likepost-more',function(e){
	e.preventDefault();
	var a_tag = $(this);
	var loader = a_tag.find('.likepost-more-loader'); //로더	
	loader.addClass('active');
	var obj = {'start': start, 'end' : end};
	var myJSON = JSON.stringify(obj);
	$.post('/pickabook/_mypage/getLikePosts.jsp', {param: myJSON}, function(data){	    	
		setTimeout(function(){ 
			loader.removeClass('active');	
			$('.likepost-item-parent').append($(data).find('.likepost-item'));
			$('.likepost-list-end').html($(data).siblings('.likepost-list-end').html());		
			applyAfterLikePost();	
			start += end;
		}, 500); //딜레이 0.3초	
	});
});

function applyAfterLikePost(){	
	$('.likepage-post-star').rating('refresh');
	$('.likepage-post-star').rating('disable'); //별 수정 못하도록
	
	$('.limit-text').each(function(){
		var length = 180; // 표시할 글자 수 정하기
		//전체 옵션을 자를 경우
		$(this).each(function(){
		   if($(this).text().length >= length){
		   $(this).text($(this).text().substr(0,length)+'...');
		   }
		});
	});
	
	$('.likePage-book-title').each(function(){ //내용
	      var length = 33; // 표시할 글자 수 정하기
	      //전체 옵션을 자를 경우
	      $(this).each(function(){
	         if($(this).text().length >= length){
	         $(this).text($(this).text().substr(0,length)+'...');
	         }
	      });
	});
}


</script>

</body>
</html>