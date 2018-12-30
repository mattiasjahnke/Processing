/*
  Author: @engineerish
 Description: A naive implementation of a Sodoku solver. It probably can't solve more complex puzzles.
 
 BEFORE YOU BEGIN:
 Prepare a file with sudoku games in the /data/ directory
 
 File format: <puzzle>,<solution>\n
 
 For example:
 004300209005009001070060043006002087190007400050083000600000105003508690042910300,864371259325849761971265843436192587198657432257483916689734125713528694542916378
 
 I've used: https://www.kaggle.com/bryanpark/sudoku
 
 Algorithm:
 
 Phase 1, Setup:
 Iterate all cells (starting from top left)
 Check if any of the number 1-9 fits in the cell (box/column/row doesn't contain the number)
 Add all numbers that fit as "reminders"
 
 Phase 2, Solo reminder:
 If the cell only has one "reminder" number - write that number in the cell
 
 Phase 3, Unique reminder:
 Iterate all boxes and their cells. If a reminder is only represented in one cell - write the number
 
 
 
 Will probably not solve harder puzzles, but have tested it on the first 30k puzzles in:
   https://www.kaggle.com/bryanpark/sudoku
 
 */

boolean newDirty = true;

class Cell {
  ArrayList<Integer> reminders = new ArrayList<Integer>();
  int value = 0;
  boolean dirty = false;
  int x;
  int y;
  public Cell(int value, int y, int x) {
    this.value = value;
    this.y = y;
    this.x = x;
  }

  void setValue(int value) {
    this.value = value;
    dirty = true;
    reminders.clear();
  }
}

Cell[][] board = new Cell[9][9];

int cellSize;
boolean puzzleSolved = false;
int startMillis;
String currentSolution;
String currentPuzzle;

BufferedReader reader;
int currentPuzzleIndex = 0;

void setup() {
  size(550, 550);
  cellSize = width / 9;
  reader = createReader("sudoku.csv");
  try {
    reader.readLine(); // First line is gibberish
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  reset();
}

void draw() {
  background(0);

  drawCurrentBoard(); // Draws the grid, cell values and cell reminders

  if (puzzleSolved) {
    //println("Puzzle solved");
    int totalTime = millis() - startMillis;
    //println("Time: " + totalTime);
    reset();
  }

  reminderPass();
  setSoloReminders();
  setBoxUniqueReminders();

  if (newDirty) {
    newDirty = false;
  } else {
    // Done
    String currentBoard = getCurrentBoardString();
    if (currentBoard.equals(currentSolution)) {
      puzzleSolved = true;
    } else {
      // We're stuck!
      println("Got stuck on puzzle: " + currentPuzzle);
      noLoop();
    }
  }
}

void reset() {
  puzzleSolved = false;
  newDirty = true;

  String[] puzzle = getRandomSodokuPuzzle();

  currentPuzzle = puzzle[0].trim();
  currentSolution = puzzle[1].trim();

  int i = 0;
  for (int y = 0; y < 9; y++) {
    for (int x = 0; x < 9; x++) {
      board[y][x] = new Cell(Integer.parseInt(puzzle[0].substring(i, i + 1)), y, x);
      i++;
    }
  }

  startMillis = millis();
}

String[] getRandomSodokuPuzzle() { 
  String line;
  try {
    println("Loading puzzle " + currentPuzzleIndex);
    line = reader.readLine();
    currentPuzzleIndex++;
  } 
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  }

  if (line == null) {
    noLoop();
    return null;
  }

  return split(line, ",");
}

void reminderPass() {
  for (int y = 0; y < 9; y++) {
    for (int x = 0; x < 9; x++) {
      Cell cell = board[y][x];
      if (cell.value != 0) {
        continue;
      }

      cell.reminders.clear();

      // Check what number the cell COULD have only based on current board
      for (int i = 1; i < 10; i++) {
        if (cellCouldHave(y, x, i)) {
          cell.reminders.add(i);
        }
      }
    }
  }
}

void setSoloReminders() {
  for (int y = 0; y < 9; y++) {
    for (int x = 0; x < 9; x++) {
      Cell cell = board[y][x];

      if (cell.value != 0) {
        continue;
      }

      if (cell.reminders.size() == 1) {
        int value = cell.reminders.get(0);

        cell.setValue(value);
        newDirty = true;

        clearOldReminders(y, x, value);
      }
    }
  }
}

void setBoxUniqueReminders() {
  for (int y = 0; y < 9; y++) {
    for (int x = 0; x < 9; x++) {
      Cell cell = board[y][x];

      if (cell.value != 0) {
        continue;
      }

      ArrayList<Cell> boxCells = getBoxCells(floor(y / 3), floor(x / 3));
      for (Integer reminder : cell.reminders) {
        boolean found = false;
        for (Cell c : boxCells) {
          if (c == cell) { 
            continue;
          }
          if (c.reminders.contains(reminder)) {
            found = true;
            break;
          }
        }
        if (!found) {
          cell.setValue(reminder);
          clearOldReminders(y, x, reminder);
          newDirty = true;
          break;
        }
      }
    }
  }
}

void clearOldReminders(int y, int x, int value) {
  for (Cell c : getColumnCells(x)) { 
    c.reminders.remove(new Integer(value));
  }

  for (Cell c : getRowCells(y)) { 
    c.reminders.remove(new Integer(value));
  }

  for (Cell c : getBoxCells(floor(y / 3), floor(x / 3))) { 
    c.reminders.remove(new Integer(value));
  }
}

String getCurrentBoardString() {
  String retVal = "";
  for (int y = 0; y < 9; y++) {
    for (int x = 0; x < 9; x++) {
      retVal += board[y][x].value;
    }
  }
  return retVal;
}

boolean cellCouldHave(int y, int x, int value) {

  // Part 1: No magic - look at the boards current state - only "set values" (no reminders)
  if (boxHas(floor(y / 3), floor(x / 3), value)) {
    return false;
  }

  if (rowHas(y, value)) {
    return false;
  }

  if (columnHas(x, value)) {
    return false;
  }

  return true;
}


// Returns an ArrayList containing all Cells in a box
ArrayList<Cell> getBoxCells(int y, int x) {
  ArrayList<Cell> retVal = new ArrayList<Cell>();

  for (int bY = 0; bY < 3; bY++) {
    for (int bX = 0; bX < 3; bX++) {
      int xx = x * 3 + bX;
      int yy = y * 3 + bY;
      retVal.add(board[yy][xx]);
    }
  }

  return retVal;
}

ArrayList<Cell> getColumnCells(int x) {
  ArrayList<Cell> retVal = new ArrayList<Cell>();

  for (int y = 0; y < 9; y++) {
    retVal.add(board[y][x]);
  }

  return retVal;
}

ArrayList<Cell> getRowCells(int y) {
  ArrayList<Cell> retVal = new ArrayList<Cell>();

  for (Cell rowCell : board[y]) {
    retVal.add(rowCell);
  }

  return retVal;
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
  for (Cell rowCell : board[y]) {
    if (rowCell.value == value) {
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
