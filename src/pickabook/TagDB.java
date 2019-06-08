package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TagDB {

   private static TagDB instance = new TagDB();

   public static TagDB getInstance() {
      return instance;
   }

   private TagDB() {
   }

   private Connection getConnection() throws Exception {
      Context initCtx = new InitialContext();
      Context envCtx = (Context) initCtx.lookup("java:comp/env");
      DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
      return ds.getConnection();
   }

   public List<TagData> getTags() throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      List<TagData> tagList = null;

      try {
         conn = getConnection();
         
         pstmt = conn.prepareStatement("select * from tag");
         rs = pstmt.executeQuery();
         
         if (rs.next()) {
            tagList = new ArrayList<TagData>();
            do {
               TagData tag = new TagData();
               tag.setTag_num(rs.getInt("tag_num"));
               tag.setName(rs.getString("name"));
               tagList.add(tag);
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
      return tagList;
   }
   
   public List<TagData> getTaggedTag(int post_num) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         List<TagData> tagList = null;
         String sql = "";
         
         try{
            conn = getConnection();
            //본인 글 포함
            sql = "select * from tag where tag_num in(select tag_num from tagged where post_num=?)";
            pstmt = conn.prepareStatement(sql);         
            pstmt.setInt(1, post_num); 
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
               tagList = new ArrayList<TagData>();
               do {
                  TagData tag = new TagData();
                  tag.setTag_num(rs.getInt("tag_num")); 
                  tag.setName(rs.getString("name"));
                  tagList.add(tag);
                  }           
                  while(rs.next());
               }
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
            return tagList;
      }
   
   public List<TagData> getFavoriteTag(String member_id) throws Exception {
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       List<TagData> tagRankList = null;
       String sql = "";
       
       try{
          conn = getConnection();
          sql = "select tag_num, name, count, @rank := @rank + 1 as tag_rank, " + 
                "@real_rank := if (@last > count, @real_rank := @real_rank+1, @real_rank) as real_rank, @last := count " + 
                "from " + 
                "(select t.tag_num, t.name, count(t.tag_num) as count " + 
                "from tagged tg, tag t, post p " + 
                "where t.tag_num = tg.tag_num " + 
                "and tg.post_num = p.post_num " + 
                "and member_id = ? " + 
                "group by name order by count desc) sub1 " + 
                "cross join (select @rank:=0, @last := 0, @real_rank := 1) sub2";
          pstmt = conn.prepareStatement(sql);         
          pstmt.setString(1, member_id); 
          rs = pstmt.executeQuery();
          
          if(rs.next()) {
             tagRankList = new ArrayList<TagData>();
             do {
                TagData tagRank = new TagData();
                tagRank.setName(rs.getString("name"));
                tagRank.setTag_rank(rs.getInt("tag_rank"));
                tagRankList.add(tagRank);
                
                }           
                while(rs.next());
             }
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
          return tagRankList;
    }
   
   //태그별 포스트 수
    public int getTagCount(int tag_num) throws Exception {
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       int count = 0;
       String sql = "";

       try {
          conn = getConnection();
          if(tag_num == 100000) {
             sql = "select count(*) from post p, post_book pb, tagged t where p.post_num = pb.post_num and t.post_num = p.post_num";
             pstmt = conn.prepareStatement(sql);             
          } else {          
             sql = "select count(*) from post p, post_book pb, tagged t where t.tag_num = ? "
                + "and p.post_num = pb.post_num and t.post_num = p.post_num";
             pstmt = conn.prepareStatement(sql);
              pstmt.setInt(1, tag_num);
             
          }
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
    
    //태그별 포스트 수
    public int getTagCount(int tag_num, String member_id) throws Exception {
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       int count = 0;
       String sql = "";

       try {
          conn = getConnection();
          if(tag_num == 100000) {
             sql = "select count(*) from post p, post_book pb, tagged t where p.post_num = pb.post_num and t.post_num = p.post_num and p.member_id != ?";
             pstmt = conn.prepareStatement(sql); 
             pstmt.setString(1, member_id);
          } else {          
             sql = "select count(*) from post p, post_book pb, tagged t where t.tag_num = ? "
                + "and p.post_num = pb.post_num and t.post_num = p.post_num and p.member_id != ?";
             pstmt = conn.prepareStatement(sql);
              pstmt.setInt(1, tag_num);
              pstmt.setString(2, member_id);
             
          }
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
}