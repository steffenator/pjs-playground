import toxi.geom.*;
import toxi.math.*;
Flock flock;
boolean drawBG = true;
void setup() {
  size(1024,768);
  flock = new Flock();
  background(0);
  ellipseMode(CENTER);
  for (int i = 0; i < 75; i++) {flock.addBoid(new Boid(new toxi.Vec2D(width/2,height/2),3.0,0.05,(int)random(2,30)));}
  smooth();
}
void draw() {
  if( frameCount % 2==0 && drawBG==true){
  fill(0, 0, 0, 1);
  noStroke();
  ellipse(width/2, height/3, width*0.75+(sin(frameCount)*300), width*0.75+(sin(frameCount)*300));
  noFill();
  }
  if( frameCount % 20==0 && drawBG==true){
  fill(0, 0, 0, 1);
  noStroke();
  rect(0, 0, width, height);
  noFill();
  }
  flock.run();
}
// Add a new boid into the System
void mousePressed() {
   drawBG = !drawBG;
  //for (int i = 0; i < (int)random(5,15); i++) {
 // flock.addBoid(new Boid(new toxi.Vec2D(mouseX,mouseY),2.0,0.05f));
  //}
}

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {
  int bodyWidth;
  toxi.Vec2D loc;
  toxi.Vec2D vel;
  toxi.Vec2D acc;
  float r;
  float maxforce;
  float maxspeed;

  public Boid(toxi.Vec2D l, float ms, float mf, int bW) {
    bodyWidth = bW;
    loc=l;
    acc = new toxi.Vec2D();
    vel = toxi.Vec2D.randomVector();
    r = 2.0;
    maxspeed = ms;
    maxforce = mf;
  }

  void run(ArrayList boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList boids) {
    toxi.Vec2D sep = separate(boids);   // Separation
    toxi.Vec2D ali = align(boids);      // Alignment
    toxi.Vec2D coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.scaleSelf(1.5);
    ali.scaleSelf(1.0);
    coh.scaleSelf(1.0);
    // Add the force vectors to acceleration
    acc.addSelf(sep);
    acc.addSelf(ali);
    acc.addSelf(coh);
  }

  // Method to update location
  void update() {
    // Update velocity
    vel.addSelf(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.addSelf(vel);
    // Reset accelertion to 0 each cycle
    acc.clear();
  }

  void seek(toxi.Vec2D target) {
    acc.addSelf(steer(target,false));
  }

  void arrive(toxi.Vec2D target) {
    acc.addSelf(steer(target,true));
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  toxi.Vec2D steer(toxi.Vec2D target, boolean slowdown) {
    toxi.Vec2D steer;  // The steering vector
    toxi.Vec2D desired = target.sub(loc);  // A vector pointing from the location to the target
    float d = desired.magnitude(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if (slowdown && d < 100.0f) desired.scaleSelf(maxspeed*d/100.0f); // This damping is somewhat arbitrary
      else desired.scaleSelf(maxspeed);
      // Steering = Desired minus Velocity
      steer = desired.sub(vel).limit(maxforce);  // Limit to maximum steering force
    } 
    else {
      steer = new toxi.Vec2D();
    }
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    //float theta = vel.heading() + radians(90);
        if(loc.y>=height*0.33) { fill(map(loc.y,height*0.33, height,255,0)); }
        else {fill(255);}
        stroke(map(loc.y,0, height,0,255));

    //noFill();
    noStroke();
    strokeWeight(5);
    pushMatrix();
    translate(loc.x,loc.y);
    //scale(1.5);
    //rotate(theta);
    //point(0,0);
    ellipse(0,0,bodyWidth,5);
    //beginShape(TRIANGLES);
   // vertex(0, -r*2);
    //vertex(-r*2.5, r*2);
    //vertex(r*2.5, r*2);
    //endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  toxi.Vec2D separate(ArrayList boids) {
    float desiredseparation = 25.0f;
    toxi.Vec2D steer = new toxi.Vec2D();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.distanceTo(other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        toxi.Vec2D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/d);
        steer.addSelf(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.magnitude() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalizeTo(maxspeed);
      steer.subSelf(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  toxi.Vec2D align (ArrayList boids) {
    float neighbordist = 50.0;
    toxi.Vec2D steer = new toxi.Vec2D();
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.distanceTo(other.loc);
      if ((d > 0) && (d < neighbordist)) {
        steer.addSelf(other.vel);
        count++;
      }
    }
    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.magnitude() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalizeTo(maxspeed);
      steer.subSelf(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  toxi.Vec2D cohesion (ArrayList boids) {
    float neighbordist = 50.0;
    toxi.Vec2D sum = new toxi.Vec2D();   // Start with empty vector to accumulate all locations
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.distanceTo(other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.addSelf(other.loc); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1.0/count);
      return steer(sum,false);  // Steer towards the location
    }
    return sum;
  }
}

// Flock class
// Does very little, simply manages the ArrayList of all the boids
class Flock {
  ArrayList boids; // An arraylist for all the boids
    Flock() {
    boids = new ArrayList(); // Initialize the arraylist
  }
  void run() {
    for (int i = 0; i < boids.size(); i++) {
      Boid b = (Boid) boids.get(i);  
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }
  void addBoid(Boid b) {
    boids.add(b);
  }
}
