//Asteroid shooter with mouse-tracking blaster

//Updates I want to add
/*
- Scoreboard thingy. -partially implemented-
- Nightmare mode... obviously.
*/

//Bugs
/*
- There's about a 90% chance that a shot will count as a hit. I need to tweak the collision parameters until it's 100%.
*/

//Coding Notes
/*
- My coding sensei zeroIndex helped make the Lasers class before I was knowledgeable enough to make it myself, but I did make the Asteroids class myself,
  as well as subsequent changes to the Lasers class, beyond the constructor and update function. I'm still a bit uncertain about class though, truth be told.
  
- The collision detection is based on PVector.heading(), i.e. the specific degree a PVector is angled from 0,0 on the x,y axis, which is centred on the blaster.
  Without this for detection, it'd be very difficult to measure collision, because the laser x and y coordinates are based on a rotating axis
  that always makes x = 0, and thus basic detection statements become true, regardless of what direction your blaster is pointed. It was a real
  headache to deal with, and I almost gave up several times, but I somehow persevered... yay...
  
- Gotten a lot of help for the blaster mouse-tracking code from:
  https://discourse.processing.org/t/rotation-and-easing/5704/4
 
 - Used https://print-graph-paper.com/virtual-graph-paper to help visualise vector shapes
 
 - The spaceship is the Rebel Flagship from the game FTL.
 */

//--------------------------------------------------------------------------------------------------------------
//Variables

//star background
  //random numbers arrays for star coordinates
float[] ran1 = new float[100]; //x
float[] ran2 = new float[100]; //y

//spaceship image
PImage spaceShip;

//blaster / laser
float laserRot = 1.5;
int ARRAY_SIZE = 14; //used to control the amount of lasers available
int laserIndex = 0;
Lasers[] laser = new Lasers[ARRAY_SIZE];
color[] laserCol = new color[ARRAY_SIZE]; 

//mouse tracking (have to be global as they are used outside the mouse-tracker object)
PVector myMouse = new PVector(); //creates mouse vector
float rot = 0, alpha, dalpha, easing = 0.5; //rotation, alpha, dalpha, and easing (controls speed of tracking)

//target
int targetArraySize = 500;
float[] targetX = new float[targetArraySize];
float[] targetY = new float[targetArraySize];
float diameter = 50;
float[] tempHeading = new float[ARRAY_SIZE];
Asteroids[] target = new Asteroids[targetArraySize];

//scoreboard
int score = 0;
int collisionCounter = 0; //counts how many times you have been hit by an asteroid
int[] oneTimeCount = new int[targetArraySize]; //basically an on/off switch for counting collisions


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
  for (int i = 0; i < laser.length; i++) {
    laser[i] = new Lasers(0, laserRot);
    laserCol[i] = color(0, 255, 0, 0);
  }
  
  //spaceship image
  spaceShip = loadImage("spaceShip.png");
  
  //asteroid declare
  for (int n = 0; n < target.length; n++) {
    targetX[n] = random(-300,300);
    targetY[n] = -1000-250*n;
    target[n] = new Asteroids(targetX[n], targetY[n], diameter);
    target[n].astVelocity(2); //declares initial speed of asteroid targets
  }
  
}
//--------------------------------------------------------------------------------------------------------------
//Draw
void draw() {
  //set centre of sketch at the very top
  translate(width/2, 850); //set the centre of the screen to the turret to try and fix the collision issue
  //background
  background(0, 0, 75);
  starBackGround(); //random stars
  
  //technically part of the background
  spaceship();  

  //mouse tracker
  mouseTracker();

  //blaster
  blaster();
  
  //lasers
  for (int i = 0; i < laser.length; i++) {
    stroke(laserCol[i]);
    laser[i].update();
  }
  
  //asteroids
  asteroidSpawner();
  
  //scoreboard
  scoreBoard();
  
  //health
  youTookaHit();
}
//--------------------------------------------------------------------------------------------------------------

void scoreBoard(){
  textAlign(CENTER,BOTTOM);
  textSize(45);
  fill(229, 142, 46);
  text(score,0,-750);
}

void youTookaHit(){
  for(int n = 0; n < target.length; n++){
    if(target[n].getY() > 0 && oneTimeCount[n] == 0){
       collisionCounter += 1;
       oneTimeCount[n] = 1;
    }
  }
  if(collisionCounter == 0){
    shieldShape(250,0,2);
    shieldShape(275,0,2);
    shieldShape(300,0,2);
  }else if(collisionCounter == 1){
    shieldShape(250,0,2);
    shieldShape(275,0,2);
  }else if(collisionCounter == 2){
    shieldShape(250,0,2);
  }else if(collisionCounter > 3){
    rectMode(CENTER);
    noStroke();
    fill(200,0,0);
    rect(0,-400,700,900);
    textAlign(CENTER,BOTTOM);
    textSize(45);
    fill(0);
    text("GAME OVER",0,-400);
  }
}

void shieldShape(float x, float y, float size){
  noStroke();
  fill(255,255,0,155);
  beginShape();
    vertex(x,y);
    vertex(x+5*size,y+1*size);
    vertex(x+5*size,y+10*size);
    vertex(x+4*size,y+13*size);
    vertex(x+2*size,y+15*size);
    vertex(x,y+16*size);
    vertex(x-2*size,y+15*size);
    vertex(x-4*size,y+13*size);
    vertex(x-5*size,y+10*size);
    vertex(x-5*size,y+1*size);
  endShape();
}

void asteroidSpawner(){
  //target practice (declaring all the stuff here just for testing)
  for(int i = 0; i < target.length; i++){
    for(int n = 0; n < laser.length; n++){    
      //checks if laser Y and asteroid/target y are close to each other, also checks if laser y is less than 800 (to prevent long shots that
      //trivialise difficulty), and, finally, it checks if the angles of the laser and asteroids from 0,0 are close to each other
      if(laser[n].getY() > (target[i].getY()+diameter/2)*-1 && laser[n].getY() < (target[i].getY()-diameter/2)*-1 && laser[n].getY() < 800 &&
        tempHeading[n] <= target[i].asteroidVecHeading()+0.055 && tempHeading[n] >= target[i].asteroidVecHeading()-0.055 && target[i].hit != true)
      {
        target[i].hit(true); //makes hit true to despawn the specific asteroids that fulfill the longass if statement above
        score += 1;
      }
    }    
  } 

  //asteroid spawner
  for(int n = 0; n < target.length; n++){
    if(target[n].hit != true && target[n].getY() < 75){ //if hit == true, the asteroid disappears
      target[n].update();
    }
  }
}

void mousePressed() {
  laserCol[laserIndex] = color(0, 255, 0, 255); //doesn't make laser visible until you fire
  laser[laserIndex] = new Lasers(0, rot); //creates the lasers based on the rotation of the mouseTracker and starting y = 0
  laser[laserIndex].lspeed = 5;  //doesn't set speed until you fire the individual lasers
  tempHeading[laserIndex] = alpha; //makes a temp save of the alpha i.e. myMouse.heading() for every laser shot, 
                                   //which is the angle used to compare with the heading angle of the asteroids
  if ( laserIndex < ARRAY_SIZE-1 ) {
    laserIndex++;
  } else {
    laserIndex = 0;
  }
  println("i: " + laserIndex); //debug stuff
}

void spaceship() { //...that you have to protect
  image(spaceShip, -284, -140);
}

//code borrowed from: https://discourse.processing.org/t/rotation-and-easing/5704/4 and tweaked to fit my sketch
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
  rot += (alpha - rot) * easing; //adds the myMouse.heading() minus rotation and multiplied by easing (easing determines rotation speed of turret)
}

//made to look like it's part of the spaceship
void blaster() {
  pushMatrix(); //matrix containing blaster (without the matrix, the translate and rotate would affect the entire sketch)
  rotate(rot-1.55); //rotation (set to -1.55 to rotate it a further 90 degrees), returns the original orientation to the blaster coordinates
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
  //debug mode stuff (shows X and Y axis of blaster)
  // /*
  strokeWeight(1.5);
  stroke(255,0,0);
  line(-600,0,600,0);
  line(0,-100,0,1000);
  // */
  popMatrix();
}

void starBackGround() { //just some pretty stars that twinkle
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
