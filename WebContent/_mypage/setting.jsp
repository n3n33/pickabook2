<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_layout/session.jsp" %> 
<%@ page import="pickabook.*, java.util.*"%>
<%@ page import="java.text.NumberFormat"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String session_user = (String)session.getAttribute("user_id");
	String session_member = (String)session.getAttribute("member_id");
	
	MemberDB memPro = MemberDB.getInstance();
	MemberData member = memPro.getInfoMember(session_member);//페이지 주인의 정보 가져오기
%>   
<jsp:include page="/_layout/header.jsp"  flush="false"/>

<style type="text/css">
	.ui.form input[type=password], .ui.form input[type=search], .ui.form input[type=text],
   .ui.form input[type=password]:focus, .ui.form input[type=search]:focus,
   .ui.form input[type=text]:focus, .ui.selection.dropdown {
   border-radius: 0rem;}
    body > .grid {
      height: 60em;
    }
    .column {
      max-width: 470px;
    }
    
    .mypage-setting-intro{
    	border-radius: 0!important;
    }
    
    .mypage-setting-submit{
    	border-radius: 0!important;
    }
    
</style>

<div class="ui top container">
	<div class="ui middle aligned center aligned grid backimg">
	   <div class="column logbox">
			<h3 class="ui header">회원정보 수정</h3>
			<form class="ui large form" method="post" action="/pickabook/_pro/settingPro.jsp" id="mypage-setting-frm" name="frm" onsubmit="return updateProfile(this)">
	      
	            <div class="field">
	               <div class="ui right icon input">
	                  <input type="text" id="user_id" name="user_id" value="<%=member.getUser_id()%>" placeholder="아이디" required="required">
	                  <i class="check icon"></i>
	                  <i class="close icon" style="display:none;"></i>
	               </div>
	            </div>
	            
	            <div class="field">
	               <input type="password" name="passwd_original" placeholder="이전 비밀번호" required="required">
	            </div>
	            
	            <div class="field">
	               <input type="password" name="passwd" placeholder="새 비밀번호">
	            </div>
	            
	            <div class="field">
	               <input type="text" id="name" name="name" value="<%=member.getName()%>" placeholder="이름" required="required">
	            </div>
	            
	            <%
	            String gender = member.getGender();
	            if(gender == null){
	            	gender = "secret";
	            }
	            %>
	            <div class="field">               
	               <div class="ui selection dropdown">
	                  <input type="hidden" name="gender" value="<%=gender%>"> 
	                  <i class="dropdown icon"></i>
	                  <div class="default text">성별</div>
	                  <div class="menu">
	                     <div class="item <%if(gender.equals("male")) out.println("active selected");%>" data-value="male">남자</div>
	                     <div class="item <%if(gender.equals("female")) out.println("active selected");%>" data-value="female">여자</div>
	                     <div class="item <%if(gender.equals("secret")) out.println("active selected");%>" data-value="secret">SECRET</div>
	                  </div>
	               </div>
	            </div>
	            <%
	            	String memDate = member.getBirth();
	            %>
	            <div class="ui equal width form">
		            <div class="three fields">
		               <div class="field">
		                  <input type="text" name="birth" placeholder="년(4자)" value="<%if(memDate != null) out.println(memDate.substring(0,4));%>" required="required">
		               </div>
		               <div class="field">
		                  <input type="text" name="birth" placeholder="월" value="<%if(memDate != null) out.println(memDate.substring(5,7));%>" required="required">
		               </div>
		               <div class="field">
		                  <input type="text" name="birth" placeholder="일" value="<%if(memDate != null) out.println(memDate.substring(8,10));%>" required="required">
		               </div>
		            </div>
	            </div>
	            <div class="field">
	            	<textarea class="ui form mypage-setting-intro" name="intro" rows="4" placeholder="자기소개"><%if(member.getIntro() != null) out.println(member.getIntro());%></textarea>
	            </div>
	            
	            <div class="field"> 
					<select multiple class="ui fluid dropdown margin-top-one" id="setting-category" name="favorite_category">
						<%
							CategoryDB categPro = CategoryDB.getInstance();
							List<CategoryData> categList = categPro.getCategoryList(); //카테고리목록
							
							FavoriteCategoryDB fCategoryPro = FavoriteCategoryDB.getInstance();
							List<CategoryData> fcategList = fCategoryPro.getFcategoryList(session_member); //등록된 선호카테고리
							
							int j = 0, check = 0;
							for(int i = 0; i < categList.size(); i++) {
								CategoryData categ = categList.get(i);
								if(fcategList != null && fcategList.size() > j){
									CategoryData fcateg = fcategList.get(j);
									if(categ.getCategory_num() == fcateg.getCategory_num()){ //등록된 선호카테고리 있으면
										check = 1;
										j++;
									}
							}%>
								<option value="<%=categ.getCategory_num()%>" <%if(check == 1) out.println("selected");%>><%=categ.getName()%></option>
				<%		check = 0;
					}
				%>
					</select>
				</div>
	            <button class="ui fluid large submit button pickabook-bgcolor mypage-setting-submit" type="submit">수정</button>         
			</form>
			<div class="ui horizontal divider">Or</div>
			<div>탈퇴하시겠습니까? <a href="" class="member-delete-btn">탈퇴하기</a></div>
	   </div>
	</div>
</div>

<script>
$(document).ready(function() {
	//성별 드롭다운
	$('.selection.dropdown').dropdown();
	
	//태그 선택
	$('#setting-category').dropdown({
		maxSelections: 3,
		placeholder: "선호 카테고리"
	});
});
//아이디 중복확인
var userId_original = '<%=member.getUser_id()%>'
$('#user_id').focusout(function(){
	var input = $(this);
	$.post("/pickabook/_logon/confirmId.jsp", {'user_id' : input.val()}, function(data){
		if(input.val() == userId_original || data.trim() != "1"){
			input.siblings('i.check.icon').css("color", "green");
			input.siblings('i.check.icon').css('display', "");
			input.siblings('i.close.icon').css('display', 'none');			
		}
		else{
			input.siblings('i.close.icon').css("color", "#B70A15");
			input.siblings('i.close.icon').css('display', "");
			input.siblings('i.check.icon').css('display', 'none');
	     }
	});
});


$('#favo-sel').dropdown({//카테고리 선택
    maxSelections: 3,
    placeholder: "카테고리"
  });

/*submit버튼 눌렀을때*/
function updateProfile(frm){
	var passwd_original = frm.passwd_original.value;
    $.post('/pickabook/_logon/confirmPw.jsp', {'passwd' : passwd_original}).done(function(data) {
    	if(data.trim() == "-1"){
    		alert('비밀번호가 맞지 않습니다');
    		return false;
    	}    		
 	});	
};


$(document).on('click','.member-delete-btn',function(e){
	e.preventDefault();
	var x = confirm('정말 탈퇴하시겠습니까?');
	if(x){
		location.href = '/pickabook/_logon/deletePro.jsp';
	}
});


</script>