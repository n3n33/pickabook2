<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
	request.setCharacterEncoding("UTF-8");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	int postnum = Integer.parseInt(request.getParameter("postnum"));
	String session_member = (String)session.getAttribute("member_id"); 
	String str = "";	
       
	// 게시글 뿌리기	
	MemberDB memPro = MemberDB.getInstance(); //include된 댓글 layout에서 쓰기땜에 필요
	PostDB postPro = PostDB.getInstance();
	PostListData post = null;
	post = postPro.getPost(postnum);
    
	if(post != null){ //사실 null일리는 없지만 그래도...
%>
		<%@ include file="/_layout/post_layout_inc.jsp" %>
<%	} 

%>