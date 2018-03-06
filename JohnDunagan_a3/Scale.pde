class Scale {
  /* Linear map from a domain to a range (idea taken from .d3)*/
  float dMin, dMax;
  float rMin, rMax;
  
  float dSize;
  float scaleFactor;
  
  public Scale(float dMin, float dMax, float rMin, float rMax) {
    this.dMin = dMin;
    this.dMax = dMax;
    this.rMin = rMin;
    this.rMax = rMax;
    
    calculate();
  }
  
  void setDomain(float dMin, float dMax) {
    this.dMin = dMin;
    this.dMax = dMax;
    calculate();
  }
  
  void setRange(float rMin, float rMax) {
    this.rMin = rMin;
    this.rMax = rMax;
    calculate();
  }
  
  float scale(float x) {
    /* Map domain value onto range (used for calculating y-coordinates)*/
    return ((x - dMin) * scaleFactor) + rMin; 
  }
  
  float normalize(float x) {
    /* Normalize domain value between 0 and 1 (used for colorization) */
    return (x-dMin) / dSize;
  }
  
  private void calculate() {
    /* Precompute scale factors */
    dSize = (dMax-dMin);
    scaleFactor = (rMax - rMin) / dSize;
  }
  
}