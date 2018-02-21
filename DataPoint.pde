class DataPoint {
  /* Stores a data point from a dataset */
  String name; // Nominal attribute
  float[] attributes; // Quantitative attributes

  public DataPoint(String name, float[] attributes) {
    // Set members
    this.name = name;
    this.attributes = attributes;
  }

}
