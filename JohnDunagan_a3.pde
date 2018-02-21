// Data input
String DATA_FILE_PATH = "cereal.csv";
boolean ENABLE_TOOLTIP = true; // Disable for better performance but less information

// Chart margins
int TOP_MARGIN = 100;
int BOTTOM_MARGIN = 100;
int LEFT_MARGIN = 100;
int RIGHT_MARGIN = 100;

// Parallel coordinates chart object
ParallelCoordinates pc;

void setup() {
  size(1200,600);
  surface.setResizable(true);
  
  // Load data into table
  Table table = loadTable(DATA_FILE_PATH,"csv");
  
  // Initialize parallel coordinates objects
  pc = new ParallelCoordinates(
    LEFT_MARGIN,
    TOP_MARGIN,
    width - LEFT_MARGIN - RIGHT_MARGIN,
    height - BOTTOM_MARGIN - TOP_MARGIN,
    table);
    
  // Enable or disable tooltip
  pc.setTooltipEnabled(ENABLE_TOOLTIP);
}

void draw() {
  background(255);
  
  // Update chart size
  pc.setSize(
    width - LEFT_MARGIN - RIGHT_MARGIN,
    height - BOTTOM_MARGIN - TOP_MARGIN);
  
  // Draw chart
  pc.draw();
}


// Mouse handlers
void mouseMoved() {
  pc.handleHover(mouseX, mouseY);
}

void mouseDragged() {
  pc.handleDrag(mouseX, mouseY);
}

void mousePressed() {
  pc.handleMouseDown(mouseX, mouseY);
}

void mouseReleased() {
  pc.handleMouseUp(mouseX, mouseY);
}