

color RED = color(225, 26, 52);
color WHITE = color(255, 255, 255);

PImage tile;

int scale;

void setup() {
  size(800, 600);
  
  scale = 16;
  
  tile = createImage(ceil(80 / scale), ceil(height / scale), RGB);
  tile.loadPixels();
  for (int i = 0; i < tile.pixels.length; i++) {
    tile.pixels[i] = RED;
    if (i < tile.pixels.length/2) {
      tile.pixels[i] = WHITE;
    }
  }
  tile.updatePixels();
}

void draw() {
  for (int x = 0; x < width; x += tile.width * scale) {
    image(tile, x, 0, tile.width * scale, tile.height * scale);
  }
}

void mousePressed() {
}

void mouseReleased() {
  tile.loadPixels();
  int index = canvasToTileX(mouseX) + tile.width * canvasToTileY(mouseY);
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
