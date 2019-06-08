<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
	request.setCharacterEncoding("UTF-8");
	String query = request.getParameter("query");
	String session_member = (String)session.getAttribute("member_id"); 	

	MemberDB memPro = MemberDB.getInstance();
%>
	<i class="close icon"></i>
	<div class="ui small header">사용자 검색 : <%=query%></div>
<%
	List<MemberData> memList = memPro.searchMembers(query);

    if(memList != null){
%>
	<div class="scrolling content" style="margin: 0em; padding: 0em; border:none;">
    	<%for(int i=0; i < memList.size(); i++) {
			MemberData member = memList.get(i);
			%>		
			
			<div class="ui grid mypage" id="<%=member.getMember_id()%>" style="margin: 0em; padding: 1em; border-bottom: 1px solid #d4d4d5;">
				<div class="eleven wide column" style="padding: 0 0 0 0.5em;">
					<a href="/pickabook/_mypage/post.jsp?user_id=<%=member.getUser_id()%>" class="ui left floated circular image" style="margin: 0 1.5em 0 0;">
						<img src="<%=member.getProfile_img()%>" class="mypost-profileimg">
					</a>
					<div style="padding-top: 5px;">
						<a href="/pickabook/_mypage/post.jsp?user_id=<%=member.getUser_id()%>">
							<h3 class="ui header"><%=member.getUser_id()%></h3>
						</a>
						<span class="smaller-font"><i class="sticky note outline icon"></i><%=memPro.getPostCount(member.getMember_id())%></span>
					</div>
				</div>				
				<div class="five wide column" style="padding: 0.5em 0.5em 0 0;">
					<%if(session_member.equals(member.getMember_id()) == false){
						if(memPro.checkFollow(member.getMember_id(), session_member) == 1){%>
							<button class="ui right floated red icon button following">팔로잉</button>
						<%}
						else{%>
							<button class="ui right floated white-border-btn icon button follow">팔로우</button>
						<%}%>
					<%}%>
				</div>
			</div>
			
		<%}%>
	</div>
	<%}%>