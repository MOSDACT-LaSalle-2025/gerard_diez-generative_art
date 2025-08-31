class Background{  
  float max_radius;
  float stroke_color;
  float timer=0;
  float offset;
  float multiplier;
  final float INCREMENT = 0.05;
  final float DIST_MAX = 3;
 
  
  Background() {
    max_radius = sqrt(pow(width,2) + pow(height,2));
  }
  
  void display() {
    /*
    background(0);
    noFill();
    stroke(255);
    strokeWeight(1);
    
    float distortionA = random(-100,100);
    float distortionB = random(-100,100);
  
    for(int a=0; a<max_radius; a+=10) {
      offset = a*0.01;
      stroke_color = sin(-timer*20 + offset);
      stroke_color = map(stroke_color, -1, 1, 0, 255);
      stroke(stroke_color, 80);
      // Draw the ellipse with uneven offsets, increasing proportional to radius. multiplier factor to have it less exagerated
      // Abs to avoid the sum of radius + offset to be negative
      multiplier = map(a, 0, max_radius, 1, 5);
      ellipse(width/2, height/2, abs(a+(distortionA*multiplier)), abs(a+(distortionB*multiplier)));
    }
    timer += INCREMENT;
    */
  }
}
