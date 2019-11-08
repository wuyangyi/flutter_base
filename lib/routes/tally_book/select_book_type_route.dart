import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:rxdart/rxdart.dart';

class SelectBookTypeRoute extends BaseRoute {
  final int selectIndex;

  SelectBookTypeRoute({this.selectIndex = -1});
  
  @override
  _SelectBookTypeRouteState createState() => _SelectBookTypeRouteState(selectIndex);
}

class _SelectBookTypeRouteState extends BaseRouteState<SelectBookTypeRoute> {
  _SelectBookTypeRouteState(this.select){
    title = "记账场景";
    showStartCenterLoading = false;
    bodyColor = MyColors.home_body_bg;
  }
  int select = -1;

  List<BookTypeBean> data = DataConfig.bookTypes;

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (context, index){
          return Container(
            width: double.infinity,
            height: 0.5,
            color: MyColors.loginDriverColor,
          );
        },
        itemBuilder: (context, index){
          return Material(
            color: Colors.white,
            child: Ink(
              child: InkWell(
                onTap: (){
                  setState(() {
                    select = index;
                  });
                  Observable.just(1).delay(new Duration(milliseconds: 200)).listen((_){
                    finish(data: index);
                  });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 70.0,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        data[index].icon,
                        color: Colors.black45,
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data[index].title,
                                style: TextStyle(
                                  color: MyColors.text_normal_1,
                                  fontSize: 15.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  data[index].desc,
                                  style: TextStyle(
                                    color: MyColors.text_normal,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: index != select,
                        child: Icon(
                          Icons.done,
                          color: MyColors.main_color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },

      )
    );
  }
}
