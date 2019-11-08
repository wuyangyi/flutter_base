
/*
 * 账本
 */
import 'base_bean.dart';

class MyBookBeanEntity extends BaseBean {
	double income; //收入金额
	int color; //账本颜色
	String createTime; //创建时间
	int userId; //用户id
	String name; //账本名称
	double pay; //支出金额
	int id; //账本id
	String type; //账本类别

	MyBookBeanEntity({this.income, this.color, this.createTime, this.userId, this.name, this.pay, this.type});

	MyBookBeanEntity.fromJson(Map<String, dynamic> json) {
		income = json['income'];
		color = json['color'];
		createTime = json['create_time'];
		userId = json['user_id'];
		name = json['name'];
		pay = json['pay'];
		id = json['id'];
		type = json['type'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['income'] = this.income;
		data['color'] = this.color;
		data['create_time'] = this.createTime;
		data['user_id'] = this.userId;
		data['name'] = this.name;
		data['pay'] = this.pay;
		data['type'] = this.type;
		return data;
	}
}
