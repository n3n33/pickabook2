<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_layout/session.jsp"%>
<%@ include file="/_api/apiInclude.jsp"%>

<%
   request.setCharacterEncoding("utf-8");
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   String isbn = request.getParameter("isbn");
   if (isbn == null || isbn.equals("")) {
      response.sendRedirect("/pickabook/_main/main.jsp");
   }
   String session_member = (String)session.getAttribute("member_id");
   
%>

<jsp:include page="/_layout/header.jsp" flush="false"/>
<style type="text/css">
#gridStyle {
   margin-top: 10em;
}

.tenColumn {
   margin-top: 2em;
}

#book-title {
   font-weight: 600;
}

#book-info {
   font-weight: 500;
}

.innerStyle {
   padding-top: 7em;
   padding-bottom: 10em;
}

body {
   background-color: #FFFFFF;
}

a {
   color: #000000;
}

a:link {
   color: #000000;
}

a:visited {
   color: #000000;
}

a:hover {
   color: #000000;
}

a:active {
   color: #000000;
}

.ui.menu .item img.logo {
   margin-right: 1.5em;
}

.top.container {
   margin-top: 7em;
}

.ui.grid {
   margin-bottom: 3em;
}

.ui.secondary.pointing.menu .active.item {
   border-color: #B70A15;
   color: #B70A15;
}

.ui.secondary.pointing.menu .active.item:hover {
   border-color: #B70A15;
   color: #B70A15;
}

.bookText {
   color: #666;
   font-size: 14px;
   font-family: "Noto Sans Light", "Malgun Gothic", sans-serif;
}

.innerSize {
   width: 960px;
   margin: 0 auto;
}

</style>

<%
   List<MemberData> memberLists = null;
   MemberData memberList = null;
   int selectBtn;

   MemberDB memberProcess = MemberDB.getInstance();
   PostDB post = PostDB.getInstance();
   BookDB bookPro = BookDB.getInstance();

   JSONObject jobj = apiIsbn(isbn); //api요청
%>

<div>
   <div class="ui container">
      <div class="ui centered grid" id="gridStyle">
         <div class="four wide column">
            <!-- 책 이미지 -->
            <img id="book-image" style="width: 210px; height: 310px;" src="<%=jobj.getString("image").replace("type=m1", "")%>">
         </div>
         <div class="ten wide column tenColumn">   
            <!-- 이미지 옆 데이터 -->
            <h2 id="book-title"><%=jobj.getString("title")%></h2>
            <h3 id="book-info">
                  <span style="color: #353535;"><%= jobj.getString("author") %></span> &nbsp; <span style="color: #747474;">|</span> &nbsp; <span style="color: #353535;"><%= jobj.getString("publisher") %></span> &nbsp; <span style="color: #747474;">|</span> &nbsp; <span style="color: #353535;">
                  <% 
                     String pubDate = jobj.getInt("pubdate") + "";
                     pubDate  = pubDate.substring(0,4) + "-" + pubDate.substring(4,6) + "-" + pubDate.substring(6,8);
                  %>
                  <%=pubDate%>
                  </span>
            </h3>
            
            <h3>
               <i class="star yellow icon" style="margin-right: 0.5em;"></i><%=post.selectStar(isbn)%>
            </h3>

            <% String check = bookPro.bookType(isbn,session_member);%>
			<div class="ui grid" style=" margin-top: 2em;">
               <div class="ui horizontal list">
                       <a class="ui button bookItem btnNo <% if(check.equals("wish")) out.println("btnAct");%>" id="wish">WISH</a>
                       <a class="ui button bookItem btnNo <% if(check.equals("ing")) out.println("btnAct");%>" id="ing">ING</a>
                       <a class="ui button bookItem btnNo <% if(check.equals("read")) out.println("btnAct");%>" id="read">READ</a>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>

<div>
   <div class="ui pointing secondary menu">
      <div class="ui container">
         <a class="item active" id="contentPage" data-tab="first">책정보</a> <a
            class="item" id="postPage" data-tab="second">포스트</a>
      </div>
   </div>
</div>

<div class="includeDiv"></div>

<script>

$(document).ready(function(){
   
   $("#postPage").removeClass('active');
   $(this).addClass('active');   
   $.ajax({
      url:"/pickabook/_browse/bookContent.jsp?isbn=<%=isbn%>", 
      success:function(result) {
         $(".includeDiv").html(result);
      }
   });
   
   $("#contentPage").click(function(){
      $("#postPage").removeClass('active');
      $(this).addClass('active');
      
      $.ajax({
         url:"/pickabook/_browse/bookContent.jsp?isbn=<%=isbn%>", 
         success:function(result) {
            $(".includeDiv").html(result);
         }
      });
   });
   
   $("#postPage").click(function(){
      $("#contentPage").removeClass('active');
      $(this).addClass('active');
      
      $.ajax({
         url:"/pickabook/_browse/bookPost.jsp?isbn=<%=isbn%>",
         success:function(result) {
            $(".includeDiv").html(result);
         }
      });
   });
});


var isbn = '<%=isbn%>';
$(document).on('click','.ui.bookItem',function(){
	var active = $('.bookItem.btnAct');
    active.removeClass('btnAct');
    $(this).addClass('btnAct');    
    var type = $(this).attr('id');
    $.post('/pickabook/_pro/simplebookInsert.jsp', {'isbn' : isbn, 'type': type});   
});
</script>

<jsp:include page="/_layout/footer.jsp" flush="false" />