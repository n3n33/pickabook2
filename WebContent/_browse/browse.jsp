<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_layout/session.jsp" %> 
<%@ page import="pickabook.*, java.util.*"%>

<%
   request.setCharacterEncoding("utf-8");
   String pageTitle = "둘러보기";
   String isbn = request.getParameter("isbn");
   
   String session_user = (String) session.getAttribute("user_id");
   String session_member = (String) session.getAttribute("member_id");
   
   List<TagData> tagLists = null;
   TagData tagList = null;
   
   TagDB tagProcess = TagDB.getInstance();
   tagLists = tagProcess.getTags();

   List<PostBrowseData> postBrowseLists = null;
   PostBrowseData postBrowseList = null;

   PostDB postProcess = PostDB.getInstance();
   
%>

<jsp:include page="/_layout/header.jsp" flush="false">
   <jsp:param name="pageTitle" value="<%=pageTitle%>" />
</jsp:include>

<style type="text/css">
body {
   background-color: #FFFFFF;
}

a {
   color: #000000;
}

a:link {
   color: #000000;
}

a:visited {
   color: #000000;
}

a:hover {
   color: #000000;
}

a:active {
   color: #000000;
}

.ui.menu .item img.logo {
   margin-right: 1.5em;
}

.top.container {
   margin-top: 7em;
}

.ui.grid {
   margin-bottom: 3em;
}

.ui.secondary.pointing.menu .active.item {
   border-color: #B70A15;
   color: #B70A15;
}

.ui.secondary.pointing.menu .active.item:hover {
   border-color: #B70A15;
   color: #B70A15;
}

.bookText {
   color: #666;
   font-size: 14px;
   font-family: "Noto Sans Light", "Malgun Gothic", sans-serif;
}

.innerSize {
   width: 960px;
   margin: 0 auto;
}

#hashButton {
   margin-top: 7em;
}

.button.hashtagBtn {
   margin-top:5px; 
   margin-bottom:5px;
   border-radius: 15px;
   margin-right: 3px;
}

.containInner {
   padding-top: 7em; 
   padding-bottom: 10em;
}
</style>

<div class="ui container">
   <div class="innerSize" style="width: 900px">
      <div class="ui centered grid" id="hashButton">
         <button class="ui red button basic hashtagBtn" id="0" style="border-radius: 15px; margin-right: 5px;"><i class="hashtag icon"></i> 전체 <span style="color: #B70A15; margin-left: 2px;"> (<%=tagProcess.getTagCount(100000, session_member)%>)</span> </button>
         <%
            for(int i=0; i<tagLists.size(); i++) {
               tagList = (TagData) tagLists.get(i);      
         %>
            <button class="ui button basic hashtagBtn" id="<%=tagList.getTag_num()%>" style="border-radius: 15px; margin-right: 5px;"><i class="hashtag icon"></i> <%= tagList.getName() %> <span style="color: #B70A15; margin-left: 2px;"> (<%=tagProcess.getTagCount(tagList.getTag_num(), session_member)%>)</span> </button>
         <%
            }
         %>   
      </div>   
   </div>
</div>

<div class="ui container" style="padding-left: 45px; padding-right: 40px;">
  <div class="innerSize">
   <div class="ui four column grid">
     <div class="ui special cards" id="browse-content-book">
     </div>
     <div id="browse-content-book-end">
     </div>
   </div>
  </div>
</div>


<!-- 모달  -->

<script>
$(document).ready(function(){
   $('#0').trigger('click');
   
   //무한 스크롤
    $(window).scroll(function() {
       //alert($(window).scrollTop() + "==" +  $(document).height() + "-" + $(window).height());
        if ($(window).scrollTop() >= $(document).height() - $(window).height() - 10) {
          start += 4;
          addBrowseContent(tag_num);
        }
    });
   
});

var start = 0;
var end = 4;
function addBrowseContent(tagnum){
    $.post("/pickabook/_browse/browseContent.jsp", {'tag_num' : tagnum, 'start':start, 'end':end},  function(data){ 
        if (data.trim() == "") { 
            $('div#browse-content-book-endk').html('포스트가 없습니다.');            
        }
        else{
            $('#browse-content-book').append(data);
            $('.blurring.dimmable.image').dimmer({ on: 'hover' });
            applyAfterBrowse();
        }
    });
}

// 처음 가져올 때
function getFirstBrowseContent(tagnum) 
{    
   $('#browse-content-book').load("/pickabook/_browse/browseContent.jsp",  {'tag_num' : tagnum, 'start':start, 'end':end}, function() {
        $('.blurring.dimmable.image').dimmer({ on: 'hover' });
        applyAfterBrowse();
   });
}; 

var tag_num;
$(document).on('click', '.hashtagBtn', function(){
   if($('.red.button') != $(this)){
      $('.red.button').removeClass('red');
      $(this).addClass('red');
   }

   tag_num = $(this).attr('id');
   getFirstBrowseContent(tag_num);
});

function applyAfterBrowse() {      
    $('.limit-text').each(function(){
        var length = 100; // 표시할 글자 수 정하기
        //전체 옵션을 자를 경우
        $(this).each(function(){
           if($(this).text().length >= length){
           $(this).text($(this).text().substr(0,length)+'...');
           }
        });
     });
}
</script>
<script src="/pickabook/assets/mypage.js"></script>
<jsp:include page="/_layout/footer.jsp" flush="false" />