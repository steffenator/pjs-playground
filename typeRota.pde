/*
  Andor Salga
 Precipice 
 */
float r = 0;
float col;
PFont font;
String a_string = "lobsterlove";
String b_string = "electro";
String c_string = "magnetic";
String d_string = "pro pa ganda";
boolean change = false;

void setup() {
  size(1024,768);
  font = createFont("Arial", 18);
  colorMode(HSB,360);
}

void draw() {
  background(0);
  int key = 0;
  translate(width*0.5, height*0.5);
  rotate((float)frameCount/400%TWO_PI);
  if(change==false) {
    for(int i = 0; i < 11; i++) {
      float xPos = cos(((float)frameCount/40)%TWO_PI) * (i * 15) + map(mouseX,0,width,-width/2,width/2);
      float yPos = (60 + sin(((float)frameCount/40)%TWO_PI)*100.0f + key) + map(mouseY,0,height,height/2,-height/2);
      col = 360/(2*(i+1));
      fill(col,360,360,180+180/(i+1));
      key += 10;
      pushMatrix();
      translate(xPos, yPos);
      rotate(cos(((float)frameCount/40)%TWO_PI) * (6/(i+1)));
      scale(key/1000.0f + sin(((float)frameCount/400)%TWO_PI) * (i * 30)+1);
      text(a_string.charAt(i), 1, 1);
      popMatrix();
    }
  } 
  else {
    for(int i = 0; i < 7; i++) {
      float xPos = cos(((float)frameCount/40)%TWO_PI) * ((i*10)) + map(mouseX,0,width,-width/6,width/6);
      float yPos = (60 + sin(((float)frameCount/40)%TWO_PI)*100.0f + key) + map(mouseY,0,height,height/2,-height/2);
      col = 360/(2.5*(i+1));
      key += 10;
      pushMatrix();
      translate(xPos+i*10, yPos);
      rotate(cos(TWO_PI-(((float)frameCount/400)%TWO_PI)) * (6/(i+1)));
      scale(key/1000.0f + xPos);
      if (i==1) {
        pushMatrix();
        rotate(-PI);
        translate(-2.5,-1);
        textSize(0.25);
        fill(360,map(mouseX,width*0.25,width*0.75,0,360));
        for(int n=0;n<8;n++) {
        translate(n*(8/(n+1))*0.075,0);
        text(c_string.charAt(n), 0, 0);
        }
        popMatrix();
      }
      fill(360-col,360,360,360/(2*i+1));
      textSize(18);
      text(b_string.charAt(i), 1, 1);
      popMatrix();
    }
  }
}
void mouseReleased() { 
  change = !change;
}

