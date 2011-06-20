/* @pjs crisp="true"; pauseOnBlur="true"; */

float weight = 0.25;

float counter = 0;
float speed = 0.0125;
boolean direction = true; // ausdehnen & zusammenziehen
float incr, decr; // ausdehnen & zusammenziehen

int fR = 30; // frameRate

float minLength = 10;
float maxLength = 50;

int l1 = (int)random(4,10);
int l2 = (int)random(2,8);
int l3 = (int)random(0,6);

int sL1[] = new int[l1];
int sL2[] = new int[l2];
int sL3[] = new int[l3];
int rotations[] = new int[sL1.length + sL2.length + sL3.length];
int colors[] = new int[sL1.length + sL2.length + sL3.length];

int circleRadius = 5;

//PFont font; 

void setup() {
  size(1024, 768);
  frameRate(fR);
  //  font = loadFont("ChaparralPro-Regular.otf");
  //  textFont(font, 32); 
  //  counter = 0;
  //  front = loadShape("LogoFront.svg");
  //  back = loadShape("LogoBack.svg");

  //fill(161,207,20);
  background(0);
  setRandValues();
  smooth();
}

void setRandValues() {

  for(int i = 0; i < sL1.length; i++) {  
    sL1[i] = (int)random(minLength, maxLength*0.75);
  }
  for(int j = 0; j < sL2.length; j++) {  
    sL2[j] = (int)random(minLength, maxLength);
  }
  for(int k = 0; k < sL3.length; k++) {  
    sL3[k] = (int)random(minLength, maxLength*1.5);
  }

  for(int l = 0; l < rotations.length; l++) {  
    rotations[l] = (int)random(0, 360);
  }
  for(int l = 0; l < rotations.length; l++) {  
    colors[l] = (int)random(50, 200);
  }
}

void draw () {

  ellipseMode(CENTER);
  counter += speed; //random(0.005, 0.01);

  // increasing & decreasing of line-lengths:
  if (counter % 10 <= 5) {
    direction = true;
  } 
  else {
    direction = false;
  }

  incr = counter % 5;
  decr = 5 - (counter % 5);
  //////////////////////////////////////////

  float x = cos(counter) * 40;
  float y = sin(counter) * 20;

  background(0);

  translate(width/2, height/2);
  seeStrokes(false);

  fill(100);
  ellipse(0, 0, 2, 2);

  for(int i=0; i < sL1.length; i++) {

    pushMatrix();
    rotate(rotations[i] + (x * 0.005));
    seeStrokes(true);
    if (direction) {
      line(0, 0, sL1[i] + x + incr*10, sL1[i] + y + incr*10);
      translate(sL1[i] + x + incr*10, sL1[i] + y + incr*10);
    } 
    else {
      line(0, 0, sL1[i] + x + decr*10, sL1[i] + y + decr*10);
      translate(sL1[i] + x + decr*10, sL1[i] + y + decr*10);
    }
    seeStrokes(false);
    fill(colors[i]);
    ellipse(0, 0, circleRadius * 1.5, circleRadius * 1.5);

    for(int j=0; j < sL2.length; j++) {

      pushMatrix();
      rotate(rotations[i + j] - (x * 0.025));
      seeStrokes(true);
      if (direction) {
        line(0, 0, sL2[j] - x + incr*10, sL2[j] - y + incr*10);
        translate(sL2[j] - x + incr*10, sL2[j] - y + incr*10);
      } 
      else {
        line(0, 0, sL2[j] - x + decr*10, sL2[j] - y + decr*10);
        translate(sL2[j] - x + decr*10, sL2[j] - y + decr*10);
      }
      seeStrokes(false);
      fill(colors[i + j]);
      ellipse(0, 0, circleRadius * 1.5, circleRadius * 1.5);

      for(int k=0; k < sL3.length; k++) {

        pushMatrix();
        rotate(rotations[i + j + k] + (x * 0.0005));
        seeStrokes(true);
        line(0, 0, sL3[k] + x, sL3[k] + y);
        translate(sL3[k] + x, sL3[k] + y);
        seeStrokes(false);

        if(k % 16 == 0) {
        fill(colors[i + j + k], 50);
        ellipse(0, 0, circleRadius * (x/8), circleRadius * (x/8));
        }
        fill(colors[i + j + k]);
        ellipse(0, 0, circleRadius * 1.5, circleRadius * 1.5);

        popMatrix();
      }
      popMatrix();
    }

    popMatrix();
  }
  //  fill(161,207,20,70);
  //  ellipse(0,0,55,55);
  //  text("GABY MUELLER", 15, 50);
}

void mousePressed() {
  setRandValues();
}

void seeStrokes(boolean yesOrNo) {
  if(yesOrNo == false) noStroke();
  if(yesOrNo == true) {
    stroke(255);
    strokeWeight(weight);
  }
}

