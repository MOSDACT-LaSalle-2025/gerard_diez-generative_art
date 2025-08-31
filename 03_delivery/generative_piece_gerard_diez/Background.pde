/*
* Generates a moving background image made of concentric ellipses.
*/
class Background{  
  float max_radius;
  float stroke_color;
  float timer=0;
  float offset;
  float multiplier;
  final float INCREMENT = 0.1;
  final float DIST_MAX = 3;
 
  /*
  * Constructor function, creates a new default background object.
  */
  Background() {
    max_radius = sqrt(pow(width,2) + pow(height,2));
  }
  
  
  /*
  * Display function. It is called every frame and draws a series of concentric ellipses.
  * These ellipses are affected by two distortion parameters, one that affects the height and
  * one that affects the width. A timer variable is incremented every frame, which makes the stroke
  * color of each ellipse vary from brighter to darker in the form of a sine function.
  */
  void display() {

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
      // Draws the ellipse with uneven offsets, increasing proportional to radius. multiplier factor to have it less exagerated
      // Abs to avoid the sum of radius + offset to be negative
      multiplier = map(a, 0, max_radius, 1, 5);
      ellipse(width/2, height/2, abs(a+(distortionA*multiplier)), abs(a+(distortionB*multiplier)));
    }
    timer += INCREMENT;
    
  }
}
