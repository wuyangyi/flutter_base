class ChessGameInfoBeanEntity {
	int id;
	bool bottomIsRed; //我方为红棋
	String gameType; //游戏类别："双人对战"："人机对战"
	String reason; //结束原因："主将被吃"： "时间到了" ："认输"："和棋"："重开"
	String winner; //胜利者："红棋"："黑棋"："平局"："重开局"
	int allGameTime; //时间总长（秒）
	String startTime; //开始时间2019-12-20 10:10:10
	String endTime; //结束时间2019-12-20 10:10:10
	bool collect; //是否收藏该比赛

	ChessGameInfoBeanEntity({this.bottomIsRed, this.gameType, this.reason, this.winner, this.allGameTime, this.startTime, this.endTime});

	upCollect() {
		collect = !collect;
	}

	ChessGameInfoBeanEntity.fromJson(Map<String, dynamic> json) {
		bottomIsRed = json['bottomIsRed'].toString() == "true";
		gameType = json['gameType'];
		reason = json['reason'];
		winner = json['winner'];
		allGameTime = json['allGameTime'];
		startTime = json['startTime'];
		endTime = json['endTime'];
		id = json['_id'];
		collect = json['collect'].toString() == "true";
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['bottomIsRed'] = this.bottomIsRed.toString();
		data['gameType'] = this.gameType;
		data['reason'] = this.reason;
		data['winner'] = this.winner;
		data['allGameTime'] = this.allGameTime;
		data['startTime'] = this.startTime;
		data['endTime'] = this.endTime;
		data['collect'] = this.collect.toString();
		return data;
	}
}
