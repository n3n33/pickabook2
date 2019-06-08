<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ include file="/_api/apiInclude.jsp" %> 
<%
	request.setCharacterEncoding("UTF-8");
	String session_member = (String)session.getAttribute("member_id");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String param = request.getParameter("postnum");
	int post_num = Integer.parseInt(param);
	
	MemberDB memPro = MemberDB.getInstance();  
	MemberData member = memPro.getInfoMember(session_member);//페이지 주인의 정보 가져오기
       
	// 게시글 뿌리기
	PostDB postPro = PostDB.getInstance();
	PostListData post = null;
	post = postPro.getPost(post_num);
 
%>
<i class="close icon"></i>
<div class="header" style="overflow: auto; padding: 0.6em;">
	<a href="/pickabook/_mypage/post.jsp?user_id=<%=post.getUser_id()%>">
		<img src="<%=post.getProfile_img()%>" class="ui left floated circular middle algined mini image">
	</a>
	<div style="margin-top: 3px;">
		<a href="/pickabook/_mypage/post.jsp?user_id=<%=post.getUser_id()%>" class="postmore-header"><%=post.getUser_id()%></a>	
   	</div> 	
</div>
	
<div class="scrolling content" id="post-more" style="padding: 0;">		  
<%
  String postContent = post.getContent();
  postContent = postContent.replaceAll("\n", "<br>");
  postContent = postContent.replaceAll("\u0020", "&nbsp;");
%>
  <div class="ui divided grid postmore mypost" id="<%=post.getPost_num()%>" style="margin: 0 0 0 0;">
	<div class="ten wide column">
		<div class="postmore-section1">		
   			<p class="postmore-content"><%=postContent%></p>
		</div>	
	</div><!-- end of ten col -->

	<div class="six wide column"> 

<%
	PostBookData postbook = new PostBookData();
	postbook = postPro.getPostBook(post.getPost_num());	
    if(postbook !=  null){ //게시글이 독후감	   
    	
    	JSONObject bookitem = apiIsbn(postbook.getIsbn());%>
    	<div class="postmore-booksection">
    		<a class="ui left floated image" style="margin: 0 0.5em 0 0;" href="/pickabook/_browse/bookInfo.jsp?isbn=<%=postbook.getIsbn()%>">    		
    		  <img src="<%=bookitem.get("image").toString().replace("type=m1", "")%>" style="height:100px; max-width: 75px; border: 1px solid #EAEAEA">
    		</a>
			<div style="margin-top: 1em; line-height: 2.7;">
			  <a href="/pickabook/_browse/bookInfo.jsp?isbn=<%=postbook.getIsbn()%>">
			  	<h4 class="ui header postmore-book-title"><%=postbook.getBook_title()%></h4>
			  </a>
			  <div class="smaller-font"><%=bookitem.get("author")%></div>
			  <div class="ui huge star rating mypost-star" data-rating="<%=postbook.getStar_rate()%>" data-max-rating="5"></div>
			</div>
		</div>
		<%
			TagDB tagPro = TagDB.getInstance();
			List<TagData> tagList = tagPro.getTaggedTag(post.getPost_num());
			if(tagList != null){
				for(int j=0; j<tagList.size(); j++){
					TagData tag = tagList.get(j);%>
					<div class="ui basic label" style="margin-bottom: 0.5em;"><i class="hashtag small icon"></i><%=tag.getName()%></div>
					<%
				}%>
		<%	} %>
		<div class="ui divider"></div> 	
		
	<%}%>

   	
		<!-- 부수 정보 -->
	   	<div class="margin-bottom-one" style="line-height: 2;">   	
		   	<%LikePostDB likePro = LikePostDB.getInstance();
		   	if(likePro.checkLike(session_member, post.getPost_num()) == 1){%>
		   		<i class="heart filled red link large icon"></i>
		   	<%}
		   	else{%>
		   		<i class="heart outline red link large icon"></i>
		   	<%}%>
		   	<span class="likecount" style="margin-right: 1rem; font-size: 15px;"><%=post.getLikecount()%></span>		   	
		   	<i class="comment outline large icon"></i>		
		   	<span class="commentcount" style="margin-right: 1rem; font-size: 15px;"><%=post.getCommentcount()%></span>
		   	
		   	<div class="smaller-font">
		   		<%=sdf.format(post.getPost_date())%>
		   	</div>	   			   	
	   	</div>
	   	
	   	<!-- 댓글 -->
	   	<div class="ui fluid input">
			<input type="text" placeholder="댓글달기..." name="comment-ta">
		</div>
		
		<!-- 댓글 목록 -->
	   	<div class="mypost-comment-list">
	    <%	int com_start = 0, com_end = 5, more_end = 5; //댓글 첨 가져오는 거니까 start, end를 0,5로 고정, more_end는 더보기로 가져올 개수
	    	CommentDB comPro = CommentDB.getInstance();
	    	List<CommentData> commentList = comPro.getComments(post.getPost_num(), com_start, com_end);
	    	if(commentList != null){
	   	   		int comment_totalcount = postPro.getCommentCount(post.getPost_num());
	   	   		if(comment_totalcount > com_end){ //여기선 getComments.jsp랑 다르게 이 조건만 넣으면됨
	   	  	   		int remain_com = more_end;
	   	  	   		if(comment_totalcount - (com_start + com_end) < more_end){ //남은 댓글 개수 < more_end(더보기로 보여줄 기준)
	   	  	   			remain_com = comment_totalcount - (com_start + com_end); //남은 댓글 개수 = 총 개수 - (여태보여준 거 + 지금 보여줄거)
	   	  	   		}%>
					<a href="" class="comment-more gray-font">
						댓글 <%=remain_com %>개 더보기
					</a>
					
			<%	}
	    		for(int j = commentList.size(); j > 0; j--){
	   	   		CommentData comment = commentList.get(j-1);  %>    	   		
				<%@ include file="/_layout/comment_layout_inc.jsp" %>
			<%}%>
		<%}%>
	   	</div>  
	   	
   	</div><!-- end of six col -->	
  </div><!-- end of grid -->
</div><!-- scrolling content -->