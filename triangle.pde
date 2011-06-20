
float x1,x2,x3,y1,y2,y3,xMid,yMid,h,a,offset=1,sW=3,versatz=1,itterations,frame=0,checkpoint,angle,disconnect;
int zeit=360;
boolean direction=true,change=true,clickable=true;
void setup() {
  size(1024,768);
  frameRate(30);
  ellipseMode(CENTER);
  colorMode(HSB, 360);
  background(0);
  strokeWeight(1);
  h=135;
  a=h/(sqrt(3)/2);
  x1=-a/2;
  x2=a/2;
  x3=0;
  y1=0;
  y2=0;
  y3=h;
  xMid=(x1+x2+x3)/3;
  yMid=(y1+y2+y3)/3;
  update();
}
void draw() {
  disconnect=0;
  fill(0,30);
  rect(0,0,width,height);
  translate(width/2, height/2-5);
  if(change!=true) {
    itterations=itterate(zeit);
    pushMatrix();
    translate(x1,yMid);
    pushMatrix();
    for(int i=0;i<(int)(itterations*offset);i+=(int)offset) {
      stroke(((360/(itterations*offset))*i),0,360,((360/(itterations*offset))*i));
      strokeWeight(1);
      versatz=(i*(itterations/(zeit/5))-(itterations/(zeit/5)))*noise(i/itterations+mouseY);
      line(0,disconnect,a+((angle*30)/(angle*angle)),versatz-(angle*angle*8));
      translate(a+((angle*30)/(angle*angle)),versatz-(angle*angle*8));
      rotate(-(PI/3)*angle);
    }
    popMatrix();
    translate(x2,-yMid);
    rotate(PI-(itterations/36));
    fill(0,360,360,360/(itterations/36));
    noStroke();
    ellipse(x1,yMid,15,15);
    ellipse(x2,yMid,15,15);
    ellipse(x3,-h+yMid,15,15);
    popMatrix();
  } 
  else {

    pushMatrix();
    translate(0,-yMid);
    fill(0,360,360);
    noStroke();
    ellipse(x1,y1,15,15);
    ellipse(x2,y2,15,15);
    ellipse(x3,y3,15,15);
    fill(0);
    beginShape();
    vertex(x1,y1);
    vertex(x2,y2);
    vertex(x3,y3);
    endShape();
    popMatrix();
    clickable=true;
  }
}
void mouseReleased() {
   update();
}
void update() {
  if(clickable==true) {
    change=!change;
    zeit=(int)random(90,360);
    offset=random(1,2);
    angle=random(0.75,2.95);
  }
  else {
    change=false;
  }
  clickable=false;
  checkpoint=frame;
}
float itterate(float duration) {
  if(direction==true) {
    frame+=(offset*0.5);
  }
  else {
    frame-=offset*5;
  }
  if(frame-checkpoint>=duration) direction = !direction;
  if(frame-checkpoint<=0) {
    direction = !direction;
    change = !change;
  }
  return frame;
}
