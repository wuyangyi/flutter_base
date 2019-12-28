class SearchBookBeanEntity {
	int total;
	List<SearchBookBeanBook> books;
	bool ok;

	SearchBookBeanEntity({this.total, this.books, this.ok});

	SearchBookBeanEntity.fromJson(Map<String, dynamic> json) {
		total = json['total'];
		if (json['books'] != null) {
			books = new List<SearchBookBeanBook>();(json['books'] as List).forEach((v) { books.add(new SearchBookBeanBook.fromJson(v)); });
		}
		ok = json['ok'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['total'] = this.total;
		if (this.books != null) {
      data['books'] =  this.books.map((v) => v.toJson()).toList();
    }
		data['ok'] = this.ok;
		return data;
	}
}

class SearchBookBeanBook {
	bool hasCp;
	String aliases;
	int wordCount;
	String author;
	String superscript;
	bool allowMonthly;
	int latelyFollower;
	String title;
	String lastChapter;
	String shortIntro;
	String cover;
	int sizetype;
	SearchBookBeanBooksHighlight highlight;
	String site;
	String cat;
	String retentionRatio;
	String sId;
	int banned;
	String contentType;

	SearchBookBeanBook({this.hasCp, this.aliases, this.wordCount, this.author, this.superscript, this.allowMonthly, this.latelyFollower, this.title, this.lastChapter, this.shortIntro, this.cover, this.sizetype, this.highlight, this.site, this.cat, this.retentionRatio, this.sId, this.banned, this.contentType});

	SearchBookBeanBook.fromJson(Map<String, dynamic> json) {
		hasCp = json['hasCp'];
		aliases = json['aliases'];
		wordCount = json['wordCount'];
		author = json['author'];
		superscript = json['superscript'];
		allowMonthly = json['allowMonthly'];
		latelyFollower = json['latelyFollower'];
		title = json['title'];
		lastChapter = json['lastChapter'];
		shortIntro = json['shortIntro'];
		cover = json['cover'];
		sizetype = json['sizetype'];
		highlight = json['highlight'] != null ? new SearchBookBeanBooksHighlight.fromJson(json['highlight']) : null;
		site = json['site'];
		cat = json['cat'];
		retentionRatio = json['retentionRatio'].toString();
		sId = json['_id'];
		banned = json['banned'];
		contentType = json['contentType'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['hasCp'] = this.hasCp;
		data['aliases'] = this.aliases;
		data['wordCount'] = this.wordCount;
		data['author'] = this.author;
		data['superscript'] = this.superscript;
		data['allowMonthly'] = this.allowMonthly;
		data['latelyFollower'] = this.latelyFollower;
		data['title'] = this.title;
		data['lastChapter'] = this.lastChapter;
		data['shortIntro'] = this.shortIntro;
		data['cover'] = this.cover;
		data['sizetype'] = this.sizetype;
		if (this.highlight != null) {
      data['highlight'] = this.highlight.toJson();
    }
		data['site'] = this.site;
		data['cat'] = this.cat;
		data['retentionRatio'] = this.retentionRatio;
		data['_id'] = this.sId;
		data['banned'] = this.banned;
		data['contentType'] = this.contentType;
		return data;
	}
}

class SearchBookBeanBooksHighlight {
	List<String> title;
	List<String> author;

	SearchBookBeanBooksHighlight({this.title, this.author});

	SearchBookBeanBooksHighlight.fromJson(Map<String, dynamic> json) {
		title = json['title']?.cast<String>();
		author = json['author']?.cast<String>();
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['title'] = this.title;
		data['author'] = this.author;
		return data;
	}
}
