class BoundingBox {
  /* Bounding box container class */
  Point lt, rt, lb, rb;
  Line left, right, top, bottom;

  color boxFill = color(0,50);
  color boxStroke = color(255);

  public BoundingBox() {
    lt = new Point();
    rt = new Point();
    lb = new Point();
    rb = new Point();
    left = new Line(lt, lb);
    right = new Line(rt, rb);
    top = new Line(lt, rt);
    bottom = new Line(lb, rb);
  }

  void setStart(float x, float y) {
    lt.x = rt.x = lb.x = rb.x = x;
    lt.y = rt.y = lb.y = rb.y = y;
  }

  void setEnd(float x, float y) {
    rt.x = rb.x = x;
    lb.y = rb.y = y;
  }

  void draw() {
    pushStyle();
    rectMode(CORNERS);

    fill(boxFill);
    stroke(boxStroke);
    rect(lt.x, lt.y, rb.x, rb.y);

    popStyle();
  }


  boolean intersects(Line l) {
    /* Test if bounding box intersects a line */
    return l.intersects(left) || l.intersects(right) || l.intersects(top) || l.intersects(bottom);
  }

  boolean intersectsPoly(Polyline pl) {
    /* Test if bounding box intersects a data polyline */
    Line[] lines = pl.lines;

    for (int i = 0; i < lines.length; i++) {
      if (intersects(lines[i])) {
        return true;
      }
    }
    return false;
  }



}
