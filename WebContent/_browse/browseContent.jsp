<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %> 
<%
   request.setCharacterEncoding("UTF-8");
   int hashtagNum = Integer.parseInt(request.getParameter("tag_num"));
   int start = Integer.parseInt(request.getParameter("start"));
   int end = Integer.parseInt(request.getParameter("end"));
   
   String session_user = (String) session.getAttribute("user_id");
   String session_member = (String) session.getAttribute("member_id");
   
   PostDB postPro = PostDB.getInstance();
   List<PostBrowseData> postBrowseLists = null;
   PostBrowseData postBrowseList = null;   
   postBrowseLists = postPro.likeCountBrowse(hashtagNum, start, end, session_member);
   

   if(postBrowseLists.size() != 0){
      for(int i = 0; i < postBrowseLists.size(); i++) {
         postBrowseList = postBrowseLists.get(i);   
         JSONObject bookitem = apiIsbn(postBrowseList.getIsbn()); %>
         <div class="card" id="<%=postBrowseList.getPost_num()%>" style="width:220px;">
            <div class="blurring dimmable image">
               <div class="ui dimmer">
                  <div class="left aligned content" id="dimmerDiv">
                  <div style="margin-bottom:0.5em;">
                     <span class="ui header" style="font-size: 16px; font-weight: bold; color: #FFF; margin-top:2px;"><%=postBrowseList.getBook_title()%></span>
                  </div>
                  <div>
                     <span class="limit-text" style="font-size: 14px; font-weight: 300; color:#FFF; margin-top:3px; line-height: 160%;"><%=postBrowseList.getContent()%></span>
                  </div>
                  <div style="margin-top: 0.5em;">
                     <a class="ui inverted basic button browse-showpost-btn" href="">포스트</a>
                     <a class="ui button" href="/pickabook/_browse/bookInfo.jsp?isbn=<%=postBrowseList.getIsbn()%>">책정보</a>
                  </div>
               </div>
            </div>
            <img style="height: 321.34px;" src="<%=bookitem.get("image").toString().replace("type=m1", "")%>">
         </div>
         <div class="extra content">
               <div class="left floated author">
                  <a class="limit-text" href="/pickabook/_mypage/post.jsp?user_id=<%=postBrowseList.getUser_id()%>" style="font-size: 14px;">
                     <img class="ui avatar image" src="<%=postBrowseList.getProfile_img()%>"><%=postBrowseList.getUser_id()%>
                  </a>
               </div>
            </div>
         </div>         
<%
      }
   }
%>            