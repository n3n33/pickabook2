<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.List"%>

<%

   String session_member = (String)session.getAttribute("member_id");
   String session_user = (String)session.getAttribute("user_id");   
   String param = request.getParameter("category_num");
   int category_num = Integer.parseInt(param);

   RankingDB rnkPro = RankingDB.getInstance();
   List<RankingData> rnkList = null;
   rnkList = rnkPro.getRnkList(category_num);
   
   MemberDB memPro = MemberDB.getInstance();
   FollowDB folPro = FollowDB.getInstance();
   
   if (rnkList == null) {
%>

<div class="ui basic segment">해당 카테고리의 포스트가 없습니다.</div>
<%
   } else {
%>
<div class="main-userrank-container" style="height:240px;">
<div class="ui four column grid" style="margin-bottom:150px;">
      <%
         int val = 0;
         if(rnkList.size() > 7) val = 7;
         else
            val = rnkList.size();
            for(int i=0 ; i < val; i++){
            RankingData ranking = rnkList.get(i);
            MemberData rankingInfo = memPro.getInfoMember(ranking.getUser_id());
      %>
   <div class="row">
      <div class="column" style="padding-left:2.5em;">
      <% if(i==0){%>
         <i class="fas fa-medal" style="color: orange;"></i>
      <% } else if(i==1) {%>   
         <i class="fas fa-medal" style="color: grey;"></i>
      <% } else if(i==2) { %>
         <i class="fas fa-medal" style="color: red;"></i>
         <% } else { %>
         <b><%= ranking.getReal_rank() %> 위</b>
         <% } %>
      </div>
         
      <div class="column" style="padding-left:3em;">
         <a class="main-user-rank-a" href="/pickabook/_mypage/post.jsp?user_id=<%=ranking.getUser_id()%>">
         <b><%=ranking.getUser_id() %></b></a>
      </div>
      
      <!-- 독후감 개수 count -->
      <div class="column" style="margin-left:6em;">
         <%= ranking.getCount() %> 개
      </div>
   </div>
   <% } %>
<% } %>
</div>
</div>
<div class="ui fitted divider" style="padding-top:5px;"></div>
<!-- 내 랭킹 -->
<%
   RankingDB mrnkPro = RankingDB.getInstance();
   List<RankingData> MyRnk = null;
   MyRnk = mrnkPro.getMyRanking(category_num, session_member);
   
   RankingDB mynullPro = RankingDB.getInstance();
   List<RankingData> rnkNull = null;
   rnkNull = mynullPro.getMyRankingNull(session_member, category_num);
   
   if (rnkNull == null) {
%>
<div class="ui basic segment" style="padding-top:0px;">
게시글을 작성해주세요.
</div>
<%
   } else {
%>
<div class="ui four column grid main-my-rank" style="padding-top:8px;">
   <%
      for(int j=0 ; j < MyRnk.size(); j++){
      RankingData ranking = MyRnk.get(j);
         
      if(session_user.equals(ranking.getUser_id())){
   %>
   <div class="row">
      <div class="column" style="padding-left:2.5em;">
      <% if(j==0){%>
         <i class="fas fa-medal" style="color: orange;"></i>
      <% } else if(j==1) {%>   
         <i class="fas fa-medal" style="color: grey;"></i>
      <% } else if(j==2) { %>
         <i class="fas fa-medal" style="color: red;"></i>
         <% } else { %>
         <b><%= ranking.getReal_rank() %> 위</b>
         <% } %>
      </div>
         
      <div class="column" style="padding-left:3em;">
         <a class="main-my-rank" href="/pickabook/_mypage/post.jsp?user_id=<%=ranking.getUser_id()%>">
         <b><%=ranking.getUser_id() %></b></a>
      </div>
      
      <!-- 독후감 개수 count -->
      <div class="column" style="margin-left:6em;">
         <%= ranking.getCount() %> 개
      </div>
   <% } else{
      out.println("<tr></tr>");
   }%>
   <% } %>
   </div>
<% } %>
</div>