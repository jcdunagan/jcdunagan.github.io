import java.util.*;

class Polyline {
  /* A chain of line segments that encodes a data point using provided axes */
  DataPoint data;

  ArrayList<Point> points;
  ArrayList<Line> lines;
  
  PGraphics pickbuffer;
  int pbWidth, pbHeight;
  
  color selectedColor = color(0,0,0);
  color unselectedColor = color(0,0,0,20);
  
  boolean selected = true;
  boolean hovered = false;
  
  static final int HOVERED_WEIGHT = 2;
  static final int REGULAR_WEIGHT = 1;
  
  public Polyline(DataPoint data, int numAttributes) {
    this.data = data;
    
    lines = new ArrayList<Line>(numAttributes - 1);
    points = new ArrayList<Point>(numAttributes);
    
    Point last = new Point();
    points.add(last);
    
    for (int i = 1; i < numAttributes; i++) {
      Point next = new Point();

      points.add(next);
      lines.add(new Line(last, next));
      
      last = next;
    }
    
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
  
  void update(Collection<Axis> axes, boolean pickbufferEnabled, int pbWidth, int pbHeight) {
    Iterator<Point> ptIter = points.iterator();
    Iterator<Axis> axIter = axes.iterator();
    for (float attr : data.attributes) {
      Point point = ptIter.next();
      Axis axis = axIter.next();
      point.x = axis.x;
      point.y = axis.yFor(attr);
    }
    
    if (pickbufferEnabled) {
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
  }
  
  void colorize(Axis axis) {
    selectedColor = axis.colorFor(data);
  }  
  
  boolean handleHover(int mx, int my) {
    hovered = pickbuffer.get(mx, my) == -1;
    return hovered;
  }
  
}