package pickabook;

import java.sql.Timestamp;

public class FollowData {
	private String user_id;
	private String member_id; //팔로우 받는 쪽
	private String follower_id; //팔로우 하는 쪽
	private Timestamp follow_date;
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getFollower_id() {
		return follower_id;
	}
	public void setFollower_id(String follower_id) {
		this.follower_id = follower_id;
	}
	public Timestamp getFollow_date() {
		return follow_date;
	}
	public void setFollow_date(Timestamp follow_date) {
		this.follow_date = follow_date;
	}
}
