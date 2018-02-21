class ParallelCoordinates {
  /* Parallel coordinates chart object */
  int x, y, w, h;

  // Data objects
  int numPoints;
  int numAttributes;
  DataPoint[] data;

  // Display objects
  Axis[] axes;
  Polyline[] polylines;

  //Interaction variables
  Axis selectedAxis;
  BoundingBox box = new BoundingBox();
  boolean linesSelected = false;

  // Internal flags
  boolean needsGeometry = true;
  boolean bounding = false;


  // Tooltip stuff
  DataPoint[] hovered;
  int numHovered = 0;
  int tooltipSize = 12;
  boolean tooltipEnabled;

  public ParallelCoordinates(int x, int y, int w, int h, String[] data) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    this.setData(data);
  }

  void setData(String[] lines) {
    /* Set underlying data table */

    String[] header = lines[0].split(",");

    // Initialize empty container to hold data and display objects
    numPoints = lines.length - 1;
    numAttributes = header.length - 1;

    data = new DataPoint[numPoints];
    axes = new Axis[numAttributes];
    hovered = new DataPoint[numPoints];

    polylines = new Polyline[numPoints];

    for (int i = 0; i < numAttributes; i++) {
      axes[i] = new Axis(i, header[i+1]);
    }

    float[] mins = new float[numAttributes];
    for (int i = 0; i < numAttributes; i++) {
      mins[i] = float("Infinity");
    }
    float[] maxs = new float[numAttributes];
    for (int i = 0; i < numAttributes; i++) {
      maxs[i] = float("-Infinity");
    }

    // For each row...
    for (int i = 1; i < lines.length; i++) {
      String[] row = lines[i].split(",");

      String name = row[0];

      float[] attributes = new float[numAttributes];
      for (int j = 0; j < numAttributes; j++) {
        float attr = float(row[j+1]);
        attributes[j] = attr;
        mins[j] = min(mins[j], attr);
        maxs[j] = max(maxs[j], attr);
      }

      DataPoint dp = new DataPoint(name, attributes);
      data[i-1] = dp;
      polylines[i-1] = new Polyline(dp, numAttributes);
    }

    int idx = 0;
    for (Axis axis : axes) {
      axis.setDomain(mins[idx], maxs[idx]);
      idx++;
    }

    selectAxis(axes[0]);
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
      int j = 0;
      for (int i = 0; i < numPoints; i++) {
        Polyline pl = polylines[i];
        if (pl.handleHover(x_prime, y_prime)) {
          if (!linesSelected || pl.selected) {
            hovered[j] = pl.data;
            j++;
          }
        }
      }

      numHovered = j;
    }

  }

  void handleMouseDown(float mx, float my) {
    float x_prime = mx - x;
    float y_prime = my - y;

    for (Axis axis : axes) {
      switch (axis.handleMouseDown(x_prime, y_prime, this)) {
        case 1:
          selectAxis(axis);
          return;
        case 2:
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

      for (int i = 0; i < numPoints; i++) {
        Polyline pl = polylines[i];

        if (box.intersectsPoly(pl)) {
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

    for (int i = 0; i < numHovered; i++) {
      DataPoint point = hovered[i];
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
