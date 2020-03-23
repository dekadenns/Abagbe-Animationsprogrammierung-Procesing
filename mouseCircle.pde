class Circle {

  float x, y, rad;

  Circle(float _x, float _y, float _r) {
    x = _x;
    y = _y;
    rad = _r;
  }

  void update(float _x, float _y) { //aktuelle Mausposition
    x = _x;
    y = _y;
  }

  void updateR(float _r) {
    rad = _r;
  }

  boolean checkCircle(Char _c) {  //Check if Char is in Circle
    if (dist(_c.x, _c.y, x, y)< rad) return true;
    else return false;
  }
}
