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
    this.label = "(" + name;
    for (int i = 0; i < attributes.length; i++) {
      this.label = label + ", " + str(attributes[i]);
    }
    this.label = label + ")";
  }

}
