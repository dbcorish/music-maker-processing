// David's Synthesiser
// Please note, an audio input and output are needed for this sketch to function

// Import minim library
import ddf.minim.*;
import ddf.minim.ugens.*;

//Declare oscillators
Oscil C4, C4S, D4, D4S, E4, F4, F4S, G4, G4S, A4, A4S, B4,
C5, C5S, D5, D5S, E5, F5, F5S, G5, G5S, A5, A5S, B5, C6;

// Declare booleans to determine if note playing
boolean Strum, C3Playing, C3SPlaying, D3Playing, D3SPlaying, E3Playing, F3Playing, F3SPlaying, G3Playing, G3SPlaying, A3Playing, A3SPlaying, B3Playing, C4GuitarPlaying,
C4Playing, C4SPlaying, D4Playing, D4SPlaying, E4Playing, F4Playing, F4SPlaying, G4Playing, G4SPlaying, A4Playing, A4SPlaying, B4Playing,
C5Playing, C5SPlaying, D5Playing, D5SPlaying, E5Playing, F5Playing, F5SPlaying, G5Playing, G5SPlaying, A5Playing, A5SPlaying, B5Playing, C6Playing,
spyroPlaying, eloPlaying, rdr2Playing, wotwPlaying, lllPlaying;

// Declare audio input
AudioInput in ;

// Declare audio outputs
AudioOutput C3Out, C3SOut, D3Out, D3SOut, E3Out, E3SOut, F3Out, F3SOut, G3Out, G3SOut, A3Out, A3SOut, B3Out, C4GuitarOut,
C4Out, C4SOut, D4Out, D4SOut, E4Out, E4SOut, F4Out, F4SOut, G4Out, G4SOut, A4Out, A4SOut, B4Out,
C5Out, C5SOut, D5Out, D5SOut, E5Out, F5Out, F5SOut, G5Out, G5SOut, A5Out, A5SOut, B5Out, C6Out,
drumMachineOut;

// Declare players for backing tracks and guitar
AudioPlayer player, spyroPlayer, eloPlayer, rdr2Player, wotwPlayer, lllPlayer,
C3Player, C3SPlayer, D3Player, D3SPlayer, E3Player, F3Player, F3SPlayer, G3Player, G3SPlayer, A3Player, A3SPlayer, B3Player, C4GuitarPlayer;

// Declare minim and recorder
Minim minim;
AudioRecorder recorder;

// Beginning of drumMachine code segment (Processing examples -> Minim -> Advanced -> DrumMachine)
Sampler kick;
Sampler snare;
Sampler hat;
Sampler clap;

boolean[] hatRow = new boolean[16];
boolean[] snrRow = new boolean[16];
boolean[] kikRow = new boolean[16];
boolean[] clpRow = new boolean[16];

ArrayList < Rect > buttons = new ArrayList < Rect > ();

int bpm = 240;

int beat;

class Tick implements Instrument {
  void noteOn(float dur) {
    if (hatRow[beat]) hat.trigger();
    if (snrRow[beat]) snare.trigger();
    if (kikRow[beat]) kick.trigger();
    if (clpRow[beat]) clap.trigger();
  }

  void noteOff() {
    // Next beat
    beat = (beat + 1) % 16;
    // Set the new tempo
    drumMachineOut.setTempo(bpm);
    // Play this again right now, with a sixteenth note duration
    drumMachineOut.playNote(0, 0.25f, this);
  }
}

class Rect {
  int x, y, w, h;
  boolean[] steps;
  int stepId;

  public Rect(int _x, int _y, boolean[] _steps, int _id) {
    x = _x;
    y = _y;
    w = 14;
    h = 30;
    steps = _steps;
    stepId = _id;
  }

  public void draw() {
    if (steps[stepId]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(x, y, w, h);
  }

  public void mousePressed() {
    if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
      steps[stepId] = !steps[stepId];
    }
  }
}
// End of DrumMachine segment

void setup() {
  // Create window
  size(965, 470);
  background(255);
  frameRate(30);
  
  minim = new Minim(this);
  
  // Create triangle wave oscillators.
  C4 = new Oscil(261.63, 0.2f, Waves.TRIANGLE); C4S = new Oscil(277.18, 0.2f, Waves.TRIANGLE); D4 = new Oscil(293.66, 0.2f, Waves.TRIANGLE); D4S = new Oscil(311.13, 0.2, Waves.TRIANGLE); 
  E4 = new Oscil(329.63, 0.2f, Waves.TRIANGLE); F4 = new Oscil(349.23, 0.2f, Waves.TRIANGLE); F4S = new Oscil(369.99, 0.2f, Waves.TRIANGLE); G4 = new Oscil(392, 0.2f, Waves.TRIANGLE); 
  G4S = new Oscil(415.3, 0.2f, Waves.TRIANGLE); A4 = new Oscil(440, 0.2f, Waves.TRIANGLE); A4S = new Oscil(466.16, 0.2f, Waves.TRIANGLE); B4 = new Oscil(493.88, 0.2f, Waves.TRIANGLE);
  C5 = new Oscil(523.25, 0.2f, Waves.TRIANGLE); C5S = new Oscil(554.37, 0.2f, Waves.TRIANGLE); D5 = new Oscil(587.33, 0.2f, Waves.TRIANGLE); D5S = new Oscil(622.25, 0.2f, Waves.TRIANGLE);
  E5 = new Oscil(659.25, 0.2f, Waves.TRIANGLE); F5 = new Oscil(698.46, 0.2f, Waves.TRIANGLE); F5S = new Oscil(739.99, 0.2f, Waves.TRIANGLE); G5 = new Oscil(783.99, 0.2f, Waves.TRIANGLE);
  G5S = new Oscil(830.6, 0.2f, Waves.TRIANGLE); A5 = new Oscil(880, 0.2f, Waves.TRIANGLE); A5S = new Oscil(932.33, 0.2f, Waves.TRIANGLE); B5 = new Oscil(987.77, 0.2f, Waves.TRIANGLE); 
  C6 = new Oscil(1046.5, 0.2f, Waves.TRIANGLE);
  
  // Get line out for the outputs
  C4Out = minim.getLineOut(); C4SOut = minim.getLineOut(); D4Out = minim.getLineOut(); D4SOut = minim.getLineOut();
  E4Out = minim.getLineOut(); F4Out = minim.getLineOut(); F4SOut = minim.getLineOut(); G4Out = minim.getLineOut();
  G4SOut = minim.getLineOut(); A4Out = minim.getLineOut(); A4SOut = minim.getLineOut(); B4Out = minim.getLineOut();
  C5Out = minim.getLineOut(); C5SOut = minim.getLineOut(); D5Out = minim.getLineOut(); D5SOut = minim.getLineOut(); 
  E5Out = minim.getLineOut(); F5Out = minim.getLineOut(); F5SOut = minim.getLineOut(); G5Out = minim.getLineOut(); 
  G5SOut = minim.getLineOut(); A5Out = minim.getLineOut(); A5SOut = minim.getLineOut(); B5Out = minim.getLineOut(); 
  C6Out = minim.getLineOut(); drumMachineOut = minim.getLineOut();
  
  // This takes input from microphone
  in = minim.getLineIn(Minim.STEREO, 2048);
  
  // Writes input to recording.wav in the data folder
  recorder = minim.createRecorder (in, dataPath("recording.wav"));
  
  // Loads all files
  player = minim.loadFile("recording.wav");
  C3Player = minim.loadFile("guitar/C3.mp3");
  C3SPlayer = minim.loadFile("guitar/C3S.mp3");
  D3Player = minim.loadFile("guitar/D3.mp3");
  D3SPlayer = minim.loadFile("guitar/D3S.mp3");
  E3Player = minim.loadFile("guitar/E3.mp3");
  F3Player = minim.loadFile("guitar/F3.mp3");
  F3SPlayer = minim.loadFile("guitar/F3S.mp3");
  G3Player = minim.loadFile("guitar/G3.mp3");
  G3SPlayer = minim.loadFile("guitar/G3S.mp3");
  A3Player = minim.loadFile("guitar/A3.mp3");
  A3SPlayer = minim.loadFile("guitar/A3S.mp3");
  B3Player = minim.loadFile("guitar/B3.mp3");
  C4GuitarPlayer = minim.loadFile("guitar/C4.mp3");
  
  // Loads backing tracks
  spyroPlayer = minim.loadFile("tracks/Spyro.mp3"); spyroPlayer.setGain(-15);
  eloPlayer = minim.loadFile("tracks/ELO.mp3");
  rdr2Player = minim.loadFile("tracks/RDR2.mp3"); rdr2Player.setGain(-15);
  wotwPlayer = minim.loadFile("tracks/WOTW.mp3"); wotwPlayer.setGain(-25);
  lllPlayer = minim.loadFile("tracks/LLL.mp3"); lllPlayer.setGain(-25);
  
  // Beginning of drum machine segment #2
  // Load all of our samples, using 4 voices for each.
  // this will help ensure we have enough voices to handle even
  // very fast tempos.
  kick  = new Sampler( "drum/BD.mp3", 4, minim );
  snare = new Sampler( "drum/SD.wav", 4, minim );
  hat   = new Sampler( "drum/CHH.wav", 4, minim );
  clap   = new Sampler( "drum/handclap.mp3", 4, minim );
  
  // Patch samplers to the output
  kick.patch( drumMachineOut );
  snare.patch( drumMachineOut );
  hat.patch( drumMachineOut );
  clap.patch( drumMachineOut );
  
  // Draws rows of rectangles
  for (int i = 0; i < 16; i++) {
    buttons.add( new Rect(550+i*24, 55, hatRow, i ) );
    buttons.add( new Rect(550+i*24, 105, snrRow, i ) );
    buttons.add( new Rect(550+i*24, 155, kikRow, i ) );
    buttons.add( new Rect(550+i*24, 205, clpRow, i ) );
  }
  
  beat = 0;
  
  // Starts the sequencer
  drumMachineOut.setTempo( bpm );
  drumMachineOut.playNote( 0, 0.25f, new Tick() );
  
  // End of drum machine segment
}

void draw() {
  background(255);
  
  // Draw white keys
  for(int i = 2; i < 17; i++) {
    fill(255);
    rect(i * 30, 150, 30, 90);
  }
  
  // Colour white keys in red when they're being pressed
  if(C4Playing) {fill(255,0,0); rect(60, 150, 30, 90); fill(0,0,0); rect(80, 150, 20, 65);}
  if(D4Playing) {fill(255,0,0); rect(90, 150, 30, 90); fill(0,0,0); rect(80, 150, 20, 65); rect(110, 150, 20, 65);}
  if(E4Playing) {fill(255,0,0); rect(120, 150, 30, 90); fill(0,0,0); rect(110, 150, 20, 65);}
  if(F4Playing) {fill(255,0,0); rect(150, 150, 30, 90); fill(0,0,0); rect(170, 150, 20, 65);}
  if(G4Playing) {fill(255,0,0); rect(180, 150, 30, 90); fill(0,0,0); rect(170, 150, 20, 65); rect(200, 150, 20, 65);}
  if(A4Playing) {fill(255,0,0); rect(210, 150, 30, 90); fill(0,0,0); rect(200, 150, 20, 65); rect(230, 150, 20, 65);}
  if(B4Playing) {fill(255,0,0); rect(240, 150, 30, 90); fill(0,0,0); rect(230, 150, 20, 65);}
  if(C5Playing) {fill(255,0,0); rect(270, 150, 30, 90); fill(0,0,0); rect(290, 150, 20, 65);}
  if(D5Playing) {fill(255,0,0); rect(300, 150, 30, 90); fill(0,0,0); rect(290, 150, 20, 65); rect(320, 150, 20, 65);}
  if(E5Playing) {fill(255,0,0); rect(330, 150, 30, 90); fill(0,0,0); rect(320, 150, 20, 65);}
  if(F5Playing) {fill(255,0,0); rect(360, 150, 30, 90); fill(0,0,0); rect(380, 150, 20, 65);}
  if(G5Playing) {fill(255,0,0); rect(390, 150, 30, 90); fill(0,0,0); rect(380, 150, 20, 65); rect(410, 150, 20, 65);}
  if(A5Playing) {fill(255,0,0); rect(420, 150, 30, 90); fill(0,0,0); rect(410, 150, 20, 65); rect(440, 150, 20, 65);}
  if(B5Playing) {fill(255,0,0); rect(450, 150, 30, 90); fill(0,0,0); rect(440, 150, 20, 65);}
  if(C6Playing) {fill(255,0,0); rect(480, 150, 30, 90);}
  
  // Corresponding keyboard input for white keys
  textSize(20);
  fill(0,0,0);
  text("A", 68, 235); text("S", 100, 235); text("D", 130, 235); text("F", 160, 235); text("G", 190, 235); text("H", 220, 235);text("J", 255, 235); text("K", 278, 235);
  text("L", 310, 235); text("Z", 340, 235); text("X", 370, 235); text("C", 400, 235); text("V", 430, 235); text("B", 460, 235); text("N", 489, 235);
  
  // Draw black keys
  for(int j = 2; j < 16; j++) {
    fill(0,0,0);
    if(j != 4 && j != 8 && j != 11 && j != 15) {
      rect((20 + j*30), 150, 20, 65);
    }
  }
  
  // Colour black keys in when they're being pressed
  if(C4SPlaying){fill(255,0,0); rect(80, 150, 20, 65);}
  if(D4SPlaying){fill(255,0,0); rect(110, 150, 20, 65);}
  if(F4SPlaying){fill(255,0,0); rect(170, 150, 20, 65);}
  if(G4SPlaying){fill(255,0,0); rect(200, 150, 20, 65);}
  if(A4SPlaying){fill(255,0,0); rect(230, 150, 20, 65);}
  if(C5SPlaying){fill(255,0,0); rect(290, 150, 20, 65);}
  if(D5SPlaying){fill(255,0,0); rect(320, 150, 20, 65);}
  if(F5SPlaying){fill(255,0,0); rect(380, 150, 20, 65);}
  if(G5SPlaying){fill(255,0,0); rect(410, 150, 20, 65);}
  if(A5SPlaying){fill(255,0,0); rect(440, 150, 20, 65);}
  
  // Corresponding keyboard input for black keys
  textSize(15);
  fill(255,255,255);
  text("Q", 84, 205); text("W", 114, 205); text("E", 175, 205); text("R", 205, 205); text("T", 235, 205); text("Y", 296, 205); text("U", 325, 205); text("I", 388, 205);
  text("O", 415, 205); text("P", 446, 205);
  
  // Draw guitar
  for(int i = 1; i < 14; i++) {
    fill(255);
    rect(515 + i * 29.7, 350, 29.7, 29.7);
  }
  
  // Draw guitar strumming box
  rect(544.7, 400, 100, 50);
  
  // Colour guitar buttons when they're active
  if(C3Playing) {fill(255,0,0); rect(544.7, 350, 29.7, 29.7);};
  if(C3SPlaying){fill(255,0,0); rect(574.4, 350, 29.7, 29.7);}
  if(D3Playing) {fill(255,0,0); rect(604.1, 350, 29.7, 29.7);}
  if(D3SPlaying) {fill(255,0,0); rect(633.8, 350, 29.7, 29.7);}
  if(E3Playing) {fill(255,0,0); rect(663.5, 350, 29.7, 29.7);}
  if(F3Playing) {fill(255,0,0); rect(693.2, 350, 29.7, 29.7);}
  if(F3SPlaying) {fill(255,0,0); rect(722.9, 350, 29.7, 29.7);}
  if(G3Playing) {fill(255,0,0); rect(752.6, 350, 29.7, 29.7);}
  if(G3SPlaying) {fill(255,0,0); rect(782.3, 350, 29.7, 29.7);}
  if(A3Playing) {fill(255,0,0); rect(812, 350, 29.7, 29.7);}
  if(A3SPlaying) {fill(255,0,0); rect(841.7, 350, 29.7, 29.7);}
  if(B3Playing) {fill(255,0,0); rect(871.4, 350, 29.7, 29.7);}
  if(C4GuitarPlaying) {fill(255,0,0); rect(901.1, 350, 29.7, 29.7);}
  if(Strum) {fill(255,0,0); rect(544.7, 400, 100, 50);}
  
  // Note values of guitar
  textSize(13);
  fill(0,0,0);
  text("C3", 551, 370); text("C3S", 578, 370); text("D3", 612, 370); text("D3S", 636, 370); text("E3", 673, 370); text("F3", 700, 370);text("F3S", 728, 370); text("G3", 760, 370);
  text("G3S", 786, 370); text("A3", 820, 370); text("A3S", 845, 370); text("B3", 879, 370); text("C4", 907, 370);
  
  // Code for strumming function
  if(Strum) {
    if(C3Playing) {C3Player.play(); C3Player.rewind();}
    if(C3SPlaying){C3SPlayer.play(); C3SPlayer.rewind();}
    if(D3Playing) {D3Player.play(); D3Player.rewind();}
    if(D3SPlaying) {D3SPlayer.play(); D3SPlayer.rewind();}
    if(E3Playing) {E3Player.play(); E3Player.rewind();}
    if(F3Playing) {F3Player.play(); F3Player.rewind();}
    if(F3SPlaying) {F3SPlayer.play(); F3SPlayer.rewind();}
    if(G3Playing) {G3Player.play(); G3Player.rewind();}
    if(G3SPlaying) {G3SPlayer.play(); G3SPlayer.rewind();}
    if(A3Playing) {A3Player.play(); A3Player.rewind();}
    if(A3SPlaying) {A3SPlayer.play(); A3SPlayer.rewind();}
    if(B3Playing) {B3Player.play(); B3Player.rewind();}
    if(C4GuitarPlaying) {C4GuitarPlayer.play(); C4GuitarPlayer.rewind();}
    Strum = false;
  }
  
  // Reset colour
  fill(255);
  
  // Backing track circles
  if(spyroPlaying){fill(255,0,0);} ellipse(90, 370, 50, 50);
  if(eloPlaying){fill(255,0,0);} else{fill(255);} ellipse(180, 370, 50, 50);
  if(rdr2Playing){fill(255,0,0);} else{fill(255);} ellipse(270, 370, 50, 50);
  if(wotwPlaying){fill(255,0,0);} else{fill(255);} ellipse(360, 370, 50, 50);
  if(lllPlaying){fill(255,0,0);} else{fill(255);} ellipse(450, 370, 50, 50);
  
  // Draw background of recording and play/pause
  fill(0,0,0);
  rect(60, 55, 40, 40);
  rect(120, 55, 40, 40);
  fill(255,0,0);
  
  // If recording, draw recording icon
  if (recorder.isRecording()) {rect(65,60,30,30);}
  else{ellipse(80,75,35,35);}
  
  // If player is playing the recording, draw pause button
  if (player.isPlaying()) {rect(127,60,10,30); rect(143,60,10,30);}
  else{triangle(128,58,128,93,157,77);}
  
  // Visualises your recording
  for(int i = 0; i < player.bufferSize() - 1; i++) {
    float x1 = map( i, 0, player.bufferSize(), 200, 510 );
    float x2 = map( i+1, 0, player.bufferSize(), 200, 510 );
    line( x1, 55 + player.left.get(i)*120, x2, 55 + player.left.get(i+1)*120 );
    line( x1, 105 + player.right.get(i)*120, x2, 105 + player.right.get(i+1)*120 );
  }
  
  // Reset colour
  fill(0, 0, 0);
  
  // Text
  textSize(24);
  text("Keyboard synthesiser using oscillators", 60, 140);
  text("Guitar strumming machine", 545, 335);
  text("Strum", 558, 432);
  text("A variety of backing tracks", 60, 290);
  textSize(16);
  text("Drum machine to create your own backing track", 545, 20);
  //text("Spyro theme", 20, 400);
  textSize(14);
  text("Button 1: Records microphone input and stores in data folder", 60, 20);
  text("Button 2: Plays back your recording", 60, 40);
  text("Click on buttons of various rows and hear samples played", 545, 260);
  text("as the beat marker crosses over. Row #1: Cymbal |", 545, 280);
  text("Row #2: Snare | Row #3: Kick | Row #4: Clap |", 545, 300);
  text("Click on whichever notes you want to play", 650, 415);
  text("Then, click strum to play all highlighted notes", 650, 440);
  textSize(12);
  text("Stewart", 70, 317);
  text("Copeland", 65, 335);
  text("Spyro Theme", 58, 415);
  text("Jeff", 172, 319);
  text("Lynne", 165, 335);
  text("When I Was", 150, 415);
  text("A Boy", 165, 430);
  text("(Backing)", 155, 445);
  text("Woody", 253, 319);
  text("Jackson", 250, 335);
  text("Prologue", 245, 415);
  text("Jeff", 348, 319);
  text("Wayne", 340, 335);
  text("Eve Of", 340, 415);
  text("The War", 336, 432);
  text("Justin", 434, 319);
  text("Hurwitz", 427, 335);
  text("Summer", 427, 415);
  text("Montage", 426, 432);
  
  // Beginning of drum machine segment #3
  // Background of drum machine
  rect(545, 30, 385, 210);
  
  // Draws buttons for drum machine
  for(int i = 0; i < buttons.size(); ++i) {
    buttons.get(i).draw();
  }
  
  stroke(128);
  if ( beat % 4 == 0 ) {
    fill(200, 0, 0);
  } else {
    fill(0, 200, 0);
  }
    
  // Beat marker    
  rect(550+beat*24, 35, 14, 9);
  // End of drum machine segment #3
}

// If corresponding keyboard input is pressed..
void keyPressed() { 
  // Play white key notes
  if (key=='a' && C4Playing==false) {C4.patch(C4Out); C4Playing=true;}
  if (key=='s' && D4Playing==false) {D4.patch(D4Out); D4Playing=true;}
  if (key=='d' && E4Playing==false) {E4.patch(E4Out); E4Playing=true;}
  if (key=='f' && F4Playing==false) {F4.patch(F4Out); F4Playing=true;}
  if (key=='g' && G4Playing==false) {G4.patch(G4Out); G4Playing=true;}
  if (key=='h' && A4Playing==false) {A4.patch(A4Out); A4Playing=true;}
  if (key=='j' && B4Playing==false) {B4.patch(B4Out); B4Playing=true;}
  if (key=='k' && C5Playing==false) {C5.patch(C5Out); C5Playing=true;}
  if (key=='l' && D5Playing==false) {D5.patch(D5Out); D5Playing=true;}
  if (key=='z' && E5Playing==false) {E5.patch(E5Out); E5Playing=true;}
  if (key=='x' && F5Playing==false) {F5.patch(F5Out); F5Playing=true;}
  if (key=='c' && G5Playing==false) {G5.patch(G5Out); G5Playing=true;}
  if (key=='v' && A5Playing==false) {A5.patch(A5Out); A5Playing=true;}
  if (key=='b' && B5Playing==false) {B5.patch(B5Out); B5Playing=true;}
  if (key=='n' && C6Playing==false) {C6.patch(C6Out); C6Playing=true;}
  
  // Play black key notes
  if (key=='q' && C4SPlaying==false) {C4S.patch(C4SOut); C4SPlaying=true;}
  if (key=='w' && D4SPlaying==false) {D4S.patch(D4SOut); D4SPlaying=true;}
  if (key=='e' && F4SPlaying==false) {F4S.patch(F4SOut); F4SPlaying=true;}
  if (key=='r' && G4SPlaying==false) {G4S.patch(G4SOut); G4SPlaying=true;}
  if (key=='t' && A4SPlaying==false) {A4S.patch(A4SOut); A4SPlaying=true;}
  if (key=='y' && C5SPlaying==false) {C5S.patch(C5SOut); C5SPlaying=true;}
  if (key=='u' && D5SPlaying==false) {D5S.patch(D5SOut); D5SPlaying=true;}
  if (key=='i' && F5SPlaying==false) {F5S.patch(F5SOut); F5SPlaying=true;}
  if (key=='o' && G5SPlaying==false) {G5S.patch(G5SOut); G5SPlaying=true;}
  if (key=='p' && A5SPlaying==false) {A5S.patch(A5SOut); A5SPlaying=true;}
}

// If corresponding keyboard input is released..
void keyReleased() {
  // Stop corresponding white note playing
  if (key=='a')  {C4.unpatch(C4Out);  C4Playing=false;}
  if (key=='s')  {D4.unpatch(D4Out);  D4Playing=false;}
  if (key=='d')  {E4.unpatch(E4Out);  E4Playing=false;}
  if (key=='f')  {F4.unpatch(F4Out);  F4Playing=false;}
  if (key=='g')  {G4.unpatch(G4Out);  G4Playing=false;}
  if (key=='h')  {A4.unpatch(A4Out);  A4Playing=false;}
  if (key=='j')  {B4.unpatch(B4Out);  B4Playing=false;}
  if (key=='k')  {C5.unpatch(C5Out);  C5Playing=false;}
  if (key=='l')  {D5.unpatch(D5Out);  D5Playing=false;}
  if (key=='z')  {E5.unpatch(E5Out);  E5Playing=false;}
  if (key=='x')  {F5.unpatch(F5Out);  F5Playing=false;}
  if (key=='c')  {G5.unpatch(G5Out);  G5Playing=false;}
  if (key=='v')  {A5.unpatch(A5Out);  A5Playing=false;}
  if (key=='b')  {B5.unpatch(B5Out);  B5Playing=false;}
  if (key=='n')  {C6.unpatch(C6Out);  C6Playing=false;}
  
  // Stop corresponding black note playing
  if (key=='q')  {C4S.unpatch(C4SOut);  C4SPlaying=false;}
  if (key=='w')  {D4S.unpatch(D4SOut);  D4SPlaying=false;}
  if (key=='e')  {F4S.unpatch(F4SOut);  F4SPlaying=false;}
  if (key=='r')  {G4S.unpatch(G4SOut);  G4SPlaying=false;}
  if (key=='t')  {A4S.unpatch(A4SOut);  A4SPlaying=false;}
  if (key=='y')  {C5S.unpatch(C5SOut);  C5SPlaying=false;}
  if (key=='u')  {D5S.unpatch(D5SOut);  D5SPlaying=false;}
  if (key=='i')  {F5S.unpatch(F5SOut);  F5SPlaying=false;}
  if (key=='o')  {G5S.unpatch(G5SOut);  G5SPlaying=false;}
  if (key=='p')  {A5S.unpatch(A5SOut);  A5SPlaying=false;}
}

void mousePressed() {
  // If you press backing track buttons, play the music
  if(mouseX<115 && mouseX>65 && mouseY<395 &&  mouseY>345) {if(spyroPlaying==false)  {spyroPlaying = true; spyroPlayer.play(); spyroPlayer.loop();}
  else {spyroPlaying = false; spyroPlayer.pause();}}
  
  if(mouseX<205 && mouseX>155 && mouseY<395 &&  mouseY>345) {if(eloPlaying==false)  {eloPlaying = true; eloPlayer.play(); eloPlayer.loop();}
  else {eloPlaying = false; eloPlayer.pause();}}
  
  if(mouseX<295 && mouseX>245 && mouseY<395 &&  mouseY>345) {if(rdr2Playing==false)  {rdr2Playing = true; rdr2Player.play(); rdr2Player.loop();}
  else {rdr2Playing = false; rdr2Player.pause();}}
  
  if(mouseX<385 && mouseX>335 && mouseY<395 &&  mouseY>345) {if(wotwPlaying==false)  {wotwPlaying = true; wotwPlayer.play(); wotwPlayer.loop();}
  else {wotwPlaying = false; wotwPlayer.pause();}}
  
  if(mouseX<475 && mouseX>425 && mouseY<395 &&  mouseY>345) {if(lllPlaying==false)  {lllPlaying = true; lllPlayer.play(); lllPlayer.loop();}
  else {lllPlaying = false; lllPlayer.pause();}}
   
  // For guitar
  if(mouseX<574.6 && mouseX>544.7 && mouseY<379.9 &&  mouseY>350) {if(C3Playing==false)  {C3Playing = true;} else{C3Playing = false;}}
  if(mouseX<604.5 && mouseX>574.6 && mouseY<379.9 &&  mouseY>350) {if(C3SPlaying==false)  {C3SPlaying = true;} else{C3SPlaying = false;}}
  if(mouseX<634.4 && mouseX>604.5 && mouseY<379.9 &&  mouseY>350) {if(D3Playing==false)  {D3Playing = true;} else{D3Playing = false;}}
  if(mouseX<664.3 && mouseX>634.4 && mouseY<379.9 &&  mouseY>350) {if(D3SPlaying==false)  {D3SPlaying = true;} else{D3SPlaying = false;}}
  if(mouseX<694.2 && mouseX>664.3 && mouseY<379.9 &&  mouseY>350) {if(E3Playing==false)  {E3Playing = true;} else{E3Playing = false;}}
  if(mouseX<724.1 && mouseX>694.2 && mouseY<379.9 &&  mouseY>350) {if(F3Playing==false)  {F3Playing = true;} else{F3Playing = false;}}
  if(mouseX<754 && mouseX>724.1 && mouseY<379.9 &&  mouseY>350) {if(F3SPlaying==false)  {F3SPlaying = true;} else{F3SPlaying = false;}}
  if(mouseX<783.9 && mouseX>754 && mouseY<379.9 &&  mouseY>350) {if(G3Playing==false)  {G3Playing = true;} else{G3Playing = false;}}
  if(mouseX<813.8 && mouseX>783.9 && mouseY<379.9 &&  mouseY>350) {if(G3SPlaying==false)  {G3SPlaying = true;} else{G3SPlaying = false;}}
  if(mouseX<843.7 && mouseX>813.8 && mouseY<379.9 &&  mouseY>350) {if(A3Playing==false)  {A3Playing = true;} else{A3Playing = false;}}
  if(mouseX<873.6 && mouseX>843.7 && mouseY<379.9 &&  mouseY>350) {if(A3SPlaying==false)  {A3SPlaying = true;} else{A3SPlaying = false;}}
  if(mouseX<903.5 && mouseX>873.6 && mouseY<379.9 &&  mouseY>350) {if(B3Playing==false)  {B3Playing = true;} else{B3Playing = false;}}
  if(mouseX<933.4 && mouseX>903.5 && mouseY<379.9 &&  mouseY>350) {if(C4GuitarPlaying==false)  {C4GuitarPlaying = true;} else{C4GuitarPlaying = false;}}
  if(mouseX<644.7 && mouseX>544.7 && mouseY<450 &&  mouseY>400) {if(Strum==false)  {Strum = true;} else{Strum = false;}}
  
  // Start recording if button pressed
  if (mouseX < 100 && mouseX > 55 && mouseY < 100 && mouseY > 55) {
    if (recorder.isRecording()) {
      recorder.endRecord();
      recorder.save();
      println("Saved recording");
    } else {
      recorder = minim.createRecorder( in , dataPath("recording.wav")); // This allows multiple recordings to be made
      recorder.beginRecord();
      println("Started recording");
    }
  }
  
  // Play/pause recording when button pressed
  if (mouseX < 160 && mouseX > 120 && mouseY < 100 && mouseY > 55) {
    if (player.isPlaying()) {
      player.pause();
      println("Not playing");
    } else {
      player = minim.loadFile("recording.wav");
      player.play();
      println("Playing");
    }
  }
  
  // Drum machine segment #4
  for (int i = 0; i < buttons.size(); ++i) {
    buttons.get(i).mousePressed();
  }
}
