import java.util.*;

class ParallelCoordinates {
  /* Parallel coordinates chart object */
  int x, y, w, h;
  
  // Data objects
  int numPoints;
  int numAttributes;
  ArrayList<DataPoint> data;
  
  // Display objects
  ArrayList<Axis> axes;
  ArrayList<Polyline> polylines;
  
  //Interaction variables
  Axis selectedAxis;
  BoundingBox box = new BoundingBox();
  boolean linesSelected = false;
  
  // Internal flags
  boolean needsGeometry = true;
  boolean bounding = false;
  
  
  // Tooltip stuff
  ArrayList<DataPoint> hovered = new ArrayList<DataPoint>();
  int tooltipSize = 12;
  boolean tooltipEnabled;
  
  public ParallelCoordinates(int x, int y, int w, int h, Table table) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    this.setData(table);
  }
  
  void setData(Table table) {
    /* Set underlying data table */
    
    // Initialize empty container to hold data and display objects 
    numPoints = table.getRowCount() - 1;
    numAttributes = table.getColumnCount() - 1;
    
    data = new ArrayList<DataPoint>(numPoints);
    axes = new ArrayList<Axis>(numAttributes);
    
    polylines = new ArrayList<Polyline>(numPoints);

    // Iterating over rows of data table
    Iterator<TableRow> iter = table.rows().iterator();
    
    // Extract header row to initialize axes
    TableRow headerRow = iter.next();
    for (int i = 0; i < numAttributes; i++) {
      axes.add(new Axis(i, headerRow.getString(i+1)));
    }
    
    float[] mins = new float[numAttributes];
    Arrays.fill(mins, Float.POSITIVE_INFINITY);
    float[] maxs = new float[numAttributes];
    Arrays.fill(maxs, Float.NEGATIVE_INFINITY);
    
    // For each row...
    while (iter.hasNext()) {
      TableRow row = iter.next();
      
      String name = row.getString(0);
      
      float[] attributes = new float[numAttributes];
      for (int i = 0; i < numAttributes; i++) {
        float attr = row.getFloat(i+1);
        attributes[i] = attr;
        mins[i] = min(mins[i], attr);
        maxs[i] = max(maxs[i], attr);
      }
      
      DataPoint dp = new DataPoint(name, attributes);
      data.add(dp);
      polylines.add(new Polyline(dp, numAttributes));
    }
    
    int idx = 0;
    for (Axis axis : axes) {
      axis.setDomain(mins[idx], maxs[idx]);
      idx++;
    }
    
    selectAxis(axes.get(0));
  }
  
  void setTooltipEnabled(boolean tooltipEnabled) {
    /* Enable or disable tooltip */
    this.tooltipEnabled = tooltipEnabled;
    needsGeometry = true;
  }
  
  void setSize(int w, int h) {
    if (this.w != w || this.h != h) {
      this.w = w;
      this.h = h;
      needsGeometry = true; //Indicate geoemtry needs updated
    }
  }
  
  void draw() {
    /* Master draw routine for the whole chart */
    if (needsGeometry) {
      recalculateGeometry();
    }
    
    pushMatrix();
    translate(x,y);
    
    for (Polyline pl : polylines) {
      pl.draw(linesSelected);
    }
    
    for (Axis axis : axes) {
      axis.draw();
    }
    
    
    if (bounding) {
      box.draw();
    }
    
    popMatrix();
    
    if (tooltipEnabled) {
      drawTooltip();
    }
  }
  
  void selectAxis(Axis axis) {
    /* Handles user selection of an axis */
    if (selectedAxis != null) {
      selectedAxis.selected = false;
    }
    
    axis.selected = true;
    selectedAxis = axis;
    
    for (Polyline pl : polylines) {
      pl.colorize(axis);
    }
  }
  
  void recalculateGeometry() {
    /* Recalculate display objects, update pickbuffers */
    int numColumns = numAttributes - 1;
    float columnWidth = float(w) / float(numColumns);
    
    
    float aX = 0.0;
    float aY1 = 0;
    float aY2 = h;
    
    for (Axis axis : axes) {
      axis.setPosition(aX, aY1, aY2);
      aX += columnWidth;
    }
    
    for (Polyline pl: polylines) {
      pl.update(axes, tooltipEnabled, w, h);
    }
    
    needsGeometry = false;
  }
  
  void handleHover(int mx, int my) {
    int x_prime = mx - x;
    int y_prime = my - y;
    
    for (Axis axis : axes) {
      if (axis.handleHover(x_prime, y_prime)) {
        return;
      }
    }
    
    if (tooltipEnabled) {
      hovered.clear();
      for (Polyline pl: polylines) {
        if (pl.handleHover(x_prime, y_prime)) {
          if (!linesSelected || pl.selected) {
            hovered.add(pl.data);
          }
        }
      }
    }
    
  }
  
  void handleMouseDown(float mx, float my) {
    float x_prime = mx - x;
    float y_prime = my - y;
    
    for (Axis axis : axes) {
      switch (axis.handleMouseDown(x_prime, y_prime, this)) {
        case SELECT:
          selectAxis(axis);
          return;
        case INVERT:
          needsGeometry = true;
          return;
        default:
          break;
      }
    }
    
    box.setStart(x_prime, y_prime);
    bounding = true;
    linesSelected = false;

  }
  
  void handleDrag(float mx, float my) {
    if (bounding) {
      float x_prime = mx - x;
      float y_prime = my - y;
      
      box.setEnd(x_prime, y_prime);
      
      linesSelected = false;
      for (Polyline pl : polylines) {
        if (box.intersects(pl)) {
          pl.selected = true;
          linesSelected = true;
        } else {
          pl.selected = false;
        }
      }
    }
  }
  
  void handleMouseUp(float mx, float my) {
    bounding = false;
  }
  
  
  void drawTooltip() {
    /* Subroutine for drawing the tooltip */
    pushStyle();

    textSize(tooltipSize);
    textAlign(LEFT, TOP);
    
    int ttH = tooltipSize+2;
    int ttX = mouseX;
    int ttY = mouseY-ttH;
    
    for (DataPoint point : hovered) {
      float ttWidth = textWidth(point.label)+4;
      fill(255);
      rect(ttX, ttY, ttWidth, ttH);
      fill(0);
      text(point.label, ttX+2, ttY);
      ttY -= ttH;
    }
    
    popStyle();
  }
  
}