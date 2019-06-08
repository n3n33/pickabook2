package pickabook;

import java.sql.Timestamp;

public class MemberData {
	private String member_id; // 회원 아이디 = pk
	private String user_id; // 사용자 아이디 = 로그인 등
	private String passwd; // 비밀번호
	private String name; // 이름
	private String profile_img; // 프로필 이미지
	private String age_range; // 연령대
	private String birth; // 생일
	private String gender; // 성별
	private String intro; // 소개
	private Timestamp reg_date; // 가입날짜
	
	
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
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getProfile_img() {
		return profile_img;
	}
	public void setProfile_img(String profile_img) {
		this.profile_img = profile_img;
	}
	public String getAge_range() {
		return age_range;
	}
	public void setAge_range(String age_range) {
		this.age_range = age_range;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getIntro() {
		return intro;
	}
	public void setIntro(String intro) {
		this.intro = intro;
	}
	public Timestamp getReg_date() {
		return reg_date;
	}
	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}
}