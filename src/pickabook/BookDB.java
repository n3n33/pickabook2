package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BookDB {

   private static BookDB instance = new BookDB();

   public static BookDB getInstance() {
      return instance;
   }

   private BookDB() {
   }

   private Connection getConnection() throws Exception {
      Context initCtx = new InitialContext();
      Context envCtx = (Context) initCtx.lookup("java:comp/env");
      DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
      return ds.getConnection();
   }

   public int insertBook(BookData book) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      String sql = "";

      try {
         conn = getConnection();
         if (checkBook(book) == 0) {
            sql = "update book set type=?, book_date=? where member_id=? and isbn=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getType());
            pstmt.setTimestamp(2, book.getBook_date());
            pstmt.setString(3, book.getMember_id());
            pstmt.setString(4, book.getIsbn());
         }
         else {
            sql = "insert into BOOK values (?,?,?,?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getMember_id());
            pstmt.setString(2, book.getIsbn());
            pstmt.setTimestamp(3, book.getBook_date());
            pstmt.setString(4, book.getType());
         }
         return pstmt.executeUpdate();
         
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
      return -1; // db�삤瑜�
   }

   public List<BookData> getBookList(String member_id, String type) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      List<BookData> bookList = null;

      try {
         conn = getConnection();

         pstmt = conn.prepareStatement("select * from BOOK where member_id=? and type=? order by book_date desc");
         pstmt.setString(1, member_id);
         pstmt.setString(2 ,type);
         rs = pstmt.executeQuery();

         if (rs.next()) {
            bookList = new ArrayList<BookData>();
            do {
               BookData book = new BookData();
               book.setMember_id(rs.getString("member_id"));
               book.setIsbn(rs.getString("isbn"));
               book.setType(rs.getString("type"));
               book.setBook_date(rs.getTimestamp("book_date"));
               bookList.add(book);
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
      return bookList;
   }
   
   public void deleteBook(String member_id, String isbn) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;

      try {
         conn = getConnection();
         pstmt = conn.prepareStatement("delete from BOOK where member_id=? and isbn=?");
         pstmt.setString(1, member_id);
         pstmt.setString(2, isbn);
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

   public int checkBook(BookData book) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;

      try {
         conn = getConnection();
         pstmt = conn.prepareStatement("select * from BOOK where member_id=? and isbn=?");
         pstmt.setString(1, book.getMember_id());
         pstmt.setString(2, book.getIsbn());
         rs = pstmt.executeQuery();

         if (rs.next()) {
            return 0;
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
      return 1;
   }
   
   //책 상태 수정
   public void updateBook(BookData book) throws Exception {
      Connection conn = null;
      PreparedStatement pstmt = null;

      try {
         conn = getConnection();
         pstmt = conn.prepareStatement("update book set type=? where isbn=?");
         pstmt.setString(1, book.getType());
         pstmt.setString(2, book.getIsbn());
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
   
   public String bookType(String isbn, String member_id) throws Exception {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      String type = "";

	      try {
	         conn = getConnection();

	         pstmt = conn.prepareStatement("select type from book where isbn = ? and member_id=? ");
	         pstmt.setString(1, isbn);
	         pstmt.setString(2, member_id);
	         rs = pstmt.executeQuery();
	         if(rs.next()) {
	            type = rs.getString("type");
	            System.out.println(type);
	            return type;
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
	      return type;
	   }
}