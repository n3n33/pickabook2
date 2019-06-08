<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="pickabook.*, java.sql.*, java.util.*"%>

<%
	request.setCharacterEncoding("utf-8");
	String[] birthArr = request.getParameterValues("birth");
	String birth = "";
	if(birthArr[1].length() == 1){ //month가 한자릿수
		birthArr[1] = "0" + birthArr[1];
	}
	if(birthArr[2].length() == 1){ //day가 한자릿수
		birthArr[2] = "0" + birthArr[2];
	}
	for(int i = 0; i<birthArr.length; i++){
		birth += birthArr[i];
		if(i != birthArr.length-1)
			birth += "-";
	}	
%>
<jsp:useBean id="memberBean" class="pickabook.MemberData">
	<jsp:setProperty property="*" name="memberBean" />
</jsp:useBean>

<%
	memberBean.setMember_id("pab" + memberBean.getUser_id());
	memberBean.setProfile_img("/pickabook/_image/non.jpg");
	memberBean.setAge_range(null);
	memberBean.setBirth(birth);
	memberBean.setIntro(null);
	memberBean.setReg_date(new Timestamp(System.currentTimeMillis()));

	MemberDB dbPro = MemberDB.getInstance();
	int x = dbPro.insertMember(memberBean);
	
	String[] fCategories = request.getParameterValues("favorite_category");	
	FavoriteCategoryDB fcategPro = FavoriteCategoryDB.getInstance();
	FavoriteCategoryData fCateg = null;
	for(int i=0; i < fCategories.length; i++){
		fCateg = new FavoriteCategoryData();
		fCateg.setMember_id("pab" + memberBean.getUser_id());
		fCateg.setCategory_num(Integer.parseInt(fCategories[i]));	
		fcategPro.insertFCategory(fCateg); //카테고리 삽입
	}		
%>
	<script>alert('회원가입을 축하드립니다! 로그인해주세요.');</script>
<%
	response.sendRedirect("/pickabook/_main/main.jsp");	
%>

