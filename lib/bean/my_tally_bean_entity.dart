
/*
 * 账单
 */
import 'base_bean.dart';

class MyTallyBeanEntity extends BaseBean {
	String useType; //用途或者来源方式（交通、红包等）
	String address; //地址
	double money; //金额（支出给负数，以便求和）
	int userId; //用户id
	String comment; //简介
	int id; //账单id
	int bookId; //账本id
	String time; //时间(2019-10-5)
	String type; //类别（支出或者收入）
	int year; //年
	int month; //月
	int day; //日

	MyTallyBeanEntity({this.useType, this.address, this.money, this.userId, this.comment, this.bookId, this.time, this.type});

	MyTallyBeanEntity.fromJson(Map<String, dynamic> json) {
		useType = json['use_type'];
		address = json['address'];
		money = json['money'];
		userId = json['user_id'];
		comment = json['comment'];
		id = json['id'];
		bookId = json['book_id'];
		time = json['time'];
		type = json['type'];
		year = json['year'];
		month = json['month'];
		day = json['day'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['use_type'] = this.useType;
		data['address'] = this.address;
		data['money'] = this.money;
		data['user_id'] = this.userId;
		data['comment'] = this.comment;
//		data['id'] = this.id;
		data['book_id'] = this.bookId;
		data['time'] = this.time;
		data['type'] = this.type;
		data['year'] = this.year;
		data['month'] = this.month;
		data['day'] = this.day;
		return data;
	}
}
