<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String session_member = (String) session.getAttribute("member_id");
	if(session_member != null){
		response.sendRedirect("/pickabook/_main/main.jsp");
		return;
	}
		
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<link rel="stylesheet" type="text/css" href="/pickabook/assets/dist/semantic.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="/pickabook/assets/dist/semantic.min.js"></script>

<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="https://apis.google.com/js/platform.js" async defer></script>
<link href="/pickabook/assets/login.css" rel="stylesheet" type="text/css">
<title>PICK A BOOK</title>
<style>
.ui.form input[type=password], .ui.form input[type=search], .ui.form input[type=text],
   .ui.form input[type=password]:focus, .ui.form input[type=search]:focus,
   .ui.form input[type=text]:focus, .ui.selection.dropdown {
   border-radius: 0rem;
}

.column.logbox{
   border-radius: 0rem;
}

.button{
   border-radius: 0rem!important;
}
</style>
</head>
<body>

	<div class="ui middle aligned center aligned grid backimg">
		<div class="column logbox">
			<img src="/pickabook/image/PAB.png" style="width:15em; border-left:0px;">
			<form class="ui large form" method="post" action="loginPro.jsp">
				<div class="field">
					<div class="ui left icon input">
						<i class="user icon"></i> <input type="text" name="user_id"
							placeholder="아이디">
					</div>
				</div>
				<div class="field">
					<div class="ui left icon input">
						<i class="lock icon"></i> <input type="password" name="passwd"
							placeholder="비밀번호">
					</div>
				</div>
				<div class="ui fluid large teal submit button" style="margin-bottom: 1.5em;">Login</div>

				<div class="ui error message"></div>
			</form>


			<div>
				처음 방문하셨나요? <a href="/pickabook/_logon/joinForm.jsp">회원가입</a>
			</div>


			<div class="ui horizontal divider">Or</div>

			<div class="ui center aligned basic segment">
				<div>
					<!-- 카카오톡으로 로그인 -->
					<div class="iconSet kakao">
						<a class="ui fluid yellow button" id="custom-login-btn"
							href="javascript:loginWithKakao()"> Kakao로 계속하기 </a>
					</div>
					<!-- 구글로 로그인 -->
					<div class="iconSet google">
						<button class="ui fluid button" id="loginBtn" value="checking...">
							Google로 계속하기
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
	$('#loginBtn').click(function(){
		if(this.value === 'Login'){
			gauth.signIn().then(function(){
				console.log('gauth.signIn()');
				checkLoginStatus();
			});
		} else {
			gauth.signOut().then(function(){
				console.log('gauth.signOut()');
				checkLoginStatus();
			});
		}
	});
	
	</script>
	<script src="/pickabook/assets/login.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="/pickabook/assets/fontawesome-free-5.0.9/svg-with-js/js/fontawesome-all.js"></script>
	<script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>
</body>
</html>