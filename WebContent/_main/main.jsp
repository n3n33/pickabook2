<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_layout/session.jsp" %> 
<%@ include file="/_api/apiInclude.jsp" %>
<%@ page import="java.text.NumberFormat"%>

<%
	request.setCharacterEncoding("UTF-8");
	String pageTitle = "메인";

	String session_member = (String)session.getAttribute("member_id");
%>

<jsp:include page="/_layout/header.jsp"  flush="false">
   <jsp:param name="pageTitle" value="<%=pageTitle %>"/>
</jsp:include>

<style>
a {
	color: #353535;
}

a:hover {
	color: #B70A15;
}

h5 {
	color: #353535;
}

.main-my-rank {
   color: #B70A15;
}

.main-user-rank-a {
   color: #353535;
}

.main-user-rank-a:hover {
   color: #B70A15;
}

.main-side-title-h5 {
   color: #353535;
   margin-top: 0.5em;
   margin-left: 0.5em;
}

.main-stats>b {
   color: #B70A15;
}

.main-stats {
   color: #4C4C4C;
}


.fixed.overlay .book-reco1, .fixed.overlay .book-reco2{
	width: 350px!important;
}
</style>

<div class="ui top container">
	
<div class="ui grid">
	
  <div class="ten wide column">
	<div id="post-list"></div>			
	<div class="post-list-end ui basic segment margin-top">
		<div class="ui text small loader">Loading</div>
	</div>
  </div><!-- end of ten wide column -->
  
  <div class="six wide column">
  
	<div class="div-border-style margin-bottom-one" style="margin-top: 0; height: 380px;">
		<h5 class="main-side-title-h5">사용자 랭킹</h5>
		<div class="ui pointing secondary three item menu">
			<div class="ui container">
			<%
				FavoriteCategoryDB fctgPro = FavoriteCategoryDB.getInstance();
				List<CategoryData> fcategoryList = null;
				fcategoryList = fctgPro.getFcategoryList(session_member);						
				
				if (fcategoryList == null) {
			%>
				<div class="ui basic segment">선호 카테고리를 설정해주세요.</div>
			<%
				} 
				else {
					for (int j = 0; j < fcategoryList.size(); j++) {
					CategoryData fcategory = fcategoryList.get(j);
					%>
					
					<a class="item fcategory-tab <% if(j==0) out.println("active");%>" id="<%=fcategory.getCategory_num() %>">
					  <%=fcategory.getName()%>
					</a>
				<% } %>
			<% } %>
			</div>
		</div>
		<div class="ranker">
			
		</div>
	</div>
	
	<!-- 사용자 추천 -->
	<div class="div-border-style margin-bottom-one">
		<h5 class="main-side-title-h5">회원님을 위한 추천</h5>
		<div class="ui container"  style="margin-top: 0; overflow:auto; height:170px;">
      <%            
         FollowDB fPro = FollowDB.getInstance();
         List<FollowData> recoList = null;
         recoList = fPro.getRecommendList(session_member);
         
         List<FollowData> topList = null;
         topList = fPro.recommendTop5();
         
         MemberDB memPro = MemberDB.getInstance();
         
         if (recoList == null) {
            for (int i = 0; i < topList.size(); i++) {
               FollowData top5 = topList.get(i);
               MemberData topInfo = memPro.getInfoMember(top5.getMember_id());
      %>
         <table>
            <tr>
               <td>                        
                  <a class="main-user-rank-a" href="/pickabook/_mypage/post.jsp?user_id=<%=topInfo.getUser_id()%>">
                  <img class="ui circular bordered fluid image" src="<%=topInfo.getProfile_img()%>" style="margin-right: 0.5em; margin-bottom:0.1em; width:35px;"></a>
               </td>
               <td>
                  <a class="main-user-rank-a" href="/pickabook/_mypage/post.jsp?user_id=<%=topInfo.getUser_id()%>"><%= topInfo.getUser_id() %></a>
               </td>
            </tr>
         </table>
      <% 	}
      	 } 
         else {
            for (int i = 0; i < recoList.size(); i++) {
               FollowData recommend = recoList.get(i);
               MemberData recommendInfo = memPro.getInfoMember(recommend.getMember_id());
      %>
         <div class="user-recommend">
            <table>
               <tr>
                  <td>                        
                     <a class="main-user-rank-a" href="/pickabook/_mypage/post.jsp?user_id=<%=recommendInfo.getUser_id()%>">
                     <img class="ui circular bordered fluid image" src="<%=recommendInfo.getProfile_img()%>" style="margin-right: 0.5em; margin-bottom:0.1em; width:35px;"></a>
                  </td>
                  <td>
                     <a class="main-user-rank-a" href="/pickabook/_mypage/post.jsp?user_id=<%=recommendInfo.getUser_id()%>"><%= recommendInfo.getUser_id() %></a>
                  </td>
               </tr>
            </table>
         </div>
      <% 	} %>
      <% } %>
		</div>
	</div>	
	
	
	<!-- 책 추천 -->
	<div class="overlay">
   <%             
      PostDB bookPro = PostDB.getInstance();
      PostBookData x = null;
      x = bookPro.recommendBook();

      if(x != null){  
            JSONObject bookitem = apiIsbn(x.getIsbn());
   %>
   <div class="div-border-style margin-bottom-one book-reco1" style="height:174px;">
   
      <div class="ui grid">
          <div class="six wide column">
            <a href="/pickabook/_browse/bookInfo.jsp?isbn=<%=x.getIsbn()%>"><img id="book-image" style="width:100px; height:145px;" src="<%=bookitem.get("image").toString().replace("type=m1", "")%>"></a>
         </div>
		<div class="ten wide column" style="padding-left:0px;">
            <div id="big-title" style="padding-top:5px; font-size: 16px;">
               <b>일본 아마존 베스트셀러!<br>&lt;<%= x.getBook_title() %>&gt;</b>
            </div>
            <div id="small-title" style="padding-top:1px; font-size: 14px;">
                  잊고있던 과거로부터<br>한 통의 편지가 도착했다.
            </div>
            <div class="main-stats" style="padding-top: 21px; font-size: 12px;">
                  최근 열흘간 <b><%= x.getCount() %>개</b>의<br><b>독후감</b>이 작성되었습니다.
            </div>
         </div>
      </div>   
   </div>
   <% } %>
   
	<!-- 책추천2 -->
   <%             
      PostDB ingPro = PostDB.getInstance();
      BookData z = null;
      z = ingPro.recommendBook2();

      if(z != null){  
            JSONObject bookitem = apiIsbn(z.getIsbn());
   %>
   <div class="div-border-style margin-bottom-one book-reco2" style="height:174px; padding">
   
      <div class="ui grid">
          <div class="six wide column">
            <a href="/pickabook/_browse/bookInfo.jsp?isbn=<%=z.getIsbn()%>"><img id="book-image" style="width:100px; height:145px;" src="<%=bookitem.get("image").toString().replace("type=m1", "")%>"></a>
         </div>
         <div class="ten wide column" style="padding-left:0px;">
            <div id="big-title" style="padding-top:5px; font-size: 16px;">
               <b>모두가 읽고싶어하는 책,<br>&lt;<%=bookitem.getString("title")%>&gt;</b>
            </div>
            <div id="small-title" style="padding-top:1px; font-size: 14px;">
                  오래된 잡화점에서 벌어지는<br>기묘하고 따뜻한 이야기
            </div>
            <div class="main-stats" style="padding-top: 21px; font-size: 12px;">
                  최근 7일간 <b><%= z.getCount() %>개</b>의<br><b>wish</b>로 선택되었습니다.
            </div>
         </div>
      </div>   
   </div>
   <% } %> 
   </div><!-- end of overlay -->
   
  </div><!-- end of six wide column -->	
</div><!-- end of grid -->
</div><!-- end of top container -->

<script src="/pickabook/assets/mypage.js"></script>
<script>

$(document).ready(function() {
	getPosts();
	$('.fcategory-tab.active').trigger('click');
	
	//무한 스크롤
    $(window).scroll(function() {
    	//alert($(window).scrollTop() + "==" +  $(document).height() + "-" + $(window).height());
        if ($(window).scrollTop() >= $(document).height() - $(window).height() - 5) {
			start += 3;
			getPosts(); 
        }
    });
	
    $('.overlay')
    .visibility({
      type   : 'fixed',
      offset : 90// give some space from top of screen
    });
});

/*getPosts()와 무한스크롤에서 사용하는 전역변수*/
var member_id = '<%=session_member%>';
var start = 0;
var end = 3;
var kind = 1;  //0인경우 post.jsp , 1인경우 main.jsp에서호출


/* 선호 카테고리 ajax */
 $(document).on('click','.fcategory-tab',function(){
	var selected = $(this);
	$('.fcategory-tab.active').removeClass('active');
	selected.addClass('active');    
	$.post('/pickabook/_main/userRank.jsp', {'category_num' : selected.attr('id')}).done(function(data){
		$('.ranker').html(data);
	});
});


</script>

</body>
</html>
