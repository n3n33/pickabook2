package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class PostDB {
   
    private static PostDB instance = new PostDB();
    
    public static PostDB getInstance() {
        return instance;
    }
    
    private PostDB() { }
   
   private Connection getConnection() throws Exception {
       Context initCtx = new InitialContext();
       Context envCtx = (Context) initCtx.lookup("java:comp/env");
       DataSource ds = (DataSource)envCtx.lookup("jdbc/pickabook");
       return ds.getConnection();
   }
   
   //게시글 삽입 후 -> post_num 리턴
   public int insertPost(PostData post) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      String sql = "";
                 
      try{
         conn = getConnection();
         sql = "insert into post(member_id, content, post_date) values (?,?,?)";         
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, post.getMember_id());
         pstmt.setString(2, post.getContent());
         pstmt.setTimestamp(3, post.getPost_date());
         
         if(pstmt.executeUpdate() == 1) {
            pstmt = conn.prepareStatement("select max(post_num) as post_num from post where member_id=?");
            pstmt.setString(1, post.getMember_id());
            rs = pstmt.executeQuery();
            if(rs.next()) {
               return rs.getInt("post_num");
            }   
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
      return -1;
   }
   
   public void insertPostBook(PostBookData pbook) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         String sql = "";
                    
         try{
            conn = getConnection();
            sql = "insert into post_book values (?,?,?,?,?)";         
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pbook.getPost_num());
            pstmt.setString(2, pbook.getIsbn());
            pstmt.setString(3, pbook.getBook_title());
            pstmt.setInt(4, pbook.getStar_rate());
            pstmt.setInt(5, pbook.getCategory_num());
            pstmt.executeUpdate();    
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
      }
   
   public void deletePost(int post_num) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
                    
         try{
            conn = getConnection();
                        
            pstmt = conn.prepareStatement("delete from post where post_num =?");
            pstmt.setInt(1, post_num);
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
   
   public void updatePost(PostData post) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
                    
         try{
            conn = getConnection();
                        
            pstmt = conn.prepareStatement("update post set content=? where post_num =?");
            pstmt.setString(1, post.getContent());
            pstmt.setInt(2, post.getPost_num());
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
   
   public void updatePostBook(PostBookData pbook) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
                    
         try{
            conn = getConnection();                        
            pstmt = conn.prepareStatement("update post_book set star_rate=? where post_num =?");
            pstmt.setInt(1, pbook.getStar_rate());
            pstmt.setInt(2, pbook.getPost_num());
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
   
   //main.jsp에서 사용
   public List<PostListData> getPosts(String member_id, int start, int end) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         List<PostListData> postList = null;
         String sql = "";
         
         try{
            conn = getConnection();
            sql = "select p.*, m.user_id, m.profile_img "
                  + "from post as p, member as m "
                  + "where p.member_id = m.member_id and m.member_id in "
                  + "(select member_id from member where member_id=? or member_id in (select member_id from follow where follower_id=?)) "
                  + "order by post_date desc limit ?,?";
            pstmt = conn.prepareStatement(sql);         
            pstmt.setString(1, member_id);        
            pstmt.setString(2, member_id); 
            pstmt.setInt(3, start);
            pstmt.setInt(4, end);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
               postList = new ArrayList<PostListData>();
               do {
                  PostListData post = new PostListData();
                  post.setPost_num(rs.getInt("post_num")); 
                  post.setMember_id(rs.getString("member_id"));
                  post.setUser_id(rs.getString("user_id"));
                  post.setProfile_img(rs.getString("profile_img"));
                  post.setContent(rs.getString("content")); 
                  post.setLikecount(this.getLikeCount(rs.getInt("post_num")));
                  post.setCommentcount(this.getCommentCount(rs.getInt("post_num")));
                  post.setPost_date(rs.getTimestamp("post_date"));
                  postList.add(post);
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
            return postList;
      }
   
   //내 게시글 목록 - post.jsp에서 사용
   public List<PostListData> getMyPosts(String id, int start, int end) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      List<PostListData> postList = null;
      String sql = "";
      
      try{
         conn = getConnection();
         sql = "select p.*, m.user_id, m.profile_img from post as p, member as m "
               + "where p.member_id = m.member_id and p.member_id = ?"
               + "order by post_date desc limit ?,?";
         pstmt = conn.prepareStatement(sql);         
         pstmt.setString(1, id);      
         pstmt.setInt(2, start);      
         pstmt.setInt(3, end); 
         rs = pstmt.executeQuery();
         
         if(rs.next()) {
            postList = new ArrayList<PostListData>();
            do {
               PostListData post = new PostListData();
               post.setPost_num(rs.getInt("post_num")); 
               post.setMember_id(rs.getString("member_id"));
               post.setUser_id(rs.getString("user_id"));
               post.setProfile_img(rs.getString("profile_img"));
               post.setContent(rs.getString("content")); 
               post.setLikecount(this.getLikeCount(rs.getInt("post_num")));
               post.setCommentcount(this.getCommentCount(rs.getInt("post_num")));
               post.setPost_date(rs.getTimestamp("post_date"));
               postList.add(post);
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
         return postList;
   }
   
   //독후감인 게시글 가져오기- post.jsp에서 사용 
   public PostListData getPost(int post_num) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      PostListData post = null;
      String sql = "";
      
      try{
         conn = getConnection();
         sql = "select p.*, m.user_id, m.profile_img "
               + "from post as p, member as m "
               + "where p.member_id = m.member_id and p.post_num = ? "
               + "order by post_date desc";
         pstmt = conn.prepareStatement(sql);         
         pstmt.setInt(1, post_num); 
         rs = pstmt.executeQuery();
         
         if(rs.next()) {
            post = new PostListData();
            post.setPost_num(rs.getInt("post_num")); 
            post.setMember_id(rs.getString("member_id"));
            post.setUser_id(rs.getString("user_id"));
            post.setProfile_img(rs.getString("profile_img"));
            post.setContent(rs.getString("content"));
            post.setLikecount(this.getLikeCount(rs.getInt("post_num")));
             post.setCommentcount(this.getCommentCount(rs.getInt("post_num")));
             post.setPost_date(rs.getTimestamp("post_date"));
         }
      } catch(Exception e) { 
         e.printStackTrace();
      } finally {
         if (rs != null)
            try {rs.close(); } catch (SQLException ex) {}
         if (pstmt != null)
            try {pstmt.close();} catch (SQLException ex) {}
         if (conn != null)
            try {conn.close();} catch (SQLException ex) {}
      }
      return post;
   }
   
   //독후감인 게시글 가져오기- post.jsp에서 사용 
   public PostBookData getPostBook(int post_num) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      PostBookData postbook = null;
      String sql = "";
      
      try{
         conn = getConnection();
         sql = "select * from post_book where post_num=?";
         pstmt = conn.prepareStatement(sql);         
         pstmt.setInt(1, post_num); 
         rs = pstmt.executeQuery();
         
         if(rs.next()) {
            postbook = new PostBookData();
            postbook.setPost_num(rs.getInt("post_num")); 
            postbook.setIsbn(rs.getString("isbn"));
            postbook.setBook_title(rs.getString("book_title"));
            postbook.setStar_rate(rs.getInt("star_rate"));
         }
      } catch(Exception e) { 
         e.printStackTrace();
      } finally {
         if (rs != null)
            try {rs.close(); } catch (SQLException ex) {}
         if (pstmt != null)
            try {pstmt.close();} catch (SQLException ex) {}
         if (conn != null)
            try {conn.close();} catch (SQLException ex) {}
      }
         return postbook;
   }
   
   public ArrayList<String> getIsbnList(String member_id) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      ArrayList<String> isbnArr = new ArrayList<String>();
      
      try{
         conn = getConnection();
         pstmt = conn.prepareStatement("select isbn from post_book where post_num in (select post_num from post where member_id=?)");   
         pstmt.setString(1, member_id);
         rs = pstmt.executeQuery();
         
         if(rs.next()) {
            do {
               isbnArr.add(rs.getString("isbn"));                  
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
         return isbnArr;
   }
   
   public int getLikeCount(int post_num) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         int count = 0;
         
         try{
            conn = getConnection();
                        
            pstmt = conn.prepareStatement("select count(*) from likepost where post_num = ?");
            pstmt.setInt(1, post_num);   
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
   
   public int getCommentCount(int post_num) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         int count = 0;
         
         try{
            conn = getConnection();
                        
            pstmt = conn.prepareStatement("select count(*) from comment where post_num = ?");
            pstmt.setInt(1, post_num);   
            rs =  pstmt.executeQuery();
            if(rs.next()) {
               count = rs.getInt(1);
            }
            return count;
         } catch(Exception e) {
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
   
   public List<PostBrowseData> likeCountBrowse(int tag_num, int start, int end, String member_id) throws Exception {
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       PostBrowseData pb = null;
       String sql = "";
       List<PostBrowseData> lists = null;

       try {
          conn = getConnection();
          
          if(tag_num == 0) {   //전체가 선택되었다면
             sql = "select m.user_id, m.profile_img, p.*, pb.* from member m, post p, post_book pb " + 
                  "where p.post_num = pb.post_num and p.member_id = m.member_id and p.member_id != ? " +
                   "group by p.post_num order by pb.star_rate desc, p.post_date desc limit ?,?";
             
             pstmt = conn.prepareStatement(sql);
             pstmt.setString(1, member_id);
             pstmt.setInt(2, start);
             pstmt.setInt(3, end);
          } 
          else {   //해시태그 버튼이 눌렸다면
             sql = "select m.user_id, m.profile_img, p.*, pb.* from member m, post p, post_book pb " + 
                   "where p.post_num = pb.post_num and p.member_id = m.member_id and p.member_id != ? " + 
                   "and p.post_num in (select post_num from tagged where tag_num = ?) " +
                   "group by p.post_num order by pb.star_rate desc, p.post_date desc limit ?,?";   
             
             pstmt = conn.prepareStatement(sql);
             pstmt.setString(1, member_id);
             pstmt.setInt(2, tag_num);
             pstmt.setInt(3, start);
             pstmt.setInt(4, end);
          }         
          
          rs = pstmt.executeQuery();
          
          lists = new ArrayList<PostBrowseData>();
          
          while(rs.next()) {
             pb = new PostBrowseData();
             
             pb.setUser_id(rs.getString("user_id"));
             pb.setProfile_img(rs.getString("profile_img"));
             pb.setMember_id(rs.getString("member_id"));
             pb.setPost_num(rs.getInt("post_num"));
             pb.setContent(rs.getString("content"));
             pb.setPost_date(rs.getTimestamp("post_date"));
             pb.setIsbn(rs.getString("isbn"));
             pb.setBook_title(rs.getString("book_title"));
             pb.setStar_rate(rs.getInt("star_rate"));
             pb.setCategory_num(rs.getInt("category_num"));
             
             lists.add(pb);
          }
          
          
       } catch (Exception ex) {
          ex.printStackTrace();
       } finally {
          if (rs != null)
             try {
                rs.close(); } catch (SQLException ex) {}
          if (pstmt != null)
             try {
                pstmt.close(); } catch (SQLException ex) {}
          if (conn != null)
             try {
                conn.close(); } catch (SQLException ex) {}
       }

       return lists;
    }
   
   //bookinfo, getSearchBooks에서 사용
   public double selectStar(String isbn) throws Exception{
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         double avg;
         
         try {
            conn = getConnection();
            pstmt = conn.prepareStatement("select truncate(avg(star_rate),1) from post_book where isbn = ? group by isbn;");
            pstmt.setString(1, isbn);
            
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
               avg = rs.getDouble(1);
               
               return avg;
            }      
      
         } catch (Exception e) {
            e.printStackTrace();
         } finally {
            
         }   
         return 0;
      }  
 //bookPost.jsp에서 사용됨.. (isbn으로 걸러서 독후감 출력)
   public List<PostBrowseData> getPostListInfo(String isbn, int start, int end) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         PostBrowseData pb = null;
         String sql = "";
         List<PostBrowseData> lists = null;

         try {
            conn = getConnection();
            
            sql = "select p.*, pb.*, m.user_id, m.profile_img "
                     + "from post p, member m, post_book pb "
                     + "where p.member_id = m.member_id and p.post_num = pb.post_num and pb.isbn = ? "
                     + "order by post_date desc limit ?,?";
            pstmt = conn.prepareStatement(sql);         
            pstmt.setString(1, isbn);  
            pstmt.setInt(2, start);
            pstmt.setInt(3, end);
            
            rs = pstmt.executeQuery();
            
            lists = new ArrayList<PostBrowseData>();
            
            while(rs.next()) {
               pb = new PostBrowseData();
               
               pb.setUser_id(rs.getString("user_id"));
               pb.setProfile_img(rs.getString("profile_img"));
               pb.setMember_id(rs.getString("member_id"));
               pb.setPost_num(rs.getInt("post_num"));
               pb.setContent(rs.getString("content"));
               pb.setPost_date(rs.getTimestamp("post_date"));
               pb.setIsbn(rs.getString("isbn"));
               pb.setBook_title(rs.getString("book_title"));
               pb.setStar_rate(rs.getInt("star_rate"));
               pb.setCategory_num(rs.getInt("category_num"));
               
               lists.add(pb);
            }
            
            
         } catch (Exception ex) {
            ex.printStackTrace();
         } finally {
            if (rs != null)
               try {
                  rs.close(); } catch (SQLException ex) {}
            if (pstmt != null)
               try {
                  pstmt.close(); } catch (SQLException ex) {}
            if (conn != null)
               try {
                  conn.close(); } catch (SQLException ex) {}
         }

         return lists;
      }
      //likePage.jsp에서 사용됨.. (내가 좋아요한 게시글을 보여줌)
   public List<PostBrowseData> getPostListLike(String member_id, int start, int end) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         PostBrowseData pb = null;
         String sql = "";
         List<PostBrowseData> lists = null;

         try {
            conn = getConnection();
            
            sql = "select p.*, pb.*, m.user_id, m.profile_img "
                     + "from post p, member m, post_book pb, likepost lp "
                     + "where p.member_id != ? and p.member_id = m.member_id and p.post_num = pb.post_num and lp.member_id = ? and lp.post_num = p.post_num "
                     + "order by post_date desc limit ?,?";
            pstmt = conn.prepareStatement(sql);         
            pstmt.setString(1, member_id);  
            pstmt.setString(2, member_id);  
            pstmt.setInt(3, start);
            pstmt.setInt(4, end);
            
            rs = pstmt.executeQuery();
            
            lists = new ArrayList<PostBrowseData>();
            
            while(rs.next()) {
               pb = new PostBrowseData();
               
               pb.setUser_id(rs.getString("user_id"));
               pb.setProfile_img(rs.getString("profile_img"));
               pb.setMember_id(rs.getString("member_id"));
               pb.setPost_num(rs.getInt("post_num"));
               pb.setContent(rs.getString("content"));
               pb.setPost_date(rs.getTimestamp("post_date"));
               pb.setIsbn(rs.getString("isbn"));
               pb.setBook_title(rs.getString("book_title"));
               pb.setStar_rate(rs.getInt("star_rate"));
               pb.setCategory_num(rs.getInt("category_num"));
               
               lists.add(pb);
            }
            
            
         } catch (Exception ex) {
            ex.printStackTrace();
         } finally {
            if (rs != null)
               try {
                  rs.close(); } catch (SQLException ex) {}
            if (pstmt != null)
               try {
                  pstmt.close(); } catch (SQLException ex) {}
            if (conn != null)
               try {
                  conn.close(); } catch (SQLException ex) {}
         }

         return lists;
      }
   
 //getSearchPosts.jsp에서 사용됨.. (검색한 내용의 결과인 isbn을 이용해 포스트 뿌려주기)
   public List<PostBrowseData> getPostListSearch(String query, int start, int end) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         PostBrowseData pb = null;
         String sql = "";
         List<PostBrowseData> lists = null;

         try {
            conn = getConnection();
            
            sql = "select m.user_id, m.profile_img, p.*, pb.* from post as p "
            		+ "right join post_book as pb on p.post_num = pb.post_num "
            		+ "left join member as m on p.member_id = m.member_id "
            		+ "WHERE concat(p.member_id, content) like ? "
            		+ "or concat(isbn, book_title) like ? "
            		+ "order by post_date desc limit ?,?";
            pstmt = conn.prepareStatement(sql);         
            pstmt.setString(1, "%" + query + "%");        
            pstmt.setString(2, "%" + query + "%");   
            pstmt.setInt(3, start);
            pstmt.setInt(4, end);
            
            rs = pstmt.executeQuery();
            
            lists = new ArrayList<PostBrowseData>();
            
            while(rs.next()) {
               pb = new PostBrowseData();
               
               pb.setUser_id(rs.getString("user_id"));
               pb.setProfile_img(rs.getString("profile_img"));
               pb.setMember_id(rs.getString("member_id"));
               pb.setPost_num(rs.getInt("post_num"));
               pb.setContent(rs.getString("content"));
               pb.setPost_date(rs.getTimestamp("post_date"));
               pb.setIsbn(rs.getString("isbn"));
               pb.setBook_title(rs.getString("book_title"));
               pb.setStar_rate(rs.getInt("star_rate"));
               pb.setCategory_num(rs.getInt("category_num"));
               
               lists.add(pb);
            }
            
            
         } catch (Exception ex) {
            ex.printStackTrace();
         } finally {
            if (rs != null)
               try {
                  rs.close(); } catch (SQLException ex) {}
            if (pstmt != null)
               try {
                  pstmt.close(); } catch (SQLException ex) {}
            if (conn != null)
               try {
                  conn.close(); } catch (SQLException ex) {}
         }

         return lists;
      }
   
   //getSearchPosts.jsp에서 사용됨.. (검색 총 결과)
   public int getPostSearchCount(String query) throws Exception {
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         String sql = "";
         int count = -1;

         try {
            conn = getConnection();
            
            sql = "select count(*) as total_count from post as p "
            		+ "right join post_book as pb on p.post_num = pb.post_num "
            		+ "WHERE concat(p.member_id, content) like ? "
            		+ "or concat(isbn, book_title) like ? "
            		+ "order by post_date desc";
            pstmt = conn.prepareStatement(sql);         
            pstmt.setString(1, "%" + query + "%");        
            pstmt.setString(2, "%" + query + "%");              
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
            	count = rs.getInt("total_count");
                return count;
            }           
            
         } catch (Exception ex) {
            ex.printStackTrace();
         } finally {
            if (rs != null)
               try {
                  rs.close(); } catch (SQLException ex) {}
            if (pstmt != null)
               try {
                  pstmt.close(); } catch (SQLException ex) {}
            if (conn != null)
               try {
                  conn.close(); } catch (SQLException ex) {}
         }

         return count;
      }
   
// 책 추천
   public PostBookData recommendBook()  throws Exception {
     Connection conn = null;
      ResultSet rs = null; 
      Statement stmt = null;
      PostBookData x = null; 
      
      try {
         conn = getConnection();
        String sql = "select pb.isbn, pb.book_title, count(pb.isbn) as count " + 
                "from post p, post_book pb " + 
                "where p.post_num = pb.post_num " + 
                "and date(p.post_date) >= date(subdate(now(), INTERVAL 10 DAY)) " + 
                "and date(p.post_date) <= date(now()) " + 
                "group by pb.isbn " + 
                "order by count desc limit 1";

         stmt = conn.createStatement();
         rs = stmt.executeQuery(sql);
          
         if(rs.next()) {
            x = new PostBookData(); 
            x.setIsbn(rs.getString("isbn"));
            x.setBook_title(rs.getString("book_title"));
            x.setCount(rs.getInt("count"));
         }
      }catch (Exception ex) {
         ex.printStackTrace();
      } finally {
         if (rs != null)
            try {
               rs.close();
            } catch (SQLException ex) {
            }
         if (stmt != null)
            try {
               stmt.close();
            } catch (SQLException ex) {
            }
         if (conn != null)
            try {
               conn.close();
            } catch (SQLException ex) {
            }
      }
      return x;
   }   
   
// 책 추천2
   public BookData recommendBook2()  throws Exception {
     Connection conn = null;
      ResultSet rs = null; 
      Statement stmt = null;
      BookData z = null; 
      
      try {
         conn = getConnection();
        String sql = "select b.isbn, count(b.isbn) as count " + 
              "from book b " + 
              "where date(b.book_date) >= date(subdate(now(), INTERVAL 7 DAY)) " + 
              "and date(b.book_date) <= date(now()) " + 
              "and b.type = 'wish' " + 
              "group by b.isbn " + 
              "order by count desc limit 1";

         stmt = conn.createStatement();
         rs = stmt.executeQuery(sql);
          
         if(rs.next())
            z = new BookData(); 
            z.setIsbn(rs.getString("isbn"));
            z.setCount(rs.getInt("count"));

      }catch (Exception ex) {
         ex.printStackTrace();
      } finally {
         if (rs != null)
            try {
               rs.close();
            } catch (SQLException ex) {
            }
         if (stmt != null)
            try {
               stmt.close();
            } catch (SQLException ex) {
            }
         if (conn != null)
            try {
               conn.close();
            } catch (SQLException ex) {
            }
      }
      return z;
   }
}