class Char {
  public float x, y, r, xT, yT, distX, distY, xC, yC;
  public char c, cDecoded;
  public color col;

  Char(float _x, float _y, float _r, char _c) { //Konstruktor
    x = _x;
    y = _y;
    r = _r;
    c = _c;
    cDecoded = _c;
    col = color(255,255,255);
  }

  public void drawChar(int _s) { //Zeichnet Chars
    pushStyle();
    textSize(_s);
    fill(col);
    text(c, x, y);
    popStyle();
  }

  public void fallingChar() { // Höhenveränderung für fallende Chars
    if (y < height-16) y = y + random(5, 15);
  }

  public void setT(float _xT, float _yT) {//setze Zielposition
    xT = _xT;
    yT = _yT;
    if (x < xT) distX = xT -x;
    else distX = x -xT;
    distY = y - yT;
  }

  public void flyingChar() { //lässt Char von (zufälliger) Startposition zu Zielposition fliegen
    if (x < xT) { 
      x = x + distX/40;
      if (xT - x < 0)x = xT;
    }
    if (x > xT) {
      x = x - distX/40;
      if (x - xT < 0) x = xT;
    }
    if (y > yT) {
      y = y - distY/40;
    }
    if (y < yT) y = yT;
  }
  
  public void changeBoden(int _start, int _end) {//Bewegung der Chars am Boden
    if ((int)c < _end) c++;
    else c = (char)_start;
  }

  public void encode(int cesar) {// Animiertes Verschlüsseln in Abhängigkeit von cesar
    if (c != 32) {

      if ((cDecoded + cesar) > cEnd) {// Buchstaben mit Sprung 
        if (c < cEnd && c >= cDecoded) c++;
        if (c >= cEnd)c = cStart;
        if (c < (cStart +(cesar - (cEnd - cDecoded))-1))c++;
      } else if (c < cDecoded + cesar) c++; // Buchstaben ohne Sprung
    }
  }

  public void decode() { //Entschlüsseln
    c = cDecoded;
  }

  public void setColor(color _col) { //Farbe setzen
    this.col = _col;
  }
}
