<script type="application/processing">

float multiply;
boolean change = false;
float counter = 0;

void setup() {
  size(1024, 768);
  background(0);
  colorMode(HSB, 360);
  multiply = random(50,80);
  ellipseMode(CENTER);
}

void draw() {
  counter+=1;
  if(counter>=100) counter=100;
  noStroke();
  fill(0, 0, 0, 15-((frameCount/160)%5));

  rect(0, 0, width, height);
  noFill();
  translate(width/2.0f, height/2.0f);

  for(int i = 1; i < 361; i++) {
    if(change) {
      stroke((360/(i*i))*360, 360, 360, ((360/(i*i))*((360-i)/2)));
      strokeWeight((int)map(i,1,360,2,counter));
    } 
    else {
      stroke((360/(i*i))*360, 360, 360, (360-i)/4.5);
      strokeWeight(2);
    }
    pushMatrix();
    rotate((i*50) + frameCount/100.0f/ (i*2.0f)) ;
    translate( cos((i*60) + frameCount/50.0f ) * (i + multiply), sin((i*50) + frameCount/80.0f) * (i + multiply) );
    point(i, i);
    popMatrix();
  }
  noStroke();
  fill(0,180);
  ellipse(0,5,65,65);
}
void mouseReleased() {
  counter=0;
  change = !change;
}

</script>
