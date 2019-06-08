package pickabook;

//post테이블에 데이터 삽입시 사용
public class TagData {
   private int tag_num;
   private String name;
   private int tag_rank;
   public int getTag_num() {
      return tag_num;
   }
   public void setTag_num(int tag_num) {
      this.tag_num = tag_num;
   }
   public String getName() {
      return name;
   }
   public void setName(String name) {
      this.name = name;
   }
   public int getTag_rank() {
      return tag_rank;
   }
   public void setTag_rank(int tag_rank) {
      this.tag_rank = tag_rank;
   }   
}