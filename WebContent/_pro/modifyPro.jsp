<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="pickabook.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%
request.setCharacterEncoding("utf-8");
String session_member = (String)session.getAttribute("member_id");%>

<%
String realFolder = "";//웹 어플리케이션상의 절대 경로
String filename ="";
MultipartRequest imageUp = null;

String saveFolder = "/upload";//파일이 업로드되는 폴더
String encType = "utf-8"; //엔코딩타입
int maxSize = 2*1024*1024;  //최대 업로될 파일크기 5Mb

//현재 jsp페이지의 웹 어플리케이션상의 절대 경로를 구한다
ServletContext context = getServletContext();
realFolder = context.getRealPath(saveFolder);  

try{
   
   //전송을 담당할 콤포넌트를 생성하고 파일을 전송한다.
   //전송할 파일명을 가지고 있는 객체, 서버상의 절대경로,최대 업로드될 파일크기, 문자코드, 기본 보안 적용
   imageUp = new MultipartRequest(request,realFolder,
		   maxSize,encType,new DefaultFileRenamePolicy());
   
   //전송한 파일 정보를 가져와 출력한다
   Enumeration<?> files = imageUp.getFileNames();
   
   //파일 정보가 있다면
   while(files.hasMoreElements()){
    //input 태그의 속성이 file인 태그의 name 속성값 :파라미터이름
      String name = (String)files.nextElement();
   
   //서버에 저장된 파일 이름
      filename = imageUp.getFilesystemName(name);
   }
}catch(IOException ioe){
 System.out.println(ioe);
}catch(Exception ex){
 System.out.println(ex);
}
%>

<jsp:useBean id="member" class="pickabook.MemberData">
	<jsp:setProperty property="*" name="member" />
</jsp:useBean>

<%
	String member_id = imageUp.getParameter("member_id");
	
	member.setMember_id(session_member);
	member.setProfile_img("/pickabook/upload/"+filename);
	MemberDB dbpro = MemberDB.getInstance();
	int update = dbpro.updateMember(member, session_member);
	if(update == 1){
		response.sendRedirect("/pickabook/_mypage/post.jsp");
		return;
	}
	response.sendRedirect("/pickabook/_mypage/post.jsp");
%>
<%-- <jsp:forward page="/pickabook/_mypage/modifyForm.jsp"></jsp:forward> --%>