/* 
Name: Gerard Diez
Date: 31/08/2025
Description: Autoexigència. It attempts to portray the feeling of having a thousand eyes on you, as if everyone was watching, whatever you do, due to self-inflicted stress.
Place of production: Sant Cugat, Catalunya
Instructions (if necessary): Try moving the mouse around! The eyes follow you wherever you go... If you have a powerful computer, set HIGH_PERFORMANCE constant to true.
*/

Eye[] eyes;
Background bg;
final float ROT_AMMT = PI/2;
final int FRAMERATE = 30;
float t = 0;
int npoints;
final float MIN_DIST = 150;
final float MARGIN = 120;
final boolean HIGH_PERFORMANCE = false;

/**
 *
 * This function is where the setup of the whole execution is done. It creates 
 * a Background object and creates all the
 * instances of the eyes. The position of the eyes is created with a
 * Poisson-Disc sampling distribution, meaning it attempts to fill the screen
 * with randomly positioned points up to a certain MARGIN, with a specified 
 * MIN_DIST between each point. An Eye object is initialized for each of the positions
 * and saved in the eyes array.
 *
 */
void setup(){
  size(1920,1080);
  fullScreen(); 
  background(0);
  frameRate(FRAMERATE);
  
  bg = new Background();
  
  // CASE 2. POISSON-DISC SAMPLING.
  ArrayList<PVector> points = poissonDisc(MIN_DIST, 30);
  npoints = points.size();
  eyes = new Eye[points.size()];
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    float rot = random(-ROT_AMMT/2, ROT_AMMT/2);
    eyes[i] = new Eye(p.x, p.y, 80, rot);
  }
}


/*
* ___________ DRAW FUNCTION ___________
* This function draws the eyes while incrementing the time counter.
* Executed every frame.
*/
void draw(){
  if(HIGH_PERFORMANCE) {bg.display();} else {background(0);}

  t+=0.2;
  for (int i=0; i<npoints; i++){
    Eye e = eyes[i];
    float dt = 1.0/FRAMERATE;
    e.update(dt);
    e.display();
  }

}


/*
* ___________ POISSON-DISC SAMPLING FUNCTION ___________
* This function was implemented from the article found in /02_research/.
* @param r [minimum distance between samples]
* @param k [number of attempts before rejection in the algorithm]
* @return [ArrayList of PVector types with the coordinates of the points]
*/
ArrayList<PVector> poissonDisc(float r, int k) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  ArrayList<PVector> active = new ArrayList<PVector>();
  
  PVector first = new PVector(random(width), random(height));
  points.add(first);
  active.add(first);
  
  while (!active.isEmpty()) {
    int randIndex = int(random(active.size()));
    PVector point = active.get(randIndex);
    boolean found = false;
    
    for (int n = 0; n < k; n++) {
      float angle = random(TWO_PI);
      float mag = random(r, 2*r);
      float nx = point.x + cos(angle) * mag;
      float ny = point.y + sin(angle) * mag;
      PVector newPoint = new PVector(nx, ny);
      
      if (nx >= MARGIN && nx < width - MARGIN && ny >= MARGIN && ny < height - MARGIN) {
        boolean ok = true;
        for (PVector p : points) {
          if (dist(nx, ny, p.x, p.y) < r) {
            ok = false;
            break;
          }
        }
        if (ok) {
          points.add(newPoint);
          active.add(newPoint);
          found = true;
          break;
        }
      }
    }
    
    if (!found) {
      active.remove(randIndex);
    }
  }
  
  return points;
}
