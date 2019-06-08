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

public class CategoryDB {

	private static CategoryDB instance = new CategoryDB();

	public static CategoryDB getInstance() {
		return instance;
	}

	private CategoryDB() {
	}

	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/pickabook");
		return ds.getConnection();
	}
	
	// 카테고리 가져오기
	public List<CategoryData> getCategoryList() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";
		ResultSet rs = null;
		List<CategoryData> categoryList = null;

		try {
			conn = getConnection();
			sql = "select * from category";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				categoryList = new ArrayList<CategoryData>();
				do {
					CategoryData category = new CategoryData();
					category.setCategory_num(rs.getInt("category_num"));
					category.setName(rs.getString("name"));
					categoryList.add(category);
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
		return categoryList;
	}

}
