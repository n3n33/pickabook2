<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
	request.setCharacterEncoding("UTF-8");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String param = request.getParameter("param");	
	JSONObject paramjobj = new JSONObject(param); //받은 파라메터를 다시 -> json으로
	String member_id = paramjobj.getString("member_id");
	int start = paramjobj.getInt("start");
	int end = paramjobj.getInt("end");
	int kind = paramjobj.getInt("kind");
	String session_member = (String)session.getAttribute("member_id"); 
       
	// 게시글 뿌리기	
	MemberDB memPro = MemberDB.getInstance(); //include된 댓글 layout에서 쓰기땜에 필요
	PostDB postPro = PostDB.getInstance();
	List<PostListData> postlist = null;
	
	if(kind == 0) //post.jsp = 나의 피드
		postlist = postPro.getMyPosts(member_id, start, end);
	else if(kind == 1) //main.jsp = 전체 피드
		postlist = postPro.getPosts(member_id, start, end);
    
	if(postlist == null){%>
		<div class="ui icon message mypost-isnull" style="border-radius:0;">
		  <i class="icon pencil alternate"></i>
		  <div class="content">
	<%	if(member_id.equals(session_member)){%>
			<p>포스트를 작성해보시겠어요?</p>
	<%	}
		else {%>
			<p>작성한 포스트가 없습니다.</p>
	<%	}%>
		  </div>		  
		</div>
<%	}
	else{
		for(int i=0 ; i < postlist.size() ; i++){
			PostListData post = postlist.get(i); %>				
			<%@ include file="/_layout/post_layout_inc.jsp" %>
		<%}%>
<%	}%>
