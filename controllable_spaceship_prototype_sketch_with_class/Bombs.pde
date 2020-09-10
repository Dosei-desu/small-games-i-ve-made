//Bomb class with constructor
class Bombs {  
  float x = 0, y = 0, size = 1; 
  boolean bombExist = true;
  Bombs(float bX, float bY, float bSize, boolean bExist){
    x = bX;
    y = bY;
    size = bSize;
    bombExist = bExist;
  }
  void update() {
    //speedo
    x = x -u; //decides speed of the bomb
  }
}
