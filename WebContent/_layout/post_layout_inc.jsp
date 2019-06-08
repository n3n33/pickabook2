<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

		<div class="mypost mypost-style" id="<%=post.getPost_num()%>">
			<div class="mypost-section1">
	    	
	    	<!-- 게시글 초반 -->
	    	<div class="ui grid">
	    	<div class="fourteen wide column">
			<a href="/pickabook/_mypage/post.jsp?user_id=<%=post.getUser_id()%>">
			<img src="<%= post.getProfile_img()%>" class="ui left floated circular middle algined image mypost-profileimg">
			</a>
			<div style="padding-top: 4px;">
			<a href="/pickabook/_mypage/post.jsp?user_id=<%=post.getUser_id()%>" class="ui header"><%=post.getUser_id()%></a>	
	    	</div>
			<span class="smaller-font"><%=sdf.format(post.getPost_date())%></span>
	    	</div>    	
	    	<div class="two wide column" style="text-align: right; padding-top: 25px;">	    	
	    	<%if(post.getMember_id().equals(session_member)){%>
		    	<div class="ui pointing top right dropdown mypost-dropdown">
			    	<i class="ellipsis vertical link icon"></i>
			    	<div class="menu">
			    	<div class="item"><span class="edit-btn">수정</span></div>
			    	<div class="item"><span class="delete-btn">삭제</span></div>
			    	</div>
		    	</div>
	    	<%} %>
	    	</div>
	    	</div>
			</div>
			
<%
	    	PostBookData postbook = new PostBookData();
	    	postbook = postPro.getPostBook(post.getPost_num());	   
		   	if(postbook != null){//게시글이 독후감		

		   		
				JSONObject bookitem = apiIsbn(postbook.getIsbn());%>		    	

		    	<div class="mypost-booksection">
			    	<a class="ui tiny left floated image" style="margin: 0.5em 2.5em 0.5em 1.5em;" href="/pickabook/_browse/bookInfo.jsp?isbn=<%=postbook.getIsbn()%>">
			    		<img src="<%=bookitem.get("image").toString().replace("type=m1", "")%>" class="book-img-border">
			    	</a> 
			    	<div style="margin-top: 1.2em; line-height: 2;">
						<a class="ui header post-book-title" href="/pickabook/_browse/bookInfo.jsp?isbn=<%=postbook.getIsbn()%>">
							<%=bookitem.get("title")%>
						</a>
						<div class="smaller-font"><%=bookitem.get("author")%></div>
						<div class="ui massive star rating mypost-star" data-rating="<%=postbook.getStar_rate()%>" data-max-rating="5" style="margin-top: 0.5em;"></div>
					</div>
				</div>
		   <%}%>	
			
			<%
			  String postContent = post.getContent();
			  postContent = postContent.replaceAll("\n", "<br>");
			  postContent = postContent.replaceAll("\u0020", "&nbsp;");
			%>
			<div class="mypost-section2">
				<p class="post-content" style="margin: 0.5em 0.5em 1em 0.5em;"><%=postContent%></p>	
				<%TagDB tagPro = TagDB.getInstance();
				List<TagData> tagList = tagPro.getTaggedTag(post.getPost_num());
				if(tagList != null){%>
					<div class="ui labels">
					<%for(int j=0; j<tagList.size(); j++){
						TagData tag = tagList.get(j);%>
						<div class="ui basic label"><i class="hashtag small icon"></i><%=tag.getName()%></div>
					<%}%>		
					</div>
				<%}%>
								 	
			</div>
		   			   
	    	<div class="ui fitted divider"></div>	
	    	 
	    	<div class="mypost-section3">	
	    		<div style="padding-left: 0.5em;">
			    	<%LikePostDB likePro = LikePostDB.getInstance();
			    	if(likePro.checkLike(session_member, post.getPost_num()) == 1){%>
			    		<i class="heart filled red link icon"></i>
			    	<%}
			    	else{ %>
			    		<i class="heart outline red link icon"></i>
			    	<%} %>
			    	<span class="likecount" style="margin-right: 0.5em; font-size: 15px;"><%=post.getLikecount()%></span>
			    	<i class="comment outline icon"></i>
			    	<span class="commentcount" style="margin-right: 0.5em; font-size: 15px;"><%=post.getCommentcount()%></span>
		    	</div>
		    	
		    	<!-- 댓글 -->
		    	
		    	<div style="padding-left: 1em; margin-top: 0.7em;">
				   	<div class="mypost-comment-list" style="min-height: 25px;">
				    <%	int com_start = 0, com_end = 2, more_end = 5; //댓글 첨 가져오는 거니까 start, end를 0,2로 고정, more_end는 더보기로 가져올 개수
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
									<div class="ui inline mini loader comment-more-loader"></div>
								</a>
								
						<%	}
				    		for(int j = commentList.size(); j > 0; j--){
				   	   		CommentData comment = commentList.get(j-1);  %>    	   		
							<%@ include file="/_layout/comment_layout_inc.jsp" %>
						<%}%>
					<%}%>
				   	</div> 
			   	</div>
			   	
			   	<div class="ui divider"></div>
			   	<div class="ui transparent fluid input" style="padding-left: 1em;">			   		
					<input type="text" placeholder="댓글달기..." name="comment-ta">
				</div>
	    	</div>
		</div>