package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class LikePostDB {
   private static LikePostDB  instance = new LikePostDB ();
    
    public static LikePostDB getInstance() {
        return instance;
    }
   
   private Connection getConnection() throws Exception {
       Context initCtx = new InitialContext();
       Context envCtx = (Context) initCtx.lookup("java:comp/env");
       DataSource ds = (DataSource)envCtx.lookup("jdbc/pickabook");
       return ds.getConnection();
   }
   
   public void insertLike(String member_id, int post_num) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
                 
      try{
         conn = getConnection();
                     
         pstmt = conn.prepareStatement("insert into likepost(member_id, post_num) values (?,?)");
         pstmt.setString(1, member_id);         
         pstmt.setInt(2, post_num);
         pstmt.executeUpdate();
      }
      catch(Exception e) {
         e.printStackTrace();
      }
      finally{
         if (pstmt != null) 
            try { pstmt.close(); } catch(SQLException ex) {}
         if (conn != null) 
            try { conn.close(); } catch(SQLException ex) {}
      }
      
   }
   
   public int checkLike(String member_id, int post_num) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      int x = -1;
      
      try{
         conn = getConnection();
                     
         pstmt = conn.prepareStatement("select * from likepost where member_id = ? and post_num = ?");
         pstmt.setString(1, member_id);         
         pstmt.setInt(2, post_num);
         rs =  pstmt.executeQuery();
         if(rs.next()) {
            x = 1;
         }
         return x;
      }
      catch(Exception e) {
         e.printStackTrace();
      }
      finally{
         if (pstmt != null) 
            try { pstmt.close(); } catch(SQLException ex) {}
         if (conn != null) 
            try { conn.close(); } catch(SQLException ex) {}
      }
      
      return x;
   }


   public void deleteLike(String member_id, int post_num) throws Exception {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	                 
	      try{
	         conn = getConnection();
	                     
	         pstmt = conn.prepareStatement("delete from likepost where member_id=? and post_num=?");
	         pstmt.setString(1, member_id);         
	         pstmt.setInt(2, post_num);
	         pstmt.executeUpdate();
	      }
	      catch(Exception e) {
	         e.printStackTrace();
	      }
	      finally{
	         if (pstmt != null) 
	            try { pstmt.close(); } catch(SQLException ex) {}
	         if (conn != null) 
	            try { conn.close(); } catch(SQLException ex) {}
	      }
	      
	   }
   

   public int getLikePostCount(String member_id) throws Exception {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      int likepost_count = 0;
	                 
	      try{
	         conn = getConnection();
	         String sql = "select count(*) as likepost_count from likepost l, post_book pb, post p "
	         		+ "where l.post_num = pb.post_num and pb.post_num = p.post_num and l.member_id=? and p.member_id !=?";
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, member_id);  
	         pstmt.setString(2, member_id);    
	         rs = pstmt.executeQuery();
	         if(rs.next()) {
	        	likepost_count = rs.getInt("likepost_count"); 
	         }
	         return likepost_count;
	      }
	      catch(Exception e) {
	         e.printStackTrace();
	      }
	      finally{
	         if (pstmt != null) 
	            try { pstmt.close(); } catch(SQLException ex) {}
	         if (conn != null) 
	            try { conn.close(); } catch(SQLException ex) {}
	      }
	      return likepost_count;
	      
	   }
}