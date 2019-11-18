import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/tally_book/tally_details.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';

class TallyListChartRoute extends BaseRoute {

  final List<MyTallyBeanEntity> tallyList;
  final BookItemBean bookItem;
  final String title;

  TallyListChartRoute(this.tallyList, this.bookItem, this.title);

  @override
  _TallyListChartRouteState createState() => _TallyListChartRouteState(tallyList, title);
}

class _TallyListChartRouteState extends BaseRouteState<TallyListChartRoute> {

  _TallyListChartRouteState(this.tallyList, String titleName){
    title = titleName;
    centerTitle = false;
    appBarElevation = 0.0;
    showStartCenterLoading = false;
    bodyColor = MyColors.home_bg;
  }
  List<MyTallyBeanEntity> tallyList;
  int selectIndex = -1; //点击的账单

  @override
  void initState() {
    super.initState();
    bus.on(EventBusString.TALLY_LOADING, (need){
      if (selectIndex != -1 && need) {
        tallyList.removeAt(selectIndex);
        setState(() {
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusString.TALLY_LOADING);
  }


  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView.separated(
        itemCount: tallyList.length,
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 0.5,
            color: MyColors.loginDriverColor,
          );
        },
        itemBuilder: (context, index) {
          return Ink(
            color: Colors.white,
            child: InkWell(
              onTap: (){
                selectIndex = index;
                NavigatorUtil.pushPageByRoute(context, TallyDetailsRoute(tallyList[index],));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 35.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(width: 1.0, color: widget.bookItem?.color)
                      ),
                      child: Icon(
                        widget.bookItem?.icon,
                        color: widget.bookItem?.color,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${tallyList[index].useType}  ${tallyList[index].money}",
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 15.0,
                            ),
                          ),
                          Offstage(
                            offstage: tallyList[index].comment == null || tallyList[index].comment.isEmpty,
                            child: Gaps.vGap5,
                          ),
                          Offstage(
                            offstage: tallyList[index].comment == null || tallyList[index].comment.isEmpty,
                            child: Text(
                              "${tallyList[index].comment}",
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: MyColors.text_normal_5,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}
