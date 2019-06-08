// 카카오톡으로 로그인
// <![CDATA[
// 사용할 앱의 JavaScript 키를 설정해 주세요.
Kakao.init('36ad859d708095206a5202149b8ca111');
function loginWithKakao() {
	// 로그인 창을 띄웁니다.
	Kakao.Auth.login({
				success : function(authObj) {
					// alert(JSON.stringify(authObj));
					Kakao.API.request({
								url : '/v2/user/me',
								success : function(res) { // res : 사용자 정보요청에
									// 성공하였을 때 가져오는 사용자
									// 정보
									// 파라미터
									// alert(res.properties.nickname + '님 로그인되었습니다.');

									/*
									 * console.log(res.id);
									 * console.log(res.properties['nickname']);
									 * console.log(res.properties['profile_image']);
									 * console.log(res.properties['custome_field1']);
									 * console.log(res.properties['custom_field2']);
									 * 
									 * console.log(res.kakao_account.has_email); //
									 * true
									 * console.log(res.kakao_account.is_email_valid);
									 * console.log(res.kakao_account.is_email_verified);
									 * console.log(res.kakao_account.email);
									 * console.log(res.kakao_account.has_age_range); //
									 * true
									 * console.log(res.kakao_account.age_range);
									 * console.log(res.kakao_account.has_birthday); //
									 * true
									 * console.log(res.kakao_account.birthday);
									 * console.log(res.kakao_account.has_gender); //
									 * true
									 * console.log(res.kakao_account.gender);
									 * 
									 * console.log(authObj.access_token);
									 */

									var member_id = res.id;
									var nickname = res.properties['nickname'];
									var profile_image = res.properties['profile_image'];
									//var email = res.kakao_account.email;
									var age_range = res.kakao_account.age_range;
									var birth = res.kakao_account.birthday;
									var gender = res.kakao_account.gender;

									location.href = "/pickabook/_logon/kakaoLoginPro.jsp?member_id="
											+ member_id
											+ "&nickname=" + nickname
											+ "&profile_image="	+ profile_image
											+ "&age_range="	+ age_range
											+ "&birth="	+ birth
											+ "&gender=" + gender;

								},
								fail : function(error) {
									alert(JSON.stringify(error));
								}
							})
				},
				fail : function(err) {
					alert(JSON.stringify(err));
				},
				persistAccessToken : Boolean (true),
				persistRefreshToken : Boolean (true)
			});
	
	
};
// ]]>

/*
// 카카오톡 로그아웃
function logoutWithKakao() {
	Kakao.Auth.logout({
		function () {
			alert("로그아웃되었습니다.");
			locaton.href="/pickabook/_logon/loginForm.jsp";
		},
		persistAccessToken : Boolean (false),
		persistRefreshToken : Boolean (false)
	});
};
*/

// 카카오톡 회원 탈퇴
// DB에 있는거 삭제하고, 카카오톡에서 삭제하고

// 구글 로그인
function checkLoginStatus() {
	var loginBtn = document.querySelector('#loginBtn');
	var nameTxt = document.querySelector('#name');
	if (gauth.isSignedIn.get()) {
		// console.log('logined');
		loginBtn.value = 'Logout';
		var profile = gauth.currentUser.get().getBasicProfile();
		// console.log(profile.getName());
		// console.log(profile.getId());
		// console.log(profile.getEmail());
		// console.log(profile.getImageUrl());
		// nameTxt.innerHTML = 'Welcome'+profile.getName();

		var member_id = profile.getId();
		var nickname = profile.getName();
		var profile_image = profile.getImageUrl();
		var email = profile.getEmail();

		location.href = "/pickabook/_logon/googleLoginPro.jsp?member_id="
				+ member_id + "&nickname=" + nickname + "&profile_image="
				+ profile_image;

	} else {
		console.log('logouted');
		loginBtn.value = 'Login';
		// nameTxt.innerHTML = '';
	}
}

function init() {
	console.log('init');
	gapi
			.load(
					'auth2',
					function() {
						console.log('auth2');
						window.gauth = gapi.auth2
								.init({
									client_id : '524482343270-32nlndnuv32nphj2cpkjsufa578rgo4i.apps.googleusercontent.com'
								})
						gauth.then(function() {
							console.log('googleAuth success');
							checkLoginStatus();
						}, function() {
							console.log('googleAuth fail');
						});
					});
}


//semantic 에서 가져온 로그인 함수
$(document).ready(function() {
	$('.ui.form').form({
		fields : {
			user_id : {
				identifier : 'user_id',
				rules : [ {
					type : 'empty',
					prompt : '아이디를 입력하세요'
				} ]
			},
			passwd : {
				identifier : 'passwd',
				rules : [ {
					type : 'empty',
					prompt : '비밀번호를 입력하세요'
				} ]
			}
		}
	});
});