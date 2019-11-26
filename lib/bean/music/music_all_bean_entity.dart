import '../base_bean.dart';

class MusicAllBeanEntity extends BaseBean {
	int sortId;
	int sin;
	int sum;
	int uin;
	int ein;
	List<MusicAllBeanList> xList;
	int categoryId;

	MusicAllBeanEntity({this.sortId, this.sin, this.sum, this.uin, this.ein, this.xList, this.categoryId});

	MusicAllBeanEntity.fromJson(Map<String, dynamic> json) {
		sortId = json['sortId'];
		sin = json['sin'];
		sum = json['sum'];
		uin = json['uin'];
		ein = json['ein'];
		if (json['list'] != null) {
			xList = new List<MusicAllBeanList>();(json['list'] as List).forEach((v) { xList.add(new MusicAllBeanList.fromJson(v)); });
		}
		categoryId = json['categoryId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sortId'] = this.sortId;
		data['sin'] = this.sin;
		data['sum'] = this.sum;
		data['uin'] = this.uin;
		data['ein'] = this.ein;
		if (this.xList != null) {
      data['list'] =  this.xList.map((v) => v.toJson()).toList();
    }
		data['categoryId'] = this.categoryId;
		return data;
	}
}

class MusicAllBeanList extends BaseBean {
	String imgurl;
	int score;
	String dissid;
	String createtime;
	MusicAllBeanListCreator creator;
	int listennum;
	String dissname;
	String commitTime;
	int version;
	String introduction;

	MusicAllBeanList({this.imgurl, this.score, this.dissid, this.createtime, this.creator, this.listennum, this.dissname, this.commitTime, this.version, this.introduction});

	MusicAllBeanList.fromJson(Map<String, dynamic> json) {
		imgurl = json['imgurl'];
		score = json['score'];
		dissid = json['dissid'];
		createtime = json['createtime'];
		creator = json['creator'] != null ? new MusicAllBeanListCreator.fromJson(json['creator']) : null;
		listennum = json['listennum'];
		dissname = json['dissname'];
		commitTime = json['commit_time'];
		version = json['version'];
		introduction = json['introduction'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['imgurl'] = this.imgurl;
		data['score'] = this.score;
		data['dissid'] = this.dissid;
		data['createtime'] = this.createtime;
		if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
		data['listennum'] = this.listennum;
		data['dissname'] = this.dissname;
		data['commit_time'] = this.commitTime;
		data['version'] = this.version;
		data['introduction'] = this.introduction;
		return data;
	}
}

class MusicAllBeanListCreator {
	int qq;
	String avatarUrl;
	String encryptUin;
	String name;
	int followflag;
	int type;
	int isVip;

	MusicAllBeanListCreator({this.qq, this.avatarUrl, this.encryptUin, this.name, this.followflag, this.type, this.isVip});

	MusicAllBeanListCreator.fromJson(Map<String, dynamic> json) {
		qq = json['qq'];
		avatarUrl = json['avatarUrl'];
		encryptUin = json['encrypt_uin'];
		name = json['name'];
		followflag = json['followflag'];
		type = json['type'];
		isVip = json['isVip'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['qq'] = this.qq;
		data['avatarUrl'] = this.avatarUrl;
		data['encrypt_uin'] = this.encryptUin;
		data['name'] = this.name;
		data['followflag'] = this.followflag;
		data['type'] = this.type;
		data['isVip'] = this.isVip;
		return data;
	}
}
