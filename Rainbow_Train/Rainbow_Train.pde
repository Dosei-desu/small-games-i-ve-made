//Rainbow Train

//Inspired by the "Borderlands 3 DLC: 'Psycho Krieg and the Fantastic Fustercluck'"

//global variables
  //train
float trainX = 1200; 
float trainY;
int trainRan = (int)random(0,7);
float speed = 10;
  //player
float playerX, playerY;

void setup(){
  size(800,400);
  frameRate(30);
}

void draw(){
  background(0);
  for(int n = 0; n < 8; ++n){ //spawn them tracks!
    stroke(150);
    trainTracks(15+(n*53));
    if(n == trainRan){
      stroke(random(0,255),random(0,255),random(0,255));
      trainTracks(15+(n*53));
    }
  }
  //player
  player(playerX,playerY);
  //fog
  rectMode(CENTER);
  noStroke();
  fill(0,100);
  rect(width/2,height/2,800,400);
  //train
  trainSpawn();
}

void player(float x, float y){
  x = mouseX;
  y = mouseY;
  strokeWeight(4);
  stroke(255);
  fill(255,105,180);
  circle(x,y,25);
}

void trainSpawn(){
  //train, chugga, chugga, chugga
  trainY = 15+(trainRan*53);
  rainbowTrain(trainX,trainY,0.4);
  trainX -= speed;
}

void trainRespawn(float x, float size){
  if(x+1125*size <= 0){
    trainX = 1200;
    trainRan = (int)random(0,7);
    if(speed <= 50){
      speed += 1;
    }
    println("respawn");
    println(speed);
  }
}

void trainTracks(float y){
  //t-t-t-t-train traaacks!!!
  line(0,y-10,width,y-10);
  line(0,y+10,width,y+10);
  //vertical lines
  for(int n = 0; n < 54; ++n){
    line(5+(n*15),y-15,5+(n*15),y+15);
  }
}

void rainbowTrain(float trainX, float trainY, float size){
  //let's draw!
    //lights
  noStroke();
  fill(200,150);
  beginShape();
  vertex(trainX,trainY-5);
  vertex(trainX-200,trainY-35);
  vertex(trainX-200,trainY+25);
  endShape(CLOSE);
  beginShape();
  vertex(trainX,trainY+5);
  vertex(trainX-200,trainY-25);
  vertex(trainX-200,trainY+35);
  endShape(CLOSE);
  //train
  strokeWeight(4);
  stroke(50);
  fill(random(0,255),random(0,255),random(0,255));
    //front bit
  beginShape();
  vertex(trainX,trainY);
  vertex(trainX,trainY-5*size);
  vertex(trainX+5*size,trainY-10*size);
  vertex(trainX+15*size,trainY-15*size);
  vertex(trainX+30*size,trainY-20*size);
  vertex(trainX+75*size,trainY-25*size);
  vertex(trainX+75*size,trainY+25*size);
  vertex(trainX+30*size,trainY+20*size);
  vertex(trainX+15*size,trainY+15*size);
  vertex(trainX+5*size,trainY+10*size);
  vertex(trainX,trainY+5*size);
  endShape(CLOSE);
    //carriages
  rectMode(CORNERS);
  rect(trainX+75*size,trainY-25*size,trainX+275*size,trainY+25*size);
  rect(trainX+275*size,trainY-25*size,trainX+475*size,trainY+25*size);
  rect(trainX+475*size,trainY-25*size,trainX+675*size,trainY+25*size);
  rect(trainX+675*size,trainY-25*size,trainX+875*size,trainY+25*size);
  rect(trainX+875*size,trainY-25*size,trainX+1075*size,trainY+25*size);
    //back bit
  beginShape();
  vertex(trainX+1075*size,trainY-25*size);
  vertex(trainX+1100*size,trainY-25*size);
  vertex(trainX+1115*size,trainY-20*size);
  vertex(trainX+1120*size,trainY-15*size);
  vertex(trainX+1125*size,trainY-5*size);
  vertex(trainX+1125*size,trainY+5*size);
  vertex(trainX+1120*size,trainY+15*size);
  vertex(trainX+1115*size,trainY+20*size);
  vertex(trainX+1100*size,trainY+25*size);
  vertex(trainX+1075*size,trainY+25*size);
  endShape(CLOSE);
  trainRespawn(trainX,size);
}
