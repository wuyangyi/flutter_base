import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/utils/utils.dart';

class ImageCut extends StatefulWidget {
  final bool needGridLines;//是否需要网格线
  final String imagePath;

  const ImageCut({Key key,
    this.needGridLines,
    this.imagePath
  }) : super(key: key);
  @override
  _ImageCutState createState() => _ImageCutState();
}

class _ImageCutState extends State<ImageCut> {

  Color bgColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).padding.top,
                color: Colors.white54,
              ),
              Container(
                width: double.infinity,
                height: 45.0,
                alignment: Alignment.center,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.close,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              "取消",
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      width: 0.5,
                      height: double.infinity,
                      color: Color(0xFF999999),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.done,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              "确定",
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 15.0,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Util.getImgPath("user_page_top_bg_02")),
                        ),
                      ),
                      child: CustomPaint(
                        size: Size(double.infinity, double.infinity),
                        painter: ImageGridLinesPainter(

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class ImageGridLinesPainter extends CustomPainter{

  final bool needGridLines;

  Size centerPosition; //方框中心的位置
  double boxSize; //方框的宽高

  var paintLine = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 1
    ..color = Colors.white;

  var paintGridLines = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 0.5
    ..color = Colors.white70;

  var paintBlack = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.black54;

  ImageGridLinesPainter({this.needGridLines = false});

  @override
  void paint(Canvas canvas, Size size) {
    centerPosition = Size(size.width / 2, size.height / 2); //默认中心为图片中心
    boxSize = size.width < size.height ? size.width : size.height;

    double startWidth = centerPosition.width - boxSize / 2;
    double endWidth = centerPosition.width + boxSize / 2;
    double startHeight = centerPosition.height - boxSize / 2;
    double endHeight = centerPosition.height + boxSize / 2;

    canvas.drawLine(Offset(startWidth, startHeight), Offset(startWidth, endHeight), paintLine);
    canvas.drawLine(Offset(startWidth, endHeight), Offset(endWidth, endHeight), paintLine);
    canvas.drawLine(Offset(endWidth, endHeight), Offset(endWidth, startHeight), paintLine);
    canvas.drawLine(Offset(endWidth, startHeight), Offset(startWidth, startHeight), paintLine);

    //画阴影
    //左边
    canvas.drawRect(Rect.fromLTRB(0, 0, centerPosition.width - boxSize / 2, size.height), paintBlack);

    //右边
    canvas.drawRect(Rect.fromLTRB(centerPosition.width + boxSize / 2, 0, size.width, size.height), paintBlack);

    //上
    canvas.drawRect(Rect.fromLTRB(centerPosition.width - boxSize / 2, 0, centerPosition.width + boxSize / 2, centerPosition.height - boxSize / 2), paintBlack);

    //下
    canvas.drawRect(Rect.fromLTRB(centerPosition.width - boxSize / 2, centerPosition.height + boxSize / 2, centerPosition.width + boxSize / 2, size.height), paintBlack);


    if (needGridLines) {
      canvas.drawLine(Offset(startWidth + boxSize / 3, startHeight), Offset(startWidth + boxSize / 3, endHeight), paintGridLines);
      canvas.drawLine(Offset(startWidth + boxSize / 3* 2, startHeight), Offset(startWidth + boxSize / 3* 2, endHeight), paintGridLines);


      canvas.drawLine(Offset(startWidth, startHeight + boxSize / 3), Offset(endWidth, startHeight + boxSize / 3), paintGridLines);
      canvas.drawLine(Offset(startWidth, startHeight + boxSize / 3 * 2), Offset(endWidth, startHeight + boxSize / 3 * 2), paintGridLines);
    }
  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
