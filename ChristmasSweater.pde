

import gifAnimation.*;

color TRANSPARENT = color(0, 0, 0, 0);
color RED = color(225, 26, 52);
color WHITE = color(255, 255, 255);

PImage[] tiles;
PShape stitch;

int scale;

int prevTileX;
int prevTileY;

int currFrame;
int numFrames;

boolean isShiftDown;

void setup() {
  size(800, 1200);
  
  scale = 16;
  
  currFrame = 0;
  numFrames = 10;
  
  isShiftDown = false;
  
  tiles = new PImage[numFrames];
  for (int i = 0; i < numFrames; i++) {
    PImage tile = createImage(100, ceil(height / scale), RGB);
    tile.loadPixels();
    for (int j = 0; j < tile.pixels.length; j++) {
      tile.pixels[j] = RED;
    }
    tile.updatePixels();
    
    tiles[i] = tile;
  }
  
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

void keyPressed() {
  if (key == CODED && keyCode == SHIFT) {
    isShiftDown = true;
  }
}

void keyReleased() {
  switch (key) {
    case 'l':
      loadTiles();
      redraw();
      break;
    
    case 's':
      saveTiles();
      break;
      
    case 'r':
      saveRender();
      break;
      
    case '=':
      scale *= 2;
      redraw();
      break;
          
    case '-':
      scale /= 2;
      redraw();
      break;
     
    case ' ':
      if (isShiftDown) {
        currFrame = (currFrame - 1) % numFrames;
      }
      else {
        currFrame = (currFrame + 1) % numFrames;
      }
      redraw();
      break;
  }
  
  if (key == CODED && keyCode == SHIFT) {
    isShiftDown = false;
  }
}

void redraw() {
  redraw(this.g);
}

void redraw(PGraphics pg) {
  redraw(pg, currFrame);
}

void redraw(PGraphics pg, int frameIndex) {
  pg.background(0);
  
  PImage tile = tiles[frameIndex];
  
  tile.loadPixels();
  for (int x = 0; x < pg.width; x += scale) {
    for (int y = 0; y < pg.height; y += scale) {
      pg.fill(tile.pixels[canvasToTileX(x) + tile.width * canvasToTileY(y)]);
      pg.shape(stitch, x, y, scale, scale);
    }
  }
}

void tilePixelChanged(int tileX, int tileY) {
  PImage tile = tiles[currFrame];
  
  tile.loadPixels();
  for (int x = tileX * scale; x < width; x += tile.width * scale) {
    for (int y = tileY * scale; y < height; y += tile.height * scale) {
      fill(tile.pixels[canvasToTileX(x) + tile.width * canvasToTileY(y)]);
      shape(stitch, x, y, scale, scale);
    }
  }
}

void swapPixel(int tileX, int tileY) {
  PImage tile = tiles[currFrame];
  
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
  return canvasX / scale % tiles[0].width;
}

int canvasToTileY(int canvasY) {
  return canvasY / scale % tiles[0].height;
}

void loadTiles() {
  for (int i = 0; i < numFrames; i++) {
    tiles[i] = loadImage("tile" + i + ".png");
  }
}

void saveTiles() {
  for (int i = 0; i < numFrames; i++) {
    tiles[i].save("tile" + i + ".png");
  }
}

void saveRender() {
  PImage tile = tiles[currFrame];
  
  GifMaker gif = new GifMaker(this, "render.gif");
  gif.setRepeat(0); // Endless animation.
  
  for (int i = 0; i < numFrames; i++) {
    PGraphics render = createGraphics(width, height);
    render.beginDraw();
    redraw(render, i);
    render.endDraw();
    
    gif.setDelay(500);
    gif.addFrame(render);
  }
  
  gif.finish();
}
