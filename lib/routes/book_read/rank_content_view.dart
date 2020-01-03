import 'package:flutter/material.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/bean/read_book/rank_type_bean_entity.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/routes/book_read/book_item.dart';
import 'package:flutter_base/widgets/status_widget.dart';

//排行榜正文Tab部分
class RankContentView extends StatefulWidget {

  final List<RankTypeBeanFemale> data;
  int leftIndex;
  final BuildContext parentContext;

  RankContentView(this.data, {this.leftIndex = 0, this.parentContext});

  @override
  _RankContentViewState createState() => _RankContentViewState(data != null && leftIndex < data.length ? data[leftIndex] : null);
}

class _RankContentViewState extends State<RankContentView> {

  RankTypeBeanFemale rankTypeBeanFemale;

  _RankContentViewState(this.rankTypeBeanFemale);

  RankBeanEntity mRankBeanEntity;
  int loadStatus = Status.loading;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      loadStatus = Status.loading;
    });
    if (rankTypeBeanFemale == null) {
      return;
    }
    NetClickUtil().getRankBookList(rankTypeBeanFemale.sId, callBack: (RankBeanEntity rankBean){
      setState(() {
        mRankBeanEntity = rankBean;
        if (mRankBeanEntity.ranking.books == null && mRankBeanEntity.ranking.books.isEmpty) {
          loadStatus = Status.empty;
        } else {
          loadStatus = Status.success;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 80.0,
            child: ListView.separated(
              itemCount: widget.data.length,
              separatorBuilder: (context, index){
                return index == widget.data.length - 1 ? Container() :
                Container(
                  width: double.infinity,
                  height: 0.5,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  color: MyColors.loginDriverColor,
                );
              },
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.leftIndex = index;
                      rankTypeBeanFemale = widget.data[widget.leftIndex];
                    });
                    initData();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    alignment: Alignment.center,
                    color: widget.leftIndex == index ? MyColors.loginDriverColor : Colors.transparent,
                    child: Text(
                      widget.data[index].shortTitle,
                      style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            width: 0.5,
            height: double.infinity,
            color: MyColors.loginDriverColor,
          ),

          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: loadStatus != Status.success ? StatusView(
                status: loadStatus,
                enableEmptyClick: false,
              ) : ListView.builder(
                itemCount: mRankBeanEntity?.ranking?.books?.length ?? 0,
                itemBuilder: (context, index){
                  return BookItem(
                    mRankBeanEntity.ranking.books[index],
                    index: index,
                    parentContext: widget?.parentContext,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
