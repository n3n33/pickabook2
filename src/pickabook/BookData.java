package pickabook;

import java.sql.Timestamp;

public class BookData {
	private String member_id;
	private String isbn;
	private Timestamp book_date;
	private String type;
	private int count;
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getIsbn() {
		return isbn;
	}
	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public Timestamp getBook_date() {
		return book_date;
	}
	public void setBook_date(Timestamp book_date) {
		this.book_date = book_date;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	

}
