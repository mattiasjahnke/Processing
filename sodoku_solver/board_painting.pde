void markCell(int y, int x) {
  markCells(y, x, 1, 1);
}

void markBox(int y, int x) {
  markCells(y * 3, x * 3, 3, 3);
}

void markColumn(int x) {
  markCells(0, x, 9, 1);
}

void markRow(int y) {
  markCells(y, 0, 1, 9);
}

void markCells(int y, int x, int numVertical, int numHorizonal) {
  noFill();
  stroke(0, 255 - (markIndentation * 4), 0);
  strokeWeight(3);
  rect(x * cellSize, y * cellSize, numHorizonal * cellSize, numVertical * cellSize);

  markIndentation++;
}