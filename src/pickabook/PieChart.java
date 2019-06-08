package pickabook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.json.JSONObject;

public class PieChart {
   private static PieChart instance = new PieChart();

   public static PieChart getInstance() {
      return instance;
   }

   private PieChart() {
   }
   private Connection getConnection() throws Exception {
        Context initCtx = new InitialContext();
        Context envCtx = (Context) initCtx.lookup("java:comp/env");
        DataSource ds = (DataSource)envCtx.lookup("jdbc/pickabook");
        return ds.getConnection();
    }
   
   public String getPieChart(String member_id) {
      String sql =   "select c.name as category_name, count(p.category_num) as amount from category c, post_book p"+
		        " where c.category_num = p.category_num"+
		        " and p.post_num in (select post_num from post where member_id =?)"
		        +" group by p.category_num";


      Connection con = null;
      PreparedStatement pstm = null;
      ResultSet rs = null;
      String piestring = null;
      List<JSONObject> pielist = new LinkedList<JSONObject>();
          try {
             con = getConnection();
                pstm = con.prepareStatement(sql);
              pstm.setString(1,member_id);
              rs = pstm.executeQuery();          
              JSONObject responseObj = new JSONObject();
              JSONObject pieObj = null;
              while (rs.next()) {
                  String category_name = rs.getString("category_name");
                  int amount = rs.getInt("amount");
                  pieObj = new JSONObject();
                  pieObj.put("category_name", category_name);
                  pieObj.put("amount", amount);
                  pielist.add(pieObj);
              }
              responseObj.put("pielist",pielist);
               piestring = responseObj.toString();
              //responseObj.put("pielist",pielist);
              //System.out.print(responseObj.toString());
       
          } catch (Exception e) {
              e.printStackTrace();
          } finally {
              if (con != null) {
                  try {
                      con.close();
                  } catch (Exception e) {
                      e.printStackTrace();
                  }
              }
          }
         return piestring;
         
   }
   
}