<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %> 

<%
   request.setCharacterEncoding("UTF-8");
   String isbn = request.getParameter("isbn");
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   MemberDB memPro = MemberDB.getInstance();

   String session_user = (String) session.getAttribute("user_id");
   String session_member = (String) session.getAttribute("member_id");
   
   if(session_member==null) {
      session_member = "nolog";
   }

   MemberData member = memPro.getInfoMember(session_member);
%>


   <%
      List<MemberData> memberLists = null;
      MemberData memberList = null;
      int selectBtn;
      MemberDB memberProcess = MemberDB.getInstance();

      List<ReviewData> reviewLists = null;
      ReviewData reviewList = null;
      ReviewDB reviewProcess = ReviewDB.getInstance();
      reviewLists = reviewProcess.getReviewList(isbn);
      
      JSONObject bookitem = apiIsbn(isbn); //도서 api가져오기 
   %>

   <div style="background-color: #F6F6F6">
      <div class="ui container">
         <div style="padding-top: 2em; padding-bottom: 10em;">
            <div class="innerSize">
               <div class="ui centered grid"
                  style="margin-top: 3em; margin-bottom: -2px;">
                  <h3>B O O K &nbsp; I N F O</h3>
               </div>
               <div class="ui centered grid">
                  <span
                     style="font-size: 14px; color: #666; font-weight: bold; font-family: 'Noto Sans DemiLight', 'Malgun Gothic';">책정보</span>
               </div>
               <p class="bookText" id="book-desc" style="line-height: 160%;"><%=bookitem.getString("description") %></p>
               
               <!-- 읽고파 등록인 -->

               <div class="wishBookDiv">
                  <div class="ui centered grid"
                     style="margin-top: 8em; margin-bottom: -2px;">
                     <h3>P E O P L E</h3>
                  </div>

                  <%
                     memberLists = memberProcess.bookPeople(isbn, "wish");
                  %>
                  <div class="ui centered grid">
                     <span
                        style="font-size: 14px; color: #666; font-weight: bold; font-family: 'Noto Sans DemiLight', 'Malgun Gothic'">
                        <%=memberLists.size()%>명
                     </span>
                  </div>
                  <div class="ui centered grid" style="height: 175px;">
                     <div class="ui horizontal list">
                        <%
                           if (memberLists.size() == 0) {
                        %>
                        <div style="height: 175px;">
                           <p
                              style="font-size: 14px; font-weight: bold; line-height: 175px;"> WISH
                              등록인이 없습니다.
                        </div>
                        <%
                           }

                           else {

                              for (int i = 0; i < memberLists.size(); i++) {
                                 memberList = (MemberData) memberLists.get(i);
                        %>
                        <div class="item">
                           <a
                              href="/pickabook/_mypage/post.jsp?user_id=<%=memberList.getUser_id()%>">
                              <img class="ui circular image" width="120" height="120"
                              src="<%=memberList.getProfile_img()%>">
                           </a>
                           <div class="ui sub centered header"
                              style="margin-top: 2em; font-size: 14px;">
                              <a><%=memberList.getUser_id()%></a>
                           </div>
                        </div>
                        <%
                           }
                           }
                        %>
                     </div>
                  </div>
               </div>

               <!-- 읽는중 등록인 -->
               <div class="ingBookDiv">
                  <div class="ui centered grid"
                     style="margin-top: 8em; margin-bottom: -2px;">
                     <h3>P E O P L E</h3>
                  </div>
                  <%
                     selectBtn = 0;
                     memberLists = memberProcess.bookPeople(isbn, "ing");
                  %>
                  <div class="ui centered grid">
                     <span
                        style="font-size: 14px; color: #666; font-weight: bold; font-family: 'Noto Sans DemiLight', 'Malgun Gothic'">
                        <%=memberLists.size()%>명
                     </span>
                  </div>
                  <div class="ui centered grid" style="height: 175px;">
                     <div class="ui horizontal list">
                        <%
                           if (memberLists.size() == 0) {
                        %>
                        <div style="height: 175px;">
                           <p
                              style="font-size: 14px; font-weight: bold; line-height: 175px;"> ING
                              등록인이 없습니다.
                        </div>
                        <%
                           }

                           else {

                              for (int i = 0; i < memberLists.size(); i++) {
                                 memberList = (MemberData) memberLists.get(i);
                        %>
                        <div class="item">
                           <a
                              href="/pickabook/_mypage/post.jsp?user_id=<%=memberList.getUser_id()%>">
                              <img class="ui circular image" width="120" height="120"
                              src="<%=memberList.getProfile_img()%>">
                           </a>
                           <div class="ui sub centered header"
                              style="margin-top: 2em; font-size: 14px;">
                              <a><%=memberList.getUser_id()%></a>
                           </div>
                        </div>

                        <%
                           }
                           }
                        %>

                     </div>
                  </div>
               </div>

               <!-- 읽었음 등록인 -->
               <div class="readBookDiv">
                  <div class="ui centered grid"
                     style="margin-top: 8em; margin-bottom: -2px;">
                     <h3>P E O P L E</h3>
                  </div>

                  <%
                     selectBtn = 1;
                     memberLists = memberProcess.bookPeople(isbn, "read");
                  %>
                  <div class="ui centered grid">
                     <span
                        style="font-size: 14px; color: #666; font-weight: bold; font-family: 'Noto Sans DemiLight', 'Malgun Gothic'">
                        <%=memberLists.size()%>명
                     </span>
                  </div>
                  <div class="ui centered grid" style="height: 175px;">
                     <div class="ui horizontal list">
                        <%
                           if (memberLists.size() == 0) {
                        %>
                        <div style="height: 175px;">
                           <p
                              style="font-size: 14px; font-weight: bold; line-height: 175px;"> READ
                              등록인이 없습니다.
                        </div>
                        <%
                           }

                           else {

                              for (int i = 0; i < memberLists.size(); i++) {
                                 memberList = (MemberData) memberLists.get(i);
                        %>
                                 <div class="item">
                                    <a
                                       href="/pickabook/_mypage/post.jsp?user_id=<%=memberList.getUser_id()%>">
                                       <img class="ui circular image" width="120" height="120"
                                       src="<%=memberList.getProfile_img()%>">
                                    </a>
                                    <div class="ui sub centered header"
                                       style="margin-top: 2em; font-size: 14px;">
                                       <a><%=memberList.getUser_id()%></a>
                                    </div>
                                 </div>
                        <%
                              }
                           }
                        %>

                     </div>
                  </div>
               </div>

               <div class="ui centered grid">
                  <div class="ui horizontal list">
                     <button class="ui button btnNo btnAct" id="wishBook">WISH</button>
                     <button class="ui button btnNo" id="ingBook">ING</button>
                     <button class="ui button btnNo" id="readBook">READ</button>                  
                  </div>
               </div>
               
               <!-- 추천해주는 부분 -->
               <div class="ui centered grid"
                  style="margin-top: 8em; margin-bottom: -2px;">
                  <h3>S A M E &nbsp; A U T H O R</h3>
               </div>
               <div class="ui centered grid">
                  <span
                     style="font-size: 14px; color: #666; font-weight: bold; font-family: 'Noto Sans DemiLight', 'Malgun Gothic'">
                     <%=bookitem.getString("author")%>
                      </span>
               </div>
               <div class="ui centered grid">
                  <div class="ui horizontal list">
                     <%
                  JSONObject jobj2 = apiAuthor(bookitem.getString("author"));
                        JSONArray jArr2 = new JSONArray(jobj2.getJSONArray("item").toString());
                        for (int i = 0; i < jArr2.length(); i++) {
                           JSONObject authorObj = jArr2.getJSONObject(i);
                           String authorIsbn = authorObj.getString("isbn");
                           if(authorIsbn.length() > 13){
                              authorIsbn = authorIsbn.split(" ")[1];
                           }
                     %>
                     <div class="item">
                        <a href="/pickabook/_browse/bookInfo.jsp?isbn=<%=authorIsbn%>">
                           <img src="<%=authorObj.getString("image").replace("type=m1", "") %>" style="width:160px; height:230px;">
                        </a>
                     </div>
                     <%
                        }
                     %>
                  </div>
               </div>
               
               <div class="ui centered grid"
                  style="margin-top: 8em; margin-bottom: -2px;">
                  <h3>S A M E &nbsp; P U B L I S H E R </h3>
               </div>
               <div class="ui centered grid">
                  <span
                     style="font-size: 14px; color: #666; font-weight: bold; font-family: 'Noto Sans DemiLight', 'Malgun Gothic'">
                     <%=bookitem.getString("publisher")%>
                      </span>
               </div>
               <div class="ui centered grid">
                  <div class="ui horizontal list">
                     <%
                  JSONObject jobj3 = apiPublisher(bookitem.getString("publisher"));
                        JSONArray jArr3 = new JSONArray(jobj3.getJSONArray("item").toString());
                        for (int i = 0; i < jArr3.length(); i++) {
                           JSONObject pubObj = jArr3.getJSONObject(i);
                           String pubIsbn = pubObj.getString("isbn");
                           if(pubIsbn.length() > 13){
                              pubIsbn = pubIsbn.split(" ")[1];
                           }
                     %>
                     <div class="item">
                        <a href="/pickabook/_browse/bookInfo.jsp?isbn=<%=pubIsbn%>">
                           <img src="<%=pubObj.getString("image").replace("type=m1", "") %>" style="width:160px; height:230px;">
                        </a>
                     </div>
                     <%
                        }
                     %>
                  </div>
               </div>

               <!-- 한줄평 -->
               <div class="ui centered grid" style="margin-top: 8em; margin-bottom: -2px;">
                  <h3>C O M M E N T</h3>
               </div>
               <div class="ui centered grid">
                  <span style="font-size: 14px; color: #666; font-weight: bold; font-family: 'Noto Sans DemiLight', 'Malgun Gothic';">한줄평</span>
               </div>               
               <div class="ui items" style="margin-top: -1em; margin-left: 10em; margin-right: 10em; padding-left: 5em; padding-right: 5em;">
                  <div class="ui celled list">
                     <%
                        if (session_member != "nolog") {
                     %>                     
                     <div class="item" style="padding-top: 2em; padding-bottom: 2em;">   
                        <form class="ui large form" method="post" action="/pickabook/_pro/reviewPro.jsp">                     
                           <div class="ui large feed">
                              <div class="event">
                                 <div class="label">
                                    <img src="<%=member.getProfile_img()%>">
                                    <!-- 사용자 본인 이미지 들어가게 바꾸기 -->
                                 </div>
                                 <div class="content">
                                    <div class="extra text">
                                       <div class="field">
                                          <textarea class="textareaD" rows="3" name="content" placeholder="이 책에 대한 한줄평을 입력해보세요."></textarea>
                                          <input type="hidden" name="isbn" value="<%=isbn%>">
                                          <input type="hidden" name="member_id" value="<%=session_member%>">
                                       </div>
                                       <button class="ui right floated basic submit button" style="background-color:#B70A15;">등록</button>
                                    </div>
                                 </div>
                              </div>
                           </div>   
                        </form>                     
                     </div>   
                     
                     <%
                        } else {
                     %>
                           <div class="ui large form">
                              <div class="item" style="padding-top: 2em; padding-bottom: 2em;">
                                 <div class="ui large feed">
                                    <div class="event">
                                       <div class="label">
                                          <img src="/pickabook/image/nan.jpg">
                                       </div>
                                       <div class="content">
                                          <div class="extra text">
                                             <div class="disabled field">
                                                <textarea class="textareaD" rows="3">로그인 후 이용하세요.</textarea>
                                             </div>
                                             <a class="ui right floated basic submit button" href="/pickabook/_logon/loginForm.jsp">로그인</a>
                                          </div>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <%
                              }
                     
                        if (reviewLists.size() == 0) {
                     %>
                        <div class="ui centered grid">                     
                           <p>   등록된 한줄평이 없습니다.                                       
                        </div>
                     <%
                        } else {

                           for (int i = 0; i < reviewLists.size(); i++) {
                              reviewList = (ReviewData) reviewLists.get(i);
                     %>

                     <div class="item" style="padding-top: 2em; padding-bottom: 2em;" id="<%= reviewList.getReview_num() %>">
                        <div class="ui large form">
                           <div class="ui large feed">
                              <div class="event">
                                 <div class="label">
                                    <img src="<%=reviewList.getProfile_img()%>">
                                 </div>
                                 
                                 <!-- 수정버튼을 누르면 이곳 내용이 변경됨 -->                                 
                                 <div class="content">
                                    <div id="changeForm_<%= reviewList.getReview_num() %>">
                                       <div class="summary">
                                          <a class="user"
                                             href="/pickabook/_mypage/post.jsp?user_id=<%=reviewList.getUser_id()%>">
                                             <%=reviewList.getUser_id()%>
                                          </a>
                                          <div class="date">
                                             <%=sdf.format(reviewList.getReview_date())%>                                          
                                          </div>
                                          <% if (session_member.equals(reviewList.getMember_id())) { %>                           
                                             <div class="right floated top aligned content" style="font-size: 12px; color: #707070;">
                                                <a class="correctBtn" style="font-size: 12px; color: #707070;">수정</a> | 
                                                <a class="deleteBtn" style="font-size: 12px; color: #707070;">삭제</a>   
                                             </div>
                                          <% } %>
                                       </div>
                                       <div class="extra text" id="txt_<%= reviewList.getReview_num() %>" style="margin-top: 1em;">
                                          <%=reviewList.getContent()%>
                                       </div>                                                                              
                                    </div>   
                                    <div id="correctForm_<%= reviewList.getReview_num() %>">   
                                    
                                    </div>                                 
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
               
            </div>
         </div>
      </div>
   </div>

   
   <!-- bookContent.jsp 에 적용 -->
<script>
$(document).ready(function(){  
	   //읽는중, 읽었음 부분은 가리기
	   $(".ingBookDiv").hide();
	   $(".readBookDiv").hide();
	  
	   //읽고파 버튼
	   $("#wishBook").click(function(){
	      $('#ingBook').removeClass('btnAct');
	      $('#readBook').removeClass('btnAct');
	       $(this).addClass('btnAct');
	       
	      $(".wishBookDiv").show();
	      $(".ingBookDiv").hide();
	      $(".readBookDiv").hide();
	   });

	   //읽는중 버튼
	   $("#ingBook").click(function(){
	      $('#wishBook').removeClass('btnAct');
	      $('#readBook').removeClass('btnAct');
	       $(this).addClass('btnAct');
	       
	      $(".wishBookDiv").hide();
	      $(".ingBookDiv").show();
	      $(".readBookDiv").hide();
	   });
	  
	   //읽었음 버튼
	   $("#readBook").click(function(){
	      $('#wishBook').removeClass('btnAct');
	      $('#ingBook').removeClass('btnAct');
	       $(this).addClass('btnAct');
	       
	      $(".wishBookDiv").hide();
	      $(".ingBookDiv").hide();
	      $(".readBookDiv").show();
	   });
   
   $(".correctBtn").click(function(){   //수정버튼을 누르면.. #changeForm 부분의 내용을 다 바꾸기
      var review_num = $(this).closest('div.item').attr("id");
      var content = $.trim($("#txt_" + review_num).html());
   
      var htmlString;
       
      htmlString = "<div id='correctFrom'> <div class='extra text'> <div class='field'> <textarea class='textareaD' id='editComment' name='content' rows='3'>"+content+"</textarea> </div> ";
      htmlString += "<button class='ui right floated basic submit button' id='updateBtn' style='background-color:#B70A15;'>수정</button> ";
      htmlString += "<button class='ui right floated basic submit button' id='cancleBtn' style='background-color:#B70A15;'>취소</button> </div> </div>";
   
      $("#correctForm_" + review_num).html(htmlString);
      $("#changeForm_" + review_num).hide();
      
      $("#cancleBtn").click(function(){   //취소버튼을 눌렀을 때
         $("#correctForm_"+review_num).hide();
         $("#changeForm_" + review_num).show();
      });      
      
      $("#updateBtn").click(function(){   //수정버튼을 눌렀을 때
         var new_comment = $("#editComment").val();
         
         $.ajax({
            url: "/pickabook/_pro/reviewCorrect.jsp",
            type: "POST",
            data: {
               "review_num": review_num,
               "content": new_comment,
            },
            dataType: "html"
         });
         location.reload();
         
      });
   });   
   
   $(".deleteBtn").click(function(){   //삭제를 눌렀을 때
      var review_num = $(this).closest('div.item').attr("id");
      var result = confirm('댓글을 삭제하시겠습니까?');
      
      if(result==true) {   //예를 누르면
         $.ajax({
                url: "/pickabook/_pro/reviewDelete.jsp",
                type: "POST",
                data: {"review_num" : review_num},
                dataType: "html"
            });
         location.reload();
         
      } else { }
   });
});
</script>