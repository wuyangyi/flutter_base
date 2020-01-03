//评论
import 'dart:convert';

import 'package:flutter_base/bean/base_bean.dart';

class BookSendCommentBeanEntity extends BaseBean {
	int commitNumber; //评论该评论的条数
	int level; //当前几级评论(1, 2)
	int grade; //平分(只有一级评论才有)
	bool isRead; //接收消息的人是否阅读了
	int id; //评论id
	List<int> likeUserId; //点赞的用户id
	String content; //评论的内容
	int parentId; //父评论id（若为一级评论，则parentId为-1）
	String parentContent; //父评论内容（若为一级评论，则parentContent为''）
	int likeNumber; //点赞的人数
	String bookId; //书id
	String bookCover; //书的封面
	String bookName; //书名
	String bookAuthor; //书的作者
	String sendTime; //评论时间(2019-12-31 16:57:20)
	CommitUserInfo sendUser; //评论的用户
	CommitUserInfo receiverUser; //被评论的用户（若为一级评论，则无此项）

	BookSendCommentBeanEntity({this.commitNumber, this.level, this.grade = -1, this.isRead, this.id, this.likeUserId, this.content, this.parentId = -1, this.likeNumber, this.bookId, this.bookName, this.bookCover, this.bookAuthor, this.sendTime, this.sendUser, this.receiverUser, this.parentContent});

	BookSendCommentBeanEntity.fromJson(Map<String, dynamic> json) {
		commitNumber = json['commitNumber'];
		level = json['level'];
		grade = json['grade'];
		isRead = json['isRead'] == "true";
		id = json['id'];
		likeUserId = [];
		if(json['likeUserId'] != null) {
			List list = jsonDecode(json['likeUserId']) as List;
			list.forEach((item){
				likeUserId.add(item as int);
			});
		}
		content = json['content'];
		parentId = json['parentId'];
		likeNumber = json['likeNumber'];
		bookId = json['bookId'];
		sendTime = json['sendTime'];
		if (json['sendUser'] != null) {
			sendUser = CommitUserInfo.fromJson(jsonDecode(json['sendUser']));
		}
		if (json['receiverUser'] != null) {
			receiverUser = CommitUserInfo.fromJson(jsonDecode(json['receiverUser']));
		}
		bookCover = json['bookCover'];
		bookName = json['bookName'];
		bookAuthor = json['bookAuthor'];
		parentContent = json['parentContent'] ?? '';
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['commitNumber'] = this.commitNumber;
		data['level'] = this.level;
		data['grade'] = this.grade;
		data['isRead'] = this.isRead.toString();
		data['id'] = this.id;
		data['likeUserId'] = this.likeUserId == null ? [] : jsonEncode(this.likeUserId);
		data['content'] = this.content;
		data['parentId'] = this.parentId;
		data['likeNumber'] = this.likeNumber;
		data['bookId'] = this.bookId;
		data['sendTime'] = this.sendTime;
		data['sendUser'] = jsonEncode(this.sendUser.toJson());
		data['receiverUser'] = this.receiverUser == null ? null : jsonEncode(this?.receiverUser?.toJson());
		data['bookCover'] = this.bookCover;
		data['bookName'] = this.bookName;
		data['bookAuthor'] = this.bookAuthor;
		data['parentContent'] = this.parentContent ?? "";
		return data;
	}
}

class CommitUserInfo {
	int userId;
	String userName;
	String sex;
	String logo;

	CommitUserInfo({this.userId, this.userName, this.sex, this.logo});

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['userId'] = this.userId;
		data['userName'] = this.userName;
		data['sex'] = this.sex;
		data['logo'] = this.logo;
		return data;
	}

	CommitUserInfo.fromJson(Map<String, dynamic> json) {
		userId = json['userId'];
		userName = json['userName'];
		sex = json['sex'];
		logo = json['logo'];
	}
}
