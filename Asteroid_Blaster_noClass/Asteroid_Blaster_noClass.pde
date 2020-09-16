//Asteroid shooter with mouse-tracking blaster


//Need to implement a vector to handle lasers, but not sure how...

//Coding Notes
/*
- Sensei zeroIndex helped me with this sketch in a lot of different ways.
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
float laserX = 0;
float laserY = 800;
float laserSpeed = 0; //set to 0 because reasons
color laserCol = color(0,255,0,0); //spawn invisible
boolean doOnce = true; //just this once, plz

//mouse tracking (have to be global as they are used outside the mouse-tracker object)
PVector myMouse = new PVector(); //creates mouse vector
float rot = 0, alpha, dalpha, easing = 0.5; //rotation, alpha, dalpha, and easing (controls speed of mouse tracking)

//test target
float tarX, tarY, tarDia;
color tarCol = color(0,0,255);

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
  
  //test target
  tarX = 200; tarY = 200; tarDia = 50;
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
  
  //blaster
  blaster();
  //laser blaster
  lasers();
  
  //test target
  strokeWeight(2);
  stroke(0);
  fill(tarCol);
  circle(tarX,tarY,tarDia);
}
//--------------------------------------------------------------------------------------------------------------

void collision(){
  boolean hit = lineCircle(laserY+50,13,laserY+75,13, tarX, tarY, tarDia/2);
  if(hit){
    tarCol = color(255,0,0);
  }
}

// LINE/CIRCLE
boolean lineCircle(float x1, float y1, float x2, float y2, float cx, float cy, float r) {

  // is either end INSIDE the circle?
  // if so, return true immediately
  boolean inside1 = pointCircle(x1,y1, cx,cy,r);
  boolean inside2 = pointCircle(x2,y2, cx,cy,r);
  if (inside1 || inside2) return true;

  // get length of the line
  float distX = x1 - x2;
  float distY = y1 - y2;
  float len = sqrt( (distX*distX) + (distY*distY) );

  // get dot product of the line and circle
  float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len,2);

  // find the closest point on the line
  float closestX = x1 + (dot * (x2-x1));
  float closestY = y1 + (dot * (y2-y1));

  // is this point actually on the line segment?
  // if so keep going, but if not, return false
  boolean onSegment = linePoint(x1,y1,x2,y2, closestX,closestY);
  if (!onSegment) return false;

  // optionally, draw a circle at the closest
  // point on the line
  fill(255,0,0);
  noStroke();
  ellipse(closestX, closestY, 20, 20);

  // get distance to closest point
  distX = closestX - cx;
  distY = closestY - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  if (distance <= r) {
    return true;
  }
  return false;
}


// POINT/CIRCLE
boolean pointCircle(float px, float py, float cx, float cy, float r) {

  // get distance between the point and circle's center
  // using the Pythagorean Theorem
  float distX = px - cx;
  float distY = py - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  // if the distance is less than the circle's
  // radius the point is inside!
  if (distance <= r) {
    return true;
  }
  return false;
}


// LINE/POINT
boolean linePoint(float x1, float y1, float x2, float y2, float px, float py) {

  // get distance from the point to the two ends of the line
  float d1 = dist(px,py, x1,y1);
  float d2 = dist(px,py, x2,y2);

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

void blaster(){
  pushMatrix(); //matrix containing blaster (without the matrix, the translate and rotate would affect the entire sketch)
  translate(0, 850); //same x and y coordinates as "myMouse.sub();" otherwise the tracking gets weird
  rotate(rot); //rotation
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
  popMatrix();
}

void lasers(){
  //laser lines
  strokeWeight(4);
  stroke(laserCol);
  line(laserX+13,laserY,laserX+13,laserY-25);
  line(laserX-13,laserY,laserX-13,laserY-25);
  laserY = laserY - laserSpeed; 
  
}

void mousePressed(){
  if(doOnce){
    laserSpeed = 15;
    laserY = 800;
    laserCol = color(0,255,0,255);
    doOnce = false;
  }
  
  if(laserY < 0){
    laserY = 800;
  }
}

void spaceship(){ //...that you have to protect
  image(spaceShip, -284, 710);
}

void mouseTracker(){
  myMouse.set(mouseX,mouseY); //sets pvector (x,y,z) you don't need to declare z as 0, it's defaulted to that
  myMouse.sub(width/2,850); //subtracts pvector (x,y,z) (sets it to centrepoint / has to be the same as translate)
  alpha = myMouse.heading(); //calculates angle for 2D vectors | https://processing.org/reference/PVector_heading_.html
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
