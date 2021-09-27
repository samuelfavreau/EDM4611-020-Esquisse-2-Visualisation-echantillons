/*
 * Class: EDM4611-020
 * Title: Esquisse 2 - Visualisation d’échantillons
 * Autor: Samuel Favreau
 
 * Instructions: 1-Press the arrow keys to select the image to process.
                 2-Type in the name of the piece.
                 3-Press ENTER to generate a patern around the frame and to export the image.
*/

//Global variables
float cAngle;
float c = 10;
float r;
float phi;

float x;
float y;
float centerX;
float centerY;

PImage baseImg;
PImage newImg;
PGraphics wall;
PImage baseNoise;
PImage finalNoise;
PImage frame;
PImage plaque;
PImage preview;

char[] letters;
String title = "";

int newImgSize = 200;
int[] rowColor = new int[newImgSize];

color circleColor;
float circleSize = newImgSize*2.5;

String[] fileNames;
int selectedFile = 0;

boolean naming = true;

int spiralIndex = 0;
int designIndex = 0;

boolean spiralEnd = false;
boolean designEnd = false;

PFont font;

boolean canReload = true;
boolean canExport = true;

int exportIndex;

//----------------------------------------------------------------------------------
//                                    SETUP
//----------------------------------------------------------------------------------

void setup() {
  size(800, 800);

  //Gets all the names of the images from the data folder and puts them in an array
  java.io.File dataFolder = new java.io.File(dataPath("images"));
  fileNames = dataFolder.list();
  
  //Checks the id of the last exported image from the export folder
  java.io.File exportFolder = new java.io.File(dataPath("export"));
  String[] exportNames = exportFolder.list();
  
  if(exportNames != null){
    exportIndex = int(exportNames[exportNames.length - 1].substring(8, 12)) + 1;
  } else {
    exportIndex = 0;
  }

  //Draws the different textures
  wall();
  woodTexture();
  frameShape();

  noStroke();
  centerX = width/2;
  centerY = height/2;

  //Sets the font of the sketch
  font = loadFont("font/BaskOldFace-48.vlw");
  textFont(font);
}

//----------------------------------------------------------------------------------
//                                    DRAW
//----------------------------------------------------------------------------------

void draw() {

  if (canReload) {
    //Loads the image that needs to be processed
    baseImg = loadImage("images/" + fileNames[selectedFile]);
    //Creates a copy that will be processed
    newImg = createImage(newImgSize, newImgSize, RGB);
    newImg.copy(baseImg, 0, 0, baseImg.width, baseImg.height, 0, 0, newImg.width, newImg.height);
    //Creates a preview showing the image being processed
    preview = createImage(50, 50, ARGB);
    preview.copy(newImg, 0, 0, newImg.width, newImg.height, 0, 0, preview.width, preview.height);

    //Calculates the overall brightness of the image
    newImg.loadPixels();
    analyseImgBright();
    //Calculates the overall color of each row of pixels
    analyseImgColor();

    canReload = false;
  }

  background(255);

  //Draws the wall
  image(wall, 0, 0);

  //Draws the preview
  if (naming) {
    image(preview, width - 100, height - 100);
  }

  //Draw the cast shadow of the frame
  for (float i = 0; i <= 8; i+=2) {
    fill(0, 40 - i);
    circle(centerX + i + 5, centerY + i + 5, circleSize + 10);
  }

  //Draws a frame with wood like texture
  image(frame, centerX - frame.width/2, centerY - frame.height/2);

  //Draws the design around the frame
  if (!naming && letters.length > 0) {
    stroke(193, 162, 96, 150);
    strokeWeight(3);
    noFill();
    beginShape();
    if (designIndex < 360) {
      designIndex += 10;
    }
    for (int i = 0; i < designIndex; i+=1) {
      float letterOffset = constrain(map(byte(letters[i % (letters.length-1)]), 65, 122, -40, 20), -10, 15);
      float x = cos(radians(i))*((newImgSize*1.12) + letterOffset);
      float y = sin(radians(i))*((newImgSize*1.12) + letterOffset);
      vertex(centerX + x, centerY + y);
    }
    endShape();
  }

  noStroke();

  //Background of the frame
  fill(constrain(circleColor - 100, 0, 255));
  circle(centerX, centerY, newImgSize*2);

  //Inner shadow of the frame
  for (float i = 0; i <= 100; i++) {
    fill(circleColor, map(i, 0, 100, 255, 0));
    circle(centerX, centerY, map(i, 0, 100, 0, newImgSize*2));
  }

  //Draws the phyllotaxis pattern
  if (spiralIndex < newImgSize) {
    spiralIndex += 5;
  }
  for (int n = 0; n < spiralIndex; n++) {
    r = c*sqrt(n);
    phi = n*cAngle;
    x = cos(phi) * r;
    y = sin(phi) * r;

    fill(red(rowColor[n]), green(rowColor[n]), blue(rowColor[n]));
    circle(centerX + x, centerY + y, c-1);
  }

  if (naming || (!naming && letters.length > 0)) {
    //Draw the cast shadow of the plaque
    float tSize = 30;
    rectMode(CENTER);
    for (float i = 0; i <= 8; i+=2) {
      fill(0, 40 - i);
      rect(centerX + i, height - centerY/4 + 3 + i, textWidth(title) + 20, tSize + 25);
    }

    //Draws the plaque for the title
    plaqueShape(centerX, height - centerY/4 + 3, textWidth(title) + 20, tSize + 25);
    fill(#EABE5C);
    rect(centerX, height - centerY/4 + 3, textWidth(title) + 10, tSize + 15);
    noStroke();

    //Writes the name of the piece
    fill(#524234);
    textSize(tSize);
    textAlign(CENTER, CENTER);
    text(title, centerX, height - centerY/4);

    //Draws the shine on the plaque
    for (float i = centerX - textWidth(title)/2 + 25; i < centerX + textWidth(title)/2 - 40; i += 100) {
      noStroke();
      fill(255, map(dist(i, 0, centerX, 0), 0, width/2, 40, 0));
      int shineSize = 10;
      int decal = 20;
      quad(i - shineSize - decal, height - centerY/4 + 3 - (tSize + 15)/2, 
        i + shineSize - decal, height - centerY/4 + 3  - (tSize + 15)/2, 
        i + shineSize + decal, height - centerY/4 + 3  + (tSize + 15)/2, 
        i - shineSize + decal, height - centerY/4 + 3 + (tSize + 15)/2);

      int shineSize2 = 5;
      int decal2 = 20;
      quad(i - shineSize2 - decal2 + 25, height - centerY/4 + 3 - (tSize + 15)/2, 
        i + shineSize2 - decal2 + 25, height - centerY/4 + 3  - (tSize + 15)/2, 
        i + shineSize2 + decal2 + 25, height - centerY/4 + 3  + (tSize + 15)/2, 
        i - shineSize2 + decal2 + 25, height - centerY/4 + 3 + (tSize + 15)/2);
    }
  }

  //Checks if the image is still processing
  if (spiralIndex >= newImgSize) {
    spiralEnd = true;
  } 
  if (designIndex >= 360 || (!naming && letters.length == 0)) {
    designEnd = true;
  }

  //If the image is done processing, export it.
  if (spiralEnd && designEnd && canExport) {
    export();
  }
}

//----------------------------------------------------------------------------------
//                                  FUNCTION
//----------------------------------------------------------------------------------

//Calculates the overall brightness of the image
void analyseImgBright() {
  int totalValues = 0;

  for (int pixel : newImg.pixels) {
    totalValues += (red(pixel) + green(pixel) + blue(pixel)) / 3;
  }

  int avgBrigh = totalValues/newImg.pixels.length;

  //Decides the angle of the phyllotaxis
  cAngle = avgBrigh;

  //Decides the color of the back of the frame
  if (avgBrigh < 50) {
    circleColor = 230;
  } else {
    circleColor = 20;
  }
}

//Calculates the overall color of each row of pixels
void analyseImgColor() {
  for (int i = 0; i < newImg.height; i++) {
    int rVal = 0;
    int gVal = 0;
    int bVal = 0;

    for (int j = 0; j < newImg.width; j++) {
      rVal += red(newImg.pixels[j + (i*newImg.width)]);
      gVal += green(newImg.pixels[j + (i*newImg.width)]);
      bVal += blue(newImg.pixels[j + (i*newImg.width)]);
    }

    rowColor[i] = color(rVal/newImg.width, gVal/newImg.width, bVal/newImg.width);
  }
}

//Draws the wood texture
void woodTexture() {
  baseNoise = createImage(2000, 200, RGB);
  finalNoise = createImage(width, height, ARGB);

  float increment = 0.02;
  baseNoise.loadPixels();

  float xoff = 0.0;
  //Sets the detail of the noise
  noiseDetail(10, 0.5);

  //Creates a texture based on the increment the detail and the offset
  for (int x = 0; x < baseNoise.width; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < baseNoise.height; y++) {
      yoff += increment;

      //Gives a wood like color to every pixels
      float bright = map(noise(xoff, yoff) * 100, 0, 100, 10, 50);
      colorMode(HSB, 360, 100, 100);
      baseNoise.pixels[x+y*baseNoise.width] = color(29, 50, bright);
    }
  }
  baseNoise.updatePixels();

  //Resets the color mode to rgb
  colorMode(RGB, 255);

  //Transforms the base noise so it looks more wood like
  finalNoise.copy(baseNoise, 0, 0, baseNoise.width, baseNoise.height, 0, 0, finalNoise.width, finalNoise.height);
}

//Draws the shape of the frame from the wood texture
void frameShape() {
  frame = createImage(int(circleSize), int(circleSize), ARGB);
  frame.copy(finalNoise, 0, 0, finalNoise.width, finalNoise.height, 0, 0, finalNoise.width, finalNoise.height);

  //Shows only the pixels closest to the center (creates a circle shape)
  frame.loadPixels();
  for (int y = 0; y < frame.height; y++) {
    for (int x = 0; x < frame.width; x++) {
      int index = x + (y*frame.width);
      float centerX = frame.width/2;
      float centerY = frame.height/2;
      if (dist(centerX, centerY, x, y) > (circleSize/2)) {
        frame.pixels[index] = color(0, 0);
      }
    }
  }
  frame.updatePixels();
}

//Draws the shape of the plaque from the wood texture 
void plaqueShape(float x, float y, float w, float h) {
  plaque = createImage(int(w), int(h), ARGB);
  plaque.copy(finalNoise, 0, 0, finalNoise.width, finalNoise.height, 0, 0, finalNoise.width, finalNoise.height);

  image(plaque, x - w/2, y - h/2);
}

//Draws the wall texture
void wall() {
  wall = createGraphics(width, height);
  wall.beginDraw();
  int grainSize = 3;
  for (int i = 0; i < width; i+=grainSize*2) {
    wall.stroke(int(random(220, 240)));
    wall.strokeWeight(grainSize);
    wall.line(i, 0, i, height);
  }

  for (int i = 0; i < height; i+=grainSize*2) {
    wall.stroke(int(random(220, 240)));
    wall.strokeWeight(grainSize);
    wall.line(0, i, width, i);
  }

  for (int i = 0; i <= 50; i++) {
    wall.noStroke();
    wall.fill(int(random(210, 220)));
    float x = random(width);
    float y = random(height);
    float w = random(50, 100);
    wall.rect(x, y, w, grainSize);
  }
  wall.endDraw();
}

//Exports the image
void export() {
  saveFrame("data/export/screen-" + nf(exportIndex, 4) + ".png");
  exportIndex++;
  canExport = false;
  naming = true;
}

void resetSpiral() {
  canReload = true;
  spiralIndex = 0;
  spiralEnd = false;
  designIndex = 0;
  designEnd = false;
}

//Checks for keypresses
void keyPressed() {
  //Enter
  if (keyCode == 10) {
    letters = title.toCharArray();
    naming = false;
    canExport = true;
  }

  //Backspace
  if (keyCode == 8 && title.length() > 0) {
    title = title.substring(0, title.length() - 1);
  }

  //If a valid character is typed, add it to the title
  if (naming && key != CODED && keyCode != 8) {
    title += key;
  }

  //Toggling between the images when hitting the arrow keys
  if (naming && key == CODED) {
    if (keyCode == LEFT) {
      resetSpiral();
      if (selectedFile == 0) {
        selectedFile = fileNames.length - 1;
      } else {
        selectedFile--;
      }
    } else if (keyCode == RIGHT) {
      resetSpiral();
      if (selectedFile == fileNames.length - 1) {
        selectedFile = 0;
      } else {
        selectedFile++;
      }
    }
  }
}
