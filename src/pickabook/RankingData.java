package pickabook;

public class RankingData {
	private String user_id;
	private int count;
	private int category_num;
	private int user_rank;	
	private int real_rank;	
	private int percentage;
		
	private int post_num;

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public int getCategory_num() {
		return category_num;
	}

	public void setCategory_num(int category_num) {
		this.category_num = category_num;
	}

	public int getUser_rank() {
		return user_rank;
	}

	public void setUser_rank(int user_rank) {
		this.user_rank = user_rank;
	}

	public int getReal_rank() {
		return real_rank;
	}

	public void setReal_rank(int real_rank) {
		this.real_rank = real_rank;
	}

	public int getPercentage() {
		return percentage;
	}

	public void setPercentage(int percentage) {
		this.percentage = percentage;
	}

	public int getPost_num() {
		return post_num;
	}

	public void setPost_num(int post_num) {
		this.post_num = post_num;
	}
	

}