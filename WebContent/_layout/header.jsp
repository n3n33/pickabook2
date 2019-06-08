<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="pickabook.*, java.util.*"%>
<%
	request.setCharacterEncoding("UTF-8");
	String pageTitle = "PICK A BOOK";
	String query = request.getParameter("query");
	String member_id = (String)session.getAttribute("member_id");
	String user_id = (String)session.getAttribute("user_id");		
	MemberDB member = MemberDB.getInstance();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="stylesheet" type="text/css" href="/pickabook/assets/dist/semantic.min.css">
<link rel="stylesheet" type="text/css" href="/pickabook/assets/mypage.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.2/css/all.css">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="/pickabook/assets/dist/semantic.min.js"></script>
<title><%=pageTitle%></title>
</head>
<style type="text/css">
body {
	background-color: #FBFBFB;
	font-family: "Noto Sans Light","Malgun Gothic",sans-serif!important;
}

.ui.container { /*페이지 헤더, 전체컨테이너*/
	width: 980px;
}
.ui.menu {
	margin-right: 1.5em;
}
.top.container { /*전체 컨테이너*/
	margin-top: 7em;
	margin-bottom: 7em;
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
	font-size: 15px;
	font-family: "Noto Sans Light","Malgun Gothic",sans-serif;
}

.innerSize {
	width: 940px;
	margin: 0 auto;
}

.iconPad {
	margin-left: 0.5em;
	margin-right: -1.5em;
}

</style>

<body>

<div class="ui borderless fixed menu">
    <div class="ui container">
       <a href="/pickabook/_main/main.jsp" class="header item left floated">
	<img src="/pickabook/image/PAB.png" style="width:10em; border-left:0px; margin-top:4px; margin-left: -1em;">
       </a>
       <div class="item">
          <form action="/pickabook/_search/search.jsp" method="get">
             <div class="ui transparent icon input">
                <input type="text" placeholder="검색" name="query" value="<%if(query!=null) out.println(query);%>">
                  <i class="search link icon"></i>
             </div>
          </form>
       </div>
       <div class="item">
          <a class="item iconPad" href="/pickabook/_browse/browse.jsp">
             <i class="large compass outline icon"></i>
          </a>    
          <a class="item iconPad" href="/pickabook/_mypage/post.jsp">
             <i class="large user outline icon"></i>
          </a>
       </div>
    </div>
</div>


<!-- 모달 -->

<!-- 팔로워 모달 -->
<div class="ui tiny modal" id="follower-modal"></div>

<!-- 팔로잉 모달 -->
<div class="ui tiny modal" id="following-modal"></div>

<!-- 포스트 수정 모달 -->
<div class="ui small modal" id="post-edit-modal">
	<div class="ui small header">포스트 수정</div>
	<div class="content">
		<form>
			<div class="ui fluid form" id="post-edit">
				<!-- 포스트 정보 여기에 뿌려짐 -->
			</div>
		</form>
	</div>
	<div class="actions">
		<div class="ui cancel button">취소</div>
		<div class="ui ok button pickabook-bgcolor">수정</div>
	</div>
</div>

<!-- 포스트 상세 모달 -->
<div class="ui modal" id="post-more-modal"></div>

<!-- 책 수정 모달 -->
<div class="ui mini modal" id="book-edit-modal">
  <div class="content">  
    <div class="ui text three item menu">
        <a class="item book-type" id="wish">WISH</a>
        <a class="item book-type" id="ing">ING</a>
        <a class="item book-type" id="read">READ</a>
      </div>     
  </div>  
  <div class="actions">
      <div class="ui cancel basic button">취소</div>
      <div class="ui ok button">수정</div>
    </div>
      
</div>

<!-- 책 삭제 모달 -->
<div class="ui mini modal" id="book-delete-modal">
  <div class="content">정말 삭제하시겠습니까?</div>
  <div class="actions">
      <div class="ui cancel basic button">취소</div>
      <div class="ui ok button">삭제</div>
    </div>
</div>
   
