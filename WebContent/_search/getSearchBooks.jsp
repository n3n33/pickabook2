<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/_api/apiInclude.jsp" %>
<%
 	//JSP code
	request.setCharacterEncoding("UTF-8");
	String param = request.getParameter("param");	
	JSONObject paramjobj = new JSONObject(param); //받은 파라메터를 다시 -> json으로
	String query = paramjobj.getString("query");
	int start = paramjobj.getInt("start");
	int display = paramjobj.getInt("display");
	String sort = paramjobj.getString("sort");
	
	JSONObject result = apiSearch(query, start, display, sort); //api에 검색어 검색
	int total = result.getInt("total"); //검색 결과 총 개수
    JSONArray jarr = new JSONArray(result.getJSONArray("items").toString());
%>
	<div class="ui text menu" style="margin-top: 0; margin-bottom: 1em;">
	  <div class="header item">도 서 (<span class="pickabook-main-color"><%=total%></span>)</div>
	  <div class="right menu">
	  	<div class="item">
	  		<a href="/pickabook/_search/search.jsp?query=<%=query%>&sort=sim" class="search-sort <%if(sort.equals("sim")) out.println("search-active"); %>">
				<i class="small check icon"></i>관련도순
			</a> 
		</div>
	  	<div class="item">
	  		<a href="/pickabook/_search/search.jsp?query=<%=query%>&sort=date" class="search-sort <%if(sort.equals("date")) out.println("search-active"); %>">
				<i class="small check icon"></i>출간일순
			</a>
		</div>
	  	<div class="item">
			<a href="/pickabook/_search/search.jsp?query=<%=query%>&sort=count" class="search-sort <%if(sort.equals("count")) out.println("search-active"); %>">
				<i class="small check icon"></i>판매량순
			</a>
	  	</div>
	  </div>
	</div>

    
<%	if(jarr.length() == 0){ %>
	<div><%=query%>에 해당하는 책이 없습니다.</div>
<%	}
	else{ %>	
				 
		<div class="ui five cards search-book-fivecards">
<%		for(int i=0; i < jarr.length(); i++){ 
			JSONObject jobj = jarr.getJSONObject(i);
			String isbn = jobj.getString("isbn");
			if(isbn.length() > 13){
				isbn = isbn.split(" ")[1];
			}
			isbn = isbn.replace("<b>", "");
			isbn = isbn.replace("</b>", "");
%>
			<div class="ui card" id="<%=isbn%>">
				<a class="image" id="book-img' + i + '" href="/pickabook/_browse/bookInfo.jsp?isbn=<%=isbn%>">
					<img src="<%= jobj.getString("image").replace("type=m1", "")%>" onerror="this.src='/pickabook/image/book_alt.png';" style="height: 250px;">
				</a>
				<div class="content" style="height: 57px;">
					<a class="ui tiny header search-book-title" href="/pickabook/_browse/bookInfo.jsp?isbn=<%=isbn%>"><%=jobj.getString("title")%></a>
					<div class="meta">
						<div class="search-book-author"><%=jobj.getString("author")%></div>
					</div>
				</div> 
			</div>	
		<%	}%>
		</div>
<%	}%>
	<div class="ui basic segment search-book-end" style="margin-top: 1em; text-align: center;">
		<div class="ui text small loader">Loading</div>
	</div>
	