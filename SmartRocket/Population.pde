
class Population {
  ArrayList<Rocket> rockets = new ArrayList<Rocket>();
  float lastMaxFitness = 0;
  
  Population(int size) {
    for (int i = 0; i < size; i++) {
      rockets.add(new Rocket(null));
    }
  }
  
  void evolve() {
    performSelection(getEvaluatedMatingPool());
  }
  
  void updateAndShow() {
    for (Rocket rocket : rockets) {
      rocket.update();
      rocket.show();
    }
  }
  
  private ArrayList<DNA> getEvaluatedMatingPool() {
    ArrayList<DNA> matingPool = new ArrayList<DNA>();
    
    float maxFitness = 0;
    for (Rocket rocket : rockets) {
      float fitness = rocket.calculateFitness();
      if (fitness > maxFitness) {
        maxFitness = fitness;
      }
    }
    
    lastMaxFitness = maxFitness;
    
    for (Rocket rocket : rockets) {
      float n = (rocket.calculateFitness() / maxFitness) * 100;
      for (int i = 0; i < n; i++) {
        matingPool.add(rocket.dna);
      }
    }
    
    return matingPool;
  }
  
  private void performSelection(ArrayList<DNA> matingPool) {
    ArrayList<Rocket> newPopulation = new ArrayList<Rocket>();
    
    for (int i = 0; i < rockets.size(); i++) {
      DNA parentA = matingPool.get(int(random(matingPool.size())));
      DNA parentB = matingPool.get(int(random(matingPool.size())));
      DNA child = parentA.crossover(parentB);
      
      newPopulation.add(new Rocket(child));
    }
    
    rockets = newPopulation;
  }
}