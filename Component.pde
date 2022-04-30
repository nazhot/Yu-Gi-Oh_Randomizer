class Component <T extends Component<T>> {
  String TYPE;
  float  x;
  float  y;
  float  w;
  float  h;
  String name;
  String label;
  String value;
  int    drawOrder;
  color  fillColor;
  float  fillAlphaValue;
  color  strokeColor;
  float  strokeAlphaValue;
  color  textColor;
  float  textAlphaValue;
  int    strokeWeight;
  float  rounding;
  float  textSize;


  Component(float x_, float y_, float w_, float h_) {
    this.x = x_;
    this.y = y_;
    this.w = w_;
    this.h = h_;
    this.name = "";
    this.label = "";
    this.value = "";
    this.drawOrder = 0;
    this.fillColor = #fde68a;
    this.fillAlphaValue = 255;
    this.strokeColor = color(0);
    this.strokeAlphaValue = 255;
    this.textColor = color(0);
    this.textAlphaValue = 255;
    this.strokeWeight = 1;
    this.rounding = 0;
    this.textSize = 12;
  }

  void display() {
  }

  boolean mouseOver(boolean calledByScreen) {
    return false;
  }

  boolean clicked() {
    return false;
  }
  String getType() {
    return this.TYPE;
  }
  float getX() {
    return this.x;
  }
  float getY() {
    return this.y;
  }
  float getW() {
    return this.w;
  }
  float getH() {
    return this.h;
  }
  String getName() {
    return this.name;
  }
  String getLabel() {
    return this.label;
  }
  String getValue() {
    return this.value;
  }
  int getDrawOrder() {
    return this.drawOrder;
  }



  void reset() {
  }

  T setMultipliers(float colMultiplier, float rowMultiplier) {
    this.x *= colMultiplier;
    this.w *= colMultiplier;
    this.y *= rowMultiplier;
    this.h *= rowMultiplier;
    this.textSize *= colMultiplier;
    return (T) this;
  }

  T setX(float x_) {
    this.x = x_;
    return (T) this;
  }

  T setY(float y_) {
    this.y = y_;
    return (T) this;
  }

  T setW(float w_) {
    this.w = w_;
    return (T) this;
  }

  T setH(float h_) {
    this.h = h_;
    return (T) this;
  }

  T setFillColor(color f_) {
    this.fillColor = f_;
    return (T) this;
  }

  T setTextColor(color t_) {
    this.textColor = t_;
    return (T) this;
  }

  T setStrokeColor(color s_) {
    this.strokeColor = s_;
    return (T) this;
  }

  T setStrokeWeight(int s_) {
    this.strokeWeight = s_;
    return (T) this;
  }

  T setName(String n_) {
    this.name = n_;
    return (T) this;
  }

  T setLabel(String l_) {
    this.label = l_;
    return (T) this;
  }
  
  T setValue(String v_){
    this.value = v_;
    return (T) this;
  }

  T setDrawOrder(int d_) {
    this.drawOrder = d_;
    return (T) this;
  }

  T setRounding(float r_) {
    this.rounding = r_;
    return (T) this;
  }

  T setTextSize(float t_) {
    this.textSize = t_;
    return (T) this;
  }
}
