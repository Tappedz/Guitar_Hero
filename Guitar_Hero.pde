import processing.sound.*;
import processing.serial.*;

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
final ArrayList<Button> modeButtons = new ArrayList<Button>();
final ArrayList<Button> easyModeButtons = new ArrayList<Button>();
final ArrayList<Button> hardModeButtons = new ArrayList<Button>();
final ArrayList<Note> notesPlaying = new ArrayList<Note>();

Song song;
SoundFile buttonSound, songFile1, songFile2;
boolean songUploaded = false;
int score;
String globalScene;

Serial myPort;

//initialize
void setup() {
  size(1080,720);
  myPort = new Serial(this, "COM3", 9600);
  globalScene = "modeSelector";
  buttonSound = new SoundFile(this, "buttonSoundEffect.mp3");
  songFile1 = new SoundFile(this, "songs/Be Quiet And Drive.mp3");
  songFile2 = new SoundFile(this, "songs/Dear Rosemary.mp3");
  score = 0;
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
      Led led;
      if(i == 0 || i == 2) {
        led = new Led(ledStripX + 14, ledStripY + 8 + (j*ledSeparator), ledColor, (i*10) + (9-j), opacity);
        ledStrip.leds.add(led);      
      }
      else if(i == 1 || i == 3) {
        led = new Led(ledStripX + 14, ledStripY + 8 + (j*ledSeparator), ledColor, (i*10) + j, opacity);
        ledStrip.leds.add(led);
      }  
    }
  }
  Button easyModeButton = new MenuButton(CENTER_X/2 - 200, CENTER_Y/2 - 70, 180, 60, "Easy","easy");
  Button hardModeButton = new MenuButton(CENTER_X/2 + 20, CENTER_Y/2 - 70, 180, 60, "Hard","hard");
  Button backButton = new MenuButton(1000, 20, 60, 60, "Back","modeSelector");  
  
  Button playButton = new PlayButton(CENTER_X/2 - 90, CENTER_Y/2 - 70, 180, 60, "Play");
  Button hardSong1 = new SongButton(CENTER_X/2 - 90, CENTER_Y/2, 180, 60, "Be Quiet And Drive");
  Button hardSong2 = new SongButton(CENTER_X/2 - 90, CENTER_Y/2 + 70, 180, 60, "Dear Rosemary");
  Button easySong1 = new SongButton(CENTER_X/2 - 90, CENTER_Y/2, 180, 60, "Track 1");
  Button easySong2 = new SongButton(CENTER_X/2 - 90, CENTER_Y/2 + 70, 180, 60, "Track 2");

  modeButtons.add(easyModeButton);
  modeButtons.add(hardModeButton);
  modeButtons.add(backButton);
  
  easyModeButtons.add(playButton);
  easyModeButtons.add(backButton);
  easyModeButtons.add(easySong1);
  easyModeButtons.add(easySong2);
  hardModeButtons.add(playButton);
  hardModeButtons.add(backButton);
  hardModeButtons.add(hardSong1);
  hardModeButtons.add(hardSong2);
}

//loop
void draw() {
  setGradient(0, 0, 1080, 720, PURPLE, NEON_BLUE);
  drawLeds();
  drawButtons();
  if(songUploaded) {
    drawSong();
  }
  drawNotes();
}

//gradient background
void setGradient(int x, int y, float w, float h, color c1, color c2) {
  noFill();
  for (int i = x; i <= x+w; i++) {
    float inter = map(i, x, x+w, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(i, y, i, y+h);
  }
}

void serialEvent(Serial myPort) {
  try{
    final String msg = myPort.readStringUntil('\n');    
     if (msg == null) {
       return;
     } 
    
    int button = Integer.parseInt(msg);
    if(button == 0) {
      if(ledStrips.get(0).leds.get(9).on) {
        println("Good Green! :)");
        buttonSound.play(1, 0.05);
        score++;
      }
      else{
        println("Miss Green :("); 
      }
    }
    else if(button == 1) {
      if(ledStrips.get(1).leds.get(9).on) {
        println("Good Red! :)");
        buttonSound.play(1,0.05);
        score++;
      }
      else{
        println("Miss Red! :("); 
      }
    }
    else if(button == 2) {
      if(ledStrips.get(2).leds.get(9).on) {
        println("Good Yellow! :)");
        buttonSound.play(1, 0.05);
        score++;
      }
      else{
        println("Miss Yellow :("); 
      }
    }
    else if(button == 3) {
      if(ledStrips.get(button).leds.get(9).on) {
        println("Good Blue! :)");
        buttonSound.play(1, 0.05);
        score++;
      }
      else{
        println("Miss Blue :("); 
      }
    }
    
  }catch(Exception e){}  
}

void mousePressed() {
  if(globalScene.equals("modeSelector")) {
    for(Button bt : modeButtons){
      if(bt.isInside(mouseX, mouseY)) {
        bt.onClick();
      }
    }
  }
  else if(globalScene.equals("easy")) {
    for(Button bt : easyModeButtons){
      if(bt.isInside(mouseX, mouseY)) {
        bt.onClick();
      }
    }
  }
  else if(globalScene.equals("hard")) {
    for(Button bt : hardModeButtons){
      if(bt.isInside(mouseX, mouseY)) {
        bt.onClick();
      }
    }
  }
}

void keyPressed() {
  if(key == 'q' || key == 'Q') {
    if(ledStrips.get(0).leds.get(9).on) {
      println("Good Green! :)");
      buttonSound.play(1, 0.05);
      score++;
    }
    else{
      println("Miss Green :("); 
    }
  }
  else if(key == 'w' || key == 'W') {
    if(ledStrips.get(1).leds.get(9).on) {
      println("Good Red! :)");
      buttonSound.play(1,0.05);
      score++;
    }
    else{
      println("Miss Red! :("); 
    }
  }
  else if(key == 'e' || key == 'E') {
    if(ledStrips.get(2).leds.get(9).on) {
      println("Good Yellow! :)");
      buttonSound.play(1, 0.05);
      score++;
    }
    else{
      println("Miss Yellow :("); 
    }
  }
  else if(key == 'r' || key == 'R') {
    if(ledStrips.get(3).leds.get(9).on) {
      println("Good Blue! :)");
      buttonSound.play(1, 0.05);
      score++;
    }
    else{
      println("Miss Blue :("); 
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
  if(globalScene.equals("modeSelector")) {
    for(Button bt : modeButtons){
      bt.draw();
    }
  }
  else if(globalScene.equals("easy")) {
    for(Button bt : easyModeButtons){
      bt.draw();
    }
  }
  else if(globalScene.equals("hard")) {
    for(Button bt : hardModeButtons){
      bt.draw();
    }
  }
}

void drawSong() {
  if(song.isPlaying && !song.hasPlayed) {
    song.draw();
  }
  if(song.isPlaying && song.hasPlayed && song.finishDelay <= millis()) {
      song.isPlaying = false;
      println("Song finished");
      println("Score: " + score);
    }
}

void drawNotes() {
  boolean[] removableNotes = new boolean[notesPlaying.size()];
  int i = 0;
  //check if notes are still playing and draw them
  for(Note nt : notesPlaying){
    if(!nt.notePlayed) {
      nt.draw();
      removableNotes[i] = false;
    }
    else {
      removableNotes[i] = true;
      Led led = ledStrips.get(nt.column).leds.get(9);
      if(!nt.followUp) {
        led.on = false;
      }
    }
    i++;
  }
  //remove finished notes  
  for(int it = 0; it < notesPlaying.size(); it++) {
    if(removableNotes[it]) {
      notesPlaying.remove(it);
    }
  }
}

void playSong() {
  //delay(song.notes.get(0).delayBtLeds * 10);
  if(song.title.equals("Be Quiet and Drive (Far Away)")) {
    songFile1.play(1, 0.5);
  }
  else if(song.title.equals("Dear Rosemary")) {
    songFile2.play(1, 0.5);
  }
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
  boolean on;

  public Led(float x, float y, color ledColor, int ledPos, int opacity) {
    this.x = x;
    this.y = y;
    this.ledColor = ledColor;
    this.ledPos = ledPos;
    this.opacity = opacity;
    this.on = false;
  }
   
  void changeColor(color c1) {
    this.ledColor = c1;
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

class MenuButton extends Button {
  String scene;
  
  public MenuButton(float x, float y, int rectWidth, int rectHeight, String text, String scene) {
    super(x, y, rectWidth, rectHeight, text);
    this.scene = scene;
  }
  
  void onClick() {
    globalScene = this.scene;
    songFile1.stop();
    songFile2.stop();
  }
}

class PlayButton extends Button {
  
  public PlayButton(float x, float y, int rectWidth, int rectHeight, String text) {
    super(x, y, rectWidth, rectHeight, text);
  }
  
  void onClick() {
    myPort.write(50);
    if(globalScene.equals("hard")) {
      playSong();
    }
    song.isPlaying = true; 
    /*
    //Code for thread play (doesn't work well because of processing's thread managment)
    int i = 0;
    for(Note nt : song.notes) {
      if(i < 3) {
        println("delay: " + (nt.delay*1000));
        delay((int)(nt.delay * 1000));
        NotePlayer thread = new NotePlayer(nt);
        thread.start();
        i++;
      }
    }*/
  }
}

class SongButton extends Button {
  
  public SongButton(float x, float y, int rectWidth, int rectHeight, String text) {
    super(x, y, rectWidth, rectHeight, text);
  }
  
  void onClick() {
    song = this.readFile(this.text, globalScene);
    if(song.title.equals("Be Quiet and Drive (Far Away)")) {
      songFile2.stop();
    }
    else if(song.title.equals("Dear Rosemary")) {
      songFile1.stop();
    }
    songUploaded = true;
  }
  
  //input: Guitar Hero chart (any song in .chart format) output: playable song
  Song readFile(String fileName, String mode) {
    if(mode.equals("easy")){
      return parseTextFile("customCharts/" + fileName + ".txt");
    }
    else {
      return parseChartFile("charts/" + fileName + ".chart");
    }
  }
  
  Song parseChartFile(String fileName) {
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
            notes.add(new Note(tick, Integer.parseInt(data[1]), delay, false));
          }
        }
      }
    }
    println("Song: " + songTitle + " by " + artist);
    println("Resolution: " + resolution);
    return new Song(122.5, resolution, songTitle, artist, notes, 0.25);
  }
  
  Song parseTextFile(String fileName) {
    String artist = "Anon";
    String songTitle = fileName;
    int tick = 0;
    float delay = 0.5;
    ArrayList<Note> notes = new ArrayList<Note>();
    String[] lines = loadStrings(fileName);
    for (int i = 0 ; i < lines.length; i++) {
        if( i != lines.length - 1) {
          if(Integer.parseInt(lines[i]) == Integer.parseInt(lines[i + 1])) {
            notes.add(new Note(tick, Integer.parseInt(lines[i]), delay, true));
          }
          else {
            notes.add(new Note(tick, Integer.parseInt(lines[i]), delay, false));
          }
        }
        else {
          notes.add(new Note(tick, Integer.parseInt(lines[i]), delay, false));
        }
        tick += 250;
    }
    println("Song: " + songTitle + " by " + artist);
    return new Song(0, 0, fileName, artist, notes, delay);
  }
}

class Song {
  ArrayList<Note> notes = new ArrayList<Note>();
  float BPM;
  int resolution;
  String title;
  String artist;
  int noteCount;
  int nextMillis;
  boolean isPlaying;
  boolean hasPlayed;
  int finishDelay;
  float noteDelay;
  
  public Song(float BPM, int resolution, String title, String artist, ArrayList<Note> notes, float noteDelay) {
    this.BPM = BPM;
    this.resolution = resolution;
    this.title = title;
    this.artist = artist;
    this.noteCount = 0;
    this.nextMillis = millis();
    this.isPlaying = false;
    this.hasPlayed = false;
    this.noteDelay = noteDelay;
    this.finishDelay = 0;
    for(Note nt : notes) {
      this.notes.add(new Note(nt));
    }
  }
  
  void draw() {
    if(this.nextMillis <= millis()){
      if(this.notes.size() == this.noteCount) {
        this.hasPlayed = true;
        this.finishDelay = millis() + (int)(this.noteDelay * 10000);
      }
      else {
        Note nt = this.notes.get(this.noteCount);
        nt = this.notes.get(this.noteCount);
        this.nextMillis = millis() + (int)(nt.delay * 1000);
        notesPlaying.add(nt);
      }
      this.noteCount++;
    }
  }
}

class Note {
  int position;
  int column;
  float delay;
  boolean notePlayed;
  int ledCount;
  int nextMillis;
  boolean followUp;
  int delayBtLeds;
  
  public Note(int position, int column, float delay, boolean followUp) {
    this.position = position;
    this.column = column;
    this.delay = delay;
    this.followUp = followUp;
    this.notePlayed = false;
    this.ledCount = 0;
    this.nextMillis = millis();
    if(globalScene.equals("easy")) {
      this.delayBtLeds = 500;
    }
    else if(globalScene.equals("hard")) {
      this.delayBtLeds = 220;
    } 
  }
  
  //Copy Constructor
  public Note(Note nt) {
    this.position = nt.position;
    this.column = nt.column;
    this.delay = nt.delay;
    this.followUp = nt.followUp;
    this.notePlayed = nt.notePlayed;
    this.ledCount = nt.ledCount;
    this.nextMillis = nt.nextMillis;
    this.delayBtLeds = nt.delayBtLeds;
  }
  
  void draw(){
    LedStrip ledStrip = ledStrips.get(this.column);
    if(this.ledCount < 10) {
      Led led = ledStrip.leds.get(this.ledCount);
      if(this.column == 0) {
        if(this.nextMillis <= millis()){
          //println(led.ledPos);
          myPort.write(led.ledPos);
          this.nextMillis = millis() + this.delayBtLeds;
          led.changeColor(GREEN);
          led.opacity = 255;
          led.on = true;
          if (this.ledCount != 0) {
            if(!this.followUp){
              Led prevLed = ledStrip.leds.get(this.ledCount - 1);
              prevLed.changeColor(WHITE);
              prevLed.on = false;
            }
          }
          this.ledCount++;
        }
      }
      else if(this.column == 1) {
        if(nextMillis <= millis()){
          myPort.write(led.ledPos);
          this.nextMillis = millis() + this.delayBtLeds;
          led.changeColor(RED);
          led.opacity = 255;
          led.on = true;
          if (this.ledCount != 0) {
            if(!this.followUp){
              Led prevLed = ledStrip.leds.get(this.ledCount - 1);
              prevLed.changeColor(WHITE);
              prevLed.on = false;
            }
          }
          this.ledCount++;
        }
      }
      else if(this.column == 2) {
        if(this.nextMillis <= millis()){
          myPort.write(led.ledPos);
          this.nextMillis = millis() + this.delayBtLeds;
          led.changeColor(YELLOW);
          led.opacity = 255;
          led.on = true;
          if (this.ledCount != 0) {
            if(!this.followUp){
              Led prevLed = ledStrip.leds.get(this.ledCount - 1);
              prevLed.changeColor(WHITE);
              prevLed.on = false;
            }
          }
          this.ledCount++;
        }
      }
      else {
        if(this.nextMillis <= millis()){
          myPort.write(led.ledPos);
          this.nextMillis = millis() + this.delayBtLeds;
          led.changeColor(BLUE);
          led.opacity = 255;
          led.on = true;
          if (this.ledCount != 0) {
            if(!this.followUp){
              Led prevLed = ledStrip.leds.get(this.ledCount - 1);
              prevLed.changeColor(WHITE);
              prevLed.on = false;
            }
          }
          this.ledCount++;
        }
      }
    }
    else if(this.ledCount == 10) {
      if(this.nextMillis <= millis()){  
        Led led = ledStrip.leds.get(9);
        led.opacity = 127;
        this.notePlayed = true;
      }
    }
  }
}

/*
//Thread class implemented to play notes with thread -> good try but threads doesn't work well in processing
class NotePlayer extends Thread {
  final Note nt;
  
  public NotePlayer(Note nt){
    this.nt = nt;
  }
  
  public void run() {
    LedStrip ledStrip = ledStrips.get(this.nt.column);
    println("playing");
    for(int i = 0; i < 10; i++) {
      if(this.nt.column == 0) {
        Led led = ledStrip.leds.get(i);
        synchronized(led) {
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
      }
      else if(this.nt.column == 1) {
        Led led = ledStrip.leds.get(i);
        synchronized(led) {
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
      }
      else if(this.nt.column == 2) {
        Led led = ledStrip.leds.get(i);
        synchronized(led) {
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
      }
      else {
        Led led = ledStrip.leds.get(i);
        synchronized(led) {
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
    }
    nt.notePlayed = true;
    println("played");
  }
}
*/
