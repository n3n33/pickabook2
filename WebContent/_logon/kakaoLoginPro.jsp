<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page import = "java.sql.*" %>
<%@ page import="pickabook.MemberDB"%>

<%
	request.setCharacterEncoding("utf-8");
%>

<jsp:useBean id="member" class="pickabook.MemberData">
	<jsp:setProperty name="member" property="*"/>
</jsp:useBean>

<%
	String id = request.getParameter("member_id");
	String nickname = request.getParameter("nickname");
	String profile_img = request.getParameter("profile_image");
	if(profile_img.equals("undefined"))
		profile_img = "/picabook/image/nan.jpg";
	String birth = request.getParameter("birth");
	if(birth.equals("undefined"))
		birth = null;
	String age_range = request.getParameter("age_range");
	if(age_range.equals("undefined"))
		age_range = null;
	String gender = request.getParameter("gender");
	if(gender.equals("undefined"))
		gender = null;
	
	String member_id = "kakao" + id;	
	
	session.setAttribute("member_id", member_id);	
	session.setAttribute("user_id", id);	
	
	MemberDB kakao = MemberDB.getInstance();
	if(kakao.findMember_id(member_id) != 1){ //가입안된 회원
		member.setMember_id(member_id);	//member_id 는 항상kakao123456789 처럼 kakao뒤에 카카오톡 아이디가 쓰인다.
		member.setUser_id(id);
		member.setPasswd(id);
		member.setName(nickname);
		member.setProfile_img(profile_img);
		member.setBirth(birth);
		member.setAge_range(age_range);
		member.setGender(gender);
		member.setReg_date(new Timestamp(System.currentTimeMillis()));
		kakao.insertKakaoMember(member);
	}

	response.sendRedirect("/pickabook/_main/main.jsp");
%>