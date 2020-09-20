//asteroid targets

class Asteroids{
  private float x;
  private float y;
  private float size;
  private boolean hit = false;
  private float astSpeed = 0;
  
  Asteroids(float _x, float _y, float _size){
    this.x = _x;
    this.y = _y;
    this.size = _size;
  }
  
  PVector asteroidVec(float _x, float _y){
    return new PVector(_x, _y);
  }
  
  float asteroidVecHeading(){
    return asteroidVec(this.x,this.y).heading();
  }
  
  float getX(){
    return this.x;
  }
  
  float getY(){
    return this.y;
  }
  
  void astVelocity(float _astSpeed){
    this.astSpeed = _astSpeed;
  }
  
  void hit(boolean _hit){
    hit = _hit;
  }
  
  void update(){
    strokeWeight(5);
    stroke(0);
    fill(200);
    circle(this.x,this.y,this.size);
    //speed
    this.astSpeed += 0.00055; //increments speed by 1/1800th, i.e. over the course of a minute at 60fps, the speed is incremented by 2
    //constraining the max speed to 10
    if(this.astSpeed > 10){
      this.astSpeed = 10;
    }
    //applying speed to the y-axis
    this.y += astSpeed;
  }
}
