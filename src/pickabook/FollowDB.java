package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class FollowDB {

   private static FollowDB instance = new FollowDB();

   public static FollowDB getInstance() {
      return instance;
   }

   private FollowDB() {
   }

   private Connection getConnection() throws Exception {
      Context initCtx = new InitialContext();
      Context envCtx = (Context) initCtx.lookup("java:comp/env");
      DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
      return ds.getConnection();
   }

   public void insertFollow(FollowData follow) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;

      try {
         conn = getConnection();
         
         pstmt = conn.prepareStatement("insert into FOLLOW values (?,?,?)");
         pstmt.setString(1, follow.getMember_id());
         pstmt.setString(2, follow.getFollower_id());
         pstmt.setTimestamp(3, follow.getFollow_date());
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
   
   public void deleteFollow(String member_id, String follower_id) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;

      try {
         conn = getConnection();
         
         pstmt = conn.prepareStatement("delete from FOLLOW where member_id=? and follower_id=?");
         pstmt.setString(1, member_id);
         pstmt.setString(2, follower_id);
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
   
   public List<FollowData> selectFollower(String member_id) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      List<FollowData> followerList = null;
      String sql;

      try {
         conn = getConnection();         
         sql = "select follower_id from FOLLOW where member_id=? and follower_id in (select member_id from follow where follower_id = ?) "
               + "UNION "
               + "select follower_id from follow where member_id = ? ";
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, member_id);
         pstmt.setString(2, member_id);
         pstmt.setString(3, member_id);
         rs = pstmt.executeQuery();

         if (rs.next()) {
            followerList = new ArrayList<FollowData>();
            do {
               FollowData follow = new FollowData();
               follow.setFollower_id(rs.getString("follower_id"));
               followerList.add(follow);
            } while (rs.next());
         }
      }catch (Exception e) {
         e.printStackTrace();
      } finally {
         if (rs != null)
            try {rs.close(); } catch (SQLException ex) {}
         if (pstmt != null)
            try {pstmt.close();} catch (SQLException ex) {}
         if (conn != null)
            try {conn.close();} catch (SQLException ex) {}
      }
      return followerList;
   }
   
   public List<FollowData> selectFollowing(String member_id) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      List<FollowData> followerList = null;
      String sql;

      try {
         conn = getConnection();
         sql = "select member_id from follow where follower_id = ? "
               + "and member_id in (select member_id from post group by member_id order by count(*) desc) " 
               + "UNION " 
               + "select member_id from follow where follower_id = ?";
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, member_id);
         pstmt.setString(2, member_id);
         rs = pstmt.executeQuery();

         if (rs.next()) {
            followerList = new ArrayList<FollowData>();
            do {
               FollowData follow = new FollowData();
               follow.setMember_id(rs.getString("member_id"));
               followerList.add(follow);
            } while (rs.next());
         }
      }catch (Exception e) {
         e.printStackTrace();
      } finally {
         if (rs != null)
            try {rs.close(); } catch (SQLException ex) {}
         if (pstmt != null)
            try {pstmt.close();} catch (SQLException ex) {}
         if (conn != null)
            try {conn.close();} catch (SQLException ex) {}
      }
      return followerList;
   }
   
// 사용자 추천 목록
   public List<FollowData> getRecommendList(String member_id) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      String sql = "";
      ResultSet rs = null;
      List<FollowData> recoList = null;

      try {
         conn = getConnection();
         sql = "select distinct member_id " + 
               "from follow " + 
               "where follower_id in " + 
               "(select member_id from follow where follower_id = ?) " + 
               "and member_id not in (select member_id from follow where follower_id = ? or member_id = ?)";
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, member_id);
         pstmt.setString(2, member_id);
         pstmt.setString(3, member_id);
         rs = pstmt.executeQuery();

         if (rs.next()) {
            recoList = new ArrayList<FollowData>();
            do {
               FollowData recommend = new FollowData();
               recommend.setMember_id(rs.getString("member_id"));
               recoList.add(recommend);
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
      return recoList;
   }
   
   // 사용자추천 TOP5
   public List<FollowData> recommendTop5() throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      String sql = "";
      ResultSet rs = null;
      List<FollowData> topList = null;

      try {
         conn = getConnection();
         sql = "select f.member_id, count(f.follower_id) as count " + 
                 "from follow f " + 
                 "group by f.member_id " + 
                 "order by count desc limit 10";
         pstmt = conn.prepareStatement(sql);
         rs = pstmt.executeQuery();

         if (rs.next()) {
            topList = new ArrayList<FollowData>();
            do {
               FollowData top5 = new FollowData();
               top5.setMember_id(rs.getString("member_id"));
               topList.add(top5);
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
      return topList;
   }
}