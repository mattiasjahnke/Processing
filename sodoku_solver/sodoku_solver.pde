/*
  Author: @engineerish
 Description: A naive implementation of a Sodoku solver. It probably can't solve more complex puzzles.
 
 Algorithm:
 
 Looping
 Iterate all cells (starting from top left)
 Check if any of the number 1-9 fits in the cell (box/column/row doesn't contain the number)
 Add all numbers that fit as "reminders"
 If the cell only has one "reminder" number - write that number in the cell
 
 The application is written in such a way that you can visualize what the algorithm is currently doing.
 It's not optimized for speed (you could remove the visualization-aspect and remove some unnecessary iterations).
 Some low hanging fruit would perhaps to have a hash table of cells, to get rid of the constant array iteration.
 
 */

Cell[][] board = new Cell[9][9];

int cellSize;

boolean puzzleSolved = false;

void setup() {
  size(550, 550);

  cellSize = width / 9;

  /*
  int[][] boardLayout = {
   {0, 0, 0, 2, 6, 0, 7, 0, 1}, 
   {6, 8, 0, 0, 7, 0, 0, 9, 0}, 
   {1, 9, 0, 0, 0, 4, 5, 0, 0}, 
   {8, 2, 0, 1, 0, 0, 0, 4, 0}, 
   {0, 0, 4, 6, 0, 2, 9, 0, 0}, 
   {0, 5, 0, 0, 0, 3, 0, 2, 8}, 
   {0, 0, 9, 3, 0, 0, 0, 7, 4}, 
   {0, 4, 0, 0, 5, 0, 0, 3, 6}, 
   {7, 0, 3, 0, 1, 8, 0, 0, 0}
   };*/

  int[][] boardLayout = {
    {0, 0, 0, 2, 0, 4, 8, 1, 0}, 
    {0, 4, 0, 0, 0, 8, 2, 6, 3}, 
    {3, 0, 0, 1, 6, 0, 0, 0, 4}, 
    {1, 0, 0, 0, 4, 0, 5, 8, 0}, 
    {6, 3, 5, 8, 2, 0, 0, 0, 7}, 
    {2, 0, 0, 5, 9, 0, 1, 0, 0}, 
    {9, 1, 0, 7, 0, 0, 0, 4, 0}, 
    {0, 0, 0, 6, 8, 0, 7, 0, 1}, 
    {8, 0, 0, 4, 0, 3, 0, 5, 0}
  };

  for (int y = 0; y < 9; y++) {
    for (int x = 0; x < 9; x++) {
      board[y][x] = new Cell(boardLayout[y][x]);
    }
  }
}

class Cell {
  ArrayList<Integer> reminders = new ArrayList<Integer>();
  int value = 0;
  boolean dirty = false;
  public Cell(int value) {
    this.value = value;
  }
  
  void setValue(int value) {
    this.value = value;
    dirty = true;
    reminders.clear();
  }
}

void draw() {
  background(0);

  drawCurrentBoard(); // Draws the grid, cell values and cell reminders

  if (puzzleSolved) {
    println("Puzzle solved");
    noLoop();
  }

  solveTick(); // solveTick will run a solv step and draw what the algorithm is looking at
}


// Solve state... 0 = find all "maybes"
int state = 0;

// state 0 variables
int s0_x = 0;
int s0_y = 0;

int markIndentation = 1;

void solveTick() {
  markIndentation = 1;
  boolean checkDone = false;

  // Get the current cell
  Cell cell = board[s0_y][s0_x];

  if (cell.value == 0) {
    cell.reminders.clear(); // Clear any reminders that's currently in the cell
    markCell(s0_y, s0_x);

    for (int i = 1; i < 10; i++) {
      markBox(floor(s0_y / 3), floor(s0_x / 3));
      markRow(s0_y);
      markColumn(s0_x);

      // Could cell contain value "i"?
      if (!boxHas(floor(s0_y / 3), floor(s0_x / 3), i) && !rowHas(s0_y, i) && !columnHas(s0_x, i)) {
        cell.reminders.add(i);
      }
    }

    // If we only have 1 reminder (only one possible number), set the cell value
    if (cell.reminders.size() == 1) {
      checkDone = true;  // Since we've changed the board - run the "solved?"-logic

      cell.setValue(cell.reminders.get(0));
    }
  }

  // Progress to next cell
  if (++s0_x == 9) {
    s0_x = 0;
    // Progress to next row
    if (++s0_y == 9) {
      // Restart
      s0_x = 0;
      s0_y = 0;
    }
  }

  if (checkDone) {
    // Check if done
    boolean done = true;
    for (int y = 0; y < 9; y++) {
      for (int x = 0; x < 9; x++) {
        if (board[y][x].value == 0) {
          done = false;
          break;
        }
        if (!done) {
          break;
        }
      }
    }

    puzzleSolved = done;
  }
}

// Returns true if a box (3x3) contains a certain value
boolean boxHas(int y, int x, int value) {
  for (int bY = 0; bY < 3; bY++) {
    for (int bX = 0; bX < 3; bX++) {
      if (board[y * 3 + bY][x * 3 + bX].value == value) {
        return true;
      }
    }
  }
  return false;
}

// Returns true if a row contains a certain value
boolean rowHas(int y, int value) {
  for (Cell row : board[y]) {
    if (row.value == value) {
      return true;
    }
  }
  return false;
}

// Returns true if a column contains a certain value
boolean columnHas(int x, int value) {
  for (int y = 0; y < 9; y++) {
    if (board[y][x].value == value) {
      return true;
    }
  }
  return false;
}

// Draws the board
void drawCurrentBoard() {
  // Draw thin lines around cells and print their values/reminders
  stroke(200);
  strokeWeight(1);
  noFill();
  for (int y = 0; y < 9; y++) {
    for (int x = 0; x < 9; x++) {
      noFill();
      rect(x * cellSize, y * cellSize, cellSize, cellSize);

      if (board[y][x].value > 0) { // Print the value
        textSize(14);
        fill(board[y][x].dirty ? 125 : 255);
        text("" + board[y][x].value, x * cellSize + cellSize / 2 - 3, y * cellSize + cellSize / 2 + 5);
      } else if (board[y][x].reminders.size() > 0) { // No value - print the reminders
        fill(0, 255, 0);
        textSize(10);
        String reminderString = "";
        for (Integer reminder : board[y][x].reminders) {
          reminderString += reminder + ",";
        }
        reminderString = reminderString.substring(0, reminderString.length() - 1); // Drop the last ", "

        text(reminderString, x * cellSize + 2, y * cellSize + cellSize - 2);
      }
    }
  }

  // Draw think lines to highlight boxes
  stroke(255);
  strokeWeight(3);
  for (int i = 1; i < 3; i++) {
    line(i * cellSize * 3, 0, i * cellSize * 3, cellSize * 9);
    line(0, i * cellSize * 3, i * cellSize * 9, i * cellSize * 3);
  }
}