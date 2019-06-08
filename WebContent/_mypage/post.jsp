<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pickabook.*, java.util.*"%>
<%
	request.setCharacterEncoding("UTF-8");
	String pageTitle = "포스트";
	MemberDB memPro = MemberDB.getInstance();

	String user_id = request.getParameter("user_id");
	String session_user = (String) session.getAttribute("user_id");
	String session_member = (String) session.getAttribute("member_id");
	String member_id = "";

	//페이지 주인 판별
	if (user_id == null || user_id.equals("")) { //파라메터가 없음
		if (session_user == null || session_user.equals("")) { //파라메터도 없고 로그인도 안한사람
			response.sendRedirect("/pickabook/_logon/loginForm.jsp");
			return;
		} else { //파라메터는 없는데 세션이 있다면 , 세션 주인의 포스트페이지 보여주기
			user_id = session_user;
			member_id = session_member;
		}
	} else { //user_id 파라메터 있음. 그사람의 페이지 보여주기
		member_id = memPro.getMember_id(user_id);
		if (member_id == null || member_id.equals("")) { //파라메터가 우리 회원아닐 경우
			response.sendRedirect("/pickabook/_main/main.jsp");
			return;
		}
	}

	MemberData member = memPro.getInfoMember(member_id);//페이지 주인의 정보 가져오기

	//선호 카테고리 가져오기
	FavoriteCategoryDB fctgPro = FavoriteCategoryDB.getInstance();
	List<CategoryData> fcategoryList = null;
	fcategoryList = fctgPro.getFcategoryList(member_id);

	TagDB tagPro = TagDB.getInstance();
	List<TagData> tagList = null;
	//자주쓰는 태그
	List<TagData> tagRankList = null;
%>
<jsp:include page="/_layout/header.jsp" flush="false"/>

<style>
.fixed.mypage-overlay{
	z-index: 0!important;
}
.fixed.mypage-overlay .mypage-intro-div, .fixed.mypage-overlay .mypage-chart-div{
	width: 350px!important;
}
</style>

<div class="ui top container">

	<jsp:include page="/_layout/mypage.jsp" flush="false">
		<jsp:param name="pageTitle" value="<%=pageTitle%>" />
		<jsp:param name="member_id" value="<%=member_id%>" />
	</jsp:include>

	<div class="ui grid">
		<div class="six wide column mypage-overlay">

			<!-- 프로필 정보 -->
			<div class="div-border-style margin-bottom-one mypage-intro-div">
				<h4 class="ui header subTitle">Intro</h4>
				
				<!-- 자기소개 -->
				<div class="mypage-intro" style="margin-top: 1.5em; margin-left: 1em; margin-right: 1em;">
					<div class="ui divider"></div>
					<div class="mypage-intro-toggle1">
					<%	
						String intro = member.getIntro();
						if (intro != null && intro.trim().equals("") != true) {%>
							<div class="ui sub header" style="margin-top: 0.5em;"><%=intro%></div>
					<%	} 
						else {
							if(member_id.equals(session_member)){%>
								<i class='paper plane outline icon'></i>
								<div class="mypage-intro" style="font-size: 13px;margin-top: 0.5em; margin-bottom: 0.5em;">회원님에 대해 소개해주세요.</div>
								<a href="" class="ui sub header pickabook-main-color mypage-intro-toggle1-btn">Add</a>
						<%	}
							else{%>
								<div class="mypage-intro" style="font-size: 13px;margin-top: 0.5em; margin-bottom: 0.5em;">소개가 없습니다.</div>
						<%	}
						}%>
					</div>
					<!-- 자기소개 수정 : 토글 -->
					<div class="mypage-intro-toggle1" style="display: none;">
						<div class="ui form">
							<textarea placeholder="Describe who you are" rows="4"></textarea>
						</div>		
						<div class="margin-top-one" style="text-align: right;">
							<a href="" class="mypage-intro-toggle1-btn smaller-font">취소</a>
							<a href="" class="mypage-intro-edit-btn smaller-font">수정</a>
						</div>
					</div>
					<div class="ui divider"></div>
				</div>


				<!-- 생일, 성별 -->
	            <div class="ui centered grid mypage-profile" style="margin: -1em 1em 0.3em 1em;">               
	               <div class="eight wide column" style="text-align: center;">
	                  <i class="birthday cake icon"></i>
	                  <%
	                     if (member.getBirth() != null) {
	                        out.println(member.getBirth());
	                     } else {
	                        out.println("<span style='font-weight: 500;'>Secret</span>");
	                     }
	                  %>
	               </div>
	               <div class="eight wide column" style="text-align: center;">
	                  <i class="venus mars icon"></i>
	                  <%                  
	                     if (member.getGender() != null) {
	                        if (member.getGender().equals("male")) {
	                           out.println("<span style='font-weight: 500;'>Male</span>");
	                        } else if (member.getGender().equals("female")) {
	                           out.println("<span style='font-weight: 500;'>Female</span>");
	                        }
	                     } else {
	                        out.println("<span style='font-weight: 500;'>Secret</span>");
	                     }
	                  %>
	               </div>
	            </div>
				<!-- 선호 카테고리 -->
				<div class="mypage-profile" style="margin-left: 1em; margin-right: 1em;">
				<%	if (fcategoryList == null) {%>
						<div class="ui basic segment mypage-profile">선호 카테고리를 설정해주세요.</div>
				<%	}
					else {%>
						<p><i class="thumbs up outline icon"></i> <span style="font-weight: 600;">선호 카테고리</span></p>
						<div style="margin-top: 0.5em; margin-bottom: 0.5em; margin-left: 0.2em;">
					<%	for (int i = 0; i < fcategoryList.size(); i++) {
							CategoryData fcategory = fcategoryList.get(i);%>
							<div class="ui tag label" id="<%=fcategory.getCategory_num()%>" style="margin-bottom: 0.5em;">
                       			<%=fcategory.getName()%>
                     		</div>
					<%	}%>
						</div>
				<%	}%>
				</div>
				
	            <!-- 많이 쓰는 태그  -->
	            <div class="mypage-profile" style="margin-left: 1em; margin-right: 1em;">
	               <p>
	                  <i class="tags icon"></i> <span style="font-weight: 600;">많이 쓰는 태그</span>
	               </p>
	               <div style="margin-top: 0.5em; margin-bottom: 0.5em; margin-left: 0.2em;">
	                  <%
	                     tagRankList = tagPro.getFavoriteTag(member_id);
	                     if (tagRankList != null) {
	                        int val = 0;
	                        if (tagRankList.size() > 3)
	                           val = 3;
	                        else
	                           val = tagRankList.size();
	                        for (int i = 0; i < val; i++) {
	                           TagData tagRank = tagRankList.get(i);
	                  %>
	                           <div class="ui basic label" style="margin-bottom: 0.5em; margin-left: 0;"><i class="hashtag small icon"></i><%=tagRank.getName()%></div>
	                  <%
	                        }
	                     } else {
	                        out.println("<span style='margin-top: 0.5em;'>선택된 태그가 없습니다.</span>");
	                     }
	                  %>
	               </div>
	            </div>
	         </div>

			<!-- 통계 -->
			<div class="div-border-style margin-bottom mypage-chart-div">
				<h4 class="ui header subTitle">Category Chart</h4>
				<div id="chart_div"></div>
			</div>

		</div>
		<!-- end of six wide column -->

		<div class="ten wide column">

			<!-- 포스트 작성 폼 - 페이지 주인과 세션 주인이 같은 경우만 표시 -->
			<%
				if (member_id.equals(session_member)) {
			%>
			<form id="post-write" class="margin-bottom-one">
				<div class="ui fluid form div-border-style">
					
					<div class="field">
						<textarea rows="6" placeholder="자신의 생각을 글로 남겨보세요" id="post-ta"></textarea>
					</div>
					<div class="ui divider"></div>
					
					<div style="overflow: auto;">
						<div class="ui checkbox" style="margin-top: 6px;">
							<input type="checkbox"><label style="font-weight: bolder;">PICK BOOK</label>
						</div>
						<button type="submit" class="ui small button right floated pickabook-bgcolor" style="border-radius: 0!important;">작성</button>
					</div>
					
					<div id="book-form" hidden="hidden">
						<div class="field margin-top-one">
							<div class="ui category fluid search mypost-search">
								<div class="ui icon input">
									<input class="prompt" type="text" placeholder="도서 검색" style="border-bottom: 1px solid rgba(34, 36, 38, 0.15); border-top:none; border-right:none; border-left: none; border-radius: 0;">
									<i class="search icon"></i>
								</div>
								<div class="results"></div>
							</div>
						</div>
						<input type="hidden" name="isbn">
						
						<div class="ui massive star rating form-star" data-max-rating="5"
							style="margin-bottom: 1rem;"></div>

						<select multiple class="ui fluid dropdown" id="tag-sel">
							<%
								List<TagData> tagList1 = null;
									TagDB tagPro1 = TagDB.getInstance();
									tagList1 = tagPro1.getTags();

									for (int i = 0; i < tagList1.size(); i++) {
										TagData tag = tagList1.get(i);
							%>
							<option value="<%=tag.getTag_num()%>"><%=tag.getName()%></option>
							<%
								}
							%>
						</select>
					</div>					
				</div>
			</form>
			<%
				}
			%>

			<!-- 내 포스트 -->
			<div id="post-list"></div>			
			<div class="post-list-end ui basic segment margin-top">
				<div class="ui text small loader">Loading</div>
			</div>

		</div>
		<!-- end of ten wide column -->
	</div>
	<!-- end of grid -->
</div>
<!-- end of top container  -->


<script src="/pickabook/assets/mypage.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	getPosts();  
	
	$('.ui.rating.form-star').rating();//별점 - 포스트작성부분만   
	$('#tag-sel').dropdown({//태그 선택
		maxSelections: 3,
		placeholder: "태그"
	});
   //무한 스크롤
   $(window).scroll(function() {
      //alert($(window).scrollTop() + "==" +  $(document).height() + "-" + $(window).height());
       if($(window).scrollTop() >= $(document).height() - $(window).height() - 5) {
         	start += end;
         	getPosts(); 
       }
   });
   
   $('.mypage-overlay').visibility({
     type   : 'fixed',
     offset : 75,// give some space from top of screen
   });
});

/*getPosts() 에서 사용하는 전역변수*/
var member_id = '<%=member_id%>';
var start = 0;
var end = 4;
var kind = 0; //0인경우 post.jsp , 1인경우 main.jsp에서호출


/*차트 load*/
var queryObject = "";
var queryObjectLen = "";
function getCategoryChart(){
	$.ajax({
	    type : 'POST',
	    url : '/pickabook/_mypage/chartData.jsp',
	    data : {'member_id' : '<%=member_id%>'},
	    dataType : 'json',
	    success : function(data) {
	        queryObject = eval('(' + JSON.stringify(data,null,2) + ')');             
	        queryObjectLen = queryObject.pielist.length;
	    },
	    error : function(xhr, type) {
	        alert('server error occoured')
	    }
	});
}
getCategoryChart();

google.charts.load('current', {'packages':['corechart'], 'language':'ko'});
google.charts.setOnLoadCallback(drawChart);

function drawChart() {
     var data = new google.visualization.DataTable();
     data.addColumn('string', 'category_name');
     data.addColumn('number', 'amount');
    for (var i = 0; i < queryObjectLen; i++) {
        var category_name = queryObject.pielist[i].category_name;
        var amount = queryObject.pielist[i].amount;
     data.addRows([
        	 [category_name,amount]
        	 ]);

    }
    var options = {
        
    };
    var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
    chart.draw(data, options);
}



</script>

</body>
</html>