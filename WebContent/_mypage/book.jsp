<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_layout/session.jsp"%>
<%@ page import="pickabook.*, java.util.*"%>
<%
   request.setCharacterEncoding("UTF-8");
	String pageTitle = "서재";

   MemberDB memPro = MemberDB.getInstance();
   String user_id = request.getParameter("user_id");
   String session_user = (String) session.getAttribute("user_id");
   String session_member = (String) session.getAttribute("member_id");
   String member_id = "";

   //페이지 주인 판별
   if (user_id == null || user_id.equals("")) { //파라메터가 없음
      if (session_user == null || session_user.equals("")) { //파라메터도 없고 로그인도 안한사람
         response.sendRedirect("/pickabook/_logon/loginForm.jsp");
         return;
      } else { //파라메터는 없는데 세션이 있다면 , 세션 주인의 포스트페이지 보여주기
         user_id = session_user;
         member_id = session_member;
      }
   } else { //user_id 파라메터 있음. 그사람의 페이지 보여주기
      member_id = memPro.getMember_id(user_id);
      if (member_id == null || member_id.equals("")) { //파라메터가 우리 회원아닐 경우
         response.sendRedirect("/pickabook/_main/main.jsp");
         return;
      }
   }
%>

<jsp:include page="/_layout/header.jsp" flush="false"/>

<style>
/*modal의 서재 타입 선택 버튼*/
.three.item.menu .active.item, .three.item.menu .active.item:hover {
   color: #B70A15;
}

.three.item.menu .item, .three.item.menu .item:hover {
   color: rgba(0, 0, 0, .6);
}

.ui.button {
   background-color: #B70A15;
   color: #F6F6F6;
}

.book.item.active {
   color: #B70A15 !important;
   font-weight: bold !important;
}
</style>

<div class="ui top container">

   <jsp:include page="/_layout/mypage.jsp" flush="false">
      <jsp:param name="pageTitle" value="<%=pageTitle%>" />
      <jsp:param name="member_id" value="<%=member_id%>" />
   </jsp:include>

   <div class="ui text menu">
      <!--       filter       -->
      <div class="item">
         <div class="menu">
            <div class="ui secondary  menu">
               <a class="ui book item search-sort" id="0"> 
                  <i class="small check icon"></i> WISH
               </a> 
               <a class="ui book item search-sort" id="1"> 
                  <i class="small check icon"></i> ING
               </a> 
               <a class="ui book item search-sort" id="2"> 
                  <i class="small check icon"></i> READ
               </a>
            </div>
         </div>
      </div>
      <div class="header item"></div>
      <div class="right menu">
         <div class="fitted item">
            <%
               if (session_member.equals(member_id)) {
            %>
            <div class="ui right floated basic icon button book-add" data-tooltip="서재에 책을 추가하세요" data-position="top right">
               <i class="add icon"></i>
            </div>
            <%
               }
            %>
         </div>
      </div>
   </div>


   <div id="my-books">
   </div>

</div>
<!-- end of 전체 container  -->



<!-- 모달 -->

<!-- 서재에 도서 등록 모달 -->
<div class="ui mini modal" id="book-add-modal">
    <div class="content" style="padding-top: 0.5em;">                  
      <div class="ui text three item menu">
        <a class="item book-type" id="wish">WISH</a>
        <a class="item book-type" id="ing">ING</a>
        <a class="item book-type" id="read">READ</a>
      </div> 
      
      <div class="ui divider"></div>
      
      <form id="book-add-form">
        <div class="ui form"><!-- ui form을 없애면 search input이 동그래짐 -->
         <div class="ui fluid category search mybook-search" style="margin-top: 1em;">
           <div class="ui fluid icon input">
             <input class="prompt" type="text" placeholder="책 검색">
             <i class="search icon"></i>
           </div>
           <div class="results"></div>        
         </div> 
        </div>
        
        <input type="hidden" name="book-add-isbn">
        <div class="ui items book-search-result" style="min-height:120px;">
         <div class="item">
         	<div class="content" style="text-align: center;">책을 선택하세요</div>
         </div>
        </div>
        
        <div class="ui form">
          <input type="date" name="book-add-date">
        </div>
      </form>      

      
    </div>
    <div class="actions">
      <div class="ui cancel basic button">취소</div>
      <div class="ui ok button">추가</div>
    </div>
</div>


<script src="/pickabook/assets/mypage.js"></script>

<script>
$(document).ready(function() {
    $('#0').trigger('click'); //첫화면 wish
    $('input[name=book-add-date]').val(new Date().toDateInputValue()); //기본값 오늘날짜로 
});

var member_id = '<%=member_id%>';
var session_member = '<%=session_member%>';

/*filter*/
var selectedFilter; //전역변수
$(document).on('click','.ui.book.item',function(){
   var active = $('.book.search-active');
    active.removeClass('search-active');
    $(this).addClass('search-active');
    
    //전역변수에 type(wish,ing,read) 넣기
    if($(this).attr('id') == 0)
       selectedFilter = "wish";
    else if($(this).attr('id') == 1)
       selectedFilter = "ing";
    else if($(this).attr('id') == 2)
       selectedFilter = "read";
    
    getMyBooks(selectedFilter);
});

/*서재 리스트 load*/
function getMyBooks(type){
   $('#my-books').load('/pickabook/_mypage/getMyBooks.jsp', {'member_id' : member_id, 'type' : type}, function(){
      	//$('.blurring.dimmable.fluid.image').dimmer('refresh');refresh안써도 작동 함 ...왜지?
       	if(session_member == member_id){
        	$('.blurring.dimmable.image').dimmer({on : 'hover'}); //자기 서재인경우만 dimmer
        }
   });
}

/*modal book-delete 띄우기*/
$(document).on('click','.book-delete-btn',function(){
   var isbn = $(this).closest('div.card').attr('id');
   $('div#book-delete-modal').modal({
      onApprove : function() {//삭제버튼
         $.post('/pickabook/_pro/bookDelete.jsp', {'isbn' : isbn}).done(function(data) {
             $('#' + isbn).remove();
         });   
      }
   }).modal('show');   
});




/*modal book-add의 type버튼*/
var selectedType = 'yet'; //전역변수
$(document).on('click','.item.book-type', function(){   
   if($(this).hasClass('active')){ //선택해제
       $(this).removeClass('active');   
       selectedType = 'yet';
   }
   else if(selectedType == 'yet'){ //첫선택
      $(this).addClass('active');   
      selectedType = $(this).attr('id');
   }
   else{ //다른걸로재선택
      $('.active.item.book-type').removeClass('active');
      $(this).addClass('active');
      selectedType = $(this).attr('id');
   }
});

/* modal book-add 띄우기*/
$(document).on('click','.book-add', function(){
   $('div#book-add-modal').modal({
      closable: false,
       blurring: true,
       autofocus: true,
       onApprove : function() { //확인 버튼
          if(selectedType == 'yet'){
             alert('서재종류를 선택해주세요');    
             return false;         
          }
          else if($('input[name=book-add-isbn]').attr('value') == null){
             alert('책을 선택해주세요');
             return false;
          }
          else{
             var param = $('#book-add-form').serializeArray();
             param.push({name: 'type', value : selectedType});
               $.post('/pickabook/_pro/bookInsert.jsp', param).done(function(data) {
                  $('#' + data.trim()).trigger('click');
                  modalBookAddReset();
               });
          }
       },
       onDeny : function() { //취소 버튼
          modalBookAddReset();
       }
   }).modal('show');
});

/*modal book-edit 띄우기*/
$(document).on('click','.book-edit-btn',function(){
   var isbn = $(this).closest('div.card').attr('id');
   $('div#book-edit-modal').modal({
      onApprove : function() {//삭제버튼
         if(selectedType == 'yet'){
             alert('서재종류를 선택해주세요');    
             return false;         
          }else{
             var obj = {'type': selectedType, 'isbn' : isbn,};
             var myJSON = JSON.stringify(obj);
          $.post('/pickabook/_pro/bookUpdate.jsp', {'param' : myJSON}).done(function(data) {
              $('#' + data.trim()).trigger('click'); //첫화면 wish        	  
          });}
      }
   }).modal('show');   
});


/*modal 책 검색*/
$('.ui.search.mybook-search').search({
   apiSettings: { url: '/pickabook/_api/apiSearch.jsp?query={query}&display=5',},
   fields: {results : 'items'},
   maxResults: 30,
   minCharacters : 1,
   type : 'customType',
   onSelect : function(result, response){
      var isbn = result.isbn;
      if(isbn.length > 13)
         isbn = isbn.split(' ')[1];
      $('input[name=book-add-isbn]').attr('value', isbn);
      var str = [];
      str.push('<a class="ui tiny image" href="/pickabook/_search/bookInfo.jsp?isbn=' + isbn + '">');
       str.push('<img src="' + result.image.replace('type=m1', '') + '">');
       str.push('</a>');
       str.push('<div class="content">');
       str.push('<a class="ui small header" href="/pickabook/_search/bookInfo.jsp?isbn=' + isbn + '">' + result.title + '</a>');
       str.push('</a>');
       str.push('<div class="description"><span style="font-size: 12px;">' + result.author + '</span></div>');
       str.push('</div>'); 
       $('.book-search-result div.item').html(str.join(''));
   }
});

/*오늘날짜 가져오는 함수*/
Date.prototype.toDateInputValue = (function() {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0,10);
});

/*modal book-add 리셋*/
function modalBookAddReset(){
   $('form').trigger('reset');
   $('.book-search-result div.item').html('책을 선택하세요');
   $('input[name=book-add-date]').val(new Date().toDateInputValue());
     $('#' + selectedType).trigger('click');
}
</script>
</body>
</html>