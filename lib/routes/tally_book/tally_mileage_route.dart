import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/line.dart';
import 'package:flutter_base/widgets/water_wave.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class TallyMileageRoute extends BaseRoute {
  @override
  _TallyMileageRouteState createState() => _TallyMileageRouteState();
}

class _TallyMileageRouteState extends BaseRouteState<TallyMileageRoute> {
  _TallyMileageRouteState(){
    title = "里程碑";
    appBarElevation = 0.0;
  }

  DateTime nowTime = DateTime.now();

  BookModel bookModel;
  TallyModel tallyModel;
  List<MyTallyBeanEntity> tallyList;
  double allMoney = 0.00; //总资产
  double allPay = 0.00; //总支出
  double allIncome = 0.00; //总收入
  int allTallyNumber = 0; //总账单条数
  int allBookNumber = 0; //账本数目

  int monthTallyNumber = 0; //本月账单条数
  double monthPay = 0.00; //本月总支出
  double monthIncome = 0.00; //本月总收入
  double monthMoney = 0.00; //本月收益

  double dayTallyNumber = 0; //今天账单条数
  double dayPay = 0.00; //今天总支出
  double dayIncome = 0.00; //今天总收入
  double dayMoney = 0.00; //今天收益


  @override
  void initState() {
    super.initState();
    bookModel = Provider.of<BookModel>(context, listen: false);
    tallyModel = Provider.of<TallyModel>(context, listen: false);
    bookModel.books.forEach((item){
      allMoney = allMoney + item.pay + item.income;
      allPay += item.pay;
      allIncome += item.income;
    });
    monthTallyNumber = tallyModel.tally.length;
    allBookNumber = bookModel.books.length;
    tallyModel.tally.forEach((item){
      monthMoney += item.money;
      if (item.type == "支出") {
        monthPay += item.money;
      } else {
        monthIncome += item.money;
      }
      if (item.time == "${nowTime.year}-${nowTime.month}-${nowTime.day}") {
        dayTallyNumber++;
        dayMoney = dayMoney + item.money;
        if (item.type == "支出") {
          dayPay += item.money;
        } else {
          dayPay += item.money;
        }
      }
    });
    MyTallyDao().findData(user.id, onCallBack: (data){
      tallyList = data;
      setState(() {
        allTallyNumber = tallyList.length;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 30.0,
              ),
              padding: EdgeInsets.fromLTRB(55.0, 55.0, 55.0, 65.0),
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(Util.getImgPath("ico_paper_bg"),), fit: BoxFit.fill,),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 100.0,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: HeroString.BOOK_MINE_USER_HEAD, //唯一标记
                          child: ClipOval(
                            // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                            child: user?.logo == null ? Image.asset(Util.getImgPath(
                              Util.getUserHeadImageName(user?.sex),),
                              width: 60.0,
                              height: 60.0,
                            ) : Image.file(File(user?.logo), width: 60.0,
                              height: 60.0,),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          alignment: Alignment.center,
                          child: Text(
                            user.name ?? user.phone ?? "",
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "总资产： $allMoney",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "总账本数： $allBookNumber",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "总账单数目： $allTallyNumber",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "总支出： $allPay",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "总收入： $allIncome",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
                          child: MySeparator(
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0, right: 15.0),
                        alignment: Alignment.center,
                        child: Text(
                          "本月里程",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
                          child: MySeparator(
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "本月账单数目： $monthTallyNumber",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "本月总收益： $monthMoney",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "本月总支出： $monthPay",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "本月总收入： $monthIncome",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
                          child: MySeparator(
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0, right: 15.0),
                        alignment: Alignment.center,
                        child: Text(
                          "当天里程",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
                          child: MySeparator(
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "今天账单数目： $dayTallyNumber",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "今天总收益： $dayMoney",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "今天总支出： $dayPay",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                  Gaps.vGap20,
                  Text(
                    "今天总收入： $dayIncome",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
          ),
          Transform.rotate(
            angle: math.pi,
            child: WaveWidget(
              bgColor: Colors.blue,
              size: Size(double.infinity, 20.0),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 10.0),
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "快掉的水里啦~",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
