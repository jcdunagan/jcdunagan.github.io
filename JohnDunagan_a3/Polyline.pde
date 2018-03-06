class Polyline {
  /* A chain of line segments that encodes a data point using provided axes */
  DataPoint data;

  Point[] points;
  Line[] lines;

  PGraphics pickbuffer;
  int pbWidth = 0;
  int pbHeight = 0;

  color selectedColor = color(0,0,0);
  color unselectedColor = color(0,0,0,20);

  boolean selected = true;
  boolean hovered = false;

  static final int HOVERED_WEIGHT = 2;
  static final int REGULAR_WEIGHT = 1;

  public Polyline(DataPoint data, int numAttributes) {
    this.data = data;

    lines = new Line[numAttributes - 1];
    points = new Point[numAttributes];

    Point last = new Point();
    points[0] = last;

    for (int i = 1; i < numAttributes; i++) {
      Point next = new Point();

      points[i] = next;
      lines[i-1] = new Line(last, next);

      last = next;
    }

    pickbuffer = createGraphics(100, 100);
  }

  void draw(boolean selectionMode) {
    pushStyle();

    strokeWeight(REGULAR_WEIGHT);

    if (selectionMode && !selected) {
      stroke(unselectedColor);
    } else {
      if (hovered) {
        stroke(0);
        strokeWeight(HOVERED_WEIGHT+1);
        for (Line line : lines){
          line.draw();
        }

        strokeWeight(HOVERED_WEIGHT);
      }

      stroke(selectedColor);
    }

    for (Line line : lines){
      line.draw();
    }

    popStyle();
  }

  void update(Axis[] axes, boolean tooltipEnabled, int pbWidth, int pbHeight) {

    for (int i = 0; i < data.attributes.length; i ++ ) {
      float attr = data.attributes[i];
      Point point = points[i];
      Axis axis = axes[i];
      point.x = axis.x;
      point.y = axis.yFor(attr);
    }

    if (pbWidth != this.pbWidth || pbHeight != this.pbHeight) {
      this.pbWidth = max(pbWidth,1);
      this.pbHeight = max(pbHeight,1);
      pickbuffer = createGraphics(this.pbWidth, this.pbHeight);
    }

    pickbuffer.beginDraw();
    pickbuffer.background(0);
    for (Line line : lines) {
      pickbuffer.stroke(255);
      pickbuffer.strokeWeight(3);
      line.draw(pickbuffer);
    }
    pickbuffer.endDraw();

  }

  void colorize(Axis axis) {
    selectedColor = axis.colorFor(data);
  }

  boolean handleHover(int mx, int my) {
    hovered = red(pickbuffer.get(mx, my)) > 0;

    return hovered;
  }

}
