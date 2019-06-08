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
	
	String member_id = "google" + id;	
	
	session.setAttribute("member_id", member_id);	
	session.setAttribute("user_id", id.substring(10));	
	
	MemberDB google = MemberDB.getInstance();
	if(google.findMember_id(member_id) != 1){//가입안된 회원
		member.setMember_id(member_id);	//member_id 는 항상google123456789 처럼 google뒤에 구글 아이디가 쓰인다.
		member.setUser_id(id.substring(10));
		member.setPasswd(id.substring(10));
		member.setName(nickname);
		member.setProfile_img(profile_img);
		member.setReg_date(new Timestamp(System.currentTimeMillis()));
		google.insertGoogleMember(member);
	}
	
	response.sendRedirect("/pickabook/_main/main.jsp");
%>