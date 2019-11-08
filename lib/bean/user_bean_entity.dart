import 'dart:convert';

import 'dao/UserDao.dart';

class UserBeanEntity {

	String password;
	String address;
	String phone;
	String sex;
	String birthDate;
	String name;
	String logo;
	UserBeanCoininfo coinInfo;
	int id;
	String synopsis;
	int age;
	bool isFinishInfo;
	String infoBg;

	setBirthDate(String time) {
		this.birthDate = time;
		int year = int.parse(time.substring(0, 4));
		DateTime nowDate = new DateTime.now();
		this.age = nowDate.year - year;
	}

	setLogo(String imagePath) {
		if (imagePath.isNotEmpty) {
			logo = imagePath;
		}
	}


	UserBeanEntity.upDataByLogin(this.phone, this.password, this.id);

	UserBeanEntity({this.password, this.address, this.phone, this.sex, this.birthDate, this.name, this.logo, this.coinInfo, this.id, this.synopsis, this.age});

	UserBeanEntity.fromJson(Map<String, dynamic> jsons) {
		password = jsons['password'];
		address = jsons['address'];
		phone = jsons['phone'];
		sex = jsons['sex'];
		birthDate = jsons['birth_date'];
		name = jsons['name'];
		logo = jsons['logo'];
//		coinInfo = jsons['coinInfo'] != null ? new UserBeanCoininfo.fromJson(jsons['coinInfo']) : null;
		id = jsons['id'];
		synopsis = jsons['synopsis'];
		age = jsons['age'] ?? 0;
		infoBg = jsons['info_bg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['password'] = this.password;
		data['address'] = this.address;
		data['phone'] = this.phone;
		data['sex'] = this.sex;
		data['birth_date'] = this.birthDate;
		data['name'] = this.name;
		data['logo'] = this.logo;
		if (this.coinInfo != null) {
      data['coinInfo'] = this.coinInfo.toJson();
    }
		data['id'] = this.id;
		data['synopsis'] = this.synopsis;
		data['age'] = this.age;
		data['info_bg'] = this.infoBg;
		return data;
	}
}

class UserBeanCoininfo {
	int rank;
	int userId;
	int coinCount;
	String username;

	UserBeanCoininfo({this.rank, this.userId, this.coinCount, this.username});

	UserBeanCoininfo.fromJson(Map<String, dynamic> jsons) {
		rank = jsons['rank'];
		userId = jsons['userId'];
		coinCount = jsons['coinCount'];
		username = jsons['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['rank'] = this.rank;
		data['userId'] = this.userId;
		data['coinCount'] = this.coinCount;
		data['username'] = this.username;
		return data;
	}
}
