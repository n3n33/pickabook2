<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pickabook.*, java.util.*"%>

<%
   request.setCharacterEncoding("UTF-8");
   String pageTitle = request.getParameter("pageTitle");
   String member_id = request.getParameter("member_id"); //페이지의 주인
   String session_member = (String)session.getAttribute("member_id"); //현재 로그인한 사람
   MemberDB memPro = MemberDB.getInstance();
   MemberData member = memPro.getInfoMember(member_id);   
%>

<style type="text/css">
.label{
   a:link { color: black; text-decoration: none;}
   a:visited { color: black; text-decoration: none;}
}

.back{
   background-image:url('https://images.unsplash.com/photo-1534283457141-00c18acca0b2?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=900d58e270b0e4c339c8d44e589fcad9&auto=format&fit=crop&w=500&q=60');
   height:10em;
   padding:3em;
   margin-bottom:10ex;
}
.post-pal{
   text-shadow: -1px 0 #353535, 0 1px #353535, 1px 0 #353535, 0 -1px #353535;
}
.fcolor{
   padding-top:2em;
}
.talign{
   text-align:center;
   font-size:50px;
}
.ssize{
   font-size:15px;
}

#follower-modal, #following-modal{
	height: 550px;
}

.mypage-profileimg-dimmer-text, .mypage-profileimg-dimmer-text span{
	 color: white!important;
}

.mypage-profileimg{
	border: 1px solid #EAEAEA!important;
	background-color: white!important;
	padding: 3px;
}
.modal-image{
	padding:10px;
}


</style>
<div class="ui bordered fluid container back">
   <div class="ui grid mypage" id="<%=member_id%>"> 
   <!-- 프로필 이미지 부분 -->
     <div class="three wide column">
		<div class="ui centered small circular bordered fluid image <%if(member_id.equals(session_member)) out.println("mypage-profileimg-dimmer");%>">
		  <div class="ui dimmer">
		    <div class="content">
		      <a href="" class="profileimg-dimmer-text">
		      	<i class="camera icon"></i>
		      	<span class="ui sub header" style="color: white!important;">Update</span>
		      </a>
		    </div>
		  </div>
		  <img src="<%=member.getProfile_img()%>" class="mypage-profileimg">
		</div>
     </div>
    <!-- 프로필 이미지 부분 end -->   
        
     <div class="ten wide column">
       <div class="ui huge header post-pal" style="color:white;"><%=member.getUser_id() %>
        
       </div>
       <div class="post-pal">
       <div class="statistics">
        <div class="ui mini statistic">
          <div class="label postcount-label" style="color:white;">포스트 <%=memPro.getPostCount(member_id)%></div>
        </div>
        <div class="ui mini statistic">
          <div class="label follower-label"><a href="" id="mypage-follower" style="color:white;">팔로워 <%=memPro.getFollowerCount(member_id)%></a>
          </div>
        </div>
        <div class="ui mini statistic">
          <div class="label following-label"><a href="" id="mypage-following"style="color:white;">팔로잉 <%=memPro.getFollowingCount(member_id)%></a>

          </div>
        </div>
      </div>
      </div>
  </div>
  <div class="three wide column" style="margin-top:15px; text-align:right;">
  <%if(member_id.equals(session_member)){%> 
	<div class="ui dropdown mypage-setting-dropdown">
	  <div class="text"><i class="icon link big setting" style="color: white;"></i></div>
	  <div class="menu">
	    <a class="item" href="/pickabook/_mypage/setting.jsp">설정</a>
	    <a class="item" href="/pickabook/_logon/logout.jsp">로그아웃</a>
	  </div>
	</div>
  <%}
  	else if(memPro.checkFollow(member_id, session_member) == 1){ 
		out.println("<button class=\"ui red button following\">팔로잉</button>");
	}
  	else
  		out.println("<button class=\"ui white-border-btn button follow\">팔로우</button>");%>   
  </div>
  </div>
</div>    
   
   <div class="ui secondary pointing menu" style="padding-top: 2em;">
     <a class="item <%if(pageTitle.equals("포스트")) out.println("active");%>" href="/pickabook/_mypage/post.jsp?user_id=<%=member.getUser_id()%>">포스트</a>
     <a class="item <%if(pageTitle.equals("서재")) out.println("active");%>" href="/pickabook/_mypage/book.jsp?user_id=<%=member.getUser_id()%>">서재</a>
     <%if(member_id.equals(session_member)){ %>
     	<a class="item <%if(pageTitle.equals("좋아요")) out.println("active");%>" href="/pickabook/_mypage/likePage.jsp?user_id=<%=member.getUser_id()%>">좋아요</a>
     <%} %>
   </div> 
   
<!-- mypage-image-modal -->
	<div class="ui profile image mini modal">
		<i class="close icon"></i>
		<form  id="upload" action="/pickabook/_pro/modifyPro.jsp"  method="post" enctype="multipart/form-data">
			<input type="file" name="profile_img" id="profile_img" hidden="hidden" onchange="fileInfo(this)">
			<div class="content modal-image"> 	
		        <button id="btn-upload" class="circular ui icon button modal-image">파일선택</button>
		        <div id="img_box" class="modal-image"></div>
			</div>
	 		<div class="ui divider"></div>
	  		<div class="actions" style="padding-bottom:10px; padding-right:5px; text-align:right;">
		   		<button type="submit" class="ui button">OK</button>
	  		</div>
	  	</form>
	</div>
<!-- mypage-image-modal end -->

<script>
// image-dimmer
$(document).on('click', '.profileimg-dimmer-text', function(e){
	e.preventDefault();
	$('.ui.profile.image.mini.modal').modal('show');
});

// file upload
$(function(){          
   $('#btn-upload').click(function(e){
      e.preventDefault();             
      $("input:file").click();               
      var ext = $("input:file").val().split(".").pop().toLowerCase();
      if(ext.length > 0){
         if($.inArray(ext, ["gif","png","jpg","jpeg"]) == -1) { 
            alert("gif,png,jpg 파일만 업로드 할수 있습니다.");
            return false;  
         }                  
      }
      $("input:file").val().toLowerCase();
   });                         
});  
// image-preview
function fileInfo(f){
	var file = f.files; // files 를 사용하면 파일의 정보를 알 수 있음

	var reader = new FileReader(); // FileReader 객체 사용
	reader.onload = function(rst){
		$('#img_box').append('<img src="' + rst.target.result + '">'); // append 메소드를 사용해서 이미지 추가
		// 이미지는 base64 문자열로 추가
	}
	reader.readAsDataURL(file[0]); // 파일을 읽는다
}
</script>