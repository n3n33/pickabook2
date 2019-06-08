<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 <%
   request.setCharacterEncoding("UTF-8");
   String member_id = request.getParameter("member_id");
   String kind = request.getParameter("kind");
   String session_member = (String)session.getAttribute("member_id");       
   MemberDB memPro = MemberDB.getInstance();
   FollowDB folPro = FollowDB.getInstance();
   List<FollowData> followList = null;
%>
   <i class="close icon"></i>
   <div class="ui small header"><%=kind%> 목록</div>
<%
   if(kind.equals("팔로워")){
      followList = folPro.selectFollower(member_id);
   }
   else if(kind.equals("팔로잉")){
      followList = folPro.selectFollowing(member_id);
   }

    if(followList == null){%>
       <div class="ui sub header"><%=kind%> 없습니다. </div>       
<%  }
    else{ 
%>
   <div class="scrolling content" style="margin: 0em; padding: 0em; border:none;">
       <%for(int i=0; i < followList.size(); i++) {
         FollowData follow = followList.get(i);
         MemberData followInfo = null;
         if(kind.equals("팔로워")){
            followInfo = memPro.getInfoMember(follow.getFollower_id());
         }
         else if(kind.equals("팔로잉")){
            followInfo = memPro.getInfoMember(follow.getMember_id());
         }%>      
         
         <div class="ui grid mypage" id="<%=followInfo.getMember_id()%>" style="margin: 0em; padding: 1em; border-bottom: 1px solid #d4d4d5;">
            <div class="eleven wide column" style="padding: 0 0 0 0.5em;">
               <a href="/pickabook/_mypage/post.jsp?user_id=<%=followInfo.getUser_id()%>" class="ui left floated circular image" style="margin: 0 1.5em 0 0;">
                  <img src="<%=followInfo.getProfile_img()%>" class="mypost-profileimg">
               </a>
               <div style="padding-top: 5px;">
                  <a href="/pickabook/_mypage/post.jsp?user_id=<%=followInfo.getUser_id()%>">
                     <h3 class="ui header"><%=followInfo.getUser_id()%></h3>
                  </a>
                  <span class="smaller-font"><i class="sticky note outline icon"></i><%=memPro.getPostCount(followInfo.getMember_id())%></span>
               </div>
            </div>            
            <div class="five wide column" style="padding: 0.5em 0.5em 0 0;">
               <%if(session_member.equals(followInfo.getMember_id()) == false){
                  if(memPro.checkFollow(followInfo.getMember_id(), session_member) == 1){%>
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