<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp"%>
<%
   request.setCharacterEncoding("UTF-8");
   String isbn = request.getParameter("isbn");
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

   int start = 0;
   int end = 10;

   String session_user = (String) session.getAttribute("user_id");
   String session_member = (String) session.getAttribute("member_id");
   
   PostDB postPro = PostDB.getInstance();
   List<PostBrowseData> postLists = null;
   PostBrowseData postList = null;
   
   postLists = postPro.getPostListInfo(isbn, start, end);
   
   TagDB tagPro = TagDB.getInstance();   
   LikePostDB likePro = LikePostDB.getInstance();
%>

<div style="background-color: #F6F6F6">
   <div class="ui container">
      <div style="padding-top: 2em; padding-bottom: 10em;">
         <div class="innerSize">
            <!-- 상단 포스트개수표현 줄 -->
            <div class="ui text menu" style="margin-top: 0; margin-bottom: 1em;">
               <div class="header item">
                  포스트 (<span style="color: #B70A15;"><%= postLists.size() %></span>)
               </div>
            </div>
            
            <!-- 하단 내용 -->
               <div class="ui items">
                  <div class="ui middle aligned divided list">
                     <%
                        if (postLists.size() == 0) {
                     %>
                        <div class="ui centered grid">                     
                           <p> 등록된 독후감이 없습니다.                                   
                        </div>
                     <%
                        } else {
                           for (int i = 0; i < postLists.size(); i++) {
                              postList = (PostBrowseData) postLists.get(i);
                     %>
                     
                     <div class="item">
                        <div style="margin-top: 1.5em; margin-bottom: 1.5em; margin-left: 2em; margin-right: 2em;">
                           <!-- 상단 프로필 영역 -->
                           <div class="ui centered grid">
                              <!-- 프로필, 글쓴 날짜 -->
                              <div class="sixteen wide column" style="margin-bottom: -1em;">
                                 <div class="ui large form">
                                       <div class="ui large feed">
                                          <div class="event">
                                          <div class="label">
                                          		<a href="/pickabook/_mypage/post.jsp?user_id=<%=postList.getUser_id()%>">                                          		
                                                	<img src="<%=postList.getProfile_img()%>">
                                          		</a>
                                             </div>
                                             <div class="content">
                                                <div class="summary">
                                                   <a class="user" href="/pickabook/_mypage/post.jsp?user_id=<%=postList.getUser_id()%>">
                                                         <%=postList.getUser_id()%>
                                                    </a>
                                                    <div class="date">
                                                        <%=sdf.format(postList.getPost_date())%>                                          
                                                     </div>
                                                </div>                                             
                                             </div>                                             
                                            </div>
                              </div>
                           </div>                                       
                              </div>
                              <!-- 하단 독후감 내용 영역 -->
                               <!-- content -->
                               <div class="eight wide column" style="height: 110px; margin-right: 0.7em;">
                                  <div class="post-content limit-text" style="margin-top: -0.5em;"><%=postList.getContent()%></div>
                               </div>
                               <!-- 별점, 태그, 좋아요수, 댓글 수 -->
                               <div class="seven wide column" style="height: 110px; border-left: 1px solid #BDBDBD;">
                                  <!-- 별점 -->
                                  <div style="margin-bottom: 0.7em; margin-left: 1em;">
                                  	<div class="ui star rating bookinfo-post-star" data-rating="<%=postList.getStar_rate()%>" data-max-rating="5"></div>
                                  </div>
                           <!-- 태그 -->
                           <div style="margin-bottom: 0.7em; margin-left: 0.7em;">
                              <%
                                 List<TagData> tagLists = tagPro.getTaggedTag(postList.getPost_num());
                                 if (tagLists != null) {      
                                    for (int j=0; j<tagLists.size(); j++) {
                                       TagData tagList = tagLists.get(j);
                                 %>
                                    <div class="ui basic label" style="margin-bottom: 0.5em;">
                                       <i class="hashtag small icon"></i><%=tagList.getName()%>
                                    </div>
                                 <%
                                    }
                                 } else {
                              %> 
                                 <span>선택된 태그가 없습니다.</span>
                              <%
                                 }
                              %>
                           </div>
                           <!-- 좋아요 수, 댓글 수 -->
                           <div style="margin-left: 0.7em; margin-bottom: -0.5em;">
                              <i class="heart filled red icon"></i>
                              <span class="likecount" style="margin-right: 0.5em; font-size: 15px;"><%= postPro.getLikeCount(postList.getPost_num()) %></span>
                              <i class="comment filled icon"></i> 
                              <span class="commentcount" style="margin-right: 0.5em; font-size: 15px;"><%= postPro.getCommentCount(postList.getPost_num()) %></span>
                           </div>
                               </div>
                            </div>                            
                        </div>
                     </div>
                     <%
                           }
                        }
                     %>

               </div>
               </div>
         </div> <!-- innerSize 끝 태그 -->
      </div>
   </div>
</div>

<script>
$('.limit-text').each(function(){
      var length = 100; // 표시할 글자 수 정하기
      //전체 옵션을 자를 경우
      $(this).each(function(){
         if($(this).text().length >= length){
         $(this).text($(this).text().substr(0,length)+'...');
         }
      });
});
   
$('.bookinfo-post-star').rating('refresh');
$('.bookinfo-post-star').rating('disable'); //별 수정 못하도록

</script>