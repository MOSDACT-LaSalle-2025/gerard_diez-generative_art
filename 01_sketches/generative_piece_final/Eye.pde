class Eye{
  float xpos;
  float ypos;
  float rotation;
  float size;
  float h;
  float w;
  color sclera_clr;
  color iris_clr;
  float pupil_radius;
  float open=1;
  float currentH;

  // Also consider coloring the strokes and eyelids
  
  // Constructor
  Eye(float xpos, float ypos, float size, float rotation, color sclera_clr, color iris_clr, float pupil_radius){
    this.xpos = xpos;
    this.ypos = ypos;
    this.size = size;
    w = size;
    h = size/3;
    this.rotation = rotation;
    this.sclera_clr = sclera_clr;
    this.iris_clr = iris_clr;
    this.pupil_radius = pupil_radius;
  }
  
  void display(){
    pushMatrix();
    translate(xpos, ypos);
    rotate(rotation);
    
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
    //Mouse Tracking - Normalized distance btween mouse and center of iris
    float hor_offset = (mouseX - xpos)/width * 0.5 * w;
    float vert_offset = (mouseY - ypos)/height * 0.6 * h;
    
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
    stroke(255);
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
  
    
}
