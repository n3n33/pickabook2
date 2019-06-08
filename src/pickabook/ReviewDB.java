package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ReviewDB {

	private static ReviewDB instance = new ReviewDB();

	public static ReviewDB getInstance() {
		return instance;
	}

	private ReviewDB() {
	}

	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
		return ds.getConnection();
	}

	public void insertReview(ReviewData review) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = getConnection();

			pstmt = conn.prepareStatement("insert into review (isbn, member_id, content, review_date) values (?,?,?,?)");
			pstmt.setString(1, review.getIsbn());
			pstmt.setString(2, review.getMember_id());
			pstmt.setString(3, review.getContent());
			pstmt.setTimestamp(4, review.getReview_date());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}
	}

	public List<ReviewData> getReviewList(String isbn) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ReviewData review = null;
		String sql = "";
		List<ReviewData> lists = null;

		try {
			conn = getConnection();
			sql = "select r.*, m.user_id, m.profile_img from review r, member m "
					+ "where r.member_id = m.member_id and isbn =? order by review_date desc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, isbn);
			rs = pstmt.executeQuery();
			
			lists = new ArrayList<ReviewData>();
			
			while (rs.next()) {
				review = new ReviewData();
				review.setReview_num(rs.getInt("review_num"));
				review.setIsbn(rs.getString("isbn"));
				review.setMember_id(rs.getString("member_id"));
				review.setContent(rs.getString("content"));
				review.setReview_date(rs.getTimestamp("review_date"));
				review.setUser_id(rs.getString("user_id"));
				review.setProfile_img(rs.getString("profile_img"));
				lists.add(review);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}
		return lists;
	}
	
	public void updateReview(String content, int review_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = getConnection();			
			
			pstmt = conn.prepareStatement("update review set content = ? where review_num = ?");
			pstmt.setString(1, content);
			pstmt.setInt(2, review_num);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}
	}
	
	public void deleteReview(int review_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = getConnection();			
			
			pstmt = conn.prepareStatement("delete from review where review_num = ?");
			pstmt.setInt(1, review_num);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}
	}
	
	public int getReviewCount(String isbn) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int x = 0;

		try {
			conn = getConnection();			
			
			pstmt = conn.prepareStatement("select count(*) as review_count from review where isbn = ?");
			pstmt.setString(1, isbn);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return x = rs.getInt("review_count");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}
		return -1;
	}
}
