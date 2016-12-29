class Obsticle {
  private float x, y, w, h;
  
  Obsticle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void show() {
    rectMode(CORNER);
    rect(x, y, w, h);
  }
  
  boolean isCollidingWithVector(PVector pos) {
    return pos.x >= x && pos.y >= y && pos.x <= x + w && pos.y <= y + h;
  }
}