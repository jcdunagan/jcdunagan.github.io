class Line {
  /* Represents a line-segment between two points */
  Point p1, p2;
  
  public Line(Point p1, Point p2) {
    this.p1 = p1;
    this.p2 = p2;
  }
  
  void draw() {
    /* Draw line in current context */
    line(p1.x,p1.y,p2.x,p2.y);
  }
  
  void draw(PGraphics buffer) {
    /* Draw line into a provided buffer */
    buffer.line(p1.x,p1.y,p2.x,p2.y);
  }
  
  boolean intersects(Line l2) {
    /* Test intersection with other line */
    return (orient(p1,p2,l2.p1) * orient(p1, p2, l2.p2) < 0) && (orient(l2.p1,l2.p2,p1)* orient(l2.p1,l2.p2,p2) < 0);
  }
  
  float orient(Point a, Point b, Point c) {
    /* Returns 1 if p3 falls to right of ray from p1->p2, -1 if to the left, 0 if intersects */
    return (b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x);
  }
  
}