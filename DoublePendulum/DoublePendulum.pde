/*
  Double Pendulum simulation
  
  Heavily inspired by The Coding Trains video:
    https://www.youtube.com/watch?v=uWzPe_S-RVE
  
  Explaination of the math is available here:
    https://www.myphysicslab.com/pendulum/double-pendulum-en.html
    
  Happy tinkering!
  
  @engineerish
*/

class Rod {
  float velocity;
  
  float len;
  float mass;
  float angle;
  
  public Rod(float velocity, float len, float mass, float angle) {
    this.velocity = velocity;
    this.len = len;
    this.mass = mass;
    this.angle = angle;
  }
}

PGraphics canvas;

Rod r1;
Rod r2;

float g = 1;

float px2 = 0;
float py2 = 0;

void setup() {
  size(900, 900);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  
  r1 = new Rod(0, 200, 20, PI/2);
  r2 = new Rod(0, 200, 20, PI/2);
}

void draw() {
  
  // Complicated math (getting the acceleration)
  float num1 = -g * (2 * r1.mass + r2.mass) * sin(r1.angle);
  float num2 = -r2.mass * g * sin(r1.angle - 2*r2.angle);
  float num3 = -2*sin(r1.angle - r2.angle) * r2.mass;
  float num4 = r2.velocity * r2.velocity * r2.len + r1.velocity * r1.velocity * r1.len * cos(r1.angle - r2.angle);
  float den = r1.len * (2*r1.mass + r2.mass - r2.mass*cos(2*r1.angle - 2*r2.angle));
  
  float r1_accel = (num1 + num2 + num3*num4) / den;
  
  num1 = 2 * sin(r1.angle - r2.angle);
  num2 = (r1.velocity*r1.velocity*r1.len*(r1.mass + r2.mass));
  num3 = g * (r1.mass + r2.mass) * cos(r1.angle);
  num4 = r2.velocity * r2.velocity * r2.len * r2.mass * cos(r1.angle - r2.angle);
  den = r2.len * (2 * r1.mass + r2.mass - r2.mass*cos(2*r1.angle - 2*r2.angle));
  
  float r2_accel = (num1 * (num2 + num3 + num4)) / den;
  
  image(canvas, 0, 0);
  stroke(0);
  strokeWeight(4);
  
  translate(width/2, height / 3);
  
  float x1 = r1.len * sin(r1.angle);
  float y1 = r1.len * cos(r1.angle);
  
  float x2 = x1 + r2.len * sin(r2.angle);
  float y2 = y1 + r2.len * cos(r2.angle);
  
  // Draw first Rod
  line(0, 0, x1, y1);
  fill(0);
  ellipse(x1, y1, r1.mass, r1.mass);
  
  // Draw second Rod
  line (x1, y1, x2, y2);
  fill(0);
  ellipse(x2, y2, r2.mass, r2.mass);
  
  r1.velocity += r1_accel;
  r2.velocity += r2_accel;
  r1.angle += r1.velocity;
  r2.angle += r2.velocity;
  
  canvas.beginDraw();
  canvas.translate(width/2, height / 3);
  canvas.strokeWeight(2);
  canvas.stroke(0);
  
  if (frameCount > 1) {
    canvas.line(px2, py2, x2, y2);
  }
  
  canvas.endDraw();
  
  px2 = x2;
  py2 = y2;
}