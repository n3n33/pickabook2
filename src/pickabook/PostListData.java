package pickabook;

import java.sql.Timestamp;

//main.jsp나 post.jsp에서 포스트 목록 가져올 때 사용
//post테이블과 member테이블 조인
public class PostListData {
	private int post_num;
	private String member_id;
	private String user_id;
	private String profile_img;
	private String content;
	private int likecount;
	private int commentcount;
	private Timestamp post_date;
	
	
	public int getPost_num() {
		return post_num;
	}
	public void setPost_num(int post_num) {
		this.post_num = post_num;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getProfile_img() {
		return profile_img;
	}
	public void setProfile_img(String profile_img) {
		this.profile_img = profile_img;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getLikecount() {
		return likecount;
	}
	public void setLikecount(int likecount) {
		this.likecount = likecount;
	}
	public int getCommentcount() {
		return commentcount;
	}
	public void setCommentcount(int commentcount) {
		this.commentcount = commentcount;
	}
	public Timestamp getPost_date() {
		return post_date;
	}
	public void setPost_date(Timestamp post_date) {
		this.post_date = post_date;
	}
}