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
  // Opening parameters
  float open=1;
  float currentH;
  float timer = 0;
  int state = 0;  // 0 = closed, 1 = opening, 2 = opened, 3 = closing
  float t_closed, t_opening, t_opened, t_closing;
  // Easing parameters
  float x,y;
  float easing=0.1;

  // Also consider coloring the strokes and eyelids
  
  // Constructor
  Eye(float xpos, float ypos, float size, float rotation, float pupil_radius){
    this.xpos = xpos;
    this.ypos = ypos;
    this.size = size;
    w = size;
    h = size/3;
    this.rotation = rotation;
    this.pupil_radius = pupil_radius;
    state = int(random(0,3));
    // Ternari -> algo = (condicio) ? valor_si_true : valor_si_fals;
    open = (state > 1) ? 0.0f : 1.0f;
    t_opened = random(1, 3);
    t_closed = random(1, 3);
    t_opening = random (0.2, 0.5);
    t_closing = random(0.2, 0.5);
    
    changeColor();
  }
  
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
    currentEasing = pow(currentEasing, 2);
    // Mapping to S-curve (smoothstep)
    //currentEasing = constrain(currentEasing, 0, 1);
    //currentEasing = currentEasing * currentEasing * (3 - 2 * currentEasing);
    float targetX = mouseX;
    float dx = targetX - x;
    x += dx * currentEasing;
    
    float targetY = mouseY;
    float dy = targetY - y;
    y += dy * currentEasing;
    // Horizontal offset of the iris and pupil according to the distance between the mouse and the eye.
    // Normalized to half of the width & height (full value was not very realistic)
    float hor_offset = constrain((x - xpos)/(width/2), -1, 1) * 0.4 * w;
    float vert_offset = constrain((y - ypos)/(height/2), -1, 1) * 0.5 * h;
    
    PGraphics eyeImg = createGraphics(int(w), int(h*2));
    eyeImg.beginDraw();
    eyeImg.background(sclera_clr);
    eyeImg.fill(iris_clr);
    eyeImg.ellipse(w/2 + hor_offset, h + vert_offset, h*1.5, h*1.5);
    eyeImg.fill(0);
    eyeImg.ellipse(w/2+ hor_offset, h+ vert_offset, pupil_radius/2, pupil_radius*2);
    //Debug
    //eyeImg.stroke(0);
    //eyeImg.strokeWeight(5);
    //eyeImg.point(0,h);
    //eyeImg.endDraw();
    
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

    // PUPIL
    //fill(0);
    //ellipse(0, 0, pupil_radius/2, pupil_radius*2);
    
    popMatrix();
  }
  
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
  
  void changeColor() {
    colorMode(HSB, 360, 100, 100);
    sclera_clr = color(9, random(26), 100);
    iris_clr = color(random(360), 90, 100); // vivid, glowing eye colors
  }
    
}
