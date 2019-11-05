import 'package:flutter_base/bean/base_bean.dart';

class MyCoinDescInfoBeanEntity {
	MyCoinDescInfoBeanData data;
	int errorCode;
	String errorMsg;

	MyCoinDescInfoBeanEntity({this.data, this.errorCode, this.errorMsg});

	MyCoinDescInfoBeanEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new MyCoinDescInfoBeanData.fromJson(json['data']) : null;
		errorCode = json['errorCode'];
		errorMsg = json['errorMsg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['errorCode'] = this.errorCode;
		data['errorMsg'] = this.errorMsg;
		return data;
	}
}

class MyCoinDescInfoBeanData {
	bool over;
	int pageCount;
	int total;
	int curPage;
	int offset;
	int size;
	List<MyCoinDescInfoBeanDataData> datas;

	MyCoinDescInfoBeanData({this.over, this.pageCount, this.total, this.curPage, this.offset, this.size, this.datas});

	MyCoinDescInfoBeanData.fromJson(Map<String, dynamic> json) {
		over = json['over'];
		pageCount = json['pageCount'];
		total = json['total'];
		curPage = json['curPage'];
		offset = json['offset'];
		size = json['size'];
		if (json['datas'] != null) {
			datas = new List<MyCoinDescInfoBeanDataData>();(json['datas'] as List).forEach((v) { datas.add(new MyCoinDescInfoBeanDataData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['over'] = this.over;
		data['pageCount'] = this.pageCount;
		data['total'] = this.total;
		data['curPage'] = this.curPage;
		data['offset'] = this.offset;
		data['size'] = this.size;
		if (this.datas != null) {
      data['datas'] =  this.datas.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class MyCoinDescInfoBeanDataData extends BaseBean {
	int date;
	String reason;
	int id;
	int type;
	String userName;
	int userId;
	int coinCount;
	String desc;

	MyCoinDescInfoBeanDataData({this.date, this.reason, this.id, this.type, this.userName, this.userId, this.coinCount, this.desc});

	MyCoinDescInfoBeanDataData.fromJson(Map<String, dynamic> json) {
		date = json['date'];
		reason = json['reason'];
		id = json['id'];
		type = json['type'];
		userName = json['userName'];
		userId = json['userId'];
		coinCount = json['coinCount'];
		desc = json['desc'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['date'] = this.date;
		data['reason'] = this.reason;
		data['id'] = this.id;
		data['type'] = this.type;
		data['userName'] = this.userName;
		data['userId'] = this.userId;
		data['coinCount'] = this.coinCount;
		data['desc'] = this.desc;
		return data;
	}
}
