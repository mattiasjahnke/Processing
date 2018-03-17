// Heavily influenced by:
// https://dev.opera.com/articles/3d-games-with-canvas-and-raycasting-part-1/

int[][] map = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};

int mapWidth = 0;
int mapHeight = 0;
int miniMapScale = 4;

int stripWidth = 2;
int numRays;
float fov = 60 * PI / 180;
//float fovHalf = fov / 2;
float viewDist;

Player player = new Player();

void setup() {
  size(896, 640);
  
  numRays = ceil(width / stripWidth);
  viewDist = (width / 2 ) / tan(fov / 2);

  mapWidth = map[0].length;
  mapHeight = map.length;
  
  println("Map size: " + mapWidth + " x " + mapHeight);
}

void draw() {
  drawSurrounding();
  
  movePlayer();
  
  drawMiniMap();
  
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case UP: player.speed = 1; break;
      case DOWN: player.speed = -1; break;
      case LEFT: player.dir = -1; break;
      case RIGHT: player.dir = 1; break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
      case DOWN:
        player.speed = 0; break;
      case LEFT:
      case RIGHT:
        player.dir = 0; break;
    }
  }
}

void movePlayer() {
  float moveStep = player.speed * player.moveSpeed;
  player.rot += player.dir * player.rotSpeed;
   
  float newX = player.x + cos(player.rot) * moveStep;
  float newY = player.y + sin(player.rot) * moveStep;
  
  if (isBlocking(newX, newY)) {
    return;
  }
  
  player.x = newX;
  player.y = newY;
}

void drawMiniMap() {
  //noStroke();
  
  castRays();
  
  
  fill(200, 0, 200, 70);
  for (int y = 0; y < mapHeight; y++) {
    for (int x = 0; x < mapWidth; x++) {
      int wall = map[y][x];
      if (wall > 0) {
        rect(x * miniMapScale, y * miniMapScale, miniMapScale, miniMapScale);
      }
    }
  }
  
  fill(0);
  ellipse(player.x * miniMapScale, player.y * miniMapScale, miniMapScale, miniMapScale);
}

void castRays() {
  int stripIdx = 0;
  for (int i = 0; i < numRays; i++) {
    float rayScreenPos = (-numRays/2 + i) * stripWidth;
    
    float rayViewDist = sqrt(rayScreenPos * rayScreenPos + viewDist * viewDist);
    
    float rayAngle = asin(rayScreenPos / rayViewDist);
    
    
    castSingleRay(player.rot + rayAngle, stripIdx++);
  }
}

void castSingleRay(float rayAngle, int stripIdx) {
  rayAngle %= TWO_PI;
  if (rayAngle < 0) {
    rayAngle += TWO_PI;
  }
  
  boolean right = (rayAngle > TWO_PI * 0.75 || rayAngle < TWO_PI * 0.25);
  boolean up = (rayAngle < 0 || rayAngle > PI);
  
  float angleSin = sin(rayAngle);
  float angleCos = cos(rayAngle);
  
  float dist = 0;
  float xHit = 0;
  float yHit = 0;
  
  int wallType = 0;
  float textureX = 0;
  
  float slope = angleSin / angleCos;
  float dX = right ? 1 : -1;
  float dY = dX * slope;
  
  float x = right ? ceil(player.x) : floor(player.x);
  float y = player.y + (x - player.x) * slope;
  
  while (x >= 0 && x < mapWidth && y >= 0 && y < mapHeight) {
    int wallX = floor(x + (right ? 0 : -1));
    int wallY = floor(y);
    
    if (map[wallY][wallX] > 0) {
      float distX = x - player.x;
      float distY = y - player.y;
      
      dist = distX*distX + distY*distY;
      
      wallType = map[wallY][wallX];
      textureX = y % 1;
      if (!right) {
        textureX = 1 - textureX;
      }
      
      xHit = x;
      yHit = y;
      break;
    }
    
    x += dX;
    y += dY;
  }
  
  slope = angleCos / angleSin;
  dY = up ? -1 : 1;
  dX = dY * slope;
  y = up ? floor(player.y) : ceil(player.y);
  x = player.x + (y - player.y) * slope;
  
  while (x >= 0 && x < mapWidth && y >= 0 && y < mapHeight) {
    int wallY = floor(y + (up ? -1 : 0));
    int wallX = floor(x);
    
    if (map[wallY][wallX] > 0) {
      float distX = x - player.x;
      float distY = y - player.y;
      float blockDist = distX*distX + distY*distY;
      
      if (dist == 0 || blockDist < dist) {
        dist = blockDist;
        xHit = x;
        yHit = y;
        
        wallType = map[wallY][wallX];
        textureX = x % 1;
        if (up) {
          textureX = 1 - textureX;
        }
      }
      
      break;
    }
    x += dX;
    y += dY;
  }
  
  if (dist > 0) {
    
    stroke(0, 0, 0, 255*0.2);
    strokeWeight(0.5);
    drawRay(xHit, yHit);
    
    dist = sqrt(dist);
    
    dist = dist * cos(player.rot - rayAngle);
    
    float tHeight = round(viewDist / dist);
    
    float tWidth = tHeight * stripWidth;
    
    float top = round((height - tHeight) / 2);
    
    float texX = round(textureX * tWidth);
    
    if (texX > tWidth - stripWidth) {
      texX = tWidth - stripWidth;
    }
    
    if (wallType == 1 ) {
      fill(map(dist, 0, 32, 255, 0));
    } else if (wallType == 2) {
      fill(map(dist, 0, 32, 255, 0), 0, 0);
    }
    noStroke();
    rect(stripIdx * stripWidth, top, stripWidth, tHeight);
  }
}

boolean isBlocking(float x, float y) {
  if (y < 0 || y >= mapHeight || x < 0 || x >= mapWidth) {
    return true;
  }
  return map[floor(y)][floor(x)] != 0;
}

void drawRay(float targetX, float targetY) {
  line(player.x * miniMapScale, player.y * miniMapScale, targetX * miniMapScale, targetY * miniMapScale);
}

void drawSurrounding() {
  // Draw ceiling and floor
  
  fill(#0b81bc);
  rect(0, 0, width, height / 2);
  fill(#206602);
  rect(0, height / 2, width, height / 2);
}