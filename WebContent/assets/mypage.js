/*search.jsp에 적용*/
function getSearchBooks(){
	var obj = {'query' : query, 'start': start, 'display' : display, 'sort': sort};
	var myJSON = JSON.stringify(obj);
	if(start == 1){ //첫 로드(api는 1이 시작)
		$('.search-tab-book').load('/pickabook/_search/getSearchBooks.jsp', {param: myJSON});
	}
	else{ //무한 스크롤		
		$('.search-tab-book .ui.loader').addClass('active'); //로더	
		$.post('/pickabook/_search/getSearchBooks.jsp', {param: myJSON}).done(function(data) {		
			setTimeout(function(){ //딜레이 0.8초
				$('.search-tab-book .ui.loader').removeClass('active');
				if($(data).siblings('.search-book-fivecards').html() != null){ //검색 결과 있을 때
					$('.search-tab-book .search-book-fivecards').append($(data).find('.ui.card'));
				}
				else{
					$('.search-tab-book .search-book-end').html('<a class="ui grey empty circular label"></a>');
				}
			}, 800);
		});
	}	
}

/*독후감 더보기*/
function getSearchPosts(){
	var obj = {'query' : query, 'start': p_start, 'end' : p_end};
	var myJSON = JSON.stringify(obj);	
	$('.search-tab-post').load('/pickabook/_search/getSearchPosts.jsp', {param: myJSON}, function(data){
		applyAfterSearch();
		p_start += p_end;
	});
}

function applyAfterSearch(){
	$('.search-post-star').rating('refresh');
	$('.search-post-star').rating('disable'); //별 수정 못하도록
	
	$('.search-post-content').each(function(){ //내용
	      var length = 180; // 표시할 글자 수 정하기
	      //전체 옵션을 자를 경우
	      $(this).each(function(){
	         if($(this).text().length >= length){
	         $(this).text($(this).text().substr(0,length)+'...');
	         }
	      });
	});
	
	$('.search-post-book-title').each(function(){ //내용
	      var length = 33; // 표시할 글자 수 정하기
	      //전체 옵션을 자를 경우
	      $(this).each(function(){
	         if($(this).text().length >= length){
	         $(this).text($(this).text().substr(0,length)+'...');
	         }
	      });
	});
}

//사용자 더보기 모달
$(document).on('click', '.search-user-more-btn', function(event){
	event.preventDefault();
	$('#search-user-more-modal').modal({
		blurring: true,
		onShow: function(){ //모달 켜질 때
	    	$('#search-user-more-modal').load("/pickabook/_modal/modalSearchUserMore.jsp", {'query' : query}, function() {
	    	});
	    }
	}).modal('show');
});

/*--------------------여기부터 post.jsp에 적용 ----------------------*/

//main.jsp, post.jsp의 무한스크롤에서 사용
function getPosts()
{ 	
	var obj = {'member_id' : member_id, 'start': start, 'end' : end, 'kind': kind};
	var myJSON = JSON.stringify(obj);
	if(start == 0){ //첫로드(db는 limit이 0부터 시작)
		$('div#post-list').load('/pickabook/_mypage/getPosts.jsp', {param: myJSON}, function(data){
            applyAfterPost();
		});
	}
	else{ //무한 스크롤			
		$('.post-list-end .ui.loader').addClass('active'); //로더	
	    $.post("/pickabook/_mypage/getPosts.jsp", {param: myJSON},  function(data){
			if($(data).siblings('.mypost').html() != null){ //포스트 있을 때		    	
				setTimeout(function(){ //딜레이 0.8초	
					$('.post-list-end .ui.loader').removeClass('active');	
					$('div#post-list').append(data);
		            applyAfterPost();
				}, 700);
			}
			else{
				$('.post-list-end').html('<div style="text-align: center;"><a class="ui grey empty circular label"></a></div>');
			}			
	    }); 
	}
}


//독후감 하나 가져오기 - 포스트 작성 후 사용
function getPost(post_num) 
{ 	
    $.post("/pickabook/_mypage/getPost.jsp", {postnum : post_num},  function(data){ 
    	$('#post-list').prepend(data);
    	applyAfterPost();
    }); 
} 

//독후감 화면에서 하나 빼기 - 삭제 후 사용
function deletePost(postnum) 
{ 	
    $('.mypost-style#' + postnum).remove();
}


/*post.jsp, modalPostMore.jsp에서 ajax후 적용*/
function applyAfterPost(){
	$('.ui.dropdown').dropdown('refresh');
	$('.ui.rating.post-update-star').rating();//별점 - 포스트수성부분 
	$('.ui.rating.mypost-star').rating('refresh');
	$('.ui.rating.mypost-star').rating('disable'); //별 수정 못하도록
	
	//포스트 책 제목 글자 수 제한
	$('.post-book-title').each(function(){
	   var length = 37; // 표시할 글자 수 정하기
	   //전체 옵션을 자를 경우
	   $(this).each(function(){
	      if($(this).text().length >= length){
	      $(this).text($(this).text().substr(0,length)+'...');
	      }
	   });
	});
	
   $('.mypage-overlay').visibility({
	     type   : 'fixed',
	     offset : 75,// give some space from top of screen
   });
}

/*포스트 작성*/ 
$(document).on('submit','#post-write',function(event){
	event.preventDefault(); //기존의 submit 막기
	var frm = $(this);
	var content = frm.find('textarea#post-ta').val();
	if(content.trim() == ""){
		alert('내용을 입력하세요');
		return;
	}	
	frm.find('.ui.form').addClass('loading');

  	if($('#book-form').attr('hidden') == 'hidden'){ //일반게시글
  		var obj = {'kind' : 1, 'content' : content};
  	  	var myJSON = JSON.stringify(obj);
  	    $.post('/pickabook/_pro/postInsert.jsp', {param : myJSON}).done(function(data) {
  	  		setTimeout(function(){ 
	  	    	frm.find('.ui.form').removeClass('loading');
	  	    	resetForm(frm);
	  	    	getPost(data.trim());  
  	  		}, 300); //딜레이
  	    });
  	}
  	else { //독후감
  	  	var isbn = frm.find('input[name=isbn]').val();
  		if(isbn.trim() == ""){
  			alert('책을 선택해주세요');
  			return;
  		}
  	  	var star = $('.ui.rating.form-star').rating('get rating');
  	  	var tags = frm.find('#tag-sel').val(); 	  	
  	  	
		$.getJSON('/pickabook/_api/apiInterpark.jsp', {'isbn': isbn}).done(function(json) {//인터파크에서 isbn 검색 -> categoryId가져오기
			var title, categoryId;
			$.each(json.item, function(index, item) {
				if(item.author != "" && item.categoryName != ""){ //패키지 상품 등 걸러내기
					categoryId = item.categoryId; 
					title = item.title;
				}
		    });
	  	  	var obj = {'kind' : 2, 'content' : content, 'isbn' : isbn, 'title': title, 'categoryNum' : categoryId, 'star-rate': star, 'tags' : tags};
	  	  	var myJSON = JSON.stringify(obj);
	  	    $.post('/pickabook/_pro/postInsert.jsp', {param: myJSON}).done(function(data) {
	  	    	setTimeout(function(){ 
		  	    	resetForm(frm);
		  	    	$('#book-form').attr('hidden', 'hidden');
		  	    	getPost(data.trim());		
	  	    		frm.find('.ui.form').removeClass('loading');  	    	
	  	    	}, 300); //딜레이
	  	    });
	  	});	  	
  	}
	getMypageStatus();
});

//포스트 등록form 리셋
function resetForm(frm){
	frm.trigger('reset');
	frm.find('.ui.rating.form-star').rating('clear rating');
	frm.find('#tag-sel').dropdown('clear');	
}


//체크박스 - 독후감
$('.checkbox').checkbox()
.first().checkbox({
  onChecked: function() {
     $('#book-form').removeAttr('hidden');     
  },
  onUnchecked: function() {
	  resetForm($('#post-write'));
	 $('#book-form').attr('hidden', 'hidden');
  }
});

/*검색 custom함수. post.jsp, book.jsp에서 사용*/
$.fn.search.settings.templates.customType = function(response) {  
	//console.log(response.items);
	var str = [];	   	
	$.each(response.items, function(index, item) {//원하는 정보만 뽑기
		str.push('<a class="result">');
		str.push('<div class="ui image" style="float:left;">');
		str.push('<img src="' + item.image + '">');
		str.push('</div>');
		str.push('<div class="content" style="margin: 0 0 0 0;">'); //margin0으로 만들기 필수!
		str.push('<div class="title">' + item.title + '</div>');
		str.push('<div class="description">' + item.author + '</div>');
		str.push('</div>');
		str.push('</a>');
	});      
	var result = str.join('');
	return result;
};;

//포스트 - 도서 검색
$('.ui.search.mypost-search').search({
  apiSettings: {url: '/pickabook/_api/apiSearch.jsp?query={query}&display=5'},
  fields: {results : 'items'},
  maxResults: 30,
  minCharacters : 1,
  type : 'customType',
  onSelect : function(result, response){ 
	  var isbn = result.isbn;
	  if(isbn.length > 13)
			isbn = isbn.split(' ')[1];
	  $('input[name=isbn]').attr("value", isbn);
  }
});


//포스트 삭제
$(document).on("click",'.delete-btn',function(){
	event.preventDefault();
	var x = confirm('정말 삭제하시겠습니까?');
	if(x){
		var postnum = $(this).closest('div.mypost').attr('id');
		$.post('/pickabook/_pro/postDelete.jsp', {'postnum' : postnum}).done(function(data) {
			$('#post-more-modal').modal('hide'); //modalPostMore.jsp이었으면 모달 숨기기
			$('div.card#' + postnum).remove(); //modalPostMore.jsp이었으면 화면에서 카드 지우기
			deletePost(postnum); //post.jsp였으면 화면에서 지우기
			getMypageStatus();
		});
	}
});
	
//포스트 수정 모달
$(document).on('click','span.edit-btn',function(){
	var post = $(this).closest('div.mypost');
	$('#post-edit-modal').modal({
		closable: false,
	    blurring: true,
	    autofocus: true,
	    onShow: function(){ //모달 켜질 때
	    	$('#post-edit').load('/pickabook/_modal/modalPostUpdate.jsp', {'postnum' : post.attr('id')}, function() {
	    		applyAfterPost();
	    	});
	    },
	    onApprove : function() { //수정 버튼	    	 
	      	var ta = $('#edit-ta').val();//textarea값
	  	  	var obj = {}; 
	  	  	var kind;
	  	  	if(post.find('.mypost-booksection').html() != null){
	  	  		kind = 2;
		  	  	var star = $('.ui.rating.post-update-star').rating('get rating'); //별점
		  	  	var tags = $('#post-update-tag-sel').val();//태그
		  	  	obj = {'postnum' : post.attr('id'), 'content' : ta, 'star-rate' : star, 'tags': tags, 'kind': kind};
	  	  	}
	  	  	else{
	  	  		kind = 1;
		  	  	obj = {'postnum' : post.attr('id'), 'content' : ta, 'kind': kind};
	  	  	}	  	  	
	  	  	var myJSON = JSON.stringify(obj);
	    	$.post('/pickabook/_pro/postUpdate.jsp', {'param' : myJSON}).done(function(data) { //업데이트 후 
	    		$.post('/pickabook/_mypage/getPost.jsp', {'postnum' : post.attr('id')}).done(function(data) { //업뎃된 독후감 가져오기
	    			post.find('.mypost-booksection').html($(data).find('.mypost-booksection').html());
	    			post.find('.mypost-section2').html($(data).find('.mypost-section2').html());
	    			applyAfterPost();
	    		});
	    	});
	    }
	}).modal('show');
});

//좋아요
$(document).on('click', '.heart.outline.icon', function(){
	var icon = $(this);
	var post = icon.closest('div.mypost');
	$.post('/pickabook/_pro/likeInsert.jsp', {postnum : post.attr('id')}).done(function(data) {
		icon.addClass('filled');
		icon.removeClass('outline');
		getLikeComment(post);
	});
});

//좋아요 취소
$(document).on('click', '.heart.filled.icon', function(){
	var icon = $(this);
	var post = icon.closest('div.mypost');
	$.post('/pickabook/_pro/likeDelete.jsp', {postnum : post.attr('id')}).done(function(data) {		
		icon.addClass('outline');
		icon.removeClass('filled');
		getLikeComment(post);
	});
});

/*좋아요개수, 댓글 개수 refresh*/
function getLikeComment(post) {
	$.getJSON('/pickabook/_mypage/getLikeComment.jsp', {'postnum' : post.attr('id')}, function(json){
		post.find('.likecount').html(json.likecount);
		post.find('.commentcount').html(json.commentcount);
	});	
}


$(document).ready(function(){
	/*댓글 작성*/
	$(document).on('keydown','input[name=comment-ta]',function(e){
    	if(e.keyCode == 13){
    		var input = $(this);
    		var post = input.closest('div.mypost');
    		var comment =  input.val();
    		if(comment.trim() == ""){
    			alert('내용을 입력하세요');
    			return;
    		}	
    		var obj = {'postnum' : post.attr('id'), 'content' : comment};
    		var myJSON = JSON.stringify(obj);
    		$.post('/pickabook/_pro/commentInsert.jsp', {param: myJSON}).done(function(data) {
    			input.val('');
    			getComment(post, data.trim());//댓글화면에추가하는 코드
    			getLikeComment(post);//댓글 개수 증가
    		});
    	}
    });
});

/*댓글 하나 가져오기 - 댓글 작성 후 사용*/
function getComment(post, comment_num) 
{ 	
    $.post('/pickabook/_mypage/getComment.jsp', {'comment_num' : comment_num},  function(data){ 
    	post.find('.mypost-comment-list').append(data);
    }); 
}

//댓글 더보기
$(document).on('click','.comment-more',function(e){
	e.preventDefault();
	var a_tag = $(this);
	var post = a_tag.closest('div.mypost');
	var count = a_tag.parent().children('div').length; //여태까지 표시된 댓글 개수
	var end = 5; //총 5개씩 load
	var loader = a_tag.find('.comment-more-loader'); //로더	
	loader.addClass('active');
	$.post("/pickabook/_mypage/getComments.jsp", {'postnum' : post.attr('id'), 'start': count, 'end' : end}, function(data){	    	
		setTimeout(function(){ 
			loader.removeClass('active');	
			a_tag.remove(); //더보기 + 로더 없애기(bcoz 이미 getComments에서 가져오노 data안에 또 들어있음)
			post.find('.mypost-comment-list').prepend(data);
			if(post.hasClass('postmore')) //모달이면 가져온 data에서 로더 없애기
				post.find('.ui.loader').remove();
		}, 300); //딜레이 0.3초	
	});
});


function commentToggle(comment){
	comment.find('.comment-input-edit').toggle(); //댓글 div <-> 수정  
	comment.find('.comment-toggle-btn1').toggle(); //edit <->
	comment.find('.comment-toggle-btn2').toggle(); //delete <->	
}

/*댓글 수정 - input toggle하기, 댓글 취소 - toggle 원상복귀*/
$(document).on('click', '.comment-edit, .comment-cancel', function(){
	event.preventDefault();
	var comment = $(this).parent().parent();
	commentToggle(comment);
});

/*댓글 수정*/
$(document).on('click', '.comment-update', function(){
	event.preventDefault();
	var comment = $(this).parent().parent();
	var content = comment.find('.toggle2 input').val(); //수정한 내용
	$.post('/pickabook/_pro/commentUpdate.jsp', {'commentnum': comment.attr('class'), 'content':content}).done(function(data) {
		commentToggle(comment);
		comment.find('.comment-input-edit.toggle1').html(content); //댓글 내용 변경
		comment.find('.toggle2 input').val(content)//수정토글 내용 변경
	});
});

/*댓글 삭제*/
$(document).on('click', '.comment-delete', function(){
	event.preventDefault();
	var x = confirm('정말 삭제하시겠습니까?');
	if(x){
		var btn = $(this);
		var comment = btn.parent().parent();
		var post = btn.closest('div.mypost');
		$.post('/pickabook/_pro/commentDelete.jsp', {'commentnum': comment.attr('class')}).done(function(data) {
		    comment.remove();//댓글 화면에서 없애기	
		    getLikeComment(post);//댓글 개수 감소
		});
	}
});


/*자기소개 수정 토글 add버튼-토글 ,취소버튼-다시토글*/
$(document).on('click', '.mypage-intro-toggle1-btn', function(e){
	e.preventDefault();
	$('.mypage-intro-toggle1').toggle();
});

/*자기소개 수정 버튼 클릭시*/
$(document).on('click', '.mypage-intro-edit-btn', function(e){
	e.preventDefault();
	var intro = $('.mypage-intro-toggle1').find('textarea').val();
	if(intro.trim() == ""){
		alert('내용을 입력하세요');
		return;
	}
	$.post('/pickabook/_pro/introUpdate.jsp', {'intro': intro}).done(function(data) {
		$('.mypage-intro-toggle1').toggle();
		var str = '<div class="ui sub header" style="margin-top: 0.5em;">' + intro + '</div>';
		//$(str).insertAfter('.mypage-intro-toggle1 .ui.divider');
		$('.mypage-intro-toggle1').html(str);
	});	
});



/*------------여기부터 mypage.jsp에 적용--------------------*/

$(document).ready(function() {
	/*프사 디머*/
	$('.mypage-profileimg-dimmer').dimmer({
	  on: 'hover'
	});
	/*설정, 로그아웃*/
	$('.mypage-setting-dropdown').dropdown();
	
});


/*팔로워 목록 modal*/
$(document).on('click', '.follower-label', function(event){
	event.preventDefault();
	var member_id = $(this).closest('div.mypage').attr("id");
	$('#follower-modal').modal({
		blurring: true,
		onShow: function(){ //모달 켜질 때
	    	$('#follower-modal').load("/pickabook/_modal/modalFollowList.jsp", {'member_id' : member_id, kind : '팔로워'}, function() {
	    	});
	    }
	}).modal('show');
});

/*팔로잉 목록 modal*/
$(document).on('click', '.following-label', function(event){
	event.preventDefault();
	var member_id = $(this).closest('div.mypage').attr("id");
	$('#following-modal').modal({
		blurring: true,
		onShow: function(){ //모달 켜질 때
	    	$('#following-modal').load("/pickabook/_modal/modalFollowList.jsp", {'member_id' : member_id, kind : '팔로잉'}, function() {
	    	});
	    }
	}).modal('show');
});


//팔로우 버튼 클릭
$(document).on('click', '.follow', function(){
	var me = $(this);
	var member_id = me.closest('div.mypage').attr("id");
	$.post('/pickabook/_pro/followInsert.jsp', {'member_id' : member_id}).done(function(data) {
		me.html('팔로잉');
		me.removeClass('white-border-btn follow');
		me.addClass('red following');
		getMypageStatus();
	});
});

//팔로잉 버튼 클릭
$(document).on('click', '.following', function(){
	var me = $(this);
	var member_id = me.closest('div.mypage').attr("id");
	$.post('/pickabook/_pro/followDelete.jsp', {'member_id' : member_id}).done(function(data) {
		me.html('팔로우');
		me.addClass('white-border-btn follow');
		me.removeClass('red following');
		getMypageStatus();
	});
});

function getMypageStatus() {
	$.getJSON('/pickabook/_mypage/getMypageStatus.jsp', {'member_id' : member_id}, function(json){
		$('.postcount-label').html('포스트 ' + json.postcount);
		$('.follower-label').find('#mypage-follower').html('팔로워 ' + json.followercount);
		$('.following-label').find('#mypage-following').html('팔로잉 ' + json.followingcount);
	});	
}


/*------------여기부터 browse.jsp에 적용--------------------*/

//포스트 상세 모달
$(document).on('click', '.browse-showpost-btn', function(){
	event.preventDefault();
	var postnum = $(this).closest('div.card').attr('id');
	$('#post-more-modal').modal({
	    blurring: true,
	    autofocus: true,
	    onShow: function(){ //모달 켜질 때
	    	$('#post-more-modal').load('/pickabook/_modal/modalPostMore.jsp', {'postnum' : postnum}, function() {
	    		applyAfterPost();
	    	});
	    }
	}).modal('show');
});
