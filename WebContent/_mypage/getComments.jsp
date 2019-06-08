<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
	request.setCharacterEncoding("UTF-8");
	int postnum = Integer.parseInt(request.getParameter("postnum"));
	int start = Integer.parseInt(request.getParameter("start"));
	int end = Integer.parseInt(request.getParameter("end"));
	String session_member = (String)session.getAttribute("member_id"); 
       
	MemberDB memPro = MemberDB.getInstance();
	PostDB postPro = PostDB.getInstance();
	CommentDB comPro = CommentDB.getInstance();
	List<CommentData> commentList = comPro.getComments(postnum, start, end);		

	if(commentList != null){
		int comment_totalcount = postPro.getCommentCount(postnum);
 	   	if(start == 0 && comment_totalcount > 2 || start + end < comment_totalcount){
  	   		int remain_com = end;
  	   		if(comment_totalcount - (start + end) < end){ //남은 댓글 개수 = 총 개수 - (여태보여준 거 + 지금 보여줄거) < end(더보기로 보여줄 기준)
  	   			remain_com = comment_totalcount - (start + end); 
  	   		}%>
			<a href="" class="comment-more gray-font">
				댓글 <%=remain_com %>개 더보기
				<div class="ui inline mini loader comment-more-loader"></div>
			</a>			
	<%	}
   	   	for(int j = commentList.size(); j > 0; j--){
   	   		CommentData comment = commentList.get(j-1);%>   
			<%@ include file="/_layout/comment_layout_inc.jsp" %>
<% 		}%>
<%
   	}
%>