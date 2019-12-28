import 'package:flutter_base/bean/base_bean.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';

class ReadBookBeanEntity extends BaseBean {
	int total;
	List<RankBeanRankingBook> books;
	bool ok;

	ReadBookBeanEntity({this.total, this.books, this.ok});

	ReadBookBeanEntity.fromJson(Map<String, dynamic> json) {
		total = json['total'];
		if (json['books'] != null) {
			books = new List<RankBeanRankingBook>();(json['books'] as List).forEach((v) { books.add(new RankBeanRankingBook.fromJson(v)); });
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