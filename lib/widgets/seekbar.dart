import 'package:flutter/material.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/event_bus.dart';

class MusicSeekBar extends StatefulWidget {

  final double height;
  final double value;
  final Color bgColor; //背景色
  final Color color; //值的颜色
  final Function onValueChange;

  const MusicSeekBar({Key key,
    this.height = 8.0,
    this.value,
    this.bgColor = const Color(0x10000000),
    this.color = MyColors.seekBar_color,
    this.onValueChange,}) : super(key: key);

  @override
  _MusicSeekBarState createState() => _MusicSeekBarState(value);
}

class _MusicSeekBarState extends State<MusicSeekBar> {

  bool down = false;
  double value;

  _MusicSeekBarState(double v) {
    if (!down) {
      value = v;
    }
  }

  @override
  void initState() {
    super.initState();
    bus.on(EventBusString.MUSIC_PROGRESS, (progress){
      setState(() {
        if (!down) {
          value = progress;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusString.MUSIC_PROGRESS);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) { //按下
        setState(() {
          down = true;
          value = (event.position.dx - (DataConfig.appSize.width - context.size.width) / 2) / context.size.width;
          value = value > 1 ? 1 : value;
          value = value < 0 ? 0 : value;
        });
        if (widget.onValueChange != null) {
          widget.onValueChange(value);
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        setState(() {
          value = (event.position.dx - (DataConfig.appSize.width - context.size.width) / 2) / context.size.width;
          value = value > 1 ? 1 : value;
          value = value < 0 ? 0 : value;
        });
        if (widget.onValueChange != null) {
          widget.onValueChange(value);
        }
      },
      onPointerUp: (PointerUpEvent event) {
        setState(() {
          value = (event.position.dx - (DataConfig.appSize.width - context.size.width) / 2) / context.size.width;
          value = value > 1 ? 1 : value;
          value = value < 0 ? 0 : value;
          down = false;
        });
        if (widget.onValueChange != null) {
          widget.onValueChange(value);
        }
      },
      child: CustomPaint(
        size: Size(double.infinity, widget.height),
        painter: MusicSeekBarPainter(value: value, down: down),
      ),
    );
  }
}


class MusicSeekBarPainter extends CustomPainter{

  final double value;
  final Color bgColor; //背景色
  final Color color; //值的颜色
  final bool down; //是否按下

  MusicSeekBarPainter({
    this.value = 0.0,
    this.bgColor = const Color(0xAAF2F1F3),
    this.color = MyColors.seekBar_color,
    this.down = false, });

  var paintL = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    paintL.strokeWidth = size.height / 6;
    //先绘制背景
    paintL.color = bgColor;
    canvas.drawLine(Offset(0.0, size.height / 2), Offset(size.width, size.height / 2), paintL);

    //先绘制前景
    paintL.color = color;
    canvas.drawLine(Offset(0.0, size.height / 2), Offset(value * size.width, size.height / 2), paintL);

    //绘制圆
    paintL.color = Colors.white;
    paintL.strokeWidth = down ? size.height : size.height / 2;
    canvas.drawCircle(Offset(value * size.width, size.height / 2), size.height / 2, paintL);
  }

  @override
  bool shouldRepaint(MusicSeekBarPainter oldDelegate) {
    return true;
  }

}