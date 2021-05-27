int canvasWidth = 800;
int canvasHeight = 800;
int scale = 1; // for hi-res images

// save each frame (make an animation)
boolean isRecording = false;

// debug tools
boolean debugDrawBoundingBox = false;
boolean debugDrawPolygonOutline = false;
boolean debugDrawPolygonCenter = false;

color canvasFG;
color canvasBG;

int saturation;

void settings(){
  size(canvasWidth*scale, canvasHeight*scale);
}

void setup(){
  // render one image (space bar refresh), or a continuous series
  
  if (isRecording != true){
    noLoop();
  }
  
  frameRate(1); // of continuous
  
  colorMode(HSB, 360, 100, 100, 100);
  
  canvasFG = #222222; canvasBG = #666666;
  saturation = 40;
  
  stroke(canvasFG);
  background(canvasBG);
}

void sketchShape(int[][] points, int density, String orientation, int size, int weightHigh, int colour){
  
  // create the polygon object (p)
  java.awt.Polygon p = new java.awt.Polygon();
  
  // add each point to the polygon object
  for (int i = 0; i < points.length; i++) {
    p.addPoint(points[i][0], points[i][1]);
  }

  // === debug: draw the polygon outline
  if (debugDrawPolygonOutline == true) {
    noFill();
    stroke(#ff0000);
    strokeWeight(1);
    beginShape();
    for (int i = 0; i <= p.npoints; i++) {
      if (i == p.npoints) {
        vertex(p.xpoints[0], p.ypoints[0]); // close shape if last point
      } else {
       vertex(p.xpoints[i], p.ypoints[i]);
      }
    }
    endShape();
  }
  
  // === debug: draw polygon center point
  if (debugDrawPolygonCenter == true) {
    int xTotal = 0;
    int yTotal = 0;
    
    // first sum up all X coordinates, all Y coordinates
    for (int i = 0; i < p.npoints; i++) {   
      xTotal += p.xpoints[i];
      yTotal += p.ypoints[i];
    }
    
    int polygonCenterX = xTotal / p.npoints;
    int polygonCenterY = yTotal / p.npoints;
  }

  
  
  // vars: range variables to calculate bounding box
  int xHigh = 0;
  int xLow = 0;
  int yHigh = 0;
  int yLow = 0;
  
  for (int i = 0; i < p.npoints; i++) {
    // on first loop, set range variables regardless
    if (i == 0){
      xHigh = p.xpoints[i];
      xLow = p.xpoints[i];
      yHigh = p.ypoints[i];
      yLow = p.ypoints[i];
    }
    
    // constrain range variables (if higher/lower)
    if (p.xpoints[i] > xHigh ) { xHigh = p.xpoints[i]; }
    if (p.xpoints[i] < xLow) { xLow = p.xpoints[i]; }
    if (p.ypoints[i] > yHigh) { yHigh = p.ypoints[i]; }
    if (p.ypoints[i] < yLow) { yLow = p.ypoints[i]; }
  }
  
  
  int tolerance = 200;
  
  xHigh += tolerance;
  xLow -= tolerance;
  yHigh += tolerance;
  yLow -= tolerance;
  
  // === debug: draw the bounding box
  if (debugDrawBoundingBox == true) {
    stroke(#0000ff);
    noFill();
    rect(xLow, yLow, xHigh - xLow, yHigh - yLow);
  }
  
  
  // draw background (no transparency)
  //fill(#ffffff);
  //noStroke();
  //beginShape();
  //for (int i = 0; i <= p.npoints; i++) {
  //  if (i == p.npoints) {
  //    vertex(p.xpoints[0], p.ypoints[0]); // close shape if last point
  //  } else {
  //   vertex(p.xpoints[i], p.ypoints[i]);
  //  }
  //}
  //endShape();
  
  
  
  
  // draw a series of lines inside the shape
  int count = density;
  size *= scale;
  for (int i = 0; i < count; i++) {
    // create a random x,y pair inside the bounding box
   
    int x1 = randomInteger(xLow, xHigh);
    int y1 = randomInteger(yLow, yHigh);
    
    int x2, y2;
    
    // limit line length
    x2 = randomInteger(x1 - size, x1 + size);
    y2 = randomInteger(y1 - size, y1 + size);
    
    // set a random weight
    int weightLow = 4;
    //int wHigh = 100;
    
    int weight = randomInteger(weightLow, weightHigh);
    weight *= scale;
    strokeWeight(weight);
    strokeCap(SQUARE);
    
    // polarise!
    if (orientation == "horizontal") { y2 = y1; }
    if (orientation == "vertical") { x2 = x1; }
    
    // set colour
    int colourOnOff = randomInteger(0, 100);

    if (colourOnOff <= colour){
      int randomHue = randomInteger(0, 360);
      stroke(randomHue, saturation, 100, 100);
    } else {
      stroke(canvasFG);
    }
    
    
    
    // check they're inside then draw line; if not reject and retry
    if (p.contains(x1, y1) == true && p.contains(x2, y2) == true){
      line(x1, y1, x2, y2);
    } else {
      i--;
    }
  }
}

// modify shape coordinates according to scale variable (for hi-res images)
void scaleShape(int[][] points){
  for (int i = 0; i < points.length; i++) {
    points[i][0] *= scale;
    points[i][1] *= scale;
  }
}

void drawScene(){
  // (points, density, orientation, size, weight, colour)
  
  // skethbook theme
  int[][] skyShape = { {0,0}, {800, 0}, {800, 440}, {0, 440} }; 
  scaleShape(skyShape);
  sketchShape(skyShape, 40, "none", 20, 10, 60);

  int[][] wallShape = { {0,440}, {800, 440}, {800, 640}, {0, 640} }; 
  scaleShape(wallShape);
  sketchShape(wallShape, 16, "vertical", 160, 80, 30);
  
  int[][] floorShape = { {0,640}, {800, 640}, {800, 800}, {0, 800} };
  scaleShape(floorShape);
  sketchShape(floorShape, 10, "horizontal", 400, 20, 30);
  
  int[][] bodyShape = { {360,320}, {520, 260}, {660, 310}, {600, 800}, {460, 800} }; 
  scaleShape(bodyShape);
  sketchShape(bodyShape, 20, "none", 80, 80, 50);
  
  int[][] headShape = { {420,120}, {600, 100}, {560, 320}, {460, 300} }; 
  scaleShape(headShape);
  sketchShape(headShape, 10, "none", 80, 80, 50);
  // === */

}

void draw(){
  background(canvasBG);
  stroke(canvasFG);
  
  drawScene();
  
  if (isRecording == true){
    saveFrame("_render/"+getTimestamp()+".png");
  }
}

// handle key press events
void keyPressed() {
  //println(keyCode);
  
  // [space] : redraw
  if (keyCode == 32) {
    redraw();
  }
  
  // P : export image
  if (keyCode == 80) {    
    saveFrame("_render/"+getTimestamp()+".png");
  }
  
  // Q : record (output images)
  if (keyCode == 81) {    
    toggleIsRecording();
  }
}


// UTILITIES
void toggleIsRecording(){
  if (isRecording == false) {
    isRecording = true;
  } else {
    isRecording = false;
  }
}

// function: generates a random integer
int randomInteger(int min, int max){
  int ri = int(random(min, max+1));
  return ri;
}

// function: generates a random float number
float randomFloat(int min, int max){
  float rf = random(min, max);
  return rf;
}

// function: generates a random boolean
boolean randomBoolean(){
  int ri = int(random(2));
  if (ri == 1) {
    return true;
  }
  return false;
}

// function: generates a random positive|negative multiplier
int randomPlusOrMinus(){
  int rm = int(random(2))*2-1;
  return rm;
}

// function: generates a timestamp string
String getTimestamp(){
  String y = nf(year(), 4);
  String m = nf(month(), 2);
  String d = nf(day(), 2);
  String h = nf(hour(), 2);
  String mm = nf(minute(), 2);
  String s = nf(second(), 2);
  
  String timestamp = y+m+d+"-"+h+mm+s;
  return timestamp;
}
