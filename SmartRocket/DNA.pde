class DNA {
  ArrayList<PVector> genes;
  
  DNA(ArrayList<PVector> genes) {
    if (genes == null) {
      this.genes = new ArrayList<PVector>();
      for (int i = 0; i < kLifespan; i++) {
        PVector vector = PVector.random2D();
        vector.setMag(0.1);
        this.genes.add(vector);
      }
    } else {
      this.genes = genes;
    }
  }
  
  void mutate() {
    for (int i = 0; i < genes.size(); i++) {
      if (random(1) < 0.01) {
        PVector mut = PVector.random2D();
        mut.setMag(0.1);
        genes.set(i, mut);
      }
    }
  }

  DNA crossover(DNA partner) {
    ArrayList<PVector> g = new ArrayList<PVector>();
    float mid = floor(random(genes.size()));
    for (int i = 0; i < genes.size(); i++) {
      g.add(i > mid ? genes.get(i) : partner.genes.get(i));
    }
    DNA childDna = new DNA(g);
    
    childDna.mutate();
    
    return childDna;
  }
}