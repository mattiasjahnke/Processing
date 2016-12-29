// Program parameters
static int kLifespan = 400;
static int width = 800;
static int height = 800;
private static int kPopulationSize = 25;

private Population population = new Population(kPopulationSize);
private ArrayList<Obsticle> obsticles = new ArrayList<Obsticle>();
private int dnaIndex = 0;
private int generation = 1;

// Public variables
PVector target = new PVector(width / 2, 50);

void settings() {
  size(width, height);
}

void setup() {
  noStroke();
  
  // Add a few obsticles
  obsticles.add(new Obsticle(200.0, 350.0, 30.0, 100.0));
  obsticles.add(new Obsticle(230.0, 400.0, width - 550, 30));
  obsticles.add(new Obsticle(width - 230.0, 350.0, 30.0, 100.0));
}

void draw() {
  background(0);
  
  // Draw target
  fill(255);
  ellipse(target.x, target.y, 16, 16);
  
  // Draw debug information
  text("DNA index: " + dnaIndex, 10, 20);
  text("Last max fitness: " + population.lastMaxFitness, 10, 40);
  text("Generation #: " + generation, 10, 60);
  
  // Draw obsticles and meanwhile check for collisions
  for (Obsticle o : obsticles) {
    o.show();
    for (Rocket r : population.rockets) {
      if (!r.dead && o.isCollidingWithVector(r.pos)) {
        r.dead = true;
      }
    }
  }
  
  // Draw all rockets in population
  fill(255, 155);
  population.updateAndShow();
  
  // Check if we've reached the end of this generation (if so - evolve)
  if (++dnaIndex == kLifespan) {
    population.evolve();
    dnaIndex = 0;
    generation++;
  }
}