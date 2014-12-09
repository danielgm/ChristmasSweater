

color RED = color(225, 26, 52);
color WHITE = color(255, 255, 255);

PImage tile;
PShape stitch;

int scale;

int prevTileX;
int prevTileY;

void setup() {
  size(700, 600);
  
  scale = 16;
  
  tile = createImage(ceil(176 / scale), ceil(height / scale), RGB);
  tile.loadPixels();
  for (int i = 0; i < tile.pixels.length; i++) {
    tile.pixels[i] = RED;
  }
  tile.updatePixels();
  
  stitch = loadShape("stitch.svg");
  stitch.disableStyle();
  
  redraw();
}

void draw() {
}

void mousePressed() {
  int tileX = canvasToTileX(mouseX);
  int tileY = canvasToTileY(mouseY);
  swapPixel(tileX, tileY);
  tilePixelChanged(tileX, tileY);
  prevTileX = tileX;
  prevTileY = tileY;
}

void mouseDragged() {
  if (mousePressed) {
    int tileX = canvasToTileX(mouseX);
    int tileY = canvasToTileY(mouseY);
    if (tileX != prevTileX || tileY != prevTileY) {
      swapPixel(tileX, tileY);
      tilePixelChanged(tileX, tileY);
      prevTileX = tileX;
      prevTileY = tileY;
    }
  }
}

void mouseReleased() {
}

void keyReleased() {
  switch (key) {  
    case 'l':
      tile = loadImage("tile.png");
      redraw();
      break;
    
    case 's':
      tile.save("tile.png");
      break;
      
    case 'r':
      save("render.png");
      break;
      
    case '=':
      scale *= 2;
      redraw();
      break;
          
    case '-':
      scale /= 2;
      redraw();
      break;
  }
}

void redraw() {
  background(0);
  
  tile.loadPixels();
  for (int x = 0; x < width; x += scale) {
    for (int y = 0; y < height; y += scale) {
      fill(tile.pixels[canvasToTileX(x) + tile.width * canvasToTileY(y)]);
      shape(stitch, x, y, scale, scale);
    }
  }
}

void tilePixelChanged(int tileX, int tileY) {
  tile.loadPixels();
  for (int x = tileX * scale; x < width; x += tile.width * scale) {
    for (int y = tileY * scale; y < height; y += tile.height * scale) {
      fill(tile.pixels[canvasToTileX(x) + tile.width * canvasToTileY(y)]);
      shape(stitch, x, y, scale, scale);
    }
  }
}

void swapPixel(int tileX, int tileY) {
  tile.loadPixels();
  int index = tileX + tile.width * tileY;
  if (tile.pixels[index] == WHITE) {
    tile.pixels[index] = RED;
  }
  else {
    tile.pixels[index] = WHITE;
  }
  tile.updatePixels();
}

int canvasToTileX(int canvasX) {
  return canvasX / scale % tile.width;
}

int canvasToTileY(int canvasY) {
  return canvasY / scale % tile.height;
}
