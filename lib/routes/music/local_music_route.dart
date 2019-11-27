import 'dart:io';
import 'dart:isolate';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/FlieInfoBean.dart';
import 'package:flutter_base/bean/dao/music/MyLocalMusicDao.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/wait_dialog.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/GradientCircularProgressIndicator.dart';
import 'package:flutter_base/widgets/button.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

/*
 * 扫描本地音乐文件
 */
class LocalMusicRoute extends BaseRoute {
  @override
  _LocalMusicRouteState createState() => _LocalMusicRouteState();
}

class _LocalMusicRouteState extends BaseRouteState<LocalMusicRoute> with SingleTickerProviderStateMixin {

  _LocalMusicRouteState(){
    title = "扫描歌曲";
    appBarElevation = 0.0;
  }

  Directory sdCardDir;
  List<FileInfoBean> files = [];

  LocalMusicModel localMusicModel;

  double angle = 0.0; //旋转的角度

  bool _allSelect = true; //全选
  int selectNumber = 0; //选中的个数

  final double padding = (DataConfig.appSize.width - 100) / 10;

  bool searched = false; //是否已扫描
  bool isStartSearch = false; //是否开始扫描

  Animation<double> animation;
  AnimationController controller;


  @override
  void initState() {
    super.initState();
    localMusicModel = Provider.of<LocalMusicModel>(context, listen: false);
    initData();
    controller = new AnimationController(
        duration: const Duration(seconds: 2), vsync: this);
    animation = new Tween(begin: 0.0, end: math.pi * 2).animate(controller)
      ..addListener(() {
        setState(() {
          angle = animation.value;
        });
      });
  }

  void initData() async {
    sdCardDir = await getExternalStorageDirectory();
    sdCardDir = sdCardDir.parent.parent.parent.parent;
    print("后：${sdCardDir.path}");
//    search(sdCardDir);
  }

  Future search(FileSystemEntity file) async {
    if (file != null) {
      if (FileSystemEntity.isFileSync(file.path)) { //文件
        String fileName = file.path;
        if (fileName.endsWith(".mp3")) {
          FileInfoBean fileInfoBean = new FileInfoBean(
            fileName: fileName.substring(fileName.lastIndexOf("/") + 1, fileName.lastIndexOf(".mp3")),
            path: fileName,
            uri: file.uri,
            check: true
          );
          files.add(fileInfoBean);
          selectNumber++;
        }
        print("文件名：$fileName");
      } else { //文件夹
        List<FileSystemEntity> fs = Directory(file.path).listSync();
        print("文件夹名：${file.path}");
        for (int i = 0; i < fs.length; i++) {
          await search(fs[i]);
        }
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: searched ?
      files.isEmpty ? StatusView(
        status: Status.empty,
        enableEmptyClick: false,
      ) : Container(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 50.0,
              decoration: Decorations.bottom,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                    value: _allSelect,
                    activeColor: MyColors.main_color,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      setState(() {
                        _allSelect = value;
                        for (int i = 0; i < files.length; i++) {
                          files[i].check = _allSelect;
                        }
                        selectNumber = _allSelect ? files.length : 0;
                      });
                    },
                  ),

                  Gaps.hGap10,
                  Text(
                    "全选",
                    style: TextStyle(
                      color: MyColors.text_normal,
                      fontSize: 12.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "已选$selectNumber个",
                        style: TextStyle(
                          color: MyColors.text_normal,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              width: double.infinity,
              height: 0.5,
              color: MyColors.loginDriverColor,
            ),

            Expanded(
              flex: 1,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: 0.5,
                    margin: EdgeInsets.only(left: 10.0),
                    color: MyColors.loginDriverColor,
                  );
                },
                itemCount: files.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.only(left: 10.0),
                    width: double.infinity,
                    height: 50.0,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Checkbox(
                          value: files[index].check,
                          activeColor: MyColors.main_color,
                          onChanged: (value) {
                            setState(() {
                              files[index].check = value;
                              if (value) {
                                selectNumber++;
                              } else {
                                selectNumber--;
                              }
                            });
                          },
                        ),

                        Expanded(
                          flex: 1,
                          child: Text(
                            files[index].fileName,
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Container(
              height: 70.0,
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.5, color: MyColors.loginDriverColor)
                )
              ),
              child: FinishButton(
                text: "添加本地音乐($selectNumber首)",
                radios: 5.0,
                width: double.infinity,
                height: 40.0,
                onTop: () async {
                  showWaitDialog();
                  List<FileInfoBean> data = [];
                  files.forEach((item) {
                    if (item.check) {
                      data.add(item);
                    }
                  });
                  localMusicModel.addAll(data);
                  hideWaitDialog();
                  showToast("成功添加$selectNumber首歌曲");
                  finish();
                },
              ),

            ),

          ],
        ),
      ) : Container(
        padding: EdgeInsets.all(50.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(padding),
                  width: double.infinity,
                  height: DataConfig.appSize.width - 100,
                  decoration: BoxDecoration(
                    color: Color(0x207C4DFF),
                    borderRadius: BorderRadius.circular(360),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(padding),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0x707C4DFF),
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xAA7C4DFF),
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          Util.getImgPath("ico_music_logo"),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),

                Offstage(
                  offstage: !isStartSearch,
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    height: DataConfig.appSize.width - 100,
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: angle,
                      child: GradientCircularProgressIndicator(
                        strokeWidth: padding * 3,
                        colors: [Color(0x007C4DFF), Color(0x207C4DFF), Color(0xFF7C4DFF)],
                        backgroundColor: Colors.transparent,
                        strokeCapRound: false,
                        value: 0.1,
                        radius: padding * 5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "一键扫描手机内的歌曲文件",
                style: TextStyle(
                  color: MyColors.title_color,
                  fontSize: 14.0,
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(),
            ),

            Container(
              margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
              alignment: Alignment.center,
              child: FinishButton(
                text: isStartSearch ? "停止扫描" : "开始扫描",
                radios: 5.0,
                width: double.infinity,
                height: 35.0,
                onTop: () {
                  setState(() {
                    isStartSearch = !isStartSearch;
                  });
                  if (isStartSearch) {
                    controller.repeat();
                    loadData();
                  } else {
                    controller.stop();
                  }

                },
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  Future loadData() async {
    await search(sdCardDir);
    if (isStartSearch) {
      setState(() {
        isStartSearch = false;
        searched = true;
        controller.stop();
      });
    }
  }
}
