//排行榜小说
import 'package:flutter_base/bean/base_bean.dart';

class RankBeanEntity extends BaseBean {
	RankBeanRanking ranking;
	bool ok;

	RankBeanEntity({this.ranking, this.ok});

	RankBeanEntity.fromJson(Map<String, dynamic> json) {
		ranking = json['ranking'] != null ? new RankBeanRanking.fromJson(json['ranking']) : null;
		ok = json['ok'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.ranking != null) {
      data['ranking'] = this.ranking.toJson();
    }
		data['ok'] = this.ok;
		return data;
	}
}

class RankBeanRanking extends BaseBean {
	bool xNew;
	String gender;
	String biTag;
	String totalRank;
	String created;
	String icon;
	String monthRank;
	String shortTitle;
	bool isSub;
	String title;
	int priority;
	String cover;
	int total;
	List<RankBeanRankingBook> books;
	int iV;
	String sId;
	String tag;
	String id;
	String updated;
	bool collapse;

	RankBeanRanking({this.xNew, this.gender, this.biTag, this.totalRank, this.created, this.icon, this.monthRank, this.shortTitle, this.isSub, this.title, this.priority, this.cover, this.total, this.books, this.iV, this.sId, this.tag, this.id, this.updated, this.collapse});

	RankBeanRanking.fromJson(Map<String, dynamic> json) {
		xNew = json['new'];
		gender = json['gender'];
		biTag = json['biTag'];
		totalRank = json['totalRank'];
		created = json['created'];
		icon = json['icon'];
		monthRank = json['monthRank'];
		shortTitle = json['shortTitle'];
		isSub = json['isSub'];
		title = json['title'];
		priority = json['priority'];
		cover = json['cover'];
		total = json['total'];
		if (json['books'] != null) {
			books = new List<RankBeanRankingBook>();(json['books'] as List).forEach((v) { books.add(new RankBeanRankingBook.fromJson(v)); });
		}
		iV = json['__v'];
		sId = json['_id'];
		tag = json['tag'];
		id = json['id'];
		updated = json['updated'];
		collapse = json['collapse'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['new'] = this.xNew;
		data['gender'] = this.gender;
		data['biTag'] = this.biTag;
		data['totalRank'] = this.totalRank;
		data['created'] = this.created;
		data['icon'] = this.icon;
		data['monthRank'] = this.monthRank;
		data['shortTitle'] = this.shortTitle;
		data['isSub'] = this.isSub;
		data['title'] = this.title;
		data['priority'] = this.priority;
		data['cover'] = this.cover;
		data['total'] = this.total;
		if (this.books != null) {
      data['books'] =  this.books.map((v) => v.toJson()).toList();
    }
		data['__v'] = this.iV;
		data['_id'] = this.sId;
		data['tag'] = this.tag;
		data['id'] = this.id;
		data['updated'] = this.updated;
		data['collapse'] = this.collapse;
		return data;
	}
}

class RankBeanRankingBook extends BaseBean {
	String cover;
	String site;
	String majorCate;
	String author;
	String minorCate;
	bool allowMonthly;
	String retentionRatio;
	int latelyFollower;
	String sId;
	int banned;
	String title;
	String shortIntro;

	int sizeType;
	String superScript;
	String contentType;
	String lastChapter;
	List<String> tags;

	RankBeanRankingBook({this.cover, this.site, this.majorCate, this.author, this.minorCate, this.allowMonthly, this.retentionRatio, this.latelyFollower, this.sId, this.banned, this.title, this.shortIntro, this.sizeType, this.superScript, this.contentType, this.lastChapter, this.tags});

	RankBeanRankingBook.fromJson(Map<String, dynamic> json) {
		cover = json['cover'];
		site = json['site'];
		majorCate = json['majorCate'];
		author = json['author'];
		minorCate = json['minorCate'];
		allowMonthly = json['allowMonthly'];
		retentionRatio = json['retentionRatio'].toString();
		latelyFollower = json['latelyFollower'];
		sId = json['_id'];
		banned = json['banned'];
		title = json['title'];
		shortIntro = json['shortIntro'];
		sizeType = json['sizetype'];
		superScript = json['superscript'];
		contentType = json['contentType'];
		lastChapter = json['lastChapter'];
		if (json['tags'] != null) {
			tags = new List<String>();(json['tags'] as List).forEach((v) { tags.add(v); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['cover'] = this.cover;
		data['site'] = this.site;
		data['majorCate'] = this.majorCate;
		data['author'] = this.author;
		data['minorCate'] = this.minorCate;
		data['allowMonthly'] = this.allowMonthly;
		data['retentionRatio'] = this.retentionRatio;
		data['latelyFollower'] = this.latelyFollower;
		data['_id'] = this.sId;
		data['banned'] = this.banned;
		data['title'] = this.title;
		data['shortIntro'] = this.shortIntro;
		data['sizetype'] = this.sizeType;
		data['superscript'] = this.superScript;
		data['contentType'] = this.contentType;
		data['lastChapter'] = this.lastChapter;
		if (this.tags != null) {
			data['tags'] =  this.tags.map((v) => v.toString()).toList();
		}
		return data;
	}
}
