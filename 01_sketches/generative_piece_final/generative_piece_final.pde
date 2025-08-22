int counter = 0;
float sine;
Eye[][] eyes;
int rows, cols;
float spacingX, spacingY;
final int DELAY = 30;
final int RND_X = 1000;
final int RND_Y = 1000;
final float ROT_AMMT = PI/6;
float t = 0;

void setup(){
  float x, y;
  float rot;
  size(800,800); 
  background(0);
  frameRate(20);
  
  rows = int(random(3,6));
  cols = int(random(3,6));
  spacingX = width/(cols+1);
  spacingY = height/(rows+1);

  eyes = new Eye[rows][cols];
  
  for (int i=0; i<rows; i++){
    for (int j=0; j<cols; j++){
      x = spacingX * (j+1);
      y = spacingY * (i+1);
      rot = random(0, ROT_AMMT) - ROT_AMMT/2;
      eyes[i][j] = new Eye(x, y, 100, rot, color(255, 255, 255), color(255, 0, 0), 10);
    }
  }
 // Constructor: Eye(float xpos, float ypos, float size, float rotation, color sclera_clr, color iris_clr, float pupil_radius)
 //eye = new Eye(width/2, height/2, 100, 0, color(255,255,255), color(255,0,0), 4);
}

void draw(){
  background(0);
  t+=0.2;
  for (int i=0; i<rows; i++){
    for (int j=0; j<cols; j++){
      Eye e = eyes[i][j];
      
      // Each eye has a slightly different phase so they don't all blink together
      float phase = (i*cols + j) * 0.5;
      
      // open oscillates between 0 and 1 (appearing and disappearing)
      e.open = (sin(0.75*t + phase) * 0.5 + 0.5);  

      e.display();
    }
  }
}
