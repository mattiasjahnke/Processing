// Heavily influenced by:
// https://dev.opera.com/articles/3d-games-with-canvas-and-raycasting-part-1/

// Constants
static int kPlayerStart = 9;

static int[][] map = {
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
  {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 3, 3, 3, 0, 0, 1, 1, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 3, 4, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 1, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
};

// Modifiable
int miniMapScale = 4;
int stripWidth = 2;

// Calculated
int mapWidth;
int mapHeight;
int numRays;
float viewDist;
float fov = 60 * PI / 180;

boolean autoTurn = false; // demo purposes

// Togglable from within game
boolean displayMiniMap = true;          // 'm'
boolean displayDebugInformation = true; // 'g'
boolean renderTexture = true;           // 't'

Player player = new Player();

PImage gun;
PImage sprites;
float orgSpriteWidth = 0;

void setup() {
  size(896, 640, P2D);

  numRays = ceil(width / stripWidth);
  viewDist = (width / 2 ) / tan(fov / 2);

  mapWidth = map[0].length;
  mapHeight = map.length;

  println("Map size: " + mapWidth + " x " + mapHeight);

  for (int y = 0; y < mapHeight; y++) {
    for (int x = 0; x < mapWidth; x++) {
      if (map[y][x] == kPlayerStart) {
        player.x = x;
        player.y = y;
      }
    }
  }

  if (autoTurn) {
    player.dir = -1;
  }
  
  sprites = loadImage("walls.png");
  gun = loadImage("pistol.png");
  orgSpriteWidth = sprites.width / 2;
}

void draw() {
  pushMatrix();
  
  // Rly stupid head movement effect ^^
  //translate(0, -(mouseY - height / 2));
  
  drawSurrounding();

  movePlayer();

  castRays();

  if (displayMiniMap) {
    drawMiniMap();
  }

  if (displayDebugInformation) {
    fill(255);
    textSize(14);
    String[] texts = {
      "x = " + player.x, 
      "y = " + player.y, 
      "direction = " + player.dir, 
      "speed = " + player.speed, 
      "rotation = " + player.rot
    };

    for (int i = 0; i < texts.length; i++) {
      text(texts[i], miniMapScale * mapWidth + 40, 40 + i * 16);
    }
  }

  if (autoTurn) {
    if (player.rot > -3 && player.dir == 1) {
      player.dir = -1;
    } else if (player.rot < -6 && player.dir == -1) {
      player.dir = 1;
    }
  }
  
  popMatrix();
  
  image(gun, (width - gun.width) / 2, height - gun.height * 7, gun.width * 7, gun.height * 7);
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
    case UP: 
      player.speed = 1; 
      break;
    case DOWN: 
      player.speed = -1; 
      break;
    case LEFT: 
      player.dir = -1; 
      break;
    case RIGHT: 
      player.dir = 1; 
      break;
    }
  }
  if (key == 'w') {
    player.speed = 1;
  } else if (key == 's') {
    player.speed = -1;
  }
  
  if (key == 'd') {
    player.dir = 1; 
  } else if (key == 'a') {
    player.dir = -1;
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
    case DOWN:
      player.speed = 0; 
      break;
    case LEFT:
    case RIGHT:
      player.dir = 0; 
      break;
    }
  } else if (key == 'm') {
    displayMiniMap = !displayMiniMap;
  } else if (key == 'g') {
    displayDebugInformation = !displayDebugInformation;
  } else if (key == 't') {
    renderTexture = !renderTexture;
  }
  
  if (key == 'w' || key == 's') {
    player.speed = 0; 
  }
  
  if (key == 'd' || key == 'a') {
    player.dir = 0;
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
  fill(200, 200, 100, 80);
  for (int y = 0; y < mapHeight; y++) {
    for (int x = 0; x < mapWidth; x++) {
      int wall = map[y][x];
      if (wall > 0 && wall != kPlayerStart) {
        rect(x * miniMapScale + 20, y * miniMapScale + 20, miniMapScale, miniMapScale);
      }
    }
  }

  fill(255);
  ellipse(player.x * miniMapScale + 20, player.y * miniMapScale + 20, miniMapScale, miniMapScale);
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

    if (map[wallY][wallX] > 0 && map[wallY][wallX] != kPlayerStart) {
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

    if (map[wallY][wallX] > 0 && map[wallY][wallX] != kPlayerStart) {
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

    stroke(255, 255, 255, 255*0.2);
    strokeWeight(0.5);
    
    if (displayMiniMap) {
      drawRay(xHit, yHit);
    }

    dist = sqrt(dist);

    dist = dist * cos(player.rot - rayAngle);

    float tHeight = round(viewDist / dist);

    float top = round((height - tHeight) / 2);

    noStroke();
    
    if (renderTexture) {
      fill(0);
      rect(stripIdx * stripWidth, top, stripWidth, tHeight);
      tint(255, map(dist, 0, 32, 255, 0));
      drawSprite(wallType, stripIdx * stripWidth, top, stripWidth * 2, tHeight, textureX, stripWidth / orgSpriteWidth, false);
      noTint();
    } else {
      if (wallType == 1) {
        fill(map(dist, 0, 32, 255, 0));
      } else {
        fill(map(dist, 0, 32, 255, 0), 0, 0);
      }
      rect(stripIdx * stripWidth, top, stripWidth, tHeight);
    }
  }
}

void drawSprite(int type, float x, float y, float w, float h, float texStart, float texWidth, boolean dark) {

  int yIndex = type - 1;
  float yStart = yIndex * 0.25;
  float xStart = (dark ? 0.5 : 0) + texStart / 2;
  float xEnd = xStart + texWidth / 2;
  
  textureMode(NORMAL);
  beginShape();
  texture(sprites);
  
  vertex(x,     y,     xStart, yStart);
  vertex(x + w, y,     xEnd,   yStart);
  vertex(x + w, y + h, xEnd,   yStart + 0.25);
  vertex(x,     y + h, xStart, yStart + 0.25);
  
  endShape();
}

boolean isBlocking(float x, float y) {
  if (y < 0 || y >= mapHeight || x < 0 || x >= mapWidth) {
    return true;
  }
  return map[floor(y)][floor(x)] != 0;
}

void drawRay(float targetX, float targetY) {
  line(player.x * miniMapScale + 20, player.y * miniMapScale + 20, targetX * miniMapScale + 20, targetY * miniMapScale + 20);
}

void drawSurrounding() {
  // Ceiling
  fill(#383838);
  rect(0, -height / 2, width, height);

  // Floor
  fill(#707070);
  rect(0, height / 2, width, height);
}