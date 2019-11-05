import 'base_bean.dart';

///用户排行榜
class UserCoinListBeanEntity {
	UserCoinListBeanData data;
	int errorCode;
	String errorMsg;

	UserCoinListBeanEntity({this.data, this.errorCode, this.errorMsg});

	UserCoinListBeanEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new UserCoinListBeanData.fromJson(json['data']) : null;
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

class UserCoinListBeanData {
	bool over;
	int pageCount;
	int total;
	int curPage;
	int offset;
	int size;
	List<UserCoinListBeanDataData> datas;

	UserCoinListBeanData({this.over, this.pageCount, this.total, this.curPage, this.offset, this.size, this.datas});

	UserCoinListBeanData.fromJson(Map<String, dynamic> json) {
		over = json['over'];
		pageCount = json['pageCount'];
		total = json['total'];
		curPage = json['curPage'];
		offset = json['offset'];
		size = json['size'];
		if (json['datas'] != null) {
			datas = new List<UserCoinListBeanDataData>();(json['datas'] as List).forEach((v) { datas.add(new UserCoinListBeanDataData.fromJson(v)); });
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

class UserCoinListBeanDataData extends BaseBean {
	int level;
	int rank;
	int userId;
	int coinCount;
	String username;

	UserCoinListBeanDataData({this.level, this.rank, this.userId, this.coinCount, this.username});

	UserCoinListBeanDataData.fromJson(Map<String, dynamic> json) {
		level = json['level'];
		rank = json['rank'];
		userId = json['userId'];
		coinCount = json['coinCount'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['level'] = this.level;
		data['rank'] = this.rank;
		data['userId'] = this.userId;
		data['coinCount'] = this.coinCount;
		data['username'] = this.username;
		return data;
	}
}
