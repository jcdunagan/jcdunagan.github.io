class Axis {
  /* Represents a single dimension on a parellel coordinates chart */
  
  // Axis properties
  float x, y1, y2;
  int index;
  
  // Attribute/dimension properties
  String name;
  float dMin = -1;
  float dMax = 1;
  
  String maxLabel = "1";
  String minLabel = "-1";
  
  Scale yScale; // Maps attribute values to y-coordinates

  // User interaction flags
  boolean selected = false;
  boolean inverted = false;
  
  // User interaction objects
  Button label;
  Button flip;
  
  // Display constants
  static final color COLD_COLOR = #4681b2;
  static final color HOT_COLOR = #a02f32;
  
  static final color TEXT_COLOR = #000000;
  static final float TEXT_PAD = 3;
  static final int TEXT_SIZE = 11;
  
  static final float TICK_RADIUS = 5;
  
  static final float LABEL_PAD = 40;
  static final int LABEL_SIZE = 14;
  
  static final float FLIP_PAD = 30;
  
  public Axis(int index, String name) {
    this.index = index;
    this.name = name;
    yScale = new Scale(dMin, dMax, 0.0, 1.0);
    label = new Button(name, LABEL_SIZE, 0.0, 0.0);
    flip = new Button("Invert", TEXT_SIZE, 0.0, 0.0);
  }
  
  void setDomain(float v1, float v2) {
    /* Set min and max value for axis */
    dMin = min(v1, v2);
    dMax = (v1 - v2 != 0) ? max(v1, v2) : dMin + 1; // Divide-by-zero precaution
    yScale.setDomain(dMin, dMax);
    
    // Compute labels
    minLabel = Float.toString(dMin);
    maxLabel = Float.toString(dMax);
  }
  
  void setPosition(float x, float y1, float y2) {
    /* Set axis position */
    this.x = x;
    this.y1 = y1;
    this.y2 = y2;
    
    if (inverted) {
      yScale.setRange(y1, y2);
    } else {
      yScale.setRange(y2, y1);
    }
    
    label.setCenter(x, y1-LABEL_PAD);
    flip.setCenter(x, y2+FLIP_PAD);
  }
  
  void invert() {
    inverted = !inverted;
    
    if (inverted) {
      yScale.setRange(y1, y2);
    } else {
      yScale.setRange(y2, y1);
    }
  }
  
  float yFor(float attr) {
    return yScale.scale(attr);
  }
  
  color colorFor(DataPoint point) {
    float attr = point.attributes[index];
    return lerpColor(COLD_COLOR, HOT_COLOR, yScale.normalize(attr));
  }
  
  void draw() {
    pushStyle();
    stroke(0);
    line(x, y1, x, y2);
    line(x-TICK_RADIUS, y1, x+TICK_RADIUS, y1);
    line(x-TICK_RADIUS, y2, x+TICK_RADIUS, y2);
    
    fill(TEXT_COLOR);
    stroke(TEXT_COLOR);
    textSize(TEXT_SIZE);
    if (inverted) {
      textAlign(CENTER, BOTTOM);
      text(minLabel, x, y1 - TEXT_PAD);
      textAlign(CENTER, TOP);
      text(maxLabel, x, y2 + TEXT_PAD);
    } else {
      textAlign(CENTER, BOTTOM);
      text(maxLabel, x, y1-  TEXT_PAD);
      textAlign(CENTER, TOP);
      text(minLabel, x, y2 + TEXT_PAD);
    }
    flip.draw();
    label.draw();
    popStyle();
  }
  
  boolean handleHover(float mx, float my) {
    if (label.handleHover(mx, my)) {
      return true;
    } else if (flip.handleHover(mx, my)) {
      return true;
    }
    return false;
  }
  
  AxisMouseDownResponse handleMouseDown(float mx, float my, ParallelCoordinates pc) {
    if (label.contains(mx, my) && pc != null) {
      pc.selectAxis(this);
      return AxisMouseDownResponse.SELECT;
    }
    
    if (flip.contains(mx,my)) {
      invert();
      return AxisMouseDownResponse.INVERT;
    }
    
    return AxisMouseDownResponse.MISS;
  }
  
}


enum AxisMouseDownResponse {
  MISS, SELECT, INVERT;
}