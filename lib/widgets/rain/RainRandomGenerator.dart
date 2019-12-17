import 'dart:math' as Math;

class RainRandomGenerator {
  static final Math.Random RANDOM = new Math.Random();

  // 区间随机
  double getRandom(double lower, double upper) {
    double min = Math.min(lower, upper);
    double max = Math.max(lower, upper);
    return getRandomDouble(max - min) + min;
  }

  // 上界随机
  double getRandomDouble(double upper) {
    return RANDOM.nextDouble() * upper;
  }

  // 上界随机
  int getRandomInt(int upper) {
    return RANDOM.nextInt(upper);
  }


  //随机产生划线的起始点坐标和结束点坐标
   List<double> getLine(double width, double height, bool start) { //创建的时候的就全屏随机
     List<double> tempCheckNum = [0, 0, 0, 0];
     double temp = getRandomWidth(width);
//     for (int i = 0; i < 4; i += 4) {
//      tempCheckNum[i] = temp;
//      tempCheckNum[i + 1] = getRandomDouble(height/6);
//      tempCheckNum[i + 2] = temp;
//      tempCheckNum[i + 3] = getRandomDouble(height/5);
//     }
     tempCheckNum[0] = temp;
     tempCheckNum[1] = start ? getRandomDouble(height) : 0;
     tempCheckNum[2] = temp;
     tempCheckNum[3] = tempCheckNum[1] + getRandomDouble(3) + 4;
     return tempCheckNum;
  }

  double getRandomWidth(double width){
    return getRandomDouble(width);
  }
}