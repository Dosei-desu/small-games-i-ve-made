//controllable spaceship prototype sketch

//Highscorers
/*
  //Normal
- DOSEI *173* 
- zeroI *???*

  //Nightmare
- DOSEI *374* 
- DOSEI *340*
- zeroI *???*
*/

//Updates needed
/*
- Potentially add sound effects to laser and hitting bombs?
- Maybe change laser? Might be a hassle though...
*/

//Fixes needed
/*
- Fix audio bug which delays start of sketch by 20s.
*/

//Coding Notes
/*
- Used https://print-graph-paper.com/virtual-graph-paper to draw the spaceship 
before making the vector shape, which was very helpful.
*/

//Gameplay Notes
/*
- Your ship goes faster forward than side to side!
- You cannot go backwards!
- You cannot move and shoot at the same time!
- Touching a bomb with your ship = Game Over!
- Letting a bomb touch the far left side of the screen = Game Over!
- You get double points on Nightmare Mode!
- The faster the bombs get, the faster your ship gets!
- You can change the "name" variable to change your name in the game!
*/

//Controls
/*
W, S, D - Movement (Up, Down, Right) 
Arrow Keys - Movement (Up, Down, Right)
Mouse Click - Shoot
Spacebar - Shoot
R - Reset
U - Nightmare Mode (increased bomb speed and ship speed)
*/

//variables
  //player
String name = "NEWBIE"; //insert name here (less than 8 letters plzzz)
  //stars
float[] starX = new float[100];
float[] starY = new float[100];
    //stars random counters that only need to be declared once
float[] ran1 =  new float[100]; 
float[] ran2 =  new float[100]; 
  //spaceship
float spaceX = -499, spaceY = 0; //start ship on the far left
boolean blasterOn = false;
int timer = 0;
  //targets
boolean hit = false;
  //bombs
boolean bombHit = false;
float u = 2; //bomb speed
  //bomb array
Bombs[] bomb = new Bombs[1000];
  //score
int score = 0;
int highScore = 0;
color scoreColour;
  //reset
boolean reset = false;
  //nightmare mode
boolean nightMare = false;

  //moosick
import processing.sound.*; //importing SoundFile library
  //background music
SoundFile backgroundMusic1; 
SoundFile backgroundMusic2;
SoundFile deathNoise; //sound played when dead
boolean dStaph = false; //check to stop deathNoise from looping

//setup
void setup() {
  //size
  size(1000, 600);
  //determines FPS, the higher it is, the faster it draws
  frameRate(60); 
  
  //set all text to be aligned with the centre of the screen
  textAlign(CENTER,BOTTOM);
  
  //declaring star random array
  for(int n = 0; n < 100; n = n +1){
    ran1[n] = random(-480,480);
    ran2[n] = random(-280,280);
  }
  
  //declaring bomb variables
  bombDeclare();
  
  //moosick
  backgroundMusic1 = new SoundFile(this, "Neogauge.mp3"); 
  backgroundMusic1.amp(0.15); //controls the volume, 0.25 = 25 %
  backgroundMusic1.loop(); //by using ".loop" instead of ".play", it will loop forever
  backgroundMusic2 = new SoundFile(this, "Digital Ether.mp3");
  backgroundMusic2.amp(0.15); 
    //death noise
  deathNoise = new SoundFile(this, "Death Noise.wav");
  deathNoise.rate(1.10); //changing the sampleRate, since processing seems to play 
  //it back a bit too slow
  deathNoise.amp(0.25);
  
  //sound effects
    //noCode.here(right,now);
}

//draw
void draw() {
  //setting x = 0 and y = 0 to the very centre of the screen
  translate(width/2, height/2);

  //map boundaries
  if (spaceX < -450) {
    spaceX = -450;
  }
  if (spaceX > 490) {
    spaceX = 490;
  }
  if (spaceY < -270) {
    spaceY = -270;
  }
  if (spaceY > 270) {
    spaceY = 270;
  }
  
  //resetterrrr
  reset();
  
  //handling all the variable game states
  if (bombHit) { //lose condition
    backgroundMusic1.stop();
    backgroundMusic2.stop();
    if(!dStaph){
      deathNoise.play();
      dStaph = true;
    }
    println("Bomb has hit!");
    noStroke();
    fill(200,0,0,50);
    rectMode(CENTER);
    rect(0,0,1000,600);
    fill(0,0,0);
    textSize(100);
    text("GAME OVER",0,-100);
    textSize(60);
    text("Higherscorers",0,0);
    textSize(40);
    text("DOSEI - 374",0,70);
    text("DOSEI - 340",0,120);
    text(name+" - "+highScore,0,170);
    scoreColour = color(0,0,0);
  }else if(score >= 1000){ //win condition
    fill(0,0,0,100);
    noStroke();
    rectMode(CENTER);
    rect(0,0,1000,600);
    fill(random(255),random(255),random(255));
    textSize(100);
    text("YOU WIN",0,-100);
    textSize(60);
    text("Higherscorers",0,0);
    textSize(40);
    text(name+" - "+highScore,0,70);
    text("DOSEI - 374",0,120);
    text("DOSEI - 340",0,170);
    scoreColour = color(random(255),random(255),random(255));
  }else{ //without this the ship, bombs, and background aren't rendered
    if(!nightMare){
      scoreColour = color(100,100,100);
    }
    //background
    backGround(spaceX, spaceY, 0, 0, 100); //backGround(x, y, red, green, blue);
    //stars
    starBackGround(0,0);
    //bombs (spawned before ship to not overlap)
    bombSequence();
    //spaceship (spawned inside lose condition, so that the ship disappears 
    //when you lose)
    spaceShip(spaceX, spaceY, 0.5);
    //nightmare mode
    nightMare(nightMare);
  }
  
  //score
  fill(scoreColour);
  textSize(35);
  text("-"+name+"-",0,-255); //player name
  text(score,445,-255);
  text("Score:",365,-255);
     //highScore
  if(highScore < score){
    highScore = score;
  }
  text(highScore,-272,-255);
  text("Highscore:",-390,-255);

  //the pull of space
  spaceX = spaceX -1;
  
  //incremental speed increase
  u = u * 1.0001;
  if(u > 12){ //max speed of the game
    u = 12;
  }
}

void mousePressed(){
  blasterOn = true;
}

void keyPressed() {
  switch(key) {
    //Up
  case 'w':
    spaceY = spaceY -5*u;
    break;
  case 'W':
    spaceY = spaceY -5*u;
    break;

    //Down
  case 's':
    spaceY = spaceY +5*u;
    break;
  case 'S':
    spaceY = spaceY +5*u;
    break;

    //Right
  case 'd':
    spaceX = spaceX +10*u;
    break;
  case 'D':
    spaceX = spaceX +10*u;
    break;

    //Shoot
  case ' ': //' ' = spacebar
    blasterOn = true;
    break;
    
    //Nightmare Mode
  case 'u': 
    nightMare = true;
    break;
  case 'U': 
    nightMare = true;
    break;

    //Reset
  case 'r':
    reset = true;
    break;
  case 'R':
    reset = true;
    break;
  }

  switch(keyCode) { //keyCode is used for special characters
    //Up
  case UP:
    spaceY = spaceY -5*u;
    break;

    //Down
  case DOWN:
    spaceY = spaceY +5*u;
    break;

    //Right
  case RIGHT:
    spaceX = spaceX +10*u;
    break;
  }
}

void reset(){
  if(reset){
    bombDeclare(); //re-declare bomb variables to reset them and start over
    bombHit = false; //resets bomb hit boolean
    //stop all music and play bgm from the beginning
    backgroundMusic1.stop();
    backgroundMusic2.stop();
    backgroundMusic1.loop();
    score = 0; //resets score, but keeps the highscore
    spaceX = -499; //resets ship X-coordinate
    spaceY = 0; //resets ship Y-coordinate
    nightMare = false; //resets to normal mode
    dStaph = false; //resets death sound (otherwise it'll only play once)
    u = 2; //resets speed of ship and bombs
    reset = false; //resets this "void reset()" function
  }
  if(mousePressed && bombHit){
    bombDeclare();
    bombHit = false;
    backgroundMusic1.stop();
    backgroundMusic2.stop();
    backgroundMusic1.loop();
    score = 0;
    spaceX = -499; 
    spaceY = 0;
    nightMare = false;
    dStaph = false;
    u = 2;
    reset = false;
  }
}

//shots fired
void blaster(float x, float y, float size) {
  int hitTimer = 0; 

  //blaster on?
  if (blasterOn) {
    timer = timer +1;
    hitTimer = hitTimer +1;
  }

  //hitscan
  if (hitTimer > 0) { //is only 'true' for a split second
    hit = true;
  } else {
    hit = false;
  }

  //blaster animation (the timer number here and in the if() statement below decide blaster reach)
  while (timer > 0 && timer < 300) { 
    strokeWeight(4);
    stroke(0, 255, 0, 50);
    fill(0, 255, 0, 200);
    rectMode(CORNERS);
    rect(x-30*size, y-38*size, x-30*size+timer, y-36*size);
    rect(x-30*size, y+38*size, x-30*size+timer, y+36*size);
    timer = timer +1;
  }
  if(timer >= 300){ 
  //supposed to make it so the laser lasts for more than a splitsecond (doesn't work)
    timer = timer +1;
  }
  if (timer >= 301) { //this is what makes it so you can fire more than just once
    blasterOn = false;
    timer = 0;
  }
}

void bombs(Bombs bomb) {
  if (hit && bomb.x < spaceX+300 && bomb.x > spaceX && bomb.y > spaceY-50 && bomb.y < spaceY+50) {
    if(bomb.bombExist && nightMare){
      score = score +2;
    }else if(bomb.bombExist){
      score = score +1;
    }
    bomb.bombExist = false;
    
  } else if (bomb.bombExist) {
    //bomb shape
    strokeWeight(3);
    stroke(200, 200, 200, 100);
    fill(25);
    beginShape();
    vertex(bomb.x, bomb.y-25*bomb.size);
    vertex(bomb.x+5*bomb.size, bomb.y-25*bomb.size);
    vertex(bomb.x+25*bomb.size, bomb.y-5*bomb.size);
    vertex(bomb.x+25*bomb.size, bomb.y+5*bomb.size);
    vertex(bomb.x+5*bomb.size, bomb.y+25*bomb.size);
    vertex(bomb.x-5*bomb.size, bomb.y+25*bomb.size);
    vertex(bomb.x-25*bomb.size, bomb.y+5*bomb.size);
    vertex(bomb.x-25*bomb.size, bomb.y-5*bomb.size);
    vertex(bomb.x-5*bomb.size, bomb.y-25*bomb.size);
    endShape(CLOSE);
    strokeWeight(1);
    stroke(200, 200, 200, 100);
    fill(255, 0, 0);
    circle(bomb.x, bomb.y, 16*bomb.size);

    //fail condition
    if (bomb.x <= -500 && bomb.y >= -300 && bomb.y <= 300 ||
    bomb.x <= spaceX && bomb.x >= spaceX-50 && bomb.y >= spaceY-25 && 
    bomb.y <= spaceY+25) {
      bombHit = true;
    }
  }
}

void bombDeclare(){
  for(int n = 0; n < 1000; n = n+1){
    //bombs(x,y,size,bombExist);
    bomb[n] = new Bombs(500*n+(400+random(100,200)), random(-250,250), 0.8, true); 
  }
}

void bombSequence(){
  for(int n = 0; n < 1000; n = n+1){
    bomb[n].update();
    bombs(bomb[n]);
  }
}

void nightMare(boolean onSwitch){
  if(onSwitch){
    if(u < 5){ //adds additional speed, but only once
      u = u +3;
      backgroundMusic1.stop();
      backgroundMusic2.loop();
    }
    noStroke();
    fill(255,0,0,100);
    rectMode(CENTER);
    rect(0,0,1000,600);
    fill(random(155,255),0,0,150);
    textSize(100);
    text("NIGHTMARE",0,-100);
    scoreColour = color(random(155,255),0,0);
  }
}

void spaceShip(float x, float y, float size) {
  blaster(x, y, size);
  strokeWeight(5);
  stroke(200, 200, 200, 150);
  fill(120);
  beginShape();
  vertex(x, y);
  vertex(x-10*size, y+10*size);
  vertex(x, y+10*size);
  vertex(x-20*size, y+30*size);
  vertex(x-30*size, y+30*size);
  vertex(x-30*size, y+40*size);
  vertex(x-40*size, y+50*size);
  vertex(x-90*size, y+50*size);
  vertex(x-80*size, y+40*size);
  vertex(x-90*size, y+30*size);
  vertex(x-80*size, y+20*size);
  vertex(x-70*size, y);
  vertex(x-80*size, y-20*size);
  vertex(x-90*size, y-30*size);
  vertex(x-80*size, y-40*size);
  vertex(x-90*size, y-50*size);
  vertex(x-40*size, y-50*size);
  vertex(x-30*size, y-40*size);
  vertex(x-30*size, y-30*size);
  vertex(x-20*size, y-30*size);
  vertex(x, y-10*size);
  vertex(x-10*size, y-10*size);
  endShape(CLOSE);
  //engines
  if (keyPressed && key == 'd' || keyPressed && keyCode == RIGHT) {
    strokeWeight(5);
    stroke(252, 190, 17, 100);
    fill(252, 190, 17, 200);
    beginShape();
    vertex(x-100*size, y-40*size);
    vertex(x-120*size, y-30*size);
    vertex(x-122*size, y-32*size);
    vertex(x-124*size, y-34*size);
    vertex(x-126*size, y-36*size);
    vertex(x-128*size, y-38*size);
    vertex(x-130*size, y-40*size);
    vertex(x-128*size, y-42*size);
    vertex(x-126*size, y-44*size);
    vertex(x-124*size, y-46*size);
    vertex(x-122*size, y-48*size);
    vertex(x-120*size, y-50*size);
    endShape(CLOSE);
    beginShape();
    vertex(x-100*size, y+40*size);
    vertex(x-120*size, y+30*size);
    vertex(x-122*size, y+32*size);
    vertex(x-124*size, y+34*size);
    vertex(x-126*size, y+36*size);
    vertex(x-128*size, y+38*size);
    vertex(x-130*size, y+40*size);
    vertex(x-128*size, y+42*size);
    vertex(x-126*size, y+44*size);
    vertex(x-124*size, y+46*size);
    vertex(x-122*size, y+48*size);
    vertex(x-120*size, y+50*size);
    endShape(CLOSE);
  }
}

void starBackGround(float x, float y){
  strokeWeight(5);
  stroke(255,252,195,random(50,100));
  for(int n = 0; n < 100; n = n +1){
    starX[n] = ran1[n];
    starY[n] = ran2[n];
    point(x+starX[n],y+starY[n]);
  }
}

void backGround(float x, float y, int r, int g, int b) {
  background(r, g, b);
  noStroke();
  fill(r-255, g-255, b-255);
  circle(x, y, 3000);
  fill(r-120, g-120, b-120);
  circle(x, y, 2400);
  fill(r-110, g-110, b-110);
  circle(x, y, 2250);
  fill(r-100, g-100, b-100);
  circle(x, y, 2100);
  fill(r-90, g-90, b-90);
  circle(x, y, 1950);
  fill(r-80, g-80, b-80);
  circle(x, y, 1800);
  fill(r-70, g-70, b-70);
  circle(x, y, 1650);
  fill(r-60, g-60, b-60);
  circle(x, y, 1500);
  fill(r-50, g-50, b-50);
  circle(x, y, 1350);
  fill(r-40, g-40, b-40);
  circle(x, y, 1200);
  fill(r-30, g-30, b-30);
  circle(x, y, 1050);
  fill(r-20, g-20, b-20);
  circle(x, y, 900);
  fill(r-10, g-10, b-10);
  circle(x, y, 750);
  fill(r, g, b);
  circle(x, y, 600);
  fill(r+10, g+10, b+10);
  circle(x, y, 450);
}
