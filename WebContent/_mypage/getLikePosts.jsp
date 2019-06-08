<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
	request.setCharacterEncoding("UTF-8");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	String session_user = (String)session.getAttribute("user_id"); 
	String session_member = (String)session.getAttribute("member_id"); 
	String param = request.getParameter("param");	
	JSONObject paramjobj = new JSONObject(param); //받은 파라메터를 다시 -> json으로
	int start = paramjobj.getInt("start");
	int end = paramjobj.getInt("end");
	
	PostDB postPro = PostDB.getInstance();
	LikePostDB likepostPro = LikePostDB.getInstance();
	List<PostBrowseData> postLists = null;
	PostBrowseData postList = null;
	
	postLists = postPro.getPostListLike(session_member, start, end);
	int total_count = likepostPro.getLikePostCount(session_member);
	
	LikePostDB likePro = LikePostDB.getInstance();

%>				
<div class="innerSize">
	<!-- 상단 포스트개수표현 줄 -->
	<div class="ui text menu" style="margin-top: 0; margin-bottom: 1em;">
		<div class="header item">
			포스트 (<span style="color: #B70A15;"><%=total_count%></span>)
		</div>
	</div>
	
	<!-- 하단 내용 -->
    <div class="ui items">
       <div class="ui middle aligned divided list likepost-item-parent">
          <%
             if (postLists.size() == 0) {
          %>
             <div class="ui centered grid">                     
                <p><div class="ui tiny header">좋아요 누른 포스트가 없습니다.</div>                                 
             </div>
          <%
             } else {
                for (int i = 0; i < postLists.size(); i++) {
             	   postList = (PostBrowseData) postLists.get(i);
             	   JSONObject bookitem = apiIsbn(postList.getIsbn());
          %>
          
          <div class="item likepost-item">
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
                              			<div class="date"><%=sdf.format(postList.getPost_date())%></div>
                         				</div>		                                 		
                         			</div>		                                 		
                     			</div>
                  			</div>
            			</div>	                                    
            		</div>
          			
         			<!-- 하단 독후감 내용 영역 -->
         			<!-- content -->
         			<div class="eight wide column" style="height: 150px; margin-right: 0.7em; overflow: hidden;">
         				<p class="post-content limit-text"><%=postList.getContent()%></p>	                				
         			</div>        
         			        		
         			<!-- 별점, 태그, 좋아요수, 댓글 수 -->
         			<div class="two wide column" style="border-left: 1px solid #BDBDBD;">	                   				
         				<a href="/pickabook/_browse/bookInfo.jsp?isbn=<%= postList.getIsbn() %>">
         					<img src="<%=bookitem.getString("image").replace("type=m1", "")%>" style="margin-left: 0.4em; height: 130px; width: 90px;">
         				</a>
         			</div>
         			<div class="five wide column" style="height: 150px; margin-bottom: 1em;">
         				<!-- 제목, 작가 -->
         				<div style="margin-bottom: 0.7em; margin-left: 1em;">
         					<a class="likePage-book-title" style="font-size: 16px; font-weight: 600;" href="/pickabook/_browse/bookInfo.jsp?isbn=<%= postList.getIsbn() %>">
         						<%=postList.getBook_title() %>
         					</a>
         					<div class="smaller-font" style="margin-top: 0.7em;"><%=bookitem.getString("author")%></div>
         				</div>
         				<!-- 별점 -->
         				<div style="margin-bottom: 0.7em; margin-left: 1em;">
          					<div class="ui star rating likepage-post-star" data-rating="<%=postList.getStar_rate()%>" data-max-rating="5"></div>
         				</div>				
						<!-- 좋아요 수, 댓글 수 -->
						<div style="margin-left: 1em; margin-bottom: -0.5em;">
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
<div class="ui basic segment likepost-list-end" style="margin-top: 1em; text-align: center;">
<%if(start == 0 && total_count > end || start + end < total_count){
   		int remain_posts = end;
   		if(total_count - (start + end) < end){ //남은 댓글 개수 = 총 개수 - (여태보여준 거 + 지금 보여줄거) < end(더보기로 보여줄 기준)
   			remain_posts = total_count - (start + end); 
   		}%>
   		<a href="" class="likepost-more gray-font">
			포스트 <%=remain_posts %>개 더보기
			<div class="ui inline mini loader likepost-more-loader"></div>
		</a>	
<%	}
	else{%>
		<a class="ui grey empty circular label"></a>
<%	} %>
</div>	