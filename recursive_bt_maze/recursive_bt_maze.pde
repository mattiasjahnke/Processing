/*
  Generate a maze with the Recursive backtracker algorithm.
  
  Read more about it here: https://en.wikipedia.org/wiki/Maze_generation_algorithm#Recursive_backtracker

*/
class Cell {
  boolean visited = false;
  int walls = 0b1111; // left, up, right, down
  int x, y;
  public Cell(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

class Stack<T> {
  private ArrayList<T> list = new ArrayList<T>();

  T pop() {
    return list.remove(list.size() - 1);
  }

  void push(T obj) {
    list.add(obj);
  }

  int size() {
    return list.size();
  }
}

// ============================= CONFIG =============================

// Adjusts the difficulty level (smaller cells == harder maze)
int cellSize = 20; 

// True == draw each maze step (see the algorithm)
// False == generate before drawing
boolean preGenerate = false;

// ===================================================================

int rows, cols;

ArrayList<Cell> matrix = new ArrayList<Cell>();
Stack<Cell> stack = new Stack<Cell>();
int biggestStack = 0;

Cell currentCell;
Cell startCell;
Cell endCell;

void setup() {
  size(601, 601);
  rows = floor(height/cellSize);
  cols = floor(width/cellSize);

  ellipseMode(CORNER);

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      matrix.add(new Cell(x, y));
    }
  }

  // Random start
  currentCell = matrix.get(int(random(matrix.size())));

  // Defined start
  currentCell = matrix.get(index(0, int(rows / 2)));

  startCell = currentCell;

  if (preGenerate) {
    while (nrOfUnvisitedCells() > 0) {
      runMazeStep();
    }
  }
}

void draw() {
  fill(0);
  rect(0, 0, width, height);

  for (Cell cell : matrix) {
    pushMatrix();

    translate(cell.x * cellSize, cell.y * cellSize);

    noStroke();

    // Render visited cell color
    if (cell.visited) {
      fill(30);
      rect(0, 0, cellSize, cellSize);
    }

    // Render special cells
    if (cell == currentCell) {
      fill(255, 0, 0);
      rect(0, 0, cellSize, cellSize);
    } else if (cell == startCell) {
      fill(82, 247, 76);
      ellipse(cellSize / 4, cellSize / 4, cellSize / 2, cellSize / 2);
    } else if (cell == endCell) {
      fill(66, 134, 244);
      ellipse(cellSize / 4, cellSize / 4, cellSize / 2, cellSize / 2);
    }

    // Render walls
    if (cell.visited) {
      stroke(255);
      if ((cell.walls & 1) == 1) {
        line(0, cellSize, cellSize, cellSize);
      }
      if ((cell.walls >> 1 & 1) == 1) {
        line(cellSize, 0, cellSize, cellSize);
      }
      if ((cell.walls >> 2 & 1) == 1) {
        line(0, 0, cellSize, 0);
      }
      if ((cell.walls >> 3 & 1) == 1) {
        line(0, 0, 0, cellSize);
      }
    }

    popMatrix();
  }

  if (nrOfUnvisitedCells() > 0) {
    runMazeStep();
  } else {
    currentCell = null;
  }
}

void runMazeStep() {
  currentCell.visited = true;

  ArrayList<Cell> nei = new ArrayList<Cell>();
  if (currentCell.x > 0) {
    Cell cell = matrix.get(index(currentCell.x - 1, currentCell.y));
    if (!cell.visited) {
      nei.add(cell);
    }
  }
  if (currentCell.y > 0) {
    Cell cell = matrix.get(index(currentCell.x, currentCell.y - 1));
    if (!cell.visited) {
      nei.add(cell);
    }
  }
  if (currentCell.y < cols - 1) {
    Cell cell = matrix.get(index(currentCell.x + 1, currentCell.y));
    if (!cell.visited) {
      nei.add(cell);
    }
  }
  if (currentCell.y < rows - 1) {
    Cell cell = matrix.get(index(currentCell.x, currentCell.y + 1));
    if (!cell.visited) {
      nei.add(cell);
    }
  }

  if (nei.size() > 0) {
    Cell chosen = nei.get(int(random(nei.size())));
    stack.push(currentCell);
    if (stack.size() > biggestStack) {
      endCell = chosen;
      biggestStack = stack.size();
    }

    if (chosen.x < currentCell.x) {
      chosen.walls &= ~(1 << 1); // Remove right
      currentCell.walls &= ~(1 << 3); // Remove left
    } else if (chosen.x > currentCell.x) {
      chosen.walls &= ~(1 << 3); // Remove left
      currentCell.walls &= ~(1 << 1); // Remove right
    } else if (chosen.y > currentCell.y) {
      chosen.walls &= ~(1 << 2); // Remove up
      currentCell.walls &= ~(1 << 0); // Remove down
    } else if (chosen.y < currentCell.y) {
      chosen.walls &= ~(1 << 0); // Remove down
      currentCell.walls &= ~(1 << 2); // Remove up
    }

    currentCell = chosen;
  } else {
    currentCell = stack.pop();
  }
}

int index(int x, int y) {
  return y * cols + x;
}

int nrOfUnvisitedCells() {
  int result = 0;

  for (Cell cell : matrix) {
    if (!cell.visited) {
      result++;
    }
  }

  return result;
}