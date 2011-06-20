int breite = 1024;
int hoehe = 768;
int counter;  
int positionX= 10;
int positionY = 420;
int groesse=20;
int willkuer;
int farbe;

float[] pitchSet = {57, 60, 60, 60, 62, 64, 67, 67, 69, 72, 72, 72, 74, 76, 79};
float setSize = pitchSet.length;
float keyRoot = 0;
float density = 0.6;

void setup() {
  frameRate(30);
  size (breite, hoehe);
  background (0);
}

void draw () {
  counter += 1;
  if ( counter >= breite - counter) {} else {
  colorMode(HSB, 360, 100, 100);
  float willkuer=random(counter, breite - counter);
  float farbe=random(0,360);
  strokeWeight(2);
  positionX+= 20;
  groesse+= 5;
  
  if (positionX > breite - counter) { positionX =  10 + counter; groesse =  20; }

  if (random(1) < density) {
    float pitch = pitchSet[(int)random(setSize)]+keyRoot;
    float m = map(pitch-50, 0, 100, 0, (float)hoehe*0.75);
    fill(360-farbe, 360-farbe, 360-farbe, (counter/4));
    noStroke();
    ellipse(willkuer, random(10+counter/4,positionY), 2, 2);   
    noFill();   
    stroke(360-farbe, 360-farbe, 360-farbe, 20+(counter/4));
    rect(willkuer, positionY, 20, m);
  }  
  }
  if ( breite/2-counter<= 0) {
  pushMatrix();
  fill(255, (counter/100));
  noStroke();
  translate(width/2, height/3); 
  beginShape();
  vertex(0, 0);
  vertex(62 ,-100);
  vertex(-62, -100);
  endShape();
  popMatrix();
  }
}

