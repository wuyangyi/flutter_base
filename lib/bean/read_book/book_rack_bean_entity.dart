class BookRackBeanEntity {
	int userId;
	String cover;
	String bookName;
	String bookId;

	BookRackBeanEntity({this.cover, this.bookName, this.bookId, this.userId});

	BookRackBeanEntity.fromJson(Map<String, dynamic> json) {
		cover = json['cover'];
		bookName = json['bookName'];
		bookId = json['bookId'];
		userId = json['userId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['cover'] = this.cover;
		data['bookName'] = this.bookName;
		data['bookId'] = this.bookId;
		data['userId'] = this.userId;
		return data;
	}
}
