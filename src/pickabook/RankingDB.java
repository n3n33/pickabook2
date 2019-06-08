package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import pickabook.RankingData;

public class RankingDB {

	private static RankingDB instance = new RankingDB();

	public static RankingDB getInstance() {
		return instance;
	}

	private RankingDB() {
	}

	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
		return ds.getConnection();
	}
	
	// 사용자 랭킹 목록
	public List<RankingData> getRnkList(int category_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";
		ResultSet rs = null;
		List<RankingData> rnkList = null;

		try {
			conn = getConnection();
			sql = "select user_id, category_num, count, @rank := @rank + 1 as user_rank, " + 
					"@real_rank := if ( @last > count, @real_rank := @real_rank+1, @real_rank) as real_rank, " +
					"@last := count " +
					"from " + 
					"(select m.user_id, pb.category_num, count(*) as count " + 
					"from post p, post_book pb, member m " + 
					"where p.post_num = pb.post_num " + 
					"and p.member_id = m.member_id " + 
					"and pb.category_num = ? " + 
					"group by m.user_id " + 
					"order by count desc limit 0, 5) sub1 " + 
					"cross join (select @rank := 0, @last := 0, @real_rank := 1) sub2";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, category_num);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				rnkList = new ArrayList<RankingData>();
				do {
					RankingData ranking = new RankingData();
					ranking.setUser_id(rs.getString("user_id"));
					ranking.setCount(rs.getInt("count"));
					ranking.setReal_rank(rs.getInt("real_rank"));
					rnkList.add(ranking);
				} while (rs.next());
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
		return rnkList;
	}
	
	// 내 랭킹
	   public List<RankingData> getMyRanking(int category_num, String member_id) throws Exception {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      String sql = "";
	      ResultSet rs = null;
	      List<RankingData> MyRnk = null;

	      try {
	         conn = getConnection();
	         sql = "select user_id, category_num, count, @rank := @rank + 1 as user_rank, " + 
	               "@real_rank := if ( @last > count, @real_rank := @real_rank+1, @real_rank) as real_rank, " + 
	               "@last := count " + 
	               "from " + 
	               "(select m.user_id, pb.category_num, count(*) as count " + 
	               "from post p, post_book pb, member m " + 
	               "where p.post_num = pb.post_num " + 
	               "and p.member_id = m.member_id " + 
	               "and pb.category_num = ? " + 
	               "group by m.user_id " + 
	               "order by count desc) sub1 " + 
	               "cross join ( " + 
	               "select @rank := 0, @last := 0, @real_rank := 1, count(member_id) as count2 " + 
	               "from favorite_category " + 
	               "where category_num = ?) sub2";
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, category_num);
	         pstmt.setInt(2, category_num);
	         rs = pstmt.executeQuery();

	         if (rs.next()) {
	            MyRnk = new ArrayList<RankingData>();
	            do {
	               RankingData ranking = new RankingData();
	               ranking.setUser_id(rs.getString("user_id"));
	               ranking.setCount(rs.getInt("count"));
	               ranking.setReal_rank(rs.getInt("real_rank"));
	               MyRnk.add(ranking);
	            } while (rs.next());
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
	      return MyRnk;
	   }
	   
	// 내랭킹 null일 때
	      public List<RankingData> getMyRankingNull(String member_id, int category_num) throws Exception {
	         Connection conn = null;
	         PreparedStatement pstmt = null;
	         String sql = "";
	         ResultSet rs = null;
	         List<RankingData> rnkNull = null;

	         try {
	            conn = getConnection();
	            sql = "select pb.post_num " + 
	                  "from post p, post_book pb " + 
	                  "where p.post_num = pb.post_num " + 
	                  "and p.member_id = ? " + 
	                  "and pb.category_num = ?";
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, member_id);
	            pstmt.setInt(2, category_num);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	               rnkNull = new ArrayList<RankingData>();
	               do {
	                  RankingData mynull = new RankingData();
	                  mynull.setPost_num(rs.getInt("post_num"));
	                  rnkNull.add(mynull);
	               } while (rs.next());
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
	         return rnkNull;
	      }
}