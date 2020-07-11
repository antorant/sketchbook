int canvasWidth = 960;
int canvasHeight = 540;

boolean isRecording = false;

void settings(){
  size(canvasWidth, canvasHeight);
}

void setup(){
  //noLoop();
  frameRate(1);
  
  stroke(#000000);
  background(#ffffff);
  fill(#cccccc);
}

void sketchShape(int[][] points, int density){
  println(points.length);
  
  // create the polygon
  java.awt.Polygon p = new java.awt.Polygon();
  
  for (int i = 0; i < points.length; i++) {
    println(points[i][0], points[i][1]);
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
  
  // get polygon center point, width, height
  // first sum all X coordinates, all Y coordinates
  // vars
  int xTotal = 0;
  int yTotal = 0;
  
  for (int i = 0; i < p.npoints; i++) {   
    xTotal += p.xpoints[i];
    yTotal += p.ypoints[i];
  }
  
  // get the average of each (= center point of shape)
  int polygonCenterX = xTotal / p.npoints;
  int polygonCenterY = yTotal / p.npoints;
  
  
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
  
  
  stroke(#ffffff);
  // draw a series of lines inside the shape
  int count = density;
  for (int i = 0; i < count; i++) {
    // create a random x,y pair inside the bounding box
    int x1 = randomInteger(xLow, xHigh);
    int y1 = randomInteger(yLow, yHigh); 
    int x2 = randomInteger(xLow, xHigh);
    int y2 = randomInteger(yLow, yHigh);
    if (p.contains(x1, y1) == true && p.contains(x2, y2) == true){
      line(x1, y1, x2, y2);
    } else {
      i--;
    }
  }
}

void draw(){
  background(#000000);
  stroke(#ffffff);
  println("---");
  
  //int[][] star1 = { {200,100}, {210, 90}, {220, 110} }; 
  //sketchShape(star1, 1);
  
  //int[][] star2 = { {400,150}, {410, 140}, {420, 160} }; 
  //sketchShape(star2, 1);
  
  //int[][] star3 = { {160,210}, {170, 200}, {180, 210} }; 
  //sketchShape(star3, 1);
  
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
  
  if (isRecording == true){
    saveFrame(getTimestamp()+".png");
  }
}

// handle key press events
void keyPressed() {
  //println(keyCode);
  
  // space bar : redraw
  if (keyCode == 32) {
    redraw();
  }
  
  // p : export image
  if (keyCode == 80) {    
    saveFrame(getTimestamp()+".png");
  }
  
  // q : record (output images)
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
