/*
*
* Creates an Eye that opens and closes, with random iris color and
* random tone of red in the sclera (white part of the eye). The eye follows
* the mouse.
* 
*/
class Eye{
  // Constructor parameters
  float xpos;
  float ypos;
  float rotation;
  float size;
  float h;
  float w;
  color sclera_clr;
  color iris_clr;
  float pupil_radius;
  // Eye opening parameters
  float open=1;
  float currentH;
  float timer = 0;
  int state = 0;  // 0 = closed, 1 = opening, 2 = opened, 3 = closing
  float t_closed, t_opening, t_opened, t_closing;
  // Easing parameters
  float x,y;
  float easing=0.1;
  
  
  /*
  *
  * Constructor function. Generates an Eye object given a set of parameters.
  * It also generates random values for the initial state (state) of the eye
  * (opened, closed, opening or closing). The variables defining how long the Eye
  * is opened or closed, and how long it takes for it to open and close are also 
  * randomized. Finally, the iris color is randomized.
  *
  * @param xpos Horizontal absolute position of the Eye.
  * @param ypos Vertical absolute position of the Eye.
  * @param size Size of the Eye.
  * @param rotation Rotation of the Eye.
  *
  */
  Eye(float xpos, float ypos, float size, float rotation){
    this.xpos = xpos;
    this.ypos = ypos;
    this.size = size;
    w = size;
    h = size/3;
    this.rotation = rotation;
    pupil_radius = size/10;
    state = int(random(0,3));
    // Ternari -> algo = (condicio) ? valor_si_true : valor_si_fals;
    open = (state > 1) ? 0.0f : 1.0f;
    t_opened = random(1, 3);
    t_closed = random(1, 3);
    t_opening = random (0.2, 0.5);
    t_closing = random(0.2, 0.5);
    
    changeColor();
  }
  
  
  /*
  *
  * Display callback, called every frame. First, the sclera and eyelids are drawn.
  * The outer shape of the eye is drawn as a mask, so that the eye can be animated to
  * open and close while the iris and pupil preserve their shape. The mouse tracking
  * is set, so that the eye looks in the direction of the mouse. First, the easing of
  * this particular eye is set. The further away the eye is from the mouse, the slower it
  * will react to mouse movement. The ammount of displacement is also determined by 
  * the distance of the eye and mouse (with easing applied), but it is constrained within the eye
  * and with distance limits tokeep it as realistic as possible. Once the position of the 
  * iris and pupil within the eye is defined, they are drawn and the mask is applied.
  *
  */
  void display(){
    pushMatrix();
    translate(xpos, ypos);
    //rotate(rotation);
    
    currentH = h * open;
        
    // SCLERA + EYELIDS -- CREATE PGRAPHICS MASK
    // Maybe move mask to the constructor? And just change the parameters as we go
    PGraphics mask = createGraphics(int(w), int(h*2));
    mask.beginDraw();
    mask.background(0);
    mask.fill(255);
    mask.noStroke();
    mask.beginShape();
    // Pgraphics has its own coordinate system (0,0) = top left!
    mask.vertex(0, h); 
    mask.bezierVertex(w/4, h - currentH, 3*w/4, h - currentH, w, h);   // top lid
    mask.bezierVertex(3*w/4, h + currentH, w/4, h + currentH, 0, h);   // bottom lid
    mask.endShape(CLOSE);
    mask.endDraw();
    

    // IRIS
    // Mouse Tracking - Normalized distance btween mouse and center of iris
    // Easing ammount proportional to euclidean distance
    float currentEasing = (sqrt(pow(mouseX - xpos, 2) + pow(mouseY - ypos, 2)))/sqrt((pow(width, 2) + pow(height, 2)));
    currentEasing = map(currentEasing, 0, 1, 1, 0);
    
    // Mapping to square curve.
    currentEasing = pow(currentEasing, 3);
    
    // Mouse tracking
    float targetX = mouseX;
    float dx = targetX - x;
    x += dx * currentEasing;
    
    float targetY = mouseY;
    float dy = targetY - y;
    y += dy * currentEasing;
    
    // Horizontal offset of the iris and pupil according to the distance between the mouse and the eye.
    // Normalized to half of the width & height (full value was not very realistic)
    float hor_offset = constrain((x - xpos)/(width/3), -1, 1) * 0.4 * w;
    float vert_offset = constrain((y - ypos)/(height/3), -1, 1) * 0.5 * h;
    
    // Draw IRIS and PUPIL
    PGraphics eyeImg = createGraphics(int(w), int(h*2));
    eyeImg.beginDraw();
    eyeImg.background(sclera_clr);
    eyeImg.fill(iris_clr);
    eyeImg.ellipse(w/2 + hor_offset, h + vert_offset, h*1.5, h*1.5);
    eyeImg.fill(0);
    eyeImg.ellipse(w/2+ hor_offset, h+ vert_offset, pupil_radius/2, pupil_radius*2);
    
    eyeImg.mask(mask);
    imageMode(CENTER);
    image(eyeImg, 0, 0);
    
    // CONTORN
    if(open==0){ noStroke(); }
    else { stroke(255); strokeWeight(2*open); }
    noFill();
    beginShape();
    vertex(-w/2, 0);
    bezierVertex(-w/4, -currentH, w/4, -currentH, w/2, 0);   // top lid
    bezierVertex(w/4, currentH, -w/4, currentH, -w/2, 0);   // bottom lid
    endShape(CLOSE);

    
    popMatrix();
  }
  
  
  /*
  *
  * Update function. Updates the blinking animation of the eye, 
  * which varies depending on the random times set. The state dictates
  * the actual state of the eye and the timer is used to count time
  * increments for the animations. Every time the eye goes from closed to open,
  * the color of the eye and sclera is changed.
  *
  * @param dt time increment.
  */
  void update(float dt) {
    timer += dt;
    
    switch(state) {
      case 0: // closed
        open = 0;
        if (timer > t_closed) { state = 1; timer = 0; changeColor(); }
        break;
      case 1: // opening
        open = map(timer, 0, t_opening, 0, 1);
        if (timer > t_opening) { state = 2; timer = 0; }
        break;
      case 2: // open
        open = 1;
        if (timer > t_opened) { state = 3; timer = 0; }
        break;
      case 3: // closing
        open = map(timer, 0, t_closing, 1, 0);
        if (timer > t_closing) { state = 0; timer = 0; }
        break;
    }
    //open = constrain(map(timer, 0, t_opening, 0, 1), 0, 1);
    open = open * open * (3 - 2 * open);
  }
  
  
  /*
  *
  * Changes the color of the iris randomly in HSB mode. Changes the color
  * of the sclera to a random tone of slight red.
  *
  */
  void changeColor() {
    colorMode(HSB, 360, 100, 100);
    sclera_clr = color(9, random(26), 100);
    iris_clr = color(random(360), 90, 100); 
  }
    
}
