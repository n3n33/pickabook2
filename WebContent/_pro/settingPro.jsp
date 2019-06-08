<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="pickabook.*"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat, org.json.*" %>

<%   request.setCharacterEncoding("utf-8");
   String session_member = (String)session.getAttribute("member_id");
   String session_user = (String) session.getAttribute("user_id");
%>
<jsp:useBean id="memberBean" scope="page" class="pickabook.MemberData">
   <jsp:setProperty name="memberBean" property="*"/>
</jsp:useBean>

<%
   String passwd = "";
   
   String gender = memberBean.getGender();
   if(gender.equals("secret"))
      gender = null;
   
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
   
   if(memberBean.getPasswd() == null)
      memberBean.setPasswd(request.getParameter("passwd_original"));
   memberBean.setPasswd(memberBean.getPasswd());   
   memberBean.setBirth(birth);
   memberBean.setGender(gender);
   
   MemberDB memPro = MemberDB.getInstance();
   memPro.updateProfile(memberBean, session_member);
   
   String[] fCategories = request.getParameterValues("favorite_category");   
   FavoriteCategoryDB fcategPro = FavoriteCategoryDB.getInstance();
   List<FavoriteCategoryData> fCategList = null;
   FavoriteCategoryData fCateg = null;
   fCategList = new ArrayList<FavoriteCategoryData>();
   for(int i=0; i < fCategories.length; i++){
      fCateg = new FavoriteCategoryData();
      fCateg.setMember_id(session_member);
      fCateg.setCategory_num(Integer.parseInt(fCategories[i]));   
      fCategList.add(fCateg);
   }      
   fcategPro.updateFCategory(session_member, fCategList); //카테고리 삽입
   
   session.setAttribute("user_id", request.getParameter("user_id"));
   
   response.sendRedirect("/pickabook/_mypage/post.jsp");   
%>