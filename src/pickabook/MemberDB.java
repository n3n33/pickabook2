package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import pickabook.MemberData;

public class MemberDB {
	private static MemberDB instance = new MemberDB();

	public static MemberDB getInstance() {
		return instance;
	}

	public MemberDB() {
	}

	// 커넥션풀로부터 커넥션객체를 얻어내는 메소드
	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
		return ds.getConnection();
	}

	//회원가입
	public int insertMember(MemberData member) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = getConnection();

			pstmt = conn.prepareStatement("insert into MEMBER values (?,?,?,?,?,?,?,?,?,?)");
			pstmt.setString(1, member.getMember_id());
			pstmt.setString(2, member.getUser_id());
			pstmt.setString(3, member.getPasswd());
			pstmt.setString(4, member.getName());
			pstmt.setString(5, member.getProfile_img());
			pstmt.setString(6, member.getBirth());
			pstmt.setString(7, member.getAge_range());
			pstmt.setString(8, member.getGender());
			pstmt.setString(9, member.getIntro());
			pstmt.setTimestamp(10, member.getReg_date());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) { }
			if (conn != null)
				try { conn.close(); } catch (SQLException ex) { }
		}
		return -1;
	}

	//카카오톡 회원가입
	public void insertKakaoMember(MemberData member) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = getConnection();
			sql = "insert into MEMBER (member_id, user_id, passwd, name, profile_img, age_range, birth, gender, reg_date) ";
			sql += "values (?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getMember_id()); // kakao+카카오톡아이디(숫자)
			pstmt.setString(2, member.getUser_id()); // 사용자 아이디
			pstmt.setString(3, member.getPasswd()); // 처음에는 입력을 안받으니까 일단
			pstmt.setString(4, member.getName()); // nickname
			pstmt.setString(5, member.getProfile_img());
			pstmt.setString(6, member.getAge_range());
			pstmt.setString(7, member.getBirth()); 
			pstmt.setString(8, member.getGender());
			pstmt.setTimestamp(9, member.getReg_date());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) { }
			if (conn != null)
				try { conn.close(); } catch (SQLException ex) { }
		}
	}

	//구글 회원가입
	public void insertGoogleMember(MemberData member) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = getConnection();
			sql = "insert into MEMBER (member_id, user_id, passwd, name, profile_img, reg_date) values (?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getMember_id());
			pstmt.setString(2, member.getUser_id());
			pstmt.setString(3, member.getPasswd());
			pstmt.setString(4, member.getName());
			pstmt.setString(5, member.getProfile_img());
			pstmt.setTimestamp(6, member.getReg_date());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) { }
			if (conn != null)
				try { conn.close(); } catch (SQLException ex) { }
		}
	}

	//아이디 중복확인
	public int confirmID(String user_id) {
		int res = -1;
		String sql = "select user_id from member where user_id=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				res = 1;
			} else {
				res = -1;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return res;
	}
	
	//이전 비번 맞는지 확인 (setting.jsp)에서 사용
	public int confirmPW(String passwd, String member_id) {
		String sql = "select passwd from member where member_id=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String pwd = "";
		int res = 0;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				pwd = rs.getString("passwd"); 
				if(pwd.equals(passwd))
					res = 1;//이전 비번 맞음
				else
					res = -1;	//이전 비번 틀림			
			}
			return res;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return res;
	}
	
	//로그인시 아이디 및 비번 확인
	public int memberCheck(String id, String passwd) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String dbpasswd = "";
		int x = -1;

		try {
			conn = getConnection();

			pstmt = conn.prepareStatement("select passwd from member where user_id = ? ");
			pstmt.setString(1, id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				dbpasswd = rs.getString("passwd");
				if (dbpasswd.equals(passwd))
					x = 1; // 인증 성공
				else
					x = 0; // 비밀번호 틀림
			} else
				x = -1;// 해당 아이디 없음

		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return x;
	}
	
	//카카오톡, 구글 중복 가입 방지
	public int findMember_id(String member_id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int res = -1;
		try {
			conn = getConnection();
			String sql = "select member_id from member where member_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				res = 1;
			} else {
				res = -1;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return res;
	}

	//프로필 이미지 수정
    public int updateMember(MemberData member, String member_id) throws Exception {
       Connection conn = null;
       PreparedStatement pstmt = null;

       try {
          conn = getConnection();

          pstmt = conn.prepareStatement("update MEMBER set profile_img=? where member_id=?");
          pstmt.setString(1, member.getProfile_img());
          pstmt.setString(2, member_id);
          pstmt.executeUpdate();
       } catch (Exception e) {
          e.printStackTrace();
       } finally {
          if (pstmt != null)
             try {pstmt.close();} catch (SQLException ex) { }
          if (conn != null)
             try { conn.close(); } catch (SQLException ex) { }
       }
       return -1;
    }
	
	//회원삭제
	public int deleteMember(String member_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int x = -1;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("delete from member where member_id = ? ");
			pstmt.setString(1, member_id);
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) { }
			if (conn != null)
				try { conn.close(); } catch (SQLException ex) { }
		}
		return x;
	}

	
	//user_id에 해당하는 member_id가져오기	
	public String getMember_id(String user_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String member_id = "";

		try {
			conn = getConnection();

			pstmt = conn.prepareStatement("select member_id from member where user_id = ? ");
			pstmt.setString(1, user_id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				member_id = rs.getString("member_id");
			}
			return member_id;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return null;
	}

	//member_id에 해당하는 user_id가져오기
	public String getUser_id(String member_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String user_id = "";

		try {
			conn = getConnection();

			pstmt = conn.prepareStatement("select user_id from member where member_id = ? ");
			pstmt.setString(1, member_id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				user_id = rs.getString("user_id");
			}
			return user_id;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return null;
	}

	//사용자 정보 - post.jsp 사용
	public MemberData getInfoMember(String member_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MemberData member = null;

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member where member_id = ?");
			pstmt.setString(1, member_id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				member = new MemberData();
				member.setMember_id(rs.getString("member_id"));
				member.setUser_id(rs.getString("user_id"));
				member.setName(rs.getString("name"));
				member.setProfile_img(rs.getString("profile_img"));
				member.setAge_range(rs.getString("age_range"));
				member.setBirth(rs.getString("birth"));
				member.setGender(rs.getString("gender"));
				member.setIntro(rs.getString("intro"));
				member.setReg_date(rs.getTimestamp("reg_date"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return member;
	}	

	//사용자 검색 - search.jsp에서 사용
	public List<MemberData> searchMembers(String query) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<MemberData> memList = null;

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member where user_id like ?");
			pstmt.setString(1, "%" + query + "%");
			rs = pstmt.executeQuery();

			if (rs.next()) {
				memList = new ArrayList<MemberData>();
				do {
					MemberData member = new MemberData();
					member.setMember_id(rs.getString("member_id"));
					member.setUser_id(rs.getString("user_id"));
					member.setName(rs.getString("name"));
					member.setProfile_img(rs.getString("profile_img"));
					member.setAge_range(rs.getString("age_range"));
					member.setBirth(rs.getString("birth"));
					member.setGender(rs.getString("gender"));
					member.setIntro(rs.getString("intro"));
					member.setReg_date(rs.getTimestamp("reg_date"));
					memList.add(member);
				} while (rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return memList;
	}

	//포스트 수 - mypage.jsp에서 사용
   public int getPostCount(String member_id) throws Exception {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      int count = 0;
	      
	      try{
	         conn = getConnection();
	                     
	         pstmt = conn.prepareStatement("select count(*) from post where member_id = ?");
	         pstmt.setString(1, member_id);   
	         rs =  pstmt.executeQuery();
	         if(rs.next()) {
	            count = rs.getInt(1);
	         }
	         return count;
	      }
	      catch(Exception e) {
	         e.printStackTrace();
	      } finally {
				if (rs != null)
					try {rs.close(); } catch (SQLException ex) {}
				if (pstmt != null)
					try {pstmt.close();} catch (SQLException ex) {}
				if (conn != null)
					try {conn.close();} catch (SQLException ex) {}
			}
	      
	      return -1;
	   }
   
	//팔로워 수 - mypage.jsp에서 사용
	public int getFollowerCount(String member_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select count(*) from FOLLOW where member_id=?");
			pstmt.setString(1, member_id);
			rs = pstmt.executeQuery();		

			if (rs.next()) {
				count = rs.getInt(1);
			}
			return count;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return -1;
	}
	
	//팔로잉 수 - mypage.jsp에서 사용
	public int getFollowingCount(String member_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select count(*) from FOLLOW where follower_id=?");
			pstmt.setString(1, member_id);
			rs = pstmt.executeQuery();		

			if (rs.next()) {
				count = rs.getInt(1);
			}
			return count;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return -1;
	}
	
	//follower_id가 member_id를 팔로우 하고있는지 없는지의 여부
	public int checkFollow(String member_id, String follower_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from FOLLOW where member_id=? and follower_id=?");
			pstmt.setString(1, member_id);
			pstmt.setString(2, follower_id);
			rs = pstmt.executeQuery();		

			if (rs.next()) {
				return 1;//팔로잉
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return -1;
	}
	
	//읽고파 회원 가져오기 - bookInfo.jsp사용
	public List<MemberData> bookPeople(String isbn, String type) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MemberData member = null;
		String sql = "";
		List<MemberData> lists = null;

		try {
			conn = getConnection();

			sql = "select * from member where member_id in " + "(select member_id from book where isbn=? and type=?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, isbn);
			pstmt.setString(2, type);

			rs = pstmt.executeQuery();
			lists = new ArrayList<MemberData>();

			while (rs.next()) {
				member = new MemberData();

				member.setMember_id(rs.getString("member_id"));
				member.setUser_id(rs.getString("user_id"));
				member.setName(rs.getString("name"));
				member.setProfile_img(rs.getString("profile_img"));
				member.setAge_range(rs.getString("age_range"));
				member.setBirth(rs.getString("birth"));
				member.setGender(rs.getString("gender"));
				member.setIntro(rs.getString("intro"));
				lists.add(member);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {rs.close(); } catch (SQLException ex) {}
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) {}
			if (conn != null)
				try {conn.close();} catch (SQLException ex) {}
		}
		return lists;
	}
	
	//멤버 자기소개 수정 (post.jsp - info 부분)
	public void updateIntro(String intro, String member_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("update MEMBER set intro=? where member_id=?");
			pstmt.setString(1, intro);
			pstmt.setString(2, member_id);
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) { }
			if (conn != null)
				try { conn.close(); } catch (SQLException ex) { }
		}
	}
	
	//프로필 정보 수정 - setting,settingpro.jsp에서 사용
    public int updateProfile(MemberData member, String member_id) throws Exception {
       Connection conn = null;
       PreparedStatement pstmt = null;
       String sql = "";
       try {
          conn = getConnection();
          sql = "update MEMBER set user_id=?, passwd=?, name=?, gender=?, birth=?, intro=? where member_id=?";
          pstmt = conn.prepareStatement(sql);
          pstmt.setString(1, member.getUser_id());
          pstmt.setString(2, member.getPasswd());
          pstmt.setString(3, member.getName());
          pstmt.setString(4, member.getGender());
          pstmt.setString(5, member.getBirth());
          pstmt.setString(6, member.getIntro());
          pstmt.setString(7, member_id);
          pstmt.executeUpdate();
       } catch (Exception e) {
          e.printStackTrace();
       } finally {
          if (pstmt != null)
             try {pstmt.close();} catch (SQLException ex) { }
          if (conn != null)
             try { conn.close(); } catch (SQLException ex) { }
       }
       return -1;
    }
}