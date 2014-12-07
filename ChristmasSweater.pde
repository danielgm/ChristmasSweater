

color RED = color(225, 26, 52);
color WHITE = color(255, 255, 255);

PImage tile;

int scale;

int prevTileX;
int prevTileY;

void setup() {
  size(800, 600);
  
  scale = 16;
  
  tile = createImage(ceil(192 / scale), ceil(height / scale), RGB);
  tile.loadPixels();
  for (int i = 0; i < tile.pixels.length; i++) {
    tile.pixels[i] = RED;
  }
  tile.updatePixels();
}

void draw() {
  noSmooth();
  for (int x = 0; x < width; x += tile.width * scale) {
    image(tile, x, 0, tile.width * scale, tile.height * scale);
  }
  smooth();
}

void mousePressed() {
  int tileX = canvasToTileX(mouseX);
  int tileY = canvasToTileY(mouseY);
  swapPixel(tileX, tileY);
  prevTileX = tileX;
  prevTileY = tileY;
}

void mouseDragged() {
  if (mousePressed) {
    int tileX = canvasToTileX(mouseX);
    int tileY = canvasToTileY(mouseY);
    if (tileX != prevTileX || tileY != prevTileY) {
      swapPixel(tileX, tileY);
      prevTileX = tileX;
      prevTileY = tileY;
    }
  }
}

void mouseReleased() {
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
