/* 
 Animationsprogrammierung - DM 5. Semester
 Andreas Enns 248050
 
 */
import processing.sound.*;


//Buchstabengedoens
Char[] arrCharsBottom; //Chars am Boden
ArrayList<Char> arrCharsText = new ArrayList<Char>(); //Text / Fliegende Chars
ArrayList<Char> arrCharsFalling = new ArrayList<Char>(); // Fallende Chars
final int cStart = 33;                         //ACSII Start
final int cEnd = 126;                          //ASCII End
final int abc = cEnd - cStart + 1;
final int lineL = 1000 / 26;                   // Window-Width
PFont font;
String text = ""; //Text als String zum Erkennen, ob eine Farbe geschrieben wurde


//Lupe/Kreis
Circle kreis;
int radius = 100; //Radius Lupe

//Verschluesselung
int cesar = 10;
boolean doEncoding = false;

//Sound
SoundFile typewriterClick;
SoundFile typewriterBell;
SoundFile typewriterEncoding;
SoundFile typewriterDelete;
SoundFile typewriterDeleteAll;


//Farbkram
String[] colors = {"red", "green", "blue", "magenta", "yellow", "cyan", "white", "black", "colorful"}; // Array zum Vergleichen der Farben
String colString ;
color col;

//Fontkram
String[] fonts = {"MajorMonoDisplay-Regular.ttf", "NovaMono-Regular.ttf", "RobotoMono-Medium.ttf", "ShareTechMono-Regular.ttf", "VT323-Regular.ttf"};


void setup() {
  size(1000, 800);
  background(0);
  initCharArr(); // Generieren der Chars am Boden des Fensters
  kreis = new Circle(width/2, height/2, radius);
  font =createFont(fonts[0], 32); //Setzen der Monospace-Font
  textFont(font);

  //frameRate(30);

  typewriterClick = new SoundFile(this, "typewriter.wav");
  typewriterBell = new SoundFile(this, "typewriter_delete_all.wav");
  typewriterEncoding = new SoundFile(this, "typewriter_encryption.wav");
  typewriterDelete = new SoundFile(this, "typewriter_delete_one.wav");
  typewriterDeleteAll = new SoundFile(this, "typewriter_delete_all.wav");
}

void draw() { // Ruft die drawChar für alle Chars auf
  background(0);
  for (int i = abc; i < arrCharsBottom.length -1; i++) { // Chars am Boden
    if (kreis.checkCircle(arrCharsBottom[i])) {
      arrCharsBottom[i].drawChar(64);
    } else {
      arrCharsBottom[i].changeBoden(cStart, cEnd);
      arrCharsBottom[i].drawChar(32);
    }
    arrCharsBottom[i].fallingChar();
  }

  if (arrCharsText.size() > 0) { //Fliegende Chars
    for ( int i = 0; i < arrCharsText.size(); i++) {
      arrCharsText.get(i).flyingChar();
      if (kreis.checkCircle(arrCharsText.get(i))) {
        arrCharsText.get(i).drawChar(64);
      } else arrCharsText.get(i).drawChar(32);
      if (doEncoding == true) {
        arrCharsText.get(i).encode(cesar);
      } else {
        arrCharsText.get(i).decode();
      }
    }
  }
  if (arrCharsFalling.size() > 0) { // Fallende Chars
    for (int i = 0; i < arrCharsFalling.size(); i++) {
      if (kreis.checkCircle(arrCharsFalling.get(i))) {
        arrCharsFalling.get(i).drawChar(64);
      } else arrCharsFalling.get(i).drawChar(32);
      arrCharsFalling.get(i).fallingChar();
      if (arrCharsFalling.get(i).y > height- 50)arrCharsFalling.remove(i);
    }
  }
}

void makeText(Char _c) {  //baut den Text als ArrayList auf
  arrCharsText.add(new Char(random(10, width -10), height - 50, 0, _c.c));
  arrCharsText.get(arrCharsText.size()-1).setT(20 + (((arrCharsText.size()-1)%lineL)*25), 10 + (((arrCharsText.size()-1)/lineL) + 1) * 50);
  text = text + _c.c;
  compareColor();
}

void initCharArr() {  // Chars am Boden
  arrCharsBottom = new Char[abc*10];
  for (int i= 0; i < arrCharsBottom.length -1; i++) {
    if (i < abc)arrCharsBottom[i] = new Char((width/abc) * i, 50, 0, (char)(i + cStart));
    else arrCharsBottom[i] = new Char(random(-10, width-10), 50, 0, (char)(random(cStart, cEnd)));
  }
}

void delAll() {  //Loescht gesamten Text (ArrayList)
  for (int i = 0; i < arrCharsText.size(); i++) {
    arrCharsFalling.add(arrCharsText.get(i));
  }
  arrCharsText = new ArrayList<Char>();
  text = "";
  compareColor();
}

void delLast() {  //loescht  den letzen Buchstaben
  arrCharsFalling.add(arrCharsText.get(arrCharsText.size()-1));
  arrCharsText.remove(arrCharsText.size()-1);
  text = text.substring(0, text.length() - 1);
  compareColor();
}

void compareColor() { // Vergleicht den getippten Text mit Elementen aus dem vordefinierten Array mit Farben 
  //und setzt die entsprechende Farbe für alle Buchstaben
  colString = "none";
  int tempI = 0;
  for (int i = 0; i < colors.length; i++) {
    if (text.contains(colors[i])) {
      if (text.lastIndexOf(colors[i]) >= tempI) {
        tempI = text.lastIndexOf(colors[i]);      
        colString = colors[i];
      }
    }
  }
  switch(colString) {
  case "none": 
    col = color(255, 255, 255);
    break;
  case "red": 
    col = color(255, 0, 0);
    break;
  case "magenta": 
    col = color(255, 0, 255);
    break;
  case "blue": 
    col = color(0, 0, 255);
    break;
  case "cyan": 
    col = color(0, 255, 255);
    break;
  case "green": 
    col = color(0, 255, 0);
    break;
  case "yellow": 
    col = color(255, 255, 0);
    break;
  case "black": 
    col = color(0, 0, 0);
    break;
  case "white": 
    col = color(255, 255, 255);
    break;
  default: 
    col = color(255, 255, 255);
  }
  for ( int i = 0; i < arrCharsText.size(); i++) {
    if (colString == "colorful") arrCharsText.get(i).setColor(color(random(100, 255), random(100, 255), random(100, 255)));
    else arrCharsText.get(i).setColor(col);
  }
}

void checkFont() { // ueberprueft den geschriebenen Text, wenn change font erkannt wurde, aendert sich die Schriftart
  if (text.contains("change font")) {
    text.replaceAll("change font", "");
    for (int i = 0; i < 11; i++) {
      delLast();
    }
    font =createFont(fonts[(int)random(0, 4)], 32); //Setzen der Monospace-Font
    textFont(font);
  }
}

void keyPressed() {  //Tatatureingaben zur Texterstellung
  int k = (int)key; 
  if (k == 9) { // Tabulator - Verschluesselung aktivieren 
    if (doEncoding == false) {
      doEncoding = true;
      typewriterEncoding.play();
    } else doEncoding = false;
  }
  if (k == 127) { // ENTF - Loescht alle Chars
    typewriterDeleteAll.play();
    delAll();
  }
  if (k ==8 && arrCharsText.size()>0) { // <-- Loescht letzten Char
    typewriterDelete.play();
    delLast(); //<--
  }
  if (k == 32) { // Leertaste - Leerzeichen
    typewriterClick.play();
    makeText(new Char(0, 0, 0, ' '));
  }  
  if (k >= cStart && k <= cEnd) { //alle anderen Zeichen
    typewriterClick.play();
    makeText(arrCharsBottom[k - cStart]);
  }
  checkFont();
}

void mouseMoved() {
  kreis.update(mouseX, mouseY);
}

void mousePressed() { // Vergroeßerung/-kleinerung der Lupe am Mauszeiger
  if (mouseButton == LEFT) kreis.rad += 10;
  if (mouseButton == RIGHT) kreis.rad -= 10;
}
