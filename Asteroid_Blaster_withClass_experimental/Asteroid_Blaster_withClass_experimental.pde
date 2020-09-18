//Asteroid shooter with mouse-tracking blaster

//Zero fixed the classes on this...

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
float laserRot = 1.5;

Lasers laser = new Lasers(0, laserRot);
int ARRAY_SIZE = 7;
int laserIndex = 0;
Lasers[] laserA = new Lasers[ARRAY_SIZE];

//mouse tracking (have to be global as they are used outside the mouse-tracker object)
PVector myMouse = new PVector(); //creates mouse vector
float rot = 0, alpha, dalpha, easing = 0.5; //rotation, alpha, dalpha, and easing (controls speed of tracking)

//target
float[] targetX = {150,-150,-250};
float[] targetY = {-700,-500,-300};
float diameter = 50;
Asteroids[] target = {new Asteroids(targetX[0], targetY[0], diameter), new Asteroids(targetX[1], targetY[1], diameter), new Asteroids(targetX[2], targetY[2], diameter)};


//--------------------------------------------------------------------------------------------------------------
//Setup
void setup() {
  //sketch size
  size(700, 900);
  //fps - if below 60 fps, the rotation of the blaster looks jittery and warped
  frameRate(60); 
  //declaring the random numbers that controls stars' x and y coordinates, if done in draw the stars jump around like crazy
  for (int n = 0; n < 100; n = n +1) {
    ran1[n] = random(-330, 330); //x within the bounds of sketch width (since width is translated to the centre, far left edge is -350 and far right is 350
    ran2[n] = random(20, 880); //y within the bounds of sketch height
  }

  //Init of laser array
  for (int i = 0; i < laserA.length; i++) {
    laserA[i] = new Lasers(0, laserRot);
  }
  //spaceship image
  spaceShip = loadImage("spaceShip.png");
}
//--------------------------------------------------------------------------------------------------------------
//Draw
void draw() {
  //set centre of sketch at the very top
  translate(width/2, 850); //set the centre of the screen to the turret to try and fix the collision issue
  //background
  background(0, 0, 75);
  starBackGround(); //random stars
  spaceship(); //technically part of the background

  //mouse tracker
  mouseTracker();

  //blaster
  blaster();
  //laser blaster
  //loop through all the lasers
  for (int i = 0; i < laserA.length; i++) {
    laserA[i].update();
  }
  
  //target practice (declaring all the stuff here just for testing)
  
  
  for(int i = 0; i < target.length; i++){
    for(int n = 0; n < laserA.length; n++){    
      if(laserA[n].getY() > target[i].getY()*-1 && laserA[n].getY() < target[i].getY()*-1+diameter && 
         myMouse.heading() <= target[i].asteroidVecHeading()+0.04 && myMouse.heading() >= target[i].asteroidVecHeading()-0.075){ 
         println("hit!");
         target[i].hit(true);
      }else{
        if(mousePressed){
          println("target "+i+" "+target[i].asteroidVecHeading());
          println("mouse :"+myMouse.heading());
        }
      }
    }    
  } 
  for(int n = 0; n < target.length; n++){
    if(target[n].hit != true){
      strokeWeight(5);
      stroke(0);
      fill(255);
      target[n].update();
    }
  }
}
//--------------------------------------------------------------------------------------------------------------

void blaster() {
  pushMatrix(); //matrix containing blaster (without the matrix, the translate and rotate would affect the entire sketch)
  rotate(rot-1.55); //rotation (set to -1.55 to rotate it a further 90 degrees)
  //actual blaster 
  strokeWeight(0.8);
  stroke(0);
  fill(229, 142, 46);
  //body
  ellipse(0, 0, 50, 50); //when set to x = 0 and y = 0, it spins around its centre axis perfectly. The rotation is imperceptible without the "guns" to show it
  //blaster "guns"
  rectMode(CORNERS);
  rect(16, 0, 10, 50);
  rect(-16, 0, -10, 50);
  //blaster guards(???)
  beginShape();
  vertex(-5, 0);
  vertex(-5, 15);
  vertex(-20, 15);
  vertex(-20, -15);
  endShape(CLOSE);
  beginShape();
  vertex(5, 0);
  vertex(5, 15);
  vertex(20, 15);
  vertex(20, -15);
  endShape(CLOSE);
  line(0, -10, 0, 25);
  circle(0, -10, 25);
  popMatrix();
}

void mousePressed() {
  laserA[laserIndex] = new Lasers(0, rot);
  if ( laserIndex < ARRAY_SIZE-1 ) {
    laserIndex++;
  } else {
    laserIndex = 0;
  }
  println("i: " + laserIndex);
}

void spaceship() { //...that you have to protect
  image(spaceShip, -284, -140);
}

void mouseTracker() {
  myMouse.set(mouseX, mouseY); //sets pvector (x,y,z) you don't need to declare z as 0, it's defaulted to that
  myMouse.sub(width/2, 850); //subtracts pvector (x,y,z) (sets it to centrepoint / has to be the same as translate)
  alpha = myMouse.heading(); //calculates angle for 2D vectors | https://processing.org/reference/PVector_heading_.html |
  dalpha = (alpha - rot)/PI; //angle minus rotation divided by PI, basically is 0.0 whenever its equal to the coordinates of myMouse
  //if the myMouse coordinates don't match with the dalpha (which is 0.0), i.e are bigger or smaller, then it changes the rotation accordingly
  if (dalpha < -1) { 
    rot -= TWO_PI;
  } else if (dalpha > 1) {
    rot += TWO_PI;
  }
  rot += (alpha - rot) * easing; //adds the myMouse.heading() minus rotation and multiplied by easing (determines rotation speed)
}

void starBackGround() {
  //star coordinates array
  float[] starX = new float[100];
  float[] starY = new float[100];
  strokeWeight(5);
  stroke(255, 252, 195, random(50, 100));
  for (int n = 0; n < 100; n = n +1) {
    starX[n] = ran1[n];
    starY[n] = ran2[n]-850;
    point(starX[n], starY[n]);
  }
}
