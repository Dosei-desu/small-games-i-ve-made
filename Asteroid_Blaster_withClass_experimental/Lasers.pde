class Lasers {
  private float ly = 0; 
  private float lRot = 1.5;

  Lasers(float constructor_y, float constructor_rot) {
    this.lRot = constructor_rot;
    this.ly = constructor_y;
  }
  
  float getY(){
    return this.ly;
  }

  void update() {
    pushMatrix();
    //---
    rotate(this.lRot-1.55);
    //laser lines
    strokeWeight(4);
    stroke(0, 255, 0);
    line(13, this.ly+50, 13, this.ly+75);
    line(-13, this.ly+50, -13, this.ly+75);
    ly = ly + 15; 
    //---
    popMatrix();
  }
}
