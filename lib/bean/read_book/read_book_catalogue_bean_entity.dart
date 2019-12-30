class ReadBookCatalogueBeanEntity {
	List<ReadBookCatalogueBeanChapter> chapters;
	String book;
	String name;
	String link;
	String host;
	String sId;
	String source;
	String updated;

	ReadBookCatalogueBeanEntity({this.chapters, this.book, this.name, this.link, this.host, this.sId, this.source, this.updated});

	ReadBookCatalogueBeanEntity.fromJson(Map<String, dynamic> json) {
		if (json['chapters'] != null) {
			chapters = new List<ReadBookCatalogueBeanChapter>();(json['chapters'] as List).forEach((v) { chapters.add(new ReadBookCatalogueBeanChapter.fromJson(v)); });
		}
		book = json['book'];
		name = json['name'];
		link = json['link'];
		host = json['host'];
		sId = json['_id'];
		source = json['source'];
		updated = json['updated'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.chapters != null) {
      data['chapters'] =  this.chapters.map((v) => v.toJson()).toList();
    }
		data['book'] = this.book;
		data['name'] = this.name;
		data['link'] = this.link;
		data['host'] = this.host;
		data['_id'] = this.sId;
		data['source'] = this.source;
		data['updated'] = this.updated;
		return data;
	}
}

class ReadBookCatalogueBeanChapter {
	String chapterCover;
	int totalpage;
	bool unreadble;
	int partsize;
	String link;
	int currency;
	String sId;
	String id;
	int time;
	String title;
	bool isVip;
	int order;

	ReadBookCatalogueBeanChapter({this.chapterCover, this.totalpage, this.unreadble, this.partsize, this.link, this.currency, this.sId, this.id, this.time, this.title, this.isVip, this.order});

	ReadBookCatalogueBeanChapter.fromJson(Map<String, dynamic> json) {
		chapterCover = json['chapterCover'];
		totalpage = json['totalpage'];
		unreadble = json['unreadble'];
		partsize = json['partsize'];
		link = json['link'];
		currency = json['currency'];
		sId = json['_id'];
		id = json['id'];
		time = json['time'];
		title = json['title'];
		isVip = json['isVip'];
		order = json['order'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['chapterCover'] = this.chapterCover;
		data['totalpage'] = this.totalpage;
		data['unreadble'] = this.unreadble;
		data['partsize'] = this.partsize;
		data['link'] = this.link;
		data['currency'] = this.currency;
		data['_id'] = this.sId;
		data['id'] = this.id;
		data['time'] = this.time;
		data['title'] = this.title;
		data['isVip'] = this.isVip;
		data['order'] = this.order;
		return data;
	}
}
