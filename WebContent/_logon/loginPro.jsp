<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="pickabook.MemberDB"%>

<%
	request.setCharacterEncoding("utf-8");
%>

<%
	String user_id = request.getParameter("user_id");
	String passwd = request.getParameter("passwd");

	MemberDB member = MemberDB.getInstance();
	int check = member.memberCheck(user_id, passwd);

	if (check == 1) {
		String member_id = member.getMember_id(user_id);
		session.setAttribute("member_id", member_id);	//member_id를 세션에 저장
		session.setAttribute("user_id", user_id);
		response.sendRedirect("/pickabook/_main/main.jsp");
		return;
	} else if (check == 0) {
%>
<script>
	alert("비밀번호가 맞지 않습니다.");
	history.go(-1);
</script>
<%
	} else {
%>
<script>
	alert("아이디가 맞지 않습니다.");
	history.go(-1);
</script>
<%
	}
%>