int canvasWidth = 960;
int canvasHeight = 960;

//
boolean isRecording = false;
String canvasTheme = "light"; // light, dark

color canvasFG;
color canvasBG;

void settings(){
  size(canvasWidth, canvasHeight);
}

void setup(){
  //noLoop();
  frameRate(1);
  
  if (canvasTheme == "light") {
    canvasFG = #000000;
    canvasBG = #ffffff;
  }
  
  if (canvasTheme == "dark") {
    canvasFG = #ffffff;
    canvasBG = #000000;
  }
  
  stroke(canvasFG);
  background(canvasBG);
  fill(#cccccc);
}

void sketchShape(int[][] points, int density, String orientation, int size){
  
  // create the polygon object (p)
  java.awt.Polygon p = new java.awt.Polygon();
  
  // add each point to the polygon object
  for (int i = 0; i < points.length; i++) {
    p.addPoint(points[i][0], points[i][1]);
  }

  /*/ === debug: draw the polygon outline
  noFill();
  stroke(#ff0000);
  beginShape();
  for (int i = 0; i <= p.npoints; i++) {
    if (i == p.npoints) {
      vertex(p.xpoints[0], p.ypoints[0]); // close shape if last point
    } else {
     vertex(p.xpoints[i], p.ypoints[i]);
    }
  }
  endShape();
  // === debug: draw the polygon outline */
  

  /*/ === debug: get polygon center point
  int xTotal = 0;
  int yTotal = 0;
  
  // first sum up all X coordinates, all Y coordinates
  for (int i = 0; i < p.npoints; i++) {   
    xTotal += p.xpoints[i];
    yTotal += p.ypoints[i];
  }
  
  int polygonCenterX = xTotal / p.npoints;
  int polygonCenterY = yTotal / p.npoints;
  // === end debug: get polygon center point */
  
  
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
  
  /*/ === debug: draw the bounding box
  stroke(#0000ff);
  noFill();
  rect(xLow, yLow, xHigh - xLow, yHigh - yLow);
  // === */
  
  /*/ === debug: draw a cross to mark center
  stroke(#0000ff);
  line(polygonCenterX - 4, polygonCenterY, polygonCenterX + 4, polygonCenterY);
  line(polygonCenterX, polygonCenterY - 4, polygonCenterX, polygonCenterY + 4);
  // === */
  
  
  // draw background (no transparency)
  //fill(#000000);
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
  
  
  stroke(canvasFG);
  // draw a series of lines inside the shape
  int count = density;
  for (int i = 0; i < count; i++) {
    // create a random x,y pair inside the bounding box
   
    int x1 = randomInteger(xLow, xHigh);
    int y1 = randomInteger(yLow, yHigh);
    
    int x2, y2;
    
    // random length
    //x2 = randomInteger(xLow, xHigh);
    //y2 = randomInteger(yLow, yHigh);
    
    // limited length
    x2 = randomInteger(x1 - size, x1 + size);
    y2 = randomInteger(y1 - size, y1 + size);
    
    // polarise!
    if (orientation == "horizontal") { y2 = y1; }
    if (orientation == "vertical") { x2 = x1; }
    
    // check they're inside then draw line; if not reject and retry
    if (p.contains(x1, y1) == true && p.contains(x2, y2) == true){
      line(x1, y1, x2, y2);
    } else {
      i--;
    }
  }
}

void drawScene(){
  
  /*/ skethbook theme
  int[][] mountain = { {0,0}, {960, 0}, {960, 400}, {0, 400} }; 
  sketchShape(mountain, 1);

  int[][] wallShape = { {0,400}, {960, 400}, {960, 440}, {0, 440} }; 
  sketchShape(wallShape, 5);
  
  int[][] floorShape = { {0,440}, {960, 440}, {960, 540}, {0, 540} }; 
  sketchShape(floorShape, 5);
  
  int[][] bodyShape = { {520,320}, {650, 260}, {780, 310}, {720, 960}, {620, 960} }; 
  sketchShape(bodyShape, 30);
  
  int[][] headShape = { {580,160}, {720, 140}, {680, 320}, {600, 300} }; 
  sketchShape(headShape, 20);
  // === */
  
  
  /*/ mountains theme
  int[][] partD = { {0,150}, {72,152}, {126,149}, {207,176}, {260,161}, {293,176}, {329,149}, {402,168}, {439,149}, {519,167}, {568,185}, {501,185}, {327,256}, {288,305}, {260,387}, {210,363}, {189,218}, {0,185}, {0,150} }; 
  sketchShape(partD, 20);
  
  int[][] partC = { {960,149}, {960,287}, {606,540}, {519,540}, {259,388}, {287,303}, {325,256}, {501,185}, {589,185}, {639,207}, {743,159}, {844,156}, {960,149} }; 
  sketchShape(partC, 140);
  
  int[][] partB = { {0,185}, {0,540}, {519,540}, {208,359}, {188,218}, {0,185} }; 
  sketchShape(partB, 320);
  
  int[][] partA = { {960,287}, {606,540}, {960,540}, {960,287} }; 
  sketchShape(partA, 380);
  // === */
  
  // cliffs
  int[][] rocks = { {960,577}, {925,592}, {900,577}, {872,597}, {863,616}, {842,617}, {838,632}, {798,646}, {779,670}, {723,694}, {656,743}, {649,776}, {593,767}, {562,774}, {523,782}, {378,819}, {311,804}, {274,802}, {189,831}, {167,823}, {136,838}, {63,838}, {50,849}, {26,851}, {0,880}, {0,960}, {960,960}, {960,577} }; 
  sketchShape(rocks, 800, "vertical", 960);
  
  int[][] sea = { {875,595}, {872,597}, {863,616}, {842,617}, {838,632}, {798,646}, {779,670}, {723,694}, {656,743}, {649,776}, {593,767}, {562,774}, {523,782}, {378,819}, {311,804}, {274,802}, {189,831}, {167,823}, {136,838}, {63,838}, {50,849}, {26,851}, {0,880}, {0,960}, {0,595}, {875,595} }; 
  sketchShape(sea, 300, "horizontal", 960);
  
  int[][] sky = { {0,595}, {875,595}, {903,577}, {925,595}, {960,577}, {960,0}, {480,0}, {553,30}, {537,51}, {551,82}, {502,102}, {554,123}, {542,164}, {574,193}, {500,255}, {512,284}, {541,298}, {531,353}, {362,435}, {296,451}, {365,402}, {335,374}, {437,337}, {367,322}, {403,307}, {337,282}, {364,261}, {247,210}, {287,185}, {217,153}, {288,128}, {207,123}, {233,96}, {177,80}, {133,0}, {0,0}, {0,595} }; 
  sketchShape(sky, 80, "none", 100);
  // === */

}

void draw(){
  background(canvasBG);
  stroke(canvasFG);
  
  drawScene();
  
  if (isRecording == true){
    saveFrame(getTimestamp()+".png");
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
    saveFrame(getTimestamp()+".png");
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
  
  String timestamp = y+m+d+h+mm+s;
  return timestamp;
}
