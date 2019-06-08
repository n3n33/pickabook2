package pickabook;

import java.sql.Timestamp;

public class PostBrowseData {
   private String user_id;
   private String profile_img;
   private String member_id;
   
   private int post_num;
   private String content;
   private Timestamp post_date;   
   private String isbn;
   private String book_title;
   private int star_rate;
   private int category_num;
   
   public String getUser_id() {
      return user_id;
   }
   public void setUser_id(String user_id) {
      this.user_id = user_id;
   }
   public String getProfile_img() {
      return profile_img;
   }
   public void setProfile_img(String profile_img) {
      this.profile_img = profile_img;
   }
   public String getMember_id() {
      return member_id;
   }
   public void setMember_id(String member_id) {
      this.member_id = member_id;
   }
   
   public int getPost_num() {
      return post_num;
   }
   public void setPost_num(int post_num) {
      this.post_num = post_num;
   }
   public String getContent() {
      return content;
   }
   public void setContent(String content) {
      this.content = content;
   }
   public Timestamp getPost_date() {
      return post_date;
   }
   public void setPost_date(Timestamp post_date) {
      this.post_date = post_date;
   }
   public String getIsbn() {
      return isbn;
   }
   public void setIsbn(String isbn) {
      this.isbn = isbn;
   }
   public String getBook_title() {
      return book_title;
   }
   public void setBook_title(String book_title) {
      this.book_title = book_title;
   }
   public int getStar_rate () {
      return star_rate;
   }
   public void setStar_rate(int star_rate) {
      this.star_rate = star_rate;
   }
   public int getCategory_num () {
      return category_num;
   }
   public void setCategory_num(int category_num) {
      this.category_num = category_num;
   }
}