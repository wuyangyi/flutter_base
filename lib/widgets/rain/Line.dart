
class Line {
   double x1;
   double y1;
   double x2;
   double y2;

   Line(double x1, double y1, double x2, double y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }

   Line.src(Line src) {
    this.x1 = src.x1;
    this.y1 = src.y1;
    this.x2 = src.x2;
    this.y2 = src.y2;
  }

   void set(double x1, double y1,double x2, double y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }

  void negate() {
    x1 = -x1;
    y1 = -y1;
    x2 = -x2;
    y2 = -y2;
  }

  void offset(double dx, double dy) {
    x1 += dx;
    y1 += dy;
    x2 += dx;
    y2 += dy;
  }

  bool equals(double x1, double y1,double x2, double y2) {
    return this.x1 == x1 && this.y1 == y1 && this.x2 == x2 && this.y2 == y2;
  }

  bool equal(Line p) {
    return this.x1 == p.x1 && this.y1 == p.y1 && this.x2 == p.x2 && this.y2 == p.y2;
  }

   String toString() {
    return "Line(" + x1.toString() + ", " + y1.toString() +  x2.toString() + ", " + y2.toString() +")";
  }
}