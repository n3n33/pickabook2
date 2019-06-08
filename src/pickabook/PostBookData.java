package pickabook;

//postbook테이블에 데이터 삽입시 사용
public class PostBookData {
	private int post_num;
	private String isbn;
	private String book_title;
	private int star_rate;
	private int category_num;
	private int count;
	
	public int getPost_num() {
		return post_num;
	}
	public void setPost_num(int post_num) {
		this.post_num = post_num;
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
	public int getStar_rate() {
		return star_rate;
	}
	public void setStar_rate(int star_rate) {
		this.star_rate = star_rate;
	}
	public int getCategory_num() {
		return category_num;
	}
	public void setCategory_num(int category_num) {
		this.category_num = category_num;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
}