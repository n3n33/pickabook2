<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
 
 <%
	request.setCharacterEncoding("UTF-8");	
 	int post_num = Integer.parseInt(request.getParameter("postnum")); 
	String session_member = (String)session.getAttribute("member_id"); 
	
	PostDB postPro = PostDB.getInstance();
	PostBookData pbook = postPro.getPostBook(post_num);
	if(pbook != null){	
		JSONObject bookitem = apiIsbn(pbook.getIsbn());
%>	
	   	<div class="">
		   	<a class="ui tiny left floated image" href="/pickabook/_browse/bookInfo.jsp?isbn=<%=pbook.getIsbn()%>">
		   		<img src="<%=bookitem.get("image").toString().replace("type=m1", "")%>" class="book-img-border">
		   	</a> 
		   	<div>
				<a class="ui header" href="/pickabook/_search/bookInfo.jsp?isbn=<%=pbook.getIsbn()%>">
					<%=pbook.getBook_title()%>
				</a>				
				<p><%=bookitem.get("author").toString()%></p>
				<div class="ui massive star rating post-update-star" data-rating="<%=pbook.getStar_rate()%>" data-max-rating="5" style="margin-top: 0.5em;"></div>			
			</div>
		</div>	
	<%}%>
	
	<%PostListData post = postPro.getPost(post_num);%>
	<div class="">
		<textarea rows="18" id="edit-ta"><%=post.getContent()%></textarea>
	</div> 
	
	<%if(pbook != null){%>
		<select multiple class="ui fluid dropdown margin-top-one" id="post-update-tag-sel">
			<%
				TagDB tagPro = TagDB.getInstance();
				List<TagData> taggedList = tagPro.getTaggedTag(post.getPost_num()); //등록된 태그
				List<TagData> tagsList = tagPro.getTags(); //태그목록
	
				int j = 0, check = 0;
				for(int i = 0; i < tagsList.size(); i++) {
					TagData tag = tagsList.get(i);
					if(taggedList != null && taggedList.size() > j){
						TagData tagged = taggedList.get(j);
						if(tag.getTag_num() == tagged.getTag_num()){ //등록된 태그 있으면
							check = 1;
							j++;
						}
					}%>
					<option value="<%=tag.getTag_num()%>" <%if(check == 1) out.println("selected");%>><%=tag.getName()%></option>
			<%		check = 0;
				}
			%>
		</select>
	<%} %>

<script>
$('#post-update-tag-sel').dropdown({//태그 선택
	maxSelections: 3,
	placeholder: "태그"
});
</script>