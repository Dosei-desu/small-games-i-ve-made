//asteroid targets

class Asteroids{
  private float x;
  private float y;
  private float size;
  private boolean hit = false;
  
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
  
  float getY(){
    return this.y;
  }
  
  void hit(boolean _hit){
    hit = _hit;
  }
  
  void update(){
    circle(this.x,this.y,this.size);
    this.y += 1;
  }
}
