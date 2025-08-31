Eye[] eyes;
Background bg;
final float ROT_AMMT = PI/2;
final int FRAMERATE = 11;
float t = 0;
int npoints;
final float MIN_DIST = 150;
final float MARGIN = 120;


//___________ SETUP FUNCTION ___________//
void setup(){
  size(1920,1080);
  fullScreen(); 
  background(0);
  frameRate(FRAMERATE);
  
  bg = new Background();
  
  // CASE 2. POISSON-DISC SAMPLING. It produces points that are tightly-packed, but no closer to each other than a specified minimum distance, resulting in a more natural pattern.
  ArrayList<PVector> points = poissonDisc(MIN_DIST, 30);
  npoints = points.size();
  eyes = new Eye[points.size()];
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    float rot = random(-ROT_AMMT/2, ROT_AMMT/2);
    eyes[i] = new Eye(p.x, p.y, 80, rot);
  }
}


//___________ DRAW FUNCTION ___________//
void draw(){
  //bg.display();
  background(0);
  t+=0.2;
  for (int i=0; i<npoints; i++){
    Eye e = eyes[i];

    float dt = 1.0/FRAMERATE;
    e.update(dt);
    e.display();
  }

}


//___________ POISSON-DISC SAMPLING FUNCTION ___________//
// r = minimum distance between samples
// k = # attempts before rejection in the algorithm 
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
