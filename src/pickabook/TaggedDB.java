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

public class TaggedDB {
	private static TaggedDB instance = new TaggedDB();
	
	public static TaggedDB getInstance() {
		return instance;
	}
	
	public TaggedDB() {
		
	}
	
	// 커넥션풀로부터 커넥션객체를 얻어내는 메소드
	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
		return ds.getConnection();
	}
	
	public void insertTagged(TaggedData tagged) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("insert into TAGGED (post_num, tag_num) values (?, ?)");
			pstmt.setInt(1, tagged.getPost_num());
			pstmt.setInt(2, tagged.getTag_num());
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
	
	public void updateTagged(List<TaggedData> taggedList, int post_num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";
		
		try {	
			conn = getConnection();
			sql = "delete from TAGGED where post_num=?"; //이전 태그 먼저 지우기
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_num);
			pstmt.executeUpdate();
			
			for(int i=0; i<taggedList.size(); i++) {
				TaggedData tagged = taggedList.get(i);
				insertTagged(tagged); //다시 삽입
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null)
				try {pstmt.close();} catch (SQLException ex) { }
			if (conn != null)
				try { conn.close(); } catch (SQLException ex) { }
		}
	}
}
