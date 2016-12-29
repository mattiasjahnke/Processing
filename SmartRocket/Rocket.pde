class Rocket {
  boolean dead, complete;
  
  DNA dna;
  PVector pos = new PVector(width / 2, height - 50);
  PVector vel = new PVector();
  PVector acc = new PVector();
  
  Rocket(DNA dna) {
    if (dna != null) {
      this.dna = dna;
    } else {
      this.dna = new DNA(null);
    }
  }
  
  void update() {
    if (dead || complete) { return; }
    
    float d = PVector.dist(pos, target);
    
    if (d < 10) {
      pos = target.copy();
      complete = true;
    }
    
    acc.add(dna.genes.get(dnaIndex));
    
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    
    // Check if out of bounds
    if (pos.x < 0 || pos.y < 0 || pos.y > height || pos.x > width) {
      dead = true;
    }
  }
  
  float calculateFitness() {
    float fitness = 1 / PVector.dist(pos, target);
    
    if (complete) {
      fitness *= 10;
    }
    
    return fitness;
  }
  
  void show() {
    if (dead) { return; }
    
    pushMatrix();
    rectMode(CENTER);
    translate(pos.x, pos.y);
    rotate(vel.heading());
    rect(0, 0, 50, 10);
    popMatrix();
  }
}