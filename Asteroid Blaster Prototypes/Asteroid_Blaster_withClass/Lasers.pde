class Lasers {
  float lx = 0; 
  float lRot = 1.5;

  Lasers(float constructor_x, float constructor_rot) {
    lRot = constructor_rot;
    lx = constructor_x;
  }

  void update() {
    pushMatrix();
    //---
    translate(0, 850);
    rotate(lRot);
    //laser lines
    strokeWeight(4);
    stroke(0, 255, 0);
    line(lx+50, 13, lx+75, 13);
    line(lx+50, -13, lx+75, -13);
    lx = lx + 15; 
    //---
    popMatrix();
  }
}
