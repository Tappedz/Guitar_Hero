import processing.sound.*;

final int LEDS_NUM = 40;
final int LEDS_COL_NUM = 4;
final int CENTER_X = 540;
final int CENTER_Y = 360;

final color WHITE = #FFFFFF;
final color BLACK = #000000;
final color PURPLE = #800080;
final color NEON_BLUE = #1F51FF;
final color GRAY = #808080;
final color RED = #FF0000; //10 - 19
final color BLUE = #0000FF;//30 - 39
final color GREEN = #008000; //0 - 9 inverse (iterate backwards)
final color YELLOW = #FFFF00;//20 - 29 inverse (iterate backwards)

final ArrayList<LedStrip> ledStrips = new ArrayList<LedStrip>();
final ArrayList<Button> buttons = new ArrayList<Button>();
Song song;
SoundFile buttonSound, songFile;

//initialize
void setup() {
  size(1080,720);
  buttonSound = new SoundFile(this, "buttonSoundEffect.mp3");
  songFile = new SoundFile(this, "songs/Be Quiet And Drive.mp3");
  int startPoint = CENTER_X;
  int ledStripSeparator = 80;
  int ledSeparator = 48;
  for(int i = 0; i < LEDS_COL_NUM; i++){
    int ledStripX = startPoint + (i*ledStripSeparator);
    int ledStripY = CENTER_Y/4;
    LedStrip ledStrip = new LedStrip(ledStripX, ledStripY, i);
    ledStrips.add(ledStrip);
    for(int j = 0; j < LEDS_NUM/LEDS_COL_NUM; j++){ //verde, rojo, amarillo, azul
      color ledColor = WHITE;
      int opacity = 255;
      if(j == 9) {
        opacity = 127;
        if(i == 0) {
          ledColor = GREEN;
        }
        else if(i == 1) {
          ledColor = RED;
        }
        else if(i == 2) {
          ledColor = YELLOW;
        }
        else if(i == 3) {
          ledColor = BLUE;
        }
      }
      Led led = new Led(ledStripX + 14, ledStripY + 8 + (j*ledSeparator), ledColor, (i*10) + j, opacity);
      ledStrip.leds.add(led);
    }
  }
  Button playButton = new PlayButton(CENTER_X/2 - 90, CENTER_Y/2 - 70, 180, 60, "Play");
  Button songButton = new SongButton(CENTER_X/2 - 90, CENTER_Y/2 + 10, 180, 60, "Be Quiet And Drive");
  buttons.add(playButton);
  buttons.add(songButton);
}

//loop
void draw() {
  setGradient(0, 0, 1080, 720, PURPLE, NEON_BLUE);
  drawLeds();
  //playNotes();
  drawButtons();
}

void setGradient(int x, int y, float w, float h, color c1, color c2) {
  noFill();
  for (int i = x; i <= x+w; i++) {
    float inter = map(i, x, x+w, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(i, y, i, y+h);
  }
}

void mousePressed() {
  for(Button bt : buttons){
    if(bt.isInside(mouseX, mouseY)) {
      bt.onClick();
    }
  }
}

void keyPressed() {
  
  if(key == 'q' || key == 'Q') {
    if(ledStrips.get(0).leds.get(9).opacity == 255) {
      println("acierto Q");
      buttonSound.play(1, 0.05);
    }
    else{
      println("fallo Q"); 
    }
  }
  else if(key == 'w' || key == 'W') {
    if(ledStrips.get(1).leds.get(9).opacity == 255) {
      println("acierto W");
      buttonSound.play(1,0.05);
    }
    else{
      println("fallo W"); 
    }
  }
  else if(key == 'e' || key == 'E') {
    if(ledStrips.get(2).leds.get(9).opacity == 255) {
      println("acierto E");
      buttonSound.play(1, 0.05);
    }
    else{
      println("fallo E"); 
    }
  }
  else if(key == 'r' || key == 'R') {
    if(ledStrips.get(3).leds.get(9).opacity == 255) {
      println("acierto R");
      buttonSound.play(1, 0.05);
    }
    else{
      println("fallo R"); 
    }
  }
}

void drawLeds() {
  for(LedStrip ls : ledStrips){
    ls.draw();
    for(Led led : ls.leds) {
      led.draw();
    }
  }
}

void drawButtons() {
  for(Button bt : buttons){
    bt.draw();
  }
}

void playSong() {
  delay(2160);
  songFile.play(1, 0.5);
}

class LedStrip {
  float x, y;
  int rectWidth = 60;
  int rectHeight = 480;
  int pos;
  ArrayList<Led> leds;
  
  public LedStrip(float x, float y, int pos) {
    this.x = x;
    this.y = y;
    this.pos = pos;
    this.leds = new ArrayList<Led>();
  }
  
  void draw() {
    fill(BLACK);
    noStroke();
    rect(this.x, this.y, this.rectWidth, this.rectHeight, 10);
    
  }
}

class Led {
  float x, y;
  int rectWidth = 32;
  int rectHeight = 32;
  color ledColor;
  int opacity;
  int ledPos;

  public Led(float x, float y, color ledColor, int ledPos, int opacity) {
    this.x = x;
    this.y = y;
    this.ledColor = ledColor;
    this.ledPos = ledPos;
    this.opacity = opacity;
  }
   
  void draw() {
    fill(this.ledColor, this.opacity);
    noStroke();
    rect(this.x, this.y, this.rectWidth, this.rectHeight, 10);
  }
}

class Button {
  float x, y;
  int rectWidth;
  int rectHeight;
  String text;
  
  public Button(float x, float y, int rectWidth, int rectHeight, String text) {
    this.x = x;
    this.y = y;
    this.rectWidth = rectWidth;
    this.rectHeight = rectHeight;
    this.text = text;
  }
  
  boolean isInside(int mx, int my) {
    if(mx > this.x & mx < this.x + this.rectWidth & my > this.y & my < this.y + this.rectHeight) {
      return true;
    }
    else {
      return false; 
    }
  }
  
  void draw() {
    fill(WHITE);
    stroke(BLACK);
    rect(this.x, this.y, this.rectWidth, this.rectHeight, 10);
    textAlign(CENTER);
    textSize(28);
    fill(BLACK);
    text(this.text, this.x + (rectWidth/2), this.y + (rectHeight/2) + 7);
    
  }

  void onClick() {
    
  }
}

class PlayButton extends Button{
  
  public PlayButton(float x, float y, int rectWidth, int rectHeight, String text) {
    super(x, y, rectWidth, rectHeight, text);
  }
  
  void onClick() {
    int i = 0;
    thread("playSong");
    for(Note nt : song.notes) {
      if(i < 3) {
        println("delay: " + (nt.delay*1000));
        delay((int)(nt.delay * 1000));
        NotePlayer thread = new NotePlayer(nt);
        thread.start();
        i++;
      }
    }
  }
}

class SongButton extends Button{
  
  public SongButton(float x, float y, int rectWidth, int rectHeight, String text) {
    super(x, y, rectWidth, rectHeight, text);
  }
  
  void onClick() {
    song = this.readFile("charts/" + this.text + ".chart");
  }
  
  Song readFile(String fileName) {
    String songTitle = "";
    String artist = "";
    int resolution = 0;
    ArrayList<Note> notes = new ArrayList<Note>();
    String[] lines = loadStrings(fileName);
    for (int i = 0 ; i < lines.length; i++) {
      String[] splitted = splitTokens(lines[i],"=");
      String aux;
      if(i == 0) {
        aux = join(split(splitted[1], '"'),"");
        songTitle = aux.substring(1, aux.length());
      }
      else if(i == 1) {
        aux = join(split(splitted[1], '"'),"");
        artist = aux.substring(1, aux.length());
      }
      else if(i == 2) {
        resolution = Integer.parseInt(join(split(splitted[1], " "),""));
      }
      else {
        int tick = Integer.parseInt(join(split(splitted[0], " "),""));
        String[] data = splitTokens(splitted[1]," ");
        if(data.length == 2) {
          
        }
        if(data.length == 3) {
          if(Integer.parseInt(data[1]) <= 3) {
            //println(tick);
            float delay = 0;
            if(notes.size() == 0) {
              delay = 60 / 122.5 * (tick - 0) / resolution; 
            }
            else {
              delay = 60 / 122.5 * (tick - notes.get(notes.size() - 1).position) / resolution;
            }
            notes.add(new Note(tick, Integer.parseInt(data[1]), delay));
          }
        }
      }
      //println(splitted[1]);
    }
    println("Song: " + songTitle + " by " + artist);
    println("Resolution: " + resolution);
    return new Song(122.5, resolution, songTitle, artist, notes);
  }
}

class Song {
  ArrayList<Note> notes = new ArrayList<Note>();
  float BPM;
  int resolution;
  String title;
  String artist;
  
  public Song(float BPM, int resolution, String title, String artist, ArrayList<Note> notes) {
    this.BPM = BPM;
    this.resolution = resolution;
    this.title = title;
    this.artist = artist;
    for(Note nt : notes) {
      this.notes.add(new Note(nt));
    }
  }
}

class Note {
  int position;
  int column;
  float delay;
  boolean notePlayed;
  
  public Note(int position, int column, float delay) {
    this.position = position;
    this.column = column;
    this.delay = delay;
    this.notePlayed = false;
  }
  
  //Copy Constructor
  public Note(Note nt) {
    this.position = nt.position;
    this.column = nt.column;
    this.delay = nt.delay;
    this.notePlayed = nt.notePlayed;
  }
}

class NotePlayer extends Thread {
  final Note nt;
  
  public NotePlayer(Note nt){
    this.nt = nt;
  }
  
  public void run() {
    LedStrip ledStrip = ledStrips.get(nt.column);
      println("playing");
      for(int i = 0; i < 10; i++) {
        if(nt.column == 0) {
          Led led = ledStrip.leds.get(i);
          led.ledColor = GREEN;
          led.opacity = 255;
          delay(240);
          if (i != 9) {
            led.ledColor = WHITE;
          }
          else {
            led.opacity = 127; 
          }
        }
        else if(nt.column == 1) {
          Led led = ledStrip.leds.get(i);
          led.ledColor = RED;
          led.opacity = 255;
          delay(240);
          if (i != 9) {
            led.ledColor = WHITE;
          }
          else {
            led.opacity = 127; 
          }
        }
        else if(nt.column == 2) {
          Led led = ledStrip.leds.get(i);
          led.ledColor = YELLOW;
          led.opacity = 255;
          delay(240);
          if (i != 9) {
            led.ledColor = WHITE;
          }
          else {
            led.opacity = 127; 
          }
        }
        else {
          Led led = ledStrip.leds.get(i);
          led.ledColor = BLUE;
          led.opacity = 255;
          delay(240);
          if (i != 9) {
            led.ledColor = WHITE;
          }
          else {
            led.opacity = 127; 
          }
        }
      }
      nt.notePlayed = true;
      println("played");
  }
}
