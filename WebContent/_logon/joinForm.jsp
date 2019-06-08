<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pickabook.*, java.util.*" %>
<!doctype html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PICK A BOOK</title>
<link rel="stylesheet" type="text/css"
   href="/pickabook/assets/dist/semantic.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="/pickabook/assets/dist/semantic.min.js"></script>
<link href="/pickabook/assets/join.css" rel="stylesheet" type="text/css">
<style>
.ui.form input[type=password], .ui.form input[type=search], .ui.form input[type=text],
   .ui.form input[type=password]:focus, .ui.form input[type=search]:focus,
   .ui.form input[type=text]:focus, .ui.selection.dropdown {
   border-radius: 0rem;
}

.submit.button{
   border-radius: 0rem;
}
.column.logbox{
   border-radius: 0rem;
}
</style>
</head>
<body>
<div class="ui middle aligned center aligned grid backimg">
   <div class="column logbox">
      <img src="/pickabook/image/PAB.png" style="width:15em; border-left:0px;">
      <form class="ui large form" method="post" action="joinPro.jsp" id="frm" name="frm">
         
            <div class="field">
               <div class="ui right icon input">
                  <input type="text" id="user_id" name="user_id" placeholder="아이디">
                  <i class="check icon"></i>
                  <i class="close icon" style="display:none;"></i>
               </div>
            </div>
            
            <div class="field">
               <input type="password" id="passwd" name="passwd" placeholder="비밀번호">
            </div>
            
            <div class="field">
               <input type="password" id="repasswd" name="repasswd" placeholder="비밀번호 확인">
            </div>
            
            <div class="field">
               <input type="text" id="name" name="name" placeholder="이름">
            </div>
            
            <div class="field">               
               <div class="ui selection dropdown">
                  <input type="hidden" name="gender"> 
                  <i class="dropdown icon"></i>
                  <div class="default text">성별</div>
                  <div class="menu">
                     <div class="item" data-value="male">남자</div>
                     <div class="item" data-value="female">여자</div>
                  </div>
               </div>
            </div>
            
            <div class="ui equal width form">
                <div class="fields">
                   <div class="field">
                      <input type="text" name="birth" placeholder="년(4자)" id="year">
                   </div>
                   <div class="field">
                      <input type="text" name="birth" placeholder="월" id="month">
                   </div>
                   <div class="field">
                      <input type="text" name="birth" placeholder="일" id="day">
                   </div>
                </div>
            </div>
            <div class="field"> 
				<select multiple class="ui fluid dropdown margin-top-one" id="join-form-category" name="favorite_category">
					<%
						CategoryDB categPro = CategoryDB.getInstance();
						List<CategoryData> categList = categPro.getCategoryList(); //카테고리목록
						for(int i = 0; i < categList.size(); i++) {
							CategoryData categ = categList.get(i);%>
							<option value="<%=categ.getCategory_num()%>"><%=categ.getName()%></option>
					<%	
						}
					%>
				</select>
			</div>
            <div class="ui fluid large teal submit button">Join</div>         
      </form>
      
         <div class="ui horizontal divider">Or</div>
         
         <div>
            이미 회원이신가요? <a href="/pickabook/_logon/loginForm.jsp">로그인</a>
         </div>
   </div>
</div>
   
<script>
$(document).ready(function() {
	//성별 드롭다운
	$('.selection.dropdown').dropdown();
	
	//태그 선택
	$('#join-form-category').dropdown({
		maxSelections: 3,
		placeholder: "선호 카테고리"
	});
	
	//아이디 중복확인
	$('#user_id').focusout(function(){
		var input = $(this);
		if(input.val().trim() == ""){
			alert('아이디를 입력하세요');
			return;
		}
		$.post("/pickabook/_logon/confirmId.jsp", {'user_id' : input.val()}, function(data){
			if(data.trim() == "1"){
				input.siblings('i.close.icon').css("color", "#B70A15");
				input.siblings('i.close.icon').css('display', "");
				input.siblings('i.check.icon').css('display', 'none');
		     }
			else{
				input.siblings('i.check.icon').css("color", "green");
				input.siblings('i.check.icon').css('display', "");
				input.siblings('i.close.icon').css('display', 'none');
		     }
		});
	});

});


//폼 전송시 체크
$('.ui.form')
.form({
  on    : 'submit',
  fields: {
     user_id: {
         identifier : 'user_id',
         rules: [
           {type   : 'empty', prompt : '필수 정보입니다.'}
         ]
     },
     passwd: {
         identifier : 'passwd',
         rules: [
           {type   : 'empty', prompt : '필수 정보입니다.'}
         ]
     },
     repasswd: {
        identifier : 'repasswd',
        rules: [
          {type   : 'empty', prompt : '필수 정보입니다.'},
          {type   : 'match[passwd]', prompt : '비밀번호가 일치하지 않습니다.'}
        ]
     },
      name: {
        identifier : 'name',
        rules: [
          {type   : 'empty', prompt : '필수 정보입니다.'}
        ]
      },
      gender: {
          identifier : 'gender',
          rules: [
            {type   : 'empty', prompt : '필수 정보입니다.'}
          ]
      },
     year: {
        identifier : 'year',
        rules: [
          {type   : 'empty', prompt : '필수 정보입니다.'}
        ]
     },
     month: {
         identifier : 'month',
         rules: [
           {type   : 'empty', prompt : '필수 정보입니다.'}
         ]
      },
      day: {
          identifier : 'day',
          rules: [
            {type   : 'empty', prompt : '필수 정보입니다.'}
          ]
       }
  }
});
</script>
</body>
</html>