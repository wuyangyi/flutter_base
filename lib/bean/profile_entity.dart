import 'package:flutter_base/bean/user_bean_entity.dart';

class ProfileEntity {
	bool isLogin;
	UserBeanEntity user;

	ProfileEntity({this.isLogin, this.user});

	ProfileEntity.fromJson(Map<String, dynamic> json) {
		isLogin = json['isLogin'];
		user = UserBeanEntity.fromJson(json['user']);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['isLogin'] = this.isLogin;
		data['user'] = this.user == null ? null : this.user?.toJson();
		return data;
	}
}
