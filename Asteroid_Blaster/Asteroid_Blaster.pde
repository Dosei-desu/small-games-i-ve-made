//Asteroid shooter with mouse-tracking blaster


//Coding Notes
/*
- Gotten a lot of help for the blaster mouse-tracking code from:
  https://discourse.processing.org/t/rotation-and-easing/5704/4
- Used https://print-graph-paper.com/virtual-graph-paper to help visualise vector shapes
- The spaceship is the Rebel Flagship from the game FTL.
*/

//--------------------------------------------------------------------------------------------------------------
//Variables

//star background
  //random numbers arrays
float[] ran1 = new float[100]; //x
float[] ran2 = new float[100]; //y

//spaceship image
PImage spaceShip;

//blaster / laser
float laserX = 0, laserY = 0, laserTimer = 0;
boolean click = false;

//mouse tracking (have to be global as they are used outside the mouse-tracker object)
PVector myMouse = new PVector(); //creates mouse vector
float rot = 0, alpha, dalpha, easing = 0.5; //rotation, alpha, dalpha, and easing (controls speed of tracking)

//--------------------------------------------------------------------------------------------------------------
//Setup
void setup(){
  //sketch size
  size(700,900);
  //fps - if below 60 fps, the rotation of the blaster looks jittery and warped
  frameRate(60); 
  //declaring the random numbers that controls stars' x and y coordinates, if done in draw the stars jump around like crazy
  for(int n = 0; n < 100; n = n +1){
    ran1[n] = random(-330,330); //x within the bounds of sketch width (since width is translated to the centre, far left edge is -350 and far right is 350
    ran2[n] = random(20,880); //y within the bounds of sketch height
  }
  //spaceship image
  spaceShip = loadImage("spaceShip.png");
}
//--------------------------------------------------------------------------------------------------------------
//Draw
void draw(){
  //set centre of sketch at the very top
  translate(width/2,0);
  //background
  background(0,0,75);
  starBackGround(); //random stars
  spaceship(); //technically part of the background
  
  //mouse tracker
  mouseTracker();
  //matrix containing blaster (without the matrix, the translate and rotate would affect the entire sketch)
  pushMatrix();
  blaster();
  popMatrix();
}
//--------------------------------------------------------------------------------------------------------------

void blaster(){
  translate(0, 850); //same x and y coordinates as "myMouse.sub();" otherwise the tracking gets weird
  rotate(rot); //rotation
  
  //----------------
  //lasers
  pushMatrix();
  lasers();
  popMatrix();
  //----------------
  
  //actual blaster 
  strokeWeight(0.8);
  stroke(0);
  fill(229,142,46);
  //body
  ellipse(0,0,50,50); //when set to x = 0 and y = 0, it spins around its centre axis perfectly. The rotation is imperceptible without the "guns" to show it
  //blaster "guns"
  rectMode(CORNERS);
  rect(0,16,50,10);
  rect(0,-16,50,-10);
  //blaster guards(???)
  beginShape();
  vertex(0,-5);
  vertex(15,-5);
  vertex(15,-20);
  vertex(-15,-20);
  endShape(CLOSE);
  beginShape();
  vertex(0,5);
  vertex(15,5);
  vertex(15,20);
  vertex(-15,20);
  endShape(CLOSE);
  line(-10,0,25,0);
  circle(-10,0,25);
}

void lasers(){
 if(click){
    strokeWeight(4);
    stroke(0,255,0);
    line(laserX+50,laserY+13,laserX+75,laserY+13);
    line(laserX+50,laserY-13,laserX+75,laserY-13);
    laserX = laserX + 15;
  }
}

void mouseReleased(){
  click = false;
  laserX = 0;
}

void mousePressed(){
  click = true;
}

void spaceship(){ //...that you have to protect
  image(spaceShip, -284, 710);
}

void mouseTracker(){
  myMouse.set(mouseX,mouseY); //sets pvector (x,y,z) you don't need to declare z as 0, it's defaulted to that
  myMouse.sub(width/2,850); //subtracts pvector (x,y,z) (sets it to centrepoint / has to be the same as translate)
  alpha = myMouse.heading(); //calculates angle for 2D vectors | https://processing.org/reference/PVector_heading_.html |
  dalpha = (alpha - rot)/PI; //angle minus rotation divided by PI, basically is 0.0 whenever its equal to the coordinates of myMouse
  //if the myMouse coordinates don't match with the dalpha (which is 0.0), i.e are bigger or smaller, then it changes the rotation accordingly
  if(dalpha < -1){ 
    rot -= TWO_PI;
  }
  else if(dalpha > 1){
    rot += TWO_PI;
  }
  rot += (alpha - rot) * easing; //adds the myMouse.heading() minus rotation and multiplied by easing (determines rotation speed)
}

void starBackGround(){
  //star coordinates array
  float[] starX = new float[100];
  float[] starY = new float[100];
  strokeWeight(5);
  stroke(255,252,195,random(50,100));
  for(int n = 0; n < 100; n = n +1){
    starX[n] = ran1[n];
    starY[n] = ran2[n];
    point(starX[n],starY[n]);
  }
}
