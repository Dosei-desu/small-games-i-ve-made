//Rainbow Train

//Inspired by the Borderlands 3 DLC: 'Psycho Krieg and the Fantastic Fustercluck' and its anthropomorphic rainbow train boss


//Highscorers:
/*
DOSEI ---- *50s*
*/

//Notes:
/*
Controls - W,A,S,D / Arrow-keys
Reset - R
*/


//------------------------------------------------------------------------------------------------------//
//Global variables

//train
float trainX = 1200; 
float trainY;
int trainRan = (int)random(0,3);
float speed = 10;

//player
float playerX = 50; 
float playerY = 200;
  //controls (only necessary for left and right)
boolean aDown = false; //left
boolean dDown = false; //right
  
//gameplay stuff
boolean reset = false;
float score = 0;
float highScore = 0;
int deathCounter = 0;

//------------------------------------------------------------------------------------------------------//
//setup

void setup(){
  size(800,400);
  frameRate(30);
}

//------------------------------------------------------------------------------------------------------//
//draw

void draw(){
  background(0);
  
  //train the tracks
  for(int n = 0; n < 3; ++n){ //spawn them tracks!
    stroke(150);
    trainTracks(height/2-53+(n*53));
    if(n == trainRan){
      stroke(random(0,255),random(0,255),random(0,255));
      trainTracks(height/2-53+(n*53));
    }
  }
  
  //player stuff
  player(playerX,playerY);
  controls();
  
  //fog
  rectMode(CENTER);
  noStroke();
  //turns screen redder the longer you stay alive
  if(speed > 75){
    fill(255,0,0,100);
  }else if(speed > 60){
    fill(200,0,0,100);
  }else if(speed > 45){
    fill(100,0,0,100);
  }else{
    fill(0,100);
  }
  rect(width/2,height/2,800,400);
  
  //train
  trainSpawn();
  
  //reset
  reset();
  
  //score
  score();
  deathCounter();
}

//------------------------------------------------------------------------------------------------------//
//player and score stuff

void player(float x, float y){ //basically just a circle with controllable coordinates
  strokeWeight(4);
  stroke(255);
  fill(255,105,180);
  circle(x,y,20);
}

void score(){
  score += 1;
  if(highScore == 0 || score > highScore){ //only updates highscore if it's 0 or below score
    highScore = score;
  }
  fill(255,105,180);
  textAlign(CENTER,BOTTOM);
  textSize(25);
  text("Score: "+(int)score/30,150,50);
  text("Highscore: "+(int)highScore/30,650,50);
}

//counts amount of times died without restarting the simulation and also counts resets
void deathCounter(){ 
  if(deathCounter > 0){
    fill(255);
    textAlign(CENTER,BOTTOM);
    textSize(35);
    text(deathCounter,width/2,60);
  }
}

void reset(){ //handles what happens when reset is reset before being reset back to standard reset
  if(reset){
    trainX = 1200; 
    trainRan = (int)random(0,3);
    speed = 10;
    playerX = 150; 
    playerY = height/2;
    score = 0;
    deathCounter += 1;
    reset = false;
  }
}

//------------------------------------------------------------------------------------------------------//
//train and tracks

//handles the train (chugga chugga), its spawnpoints based on trainRan (0,1,2), and its speed
void trainSpawn(){ 
  //train, chugga, chugga, chugga
  trainY = 200-53+(trainRan*53);
  rainbowTrain(trainX,trainY,0.4);
  trainX -= speed;
}

//controls the respawn mechanic of the train by setting a new trainRan for ^^^^^
void trainRespawn(float x, float size){
  if(x+1125*size <= 0){
    trainX = 1200;
    trainRan = (int)random(0,3);
    if(speed <= 79){ //controls upper limit of speed
      speed += 5;
    }
  }
}

//traintrack creator
void trainTracks(float y){
  //t-t-t-t-train traaacks!!!
  line(0,y-10,width,y-10);
  line(0,y+10,width,y+10);
  //vertical lines
  for(int n = 0; n < 54; ++n){
    line(5+(n*15),y-15,5+(n*15),y+15);
  }
}

//*boom* *crash* *bang* *reset*
void collision(float x, float y, float size){
  if(playerX > x && playerX < x+1125*size && playerY > y-25*size && playerY < y+25*size){
    trainX = 1200; 
    trainRan = (int)random(0,3);
    speed = 10;
    playerX = 150; 
    playerY = height/2;
    deathCounter += 1;
    println("You were turned into a fine paste by the Rainbow Train at "+(int)score/30+" seconds.");
    score = 0;
  }
}

void rainbowTrain(float x, float y, float size){ //chugga chugga
  //let's draw!
  
  //headlights
  noStroke();
  fill(200,150);
  beginShape();
  vertex(x,y-5);
  vertex(x-200,y-35);
  vertex(x-200,y+25);
  endShape(CLOSE);
  beginShape();
  vertex(x,y+5);
  vertex(x-200,y-25);
  vertex(x-200,y+35);
  endShape(CLOSE);
  
  //train
  strokeWeight(4);
  stroke(50);
  fill(random(0,255),random(0,255),random(0,255));
    //front bit
  beginShape();
  vertex(x,y);
  vertex(x,y-5*size);
  vertex(x+5*size,y-10*size);
  vertex(x+15*size,y-15*size);
  vertex(x+30*size,y-20*size);
  vertex(x+75*size,y-25*size);
  vertex(x+75*size,y+25*size);
  vertex(x+30*size,y+20*size);
  vertex(x+15*size,y+15*size);
  vertex(x+5*size,y+10*size);
  vertex(x,y+5*size);
  endShape(CLOSE);
    //carriages
  rectMode(CORNERS);
  rect(x+75*size,y-25*size,x+275*size,y+25*size);
  rect(x+275*size,y-25*size,x+475*size,y+25*size);
  rect(x+475*size,y-25*size,x+675*size,y+25*size);
  rect(x+675*size,y-25*size,x+875*size,y+25*size);
  rect(x+875*size,y-25*size,x+1075*size,y+25*size);
    //back bit
  beginShape();
  vertex(x+1075*size,y-25*size);
  vertex(x+1100*size,y-25*size);
  vertex(x+1115*size,y-20*size);
  vertex(x+1120*size,y-15*size);
  vertex(x+1125*size,y-5*size);
  vertex(x+1125*size,y+5*size);
  vertex(x+1120*size,y+15*size);
  vertex(x+1115*size,y+20*size);
  vertex(x+1100*size,y+25*size);
  vertex(x+1075*size,y+25*size);
  endShape(CLOSE);
  
  //these are pushed in here to use the same coordinate and size variable
  trainRespawn(x,size);
  collision(x,y,size);
}

//------------------------------------------------------------------------------------------------------//
//player controls

//two different types of controls for movement: rapidly-updated side-to-side and slow up-and-down

void controls(){ //only for side-to-side, since this updates rapidly and is unfit for up-and-down movement
  if(aDown && playerX > 16){ //checks coordinates of playerX to ensure you don't leave the tracks
    playerX = playerX -10;
  }
  if(dDown && playerX < width-16){
    playerX = playerX +10;
  }
}

void keyPressed(){
  if (key == 'A' || key == 'a' || keyCode == LEFT){
    aDown = true;
  }
  else if(key == 'D' || key == 'd' || keyCode == RIGHT){
    dDown = true;
  }
  if(playerY != 200-53){ //checks coordinates of playerY to ensure you don't leave the tracks
    if(key == 'W' || key == 'w' || keyCode == UP){
      playerY = playerY -53;
    }
  }
  if(playerY != 200-53+(53*2)){
    if(key == 'S' || key == 's' || keyCode == DOWN){
      playerY = playerY +53;
    }
  }
  if(key == 'r' || key == 'R'){
    reset = true;
  }
}
void keyReleased(){
  if (key == 'A' || key == 'a' || keyCode == LEFT){
    aDown = false;
  }
  else if(key == 'D' || key == 'd' || keyCode == RIGHT){
    dDown = false;
  }

}
