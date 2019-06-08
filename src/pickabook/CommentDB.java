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

import pickabook.CommentData;

public class CommentDB {

	private static CommentDB instance = new CommentDB();

	public static CommentDB getInstance() {
		return instance;
	}

	private CommentDB() {
	}

	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
		return ds.getConnection();
	}

	// comment테이블에 댓글을 추가(insert문)
	public int insertComment(CommentData comment) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";

		try {
			conn = getConnection();
			sql = "insert into comment(content, comment_date, member_id, post_num)";
			sql += " values(?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getContent());
			pstmt.setTimestamp(2, comment.getComment_date());
			pstmt.setString(3, comment.getMember_id());
			pstmt.setInt(4, comment.getPost_num());
			
	         if(pstmt.executeUpdate() == 1) {
		         pstmt = conn.prepareStatement("select max(comment_num) as comment_num from comment where member_id=?");
		         pstmt.setString(1, comment.getMember_id());
		         rs = pstmt.executeQuery();
		         if(rs.next()) {
		        	 return rs.getInt("comment_num");
		         }   
	         }
		} catch (Exception ex) {
			ex.printStackTrace();
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



	// 댓글 수정 시 사용
	public int updateComment(int comment_num, String content) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = getConnection();					
			sql = "update comment set content=? where comment_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, content);
			pstmt.setInt(2, comment_num);
			pstmt.executeUpdate();
		} 
		catch (Exception ex) {
			ex.printStackTrace();
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
		return -1; // 데이터베이스 오류
	}
	
	// 댓글 삭제 처리 시 사용(delete문)
	public int deleteComment(int comment_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = getConnection();					
			sql = "delete from comment where comment_num=?";
			pstmt = conn.prepareStatement(sql); // 댓글 삭제
			pstmt.setInt(1, comment_num);
			pstmt.executeUpdate();
		} 
		catch (Exception ex) {
			ex.printStackTrace();
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
		return -1; // 데이터베이스 오류
	}
	
	
	// 댓글 목록(복수개)을 가져옴(select문)
	public List<CommentData> getComments(int post_num, int start, int end) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";
		ResultSet rs = null;
		List<CommentData> commentList = null;
		
		try {
			conn = getConnection();
			sql = "select * from comment where post_num = ? order by comment_date desc limit ?,?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_num);
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				commentList = new ArrayList<CommentData>();
				do {
					CommentData comment = new CommentData();
					comment.setComment_num(rs.getInt("comment_num"));
					comment.setContent(rs.getString("content"));
					comment.setComment_date(rs.getTimestamp("comment_date"));
					comment.setMember_id(rs.getString("member_id"));
					comment.setPost_num(rs.getInt("post_num"));

					commentList.add(comment);
				} while (rs.next());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException ex) {
				}
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
		return commentList; // 그 가방을 리턴해주거있음
	}
	
	// 댓글한개 가져옴
	public CommentData getComment(int comment_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";
		ResultSet rs = null;
		CommentData comment = null;
		
		try {
			conn = getConnection();
			sql = "select * from comment where comment_num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, comment_num);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				comment = new CommentData();
				comment.setComment_num(rs.getInt("comment_num"));
				comment.setContent(rs.getString("content"));
				comment.setComment_date(rs.getTimestamp("comment_date"));
				comment.setMember_id(rs.getString("member_id"));
				comment.setPost_num(rs.getInt("comment_num"));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException ex) {
				}
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
		return comment;
	}
}