package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class FavoriteCategoryDB {

	private static FavoriteCategoryDB instance = new FavoriteCategoryDB();

	public static FavoriteCategoryDB getInstance() {
		return instance;
	}

	private FavoriteCategoryDB() {
	}

	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
		return ds.getConnection();
	}
	
	// 랭킹 선호 카테고리 가져오기
	public List<CategoryData> getFcategoryList(String member_id) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";
		ResultSet rs = null;
		List<CategoryData> fcategoryList = null;

		try {
			conn = getConnection();
			sql = "select c.category_num, c.name "
					+ "from category c, favorite_category f, member m "
					+ "where c.category_num = f.category_num "
					+ "and f.member_id = m.member_id and m.member_id = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				fcategoryList = new ArrayList<CategoryData>();
				do {
					CategoryData fcategory = new CategoryData();
					fcategory.setCategory_num(rs.getInt("category_num"));
					fcategory.setName(rs.getString("name"));
					fcategoryList.add(fcategory);
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
		return fcategoryList;
	}
	
	// 랭킹 선호 카테고리 가져오기
	public void insertFCategory(FavoriteCategoryData fcategory) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = getConnection();
			sql = "insert into favorite_category values(?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, fcategory.getMember_id());
			pstmt.setInt(2, fcategory.getCategory_num());
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
	
	// 랭킹 선호 카테고리 가져오기
	public void updateFCategory(String session_member, List<FavoriteCategoryData> fcategList) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";

		try {
			conn = getConnection();
			sql = "delete from favorite_category where member_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, session_member);
			pstmt.executeUpdate();

			FavoriteCategoryData fCateg = null;
			for(int i=0; i < fcategList.size(); i++) {
				fCateg = fcategList.get(i);
				insertFCategory(fCateg);
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
	}
}