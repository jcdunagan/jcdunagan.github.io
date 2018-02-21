class DataPoint {
  /* Stores a data point from a dataset */
  String name; // Nominal attribute
  float[] attributes; // Quantitative attributes
  
  String label; // Display label
  
  public DataPoint(String name, float[] attributes) {
    // Set members
    this.name = name;
    this.attributes = attributes;
    
    // Compute display label
    StringBuilder labelBuilder = new StringBuilder("(");
    labelBuilder.append(name);
    for (float attr : attributes) {
      labelBuilder.append(", ");
      labelBuilder.append(Float.toString(attr));
    }
    labelBuilder.append(")");
    label = labelBuilder.toString();
  }
  
}