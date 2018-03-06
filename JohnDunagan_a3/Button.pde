class Button {
  /* A rectangular button */
  
  // Button display parameters
  float x, y; // Position
  float w, h; // Dimensions
  float cx, cy;
  
  boolean hovered = false;
  
  color regularFill =  color(255,255,255,0);
  color regularStroke = color(255,255,255,0);
  
  color hoveredFill = color(200);
  color hoveredStroke = color(0);
  
  color labelFill = color(0);
  
  String label;
  int labelSize;
  
  int padding = 3;
  
  Button(String label, int labelSize, float cx, float cy) {
    /* Initialize button with given position and dimensions */
    
    setLabel(label, labelSize);
    
    pushStyle();
    textSize(labelSize);
    this.w = textWidth(label) + 2*padding;
    this.h = labelSize + 2*padding;
    popStyle();
    
    setCenter(cx, cy);
  }
  
  void setLabel(String label, int labelSize) {
    this.label = label;
    this.labelSize = labelSize;
  }
  
  void setCenter(float cx, float cy) {
    /* Set button's position */
    this.cx = cx;
    this.cy = cy;
    
    this.x = cx - (w / 2);
    this.y = cy - (h / 2);
  }
  
  void setSize(float w, float h) {
    this.w = w;
    this.h = h;
    setCenter(cx, cy);
  }
  
  void draw() {
    /* Draw button */
    pushStyle();
    
    if (hovered) {
      fill(hoveredFill);
      stroke(hoveredStroke);
    } else {
      fill(regularFill);
      stroke(regularStroke);
    }
    rect(x,y,w,h);
    popStyle();
    
    pushStyle();
    fill(labelFill);
    textAlign(CENTER, CENTER);
    textSize(labelSize);
    text(label, cx, cy);
    popStyle();
  }
  
  boolean contains(float mx, float my) {
    /* Point test to see if mx and my are in button */
    return (mx >= x) && (my >= y) && (mx <= x+w) && (my <= y+h);
  }
  
  boolean handleHover(float mx, float my) {
    /* Point test to see if mx and my are in button */
    hovered = contains(mx,my);
    return hovered;
  }
  
}