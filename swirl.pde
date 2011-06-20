int steps = 24;
int maxSteps = 32;
int nrLines = 32;
float x1;
float y1;
float cx1;
float cy1;
float cx2;
float cy2;
float x2;
float y2;
float swing;
float swingfactor = 1.75;
float counter = 0;
float lineLength = 300;
float offset;
boolean plus = true;

float t;
float x;
float y;
float tx;
float ty;
float a;
float c;
float colorHue;

void setup() {
  size(1024, 768);
  frameRate(30);
  colorMode(HSB, 360);
  smooth();
}
void draw() {
  background(0);
  counter += 0.1;

  swing = (sin(counter*0.1)*lineLength*swingfactor);

  translate(width/2, height/2);
  pushMatrix();


  rotate(counter/5);
  for (int i = 0; i < nrLines; i++) {

    x1 = 0;
    y1 = 0;
    cx1 = lineLength*0.33;
    cy1 = swing;
    cx2 = lineLength*0.66;
    cy2 = -swing;
    x2 = lineLength;
    y2 = 0;

    strokeWeight(0.5);
    offset = PI*1.5;
    colorHue = (((((2*PI/nrLines)*i)+(counter/5) + offset) % (2*PI)) / (2*PI)) * 360;
 
    for (int j = 1; j < steps; j++) {
      strokeWeight(1);
      t = j / float(steps);
      x = bezierPoint(x1, cx1, cx2, x2, t);
      y = bezierPoint(y1, cy1, cy2, y2, t);
      tx = bezierTangent(x1, cx1, cx2, x2, t);
      ty = bezierTangent(y1, cy1, cy2, y2, t);
      a = atan2(ty, tx);
      c = atan2(ty, tx);
      a += PI;
      stroke(colorHue, 360, 360, map(swing, 500/swingfactor, -500/swingfactor, 0, 360/(j*0.15)));
      if (j%2==0) {line(x, y, cos(a)*-26 + x*(1.1/(j*0.75)), sin(a)*-26 + y*(1.1/(j*0.75)));}


      noStroke();
      fill(0, 0, 360, 360/j);
      if (plus == false) {
        rect(cos(a)*8 + (x+j), sin(a)*8 + (y+j), j*((-(1/j)+1)*3), j*((-(1/j)+1)*0.75));
      } 
      else {
        ellipse(cos(a)*8 + (x+j), sin(a)*8 + (y+j), j*((-(1/j)+1)*1.5), j*((-(1/j)+1)*1.5));
      }
    }

    rotate((2*PI/nrLines));
  }
  popMatrix();
  if (mouseX <= width/2) { nrLines = (int)map(mouseX, 0, width/2, 8, 32);}
  if (mouseX > width/2) {nrLines = (int)map(mouseX, width/2, width, 32, 8);}  
  if (mouseY <= height/2){ steps = (int)map(mouseY, 0, height, 4, 24);}
  if (mouseY > height/2) {steps = (int)map(mouseY, height/2, height, 24, 4);}

}
void mouseReleased() {
  plus = !plus;
}

