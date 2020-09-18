class Lasers {
  private float ly = 0; 
  private float lRot = 1.5;
  private float lspeed = 0;
  
  Lasers(float constructor_y, float constructor_rot) {
    this.lRot = constructor_rot;
    this.ly = constructor_y;
  }
  
  float getY(){
    return this.ly;
  }
  
  void lVelocity(float _lspeed){
    this.lspeed = _lspeed;
  }

  void update() {
    pushMatrix();
    //---
    rotate(this.lRot-1.55); //this rotation makes it so Y points upwards, instead of X, which would be the default without the -1.55
    //laser lines
    strokeWeight(4);
    constrain(ly,0,1000);
    line(13, this.ly+50, 13, this.ly+75);
    line(-13, this.ly+50, -13, this.ly+75);
    ly = ly + lspeed; 
    //---
    popMatrix();
  }
}
