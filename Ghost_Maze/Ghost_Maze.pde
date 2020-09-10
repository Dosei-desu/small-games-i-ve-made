//Ghost Maze

//Scoreboard:
/*
- zeroIndex - *45s* (normal mode / pre-portal update)
- Dosei ----- *40s* (normal mode)
*/

//Updates:
/*
- Add pick-ups?
*/

//Bugs:
/*
- Very rare bug where the enemies will be set to a speed of 0 
  or so close to 0 that they don't move. Have only encountered
  this once.
- On nightmare mode, it is possible to get trapped in the spawn for
  over a minute by the ghosts.
*/

//Notes:
/*
- Used https://print-graph-paper.com/virtual-graph-paper to draw maze.
  I broke down the graph paper so that each square was 50x50, meaning 16x16 squares
  of 50x50 = 800x800, i.e. the size() of my sketch
- Code for handling line/circle detection borrowed from:
  http://www.jeffreythompson.org/collision-detection/line-circle.php
*/

//Gameplay Notes:
/*
- Score is based on how fast you can make it to the end, i.e. the lower
  the better.
- There are roaming ghosts that will reset you if they touch you!
- On nightmare mode, the number of ghosts are doubled, and their speed is also 
  doubled, however, your timer only counts half as fast and your speed is doubled too, 
  making it possible to achieve even faster times than on normal mode.
- Theoretically, the lowest score possible is about 20-25s, my personal highscore 
  is 40s (with portal), 54s (without portal).
- You can see the eyes of the roaming ghosts and use it to your advantage!
- There is a portal hidden somewhere on the level, which may give you an advantage!
- Nightmare mode only gets turned off when you press R to reset the game.
*/

//Controls:
/*
- Movement: W,A,S,D or Arrow-keys
- Reset: R
- Nightmare Mode: U
*/

//****************************************************************************************
//Variables:

//player
float px, py; //x and y
float pSize = 15;
float fovSize = 200; //size of field-of-view
float flicker = 255; //controls field-of-view opacity 255 = 100% 0 = 0%
boolean flickerN = true;
  //movement
boolean aDown = false;
boolean sDown = false;
boolean dDown = false;
boolean wDown = false;

//enemies
int arrayS = 10; //determines number of enemies 
float[] eX = new float[arrayS];
float[] eY = new float[arrayS];
float[] speedX = new float[arrayS]; 
float[] speedY = new float[arrayS]; 

//line detection
int lArraySize = 119; //determines the size of the array
//line co-ordinates
float[] lx1 = new float[lArraySize];
float[] lx2 = new float[lArraySize];
float[] ly1 = new float[lArraySize];
float[] ly2 = new float[lArraySize];

//background colour
color mazeCol = color(0,0,0);

//nightmare mode
boolean nightMare = false;
int nm = 2;
float nmBonus = 0;

//score
float score = 0;
float highScore = 0;

//reset
boolean reset = false;

//moosick
/*
import processing.sound.*; //importing SoundFile library
//background music
SoundFile backgroundMusic; 
*/

//****************************************************************************************
void setup() {
  size(800, 800);
  //sets start position
  px = 25; 
  py = 25;
  //enemy array
  for(int n = 0; n < arrayS; n += 1){
    eX[n] = random(100,700);
    eY[n] = random(100,700);
    speedX[n] = random(-1.5,1.5);
    speedY[n] = random(-1.5,1.5);
  }
  //moosick
  /*
  backgroundMusic = new SoundFile(this, "8bit Syndrome.mp3"); //("8bit Syndrome" by z3r0) - https://www.youtube.com/watch?v=28dbNKUz7QI 
  backgroundMusic.amp(0.15); //controls the volume, 0.25 = 25 %
  backgroundMusic.loop(); //by using ".loop" instead of ".play", it will loop forever
  */
}
//****************************************************************************************
void draw() {
  background(mazeCol);
  //field of view
  fov(px, py, fovSize);
  flickerOn();
  //maze
  maze();
  //declaring lines based on maze() values
  for (int n = 0; n < lArraySize; ++n) {
    strokeWeight(6);
    stroke(mazeCol);
    line(lx1[n], ly1[n], lx2[n], ly2[n]);
  }
  //exit
  exitGate();
  //portal
  portal();
  //player
  player(px, py);
  //controls
  controls();
  //enemies
  enemy(arrayS);
  //hit detection and subsequent reset
  hit();
  //resets the reset, ironically
  reset = false;
  //displays instructions
  instructions();
  //score
  score();
  //win condition
  win();
  //nightmare mode
  nightMare(nightMare);
}
//****************************************************************************************

void controls(){
  //controls
  //checks if nightmare mode is on, and if so, doubles speed
  if(aDown && nightMare){
    px = px -2;
  }else if(aDown){
    px = px -1;
  }
  if(dDown && nightMare){
    px = px +2;
  }else if(dDown){
    px = px +1;
  }
  if(wDown && nightMare){
    py = py -2;
  }else if(wDown){
    py = py -1;
  }
  if(sDown && nightMare){
    py = py +2;
  }else if(sDown){
    py = py +1;
  }
}

void exitGate(){ //visualising exit
  if(px > width-150 && py > height-100){
    strokeWeight(6);
    stroke(255);
    fill(255);
    line(width-100,height,width,height); //door
    //lightcone tracking player
    if(px > width-100 && py > height-75){ 
      noStroke();
      fill(255,100);
      beginShape();
      vertex(width-100,height);
      vertex(width,height);
      vertex(px,py);
      endShape(CLOSE);
    }
  }
}

void portal(){ //from 325,375 to 525,725
  //one-way portal
  strokeWeight(4);
  ellipseMode(CENTER);
  if(px > 200 && px < 350 && py > 350 && py < 400){ //make portal visible only when near
    //light-cone
    noStroke();
    fill(255,100);
    beginShape();
    vertex(325,375-10);
    vertex(325,375+10);
    vertex(px,py);
    endShape();
    //orange portal (entry)
    stroke(255,94,19); 
    fill(0);
    ellipse(325,375,20,35);
    if(px > 325-5 && px < 325+5 && py > 375-17 && py < 375+17){ //teleport
      px = 525;
      py = 725;
    }
  }
  if(px > 500 && px < 550 && py > 650 && py < 750){
    //light-cone
    noStroke();
    fill(255,100);
    beginShape();
    vertex(525-17,725);
    vertex(525+17,725);
    vertex(px,py);
    endShape();
    //blue portal (exit)
    stroke(57,138,215); 
    fill(0);
    ellipse(525,725,35,20);
  }
}

void fov(float x, float y, float size) {
  noStroke();
  fill(150,flicker);
  circle(x, y, size);
}

void flickerOn(){
  float n = -5;
  if(flicker >= 255){
    flickerN = true;
  }
  if(flicker <= 0){
    flickerN = false;
  }
  if(!flickerN){
    flicker -= n;
  }else if(flickerN){
    flicker += n;
  } 
}

void player(float x, float y) {
  strokeWeight(3);
  stroke(0);
  fill(252, 194, 104);
  circle(x, y, pSize);
}

void enemy(int n){
  fovSize = 200;
  for(n = 0; n < arrayS-(arrayS-nm); n += 1){
    eX[n] = eX[n] - speedX[n];
    eY[n] = eY[n] - speedY[n];
    if(eX[n] < px+pSize*6 && eY[n] < py+pSize*6 && eX[n] > px-pSize*6 && eY[n] > py-pSize*6){
      strokeWeight(2);
      stroke(mazeCol);
      fill(mazeCol);
      //diamond shape
      beginShape();
      vertex(eX[n],eY[n]-pSize*2);
      vertex(eX[n]+pSize*2,eY[n]);
      vertex(eX[n],eY[n]+pSize*2);
      vertex(eX[n]-pSize*2,eY[n]);
      endShape(CLOSE);
      fovSize = 100;
    }
    noStroke();
    if(mazeCol != color(0)){
     fill(255, 255, 255);
    }else{
     fill(255,0,0);
    }
    circle(eX[n]-5,eY[n],5);
    circle(eX[n]+5,eY[n],5);
    if(eX[n] >= 800-pSize*2){
      speedX[n] = speedX[n] *-1;
    }
    if(eX[n] <= 0+pSize*2){
      speedX[n] = speedX[n] *-1;
    }
    if(eY[n] >= 800-pSize*2){
      speedY[n] = speedY[n] *-1;
    }
    if(eY[n] <= 0+pSize*2){
      speedY[n] = speedY[n] *-1;
    }
    if(eX[n] < px+pSize*2 && eY[n] < py+pSize*2 && eX[n] > px-pSize*2 && eY[n] > py-pSize*2){
      reset = true;
    }
  }
}

void hit() {
  for (int n = 0; n < lArraySize; ++n) {
    boolean hit = lineCircle(lx1[n], ly1[n], lx2[n], ly2[n], px, py, pSize/2);
    if (hit || reset) {
      px = 25; 
      py = 25;
      score = 0;
      //resets enemies
      if(!nightMare){
        for(int n2 = 0; n2 < arrayS; n2 += 1){
          speedX[n2] = random(-1.5,1.5);
          speedY[n2] = random(-1.5,1.5);
        }
      }else{
        for(int n3 = 0; n3 < arrayS; n3 += 1){
          speedX[n3] = random(-3,3);
          speedY[n3] = random(-3,3);
        }
      }
    }
  }
}

void score(){
  //checks if a highScore already exists (i.e. is bigger than 0)
  //if it doesn't, highScore is set to the value of score
  //if it does, highScore is only set to the value of score if it's lower
  if(highScore < score && highScore == 0 && win()){
    highScore = score;
  }else if(highScore > score && score > 0 && win()){
    highScore = score;
  }
  textAlign(CENTER,BOTTOM);
  textSize(25);
  fill(252, 194, 104);
  text("Fastest Time: "+(int)highScore/60,650,30);
  text("Current Time: "+(int)score/60,150,30);
  score = score +(1-nmBonus);
}

boolean win(){
  if(py >= height){
    reset = true;
    return true;
  }
  return false;
}

void instructions(){
  if(px < 150 && py < 50){
    textAlign(CENTER,BOTTOM);
    textSize(60);
    fill(252, 194, 104);
    text("Find the Exit!",width/2,height/2);
    textSize(30);
    text("Move with Arrow-keys or W,A,S,D",width/2,height/2+50);
    strokeWeight(5);
    stroke(252, 194, 104);
    line(765,725,765,775);
    line(765,775,750,760);
    line(765,775,780,760);
  }
}

void nightMare(boolean nmOn){
  if(nmOn){
    nm = arrayS;
    mazeCol = color(155,0,0);
    nmBonus = 0.5; //slows down counter by 50%, making it possible to get times as low as 25 seconds
  }else{
    nm = arrayS/2;
    mazeCol = color(0);
    nmBonus = 0;
  }
}

boolean lineCircle(float x1, float y1, float x2, float y2, float px, float py, float pSize) {
  //detects if either is inside the circle
  boolean inside1 = pointCircle(x1, y1, px, py, pSize);
  boolean inside2 = pointCircle(x2, y2, px, py, pSize);
  if (inside1 || inside2) {
    return true;
  }

  // get length of the line
  float distX = x1 - x2;
  float distY = y1 - y2;
  float len = sqrt( (distX*distX) + (distY*distY) );

  // get dot product of the line and circle
  float dot = (((px-x1)*(x2-x1)) + ((py-y1)*(y2-y1))) / pow(len, 2);

  // find the closest point on the line
  float closestX = x1 + (dot * (x2-x1));
  float closestY = y1 + (dot * (y2-y1));

  // is this point actually on the line segment?
  // if so keep going, but if not, return false
  boolean onSegment = linePoint(x1, y1, x2, y2, closestX, closestY);
  if (!onSegment) return false;

  // optionally, draw a circle at the closest
  // point on the line
  fill(0,0,0,0); //invisible, but can be changed to something like fill(0,255,0,255); to debug collisions
  noStroke();
  ellipse(closestX, closestY, 5, 5);

  // get distance to closest point
  distX = closestX - px;
  distY = closestY - py;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  if (distance <= pSize) {
    return true;
  }
  return false;
}

boolean pointCircle(float pointx, float pointy, float px, float py, float pSize) {
  // get distance between the point and circle's center
  // using the Pythagorean Theorem
  float distX = pointx - px;
  float distY = pointy - py;
  float distance = sqrt((distX*distX) + (distY*distY));

  // if the distance is less than the circle's
  // radius the point is inside!
  if (distance <= pSize) {
    return true;
  }
  return false;
}

boolean linePoint(float x1, float y1, float x2, float y2, float pointx, float pointy) {
  // get distance from the point to the two ends of the line
  float d1 = dist(pointx,pointy, x1,y1);
  float d2 = dist(pointx,pointy, x2,y2);

  // get the length of the line
  float lineLen = dist(x1,y1, x2,y2);

  // since floats are so minutely accurate, add
  // a little buffer zone that will give collision
  float buffer = 0.1;    // higher # = less accurate

  // if the two distances are equal to the line's
  // length, the point is on the line!
  // note we use the buffer here to give a range,
  // rather than one #
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
    return true;
  }
  return false;
}

//controls
void keyReleased() //when key is released
{
  if (key == 'A' || key == 'a' || keyCode == LEFT){
    aDown = false;
  }
  else if(key == 'D' || key == 'd' || keyCode == RIGHT){
    dDown = false;
  }
  else if(key == 'W' || key == 'w' || keyCode == UP){
    wDown = false;
  }
  else if(key == 'S' || key == 's' || keyCode == DOWN){
    sDown = false;
  }
}

void keyPressed() //when key is pressed
{
  if (key == 'A' || key == 'a' || keyCode == LEFT){
    aDown = true;
  }
  else if(key == 'D' || key == 'd' || keyCode == RIGHT){
    dDown = true;
  }
  else if(key == 'W' || key == 'w' || keyCode == UP){
    wDown = true;
  }
  else if(key == 'S' || key == 's' || keyCode == DOWN){
    sDown = true;
  }
  if(key == 'r' || key == 'R'){
    nightMare = false; //moved nightmare mode reset to here to avoid having to
                       //constantly initiate it
    reset = true;
  }
  if(key == 'u' || key == 'U'){
    nightMare = true;
    px = 25; 
    py = 25;
    score = 0;
    for(int n2 = 0; n2 < arrayS; n2 += 1){
        speedX[n2] = random(-3,3);
        speedY[n2] = random(-3,3);
    }
  }
}

void maze() { //creates coordinates for the maze
  int n = 0;
  int mC = 50; //maze counter (to make it easier to write) basically the size per "block"
  
  if(n < lArraySize){ //to avoid out-of-bounds if I somehow miscount the amount of arrays I use
    n = 0;
  }
  
  //permiter walls
  lx1[n] = 0; ly1[n] = 0; lx2[n] = width; ly2[n] = 0; //ceiling
  n = n +1; //increments by one, so I don't have to constantly write the [n] individually, 
            //which would be a pain in the ass
  lx1[n] = 0; ly1[n] = 0; lx2[n] = 0; ly2[n] = height; //left wall
  n = n +1;
  lx1[n] = 0; ly1[n] = height; lx2[n] = width-mC*2; ly2[n] = height; //floor (there is a gap here to serve as the Exit
  n = n +1;
  lx1[n] = width; ly1[n] = 0; lx2[n] = width; ly2[n] = height; //right wall
  n = n +1;
  
  //actual maze (following the order of the first y-axis coordinate to give some sort of structure)
    //y starts on 0
  lx1[n] = mC*3; ly1[n] = mC*0; lx2[n] = mC*3; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*0; lx2[n] = mC*5; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*0; lx2[n] = mC*9; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*0; lx2[n] = mC*10; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*0; lx2[n] = mC*14; ly2[n] = mC*2;
  n = n +1;
    //y starts on 1
  lx1[n] = mC*0; ly1[n] = mC*1; lx2[n] = mC*2; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*3; ly1[n] = mC*1; lx2[n] = mC*4; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*1; lx2[n] = mC*6; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*1; lx2[n] = mC*8; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*1; lx2[n] = mC*12; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*1; lx2[n] = mC*13; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*1; lx2[n] = mC*15; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*1; lx2[n] = mC*16; ly2[n] = mC*1;
  n = n +1;
    //y stars on 2
  lx1[n] = mC*1; ly1[n] = mC*2; lx2[n] = mC*1; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*1; ly1[n] = mC*2; lx2[n] = mC*2; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*2; lx2[n] = mC*4; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*2; lx2[n] = mC*7; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*2; lx2[n] = mC*7; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*8; ly1[n] = mC*2; lx2[n] = mC*10; ly2[n] = mC*2;
  n = n +1; 
  lx1[n] = mC*11; ly1[n] = mC*2; lx2[n] = mC*11; ly2[n] = mC*4;
  n = n +1; 
  lx1[n] = mC*11; ly1[n] = mC*2; lx2[n] = mC*13; ly2[n] = mC*2;
  n = n +1; 
  lx1[n] = mC*8; ly1[n] = mC*2; lx2[n] = mC*10; ly2[n] = mC*2;
  n = n +1;
    //y stars on 3
  lx1[n] = mC*1; ly1[n] = mC*3; lx2[n] = mC*4; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*3; lx2[n] = mC*2; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*3; ly1[n] = mC*3; lx2[n] = mC*3; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*3; lx2[n] = mC*6; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*3; lx2[n] = mC*7; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*3; lx2[n] = mC*9; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*3; lx2[n] = mC*13; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*3; lx2[n] = mC*15; ly2[n] = mC*3;
  n = n +1;
    //y starts on 4
  lx1[n] = mC*0; ly1[n] = mC*4; lx2[n] = mC*2; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*4; lx2[n] = mC*4; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*4; lx2[n] = mC*5; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*4; lx2[n] = mC*7; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*8; ly1[n] = mC*4; lx2[n] = mC*8; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*4; lx2[n] = mC*10; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*4; lx2[n] = mC*12; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*4; lx2[n] = mC*15; ly2[n] = mC*4;
  n = n +1;
    //y starts on 5
  lx1[n] = mC*0; ly1[n] = mC*5; lx2[n] = mC*1; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*5; lx2[n] = mC*4; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*5; lx2[n] = mC*5; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*5; lx2[n] = mC*10; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*5; lx2[n] = mC*11; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*5; lx2[n] = mC*15; ly2[n] = mC*5;
  n = n +1;
    //y starts on 6
  lx1[n] = mC*1; ly1[n] = mC*6; lx2[n] = mC*5; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*6; lx2[n] = mC*4; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*6; lx2[n] = mC*6; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*6; lx2[n] = mC*9; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*6; lx2[n] = mC*16; ly2[n] = mC*6;
  n = n +1;
    //y starts on 7
  lx1[n] = mC*0; ly1[n] = mC*7; lx2[n] = mC*3; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*1; ly1[n] = mC*7; lx2[n] = mC*1; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*7; lx2[n] = mC*8; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*7; lx2[n] = mC*7; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*8; ly1[n] = mC*7; lx2[n] = mC*8; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*7; lx2[n] = mC*9; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*7; lx2[n] = mC*12; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*7; lx2[n] = mC*16; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*7; lx2[n] = mC*14; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*7; lx2[n] = mC*15; ly2[n] = mC*8;
  n = n +1;
    //y starts on 8
  lx1[n] = mC*2; ly1[n] = mC*8; lx2[n] = mC*4; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*8; lx2[n] = mC*5; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*8; lx2[n] = mC*7; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*8; lx2[n] = mC*11; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*8; lx2[n] = mC*11; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*8; lx2[n] = mC*13; ly2[n] = mC*8;
  n = n +1;
    //y starts on 9
  lx1[n] = mC*2; ly1[n] = mC*9; lx2[n] = mC*2; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*9; lx2[n] = mC*5; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*9; lx2[n] = mC*6; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*9; lx2[n] = mC*10; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*9; lx2[n] = mC*15; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*9; lx2[n] = mC*14; ly2[n] = mC*15;
  n = n +1;
    //y starts on 10
  lx1[n] = mC*0; ly1[n] = mC*10; lx2[n] = mC*3; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*3; ly1[n] = mC*10; lx2[n] = mC*3; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*10; lx2[n] = mC*11; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*10; lx2[n] = mC*9; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*10; lx2[n] = mC*14; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*10; lx2[n] = mC*16; ly2[n] = mC*10;
  n = n +1;
    //y starts on 11
  lx1[n] = mC*1; ly1[n] = mC*11; lx2[n] = mC*1; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*1; ly1[n] = mC*11; lx2[n] = mC*2; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*11; lx2[n] = mC*2; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*11; lx2[n] = mC*8; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*11; lx2[n] = mC*6; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*11; lx2[n] = mC*7; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*11; lx2[n] = mC*10; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*11; lx2[n] = mC*10; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*11; lx2[n] = mC*11; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*11; lx2[n] = mC*13; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*11; lx2[n] = mC*15; ly2[n] = mC*11;
  n = n +1;
    //y starts on 12
  lx1[n] = mC*2; ly1[n] = mC*12; lx2[n] = mC*5; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*3; ly1[n] = mC*12; lx2[n] = mC*3; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*12; lx2[n] = mC*5; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*12; lx2[n] = mC*9; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*12; lx2[n] = mC*11; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*12; lx2[n] = mC*12; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*12; lx2[n] = mC*14; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*12; lx2[n] = mC*16; ly2[n] = mC*12;
  n = n +1;
    //y starts on 13
  lx1[n] = mC*0; ly1[n] = mC*13; lx2[n] = mC*3; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*13; lx2[n] = mC*4; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*13; lx2[n] = mC*7; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*8; ly1[n] = mC*13; lx2[n] = mC*12; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*13; lx2[n] = mC*10; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*13; lx2[n] = mC*13; ly2[n] = mC*14;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*13; lx2[n] = mC*14; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*13; lx2[n] = mC*16; ly2[n] = mC*13;
  n = n +1;
    //y starts on 14
  lx1[n] = mC*1; ly1[n] = mC*14; lx2[n] = mC*3; ly2[n] = mC*14;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*14; lx2[n] = mC*8; ly2[n] = mC*14;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*14; lx2[n] = mC*9; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*14; lx2[n] = mC*11; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*14; lx2[n] = mC*13; ly2[n] = mC*14;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*14; lx2[n] = mC*15; ly2[n] = mC*14;
  n = n +1;
    //y starts on 15
  lx1[n] = mC*1; ly1[n] = mC*15; lx2[n] = mC*5; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*15; lx2[n] = mC*2; ly2[n] = mC*16;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*15; lx2[n] = mC*12; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*15; lx2[n] = mC*12; ly2[n] = mC*16;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*15; lx2[n] = mC*13; ly2[n] = mC*16;
  n = n +1;
}

//debug mode
/*
void mouseDragged() {
  px = mouseX;
  py = mouseY;
}
*/
