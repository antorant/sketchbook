int canvasWidth = 960;
int canvasHeight = 960;

// save each frame (make an animation)
boolean isRecording = false;

// debug tools
boolean debugDrawBoundingBox = false;
boolean debugDrawPolygonOutline = false;
boolean debugDrawPolygonCenter = false;

color canvasFG;
color canvasBG;

void settings(){
  size(canvasWidth, canvasHeight);
}

void setup(){
  //noLoop();
  frameRate(1);
  
  colorMode(HSB, 360, 100, 100, 100);
  
  canvasFG = #222222;
  canvasBG = #eeeeee;
  
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
  for (int i = 0; i < count; i++) {
    // create a random x,y pair inside the bounding box
   
    int x1 = randomInteger(xLow, xHigh);
    int y1 = randomInteger(yLow, yHigh);
    
    int x2, y2;
    
    // limit line length
    x2 = randomInteger(x1 - size, x1 + size);
    y2 = randomInteger(y1 - size, y1 + size);
    
    // set a random weight
    int weightLow = 1;
    //int wHigh = 100;
    
    int weight = randomInteger(weightLow, weightHigh);
    strokeWeight(weight);
    strokeCap(SQUARE);
    
    // polarise!
    if (orientation == "horizontal") { y2 = y1; }
    if (orientation == "vertical") { x2 = x1; }
    
    // set colour
    int colourOnOff = randomInteger(0, 100);

    if (colourOnOff <= colour){
      int randomHue = randomInteger(0, 360);
      stroke(randomHue, 40, 100, 100);
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

void drawScene(){
  // (points, density, orientation, size, weight, colour)
  
  // skethbook theme
  int[][] mountain = { {0,0}, {960, 0}, {960, 440}, {0, 440} }; 
  sketchShape(mountain, 80, "none", 20, 10, 50);

  int[][] wallShape = { {0,440}, {960, 440}, {960, 640}, {0, 640} }; 
  sketchShape(wallShape, 20, "vertical", 200, 100, 20);
  
  int[][] floorShape = { {0,640}, {960, 640}, {960, 960}, {0, 960} }; 
  sketchShape(floorShape, 40, "horizontal", 400, 20, 20);
  
  int[][] bodyShape = { {520,320}, {650, 260}, {780, 310}, {720, 960}, {620, 960} }; 
  sketchShape(bodyShape, 40, "none", 50, 100, 40);
  
  int[][] headShape = { {580,160}, {720, 140}, {680, 320}, {600, 300} }; 
  sketchShape(headShape, 20, "none", 50, 100, 40);
  // === */
  
  
  /*/ mountains theme
  int[][] partE = { {0,370},{72,396},{126,369},{207,404},{260,381},{293,404},{329,369},{402,396},{440,369},{519,475},{568,493},{590,494},{640,516},{744,468},{844,464},{960,426},{960,0},{0,0},{0,370} }; 
  sketchShape(partE, 100, "none", 10);

  int[][] partD = { {0,370},{72,396},{126,369},{207,404},{260,381},{293,404},{329,369},{402,396},{440,370},{519,475},{568,493},{500,494},{326,564},{286,612},{259,714},{208,668},{188,526},{0,493},{0,370} }; 
  sketchShape(partD, 20, "vertical", 960);
  
  int[][] partC = { {960,426},{960,707},{606,960},{518,960},{259,716},{286,612},{326,564},{500,494},{590,494},{640,516},{744,468},{844,464},{960,426} }; 
  sketchShape(partC, 60, "vertical", 960);
  
  int[][] partB = { {0,493},{0,960},{518,960},{208,668},{188,526},{0,493} }; 
  sketchShape(partB, 80, "horizontal", 960);
  
  int[][] partA = { {960,707},{606,960},{960,960},{960,707} }; 
  sketchShape(partA, 80, "horizontal", 960);
  // === */
  
  /*/ cliffs
  int[][] rocks = { {960,577}, {925,592}, {900,577}, {872,597}, {863,616}, {842,617}, {838,632}, {798,646}, {779,670}, {723,694}, {656,743}, {649,776}, {593,767}, {562,774}, {523,782}, {378,819}, {311,804}, {274,802}, {189,831}, {167,823}, {136,838}, {63,838}, {50,849}, {26,851}, {0,880}, {0,960}, {960,960}, {960,577} }; 
  sketchShape(rocks, 300, "vertical", 60);
  
  int[][] sea = { {875,595}, {872,597}, {863,616}, {842,617}, {838,632}, {798,646}, {779,670}, {723,694}, {656,743}, {649,776}, {593,767}, {562,774}, {523,782}, {378,819}, {311,804}, {274,802}, {189,831}, {167,823}, {136,838}, {63,838}, {50,849}, {26,851}, {0,880}, {0,960}, {0,595}, {875,595} }; 
  sketchShape(sea, 20, "horizontal", 960);
  
  int[][] sky = { {0,595}, {875,595}, {903,577}, {925,595}, {960,577}, {960,0}, {480,0}, {553,30}, {537,51}, {551,82}, {502,102}, {554,123}, {542,164}, {574,193}, {500,255}, {512,284}, {541,298}, {531,353}, {362,435}, {296,451}, {365,402}, {335,374}, {437,337}, {367,322}, {403,307}, {337,282}, {364,261}, {247,210}, {287,185}, {217,153}, {288,128}, {207,123}, {233,96}, {177,80}, {133,0}, {0,0}, {0,595} }; 
  sketchShape(sky, 400, "none", 4);
  // === */
  
  /*/ silhouette
  int[][] person = { {133, 960}, {132, 960}, {154, 785}, {152, 755}, {141, 735}, {113, 705}, {60, 643}, {79, 578}, {115, 550}, {151, 518}, {164, 522}, {175, 507}, {163, 480}, {183, 464}, {177, 410}, {192, 397}, {196, 383}, {190, 375}, {199, 364}, {231, 352}, {284, 268}, {315, 251}, {365, 258}, {390, 255}, {466, 345}, {480, 426}, {547, 551}, {568, 600}, {547, 675}, {566, 721}, {567, 748}, {565, 783}, {592, 960}, {576, 856}, {576, 856}, {592, 960}, {133, 960}, {132, 957}, {132, 960}, {133, 960} }; 
  sketchShape(person, 500, "horizontal", 100);
  
  int[][] plants1 = { {132, 960}, {0, 960}, {0, 822}, {60, 871}, {114, 859}, {132, 957}, {132, 960} }; 
  sketchShape(plants1, 10, "none", 20);
  
  int[][] plants2 = { {960, 569}, {960, 960}, {592, 960}, {576, 856}, {592, 802}, {652, 745}, {679, 885}, {767, 848}, {718, 788}, {716, 665}, {747, 514}, {889, 480}, {960, 569} }; 
  sketchShape(plants2, 10, "none", 180);
  
  int[][] sky = { {960, 569}, {889, 480}, {747, 514}, {716, 665}, {718, 788}, {767, 848}, {679, 885}, {652, 745}, {592, 802}, {576, 856}, {565, 783}, {567, 748}, {566, 721}, {547, 675}, {568, 600}, {547, 551}, {480, 426}, {466, 345}, {390, 255}, {365, 258}, {315, 251}, {284, 268}, {231, 352}, {199, 364}, {190, 375}, {196, 383}, {192, 397}, {177, 410}, {183, 464}, {163, 480}, {175, 507}, {164, 522}, {151, 518}, {115, 550}, {79, 578}, {60, 643}, {113, 705}, {141, 735}, {152, 755}, {154, 785}, {132, 957}, {114, 859}, {60, 871}, {0, 822}, {0, 0}, {960, 0}, {960, 569} }; 
  sketchShape(sky, 400, "none", 2);
  // === */

  /*/ balcony
  int[][] buildings = { {960,960},{328,960},{328,637},{561,611},{766,641},{766,607},{809,565},{835,565},{847,583},{960,577},{960,960} }; 
  sketchShape(buildings, 100, "vertical", 200);
  
  int[][] wall = { {328,324},{328,960},{0,960},{0,0},{960,0},{960,182},{480,366},{328,324} }; 
  sketchShape(wall, 300, "horizontal", 60);
  
  int[][] sky = { {960,181},{480,366},{328,324},{328,637},{562,611},{766,641},{766,607},{809,565},{835,565},{847,583},{960,577},{960,181} }; 
  sketchShape(sky, 200, "none", 4);
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
