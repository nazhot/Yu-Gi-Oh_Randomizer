class Slider extends Interactable {
  String TYPE = "Slider";
  String name;
  String title;
  float min;
  float max;
  float x;
  float y;
  float w;
  float r;
  float slidePosition;
  color textColor;
  color lineColor;
  color tickColor;
  color slideFillColor;
  color slideStrokeColor;
  float lineWeight;
  float tickWeight;
  float slideStrokeWeight;
  boolean slideMoving;
  float slideValue;
  String titlePosition; //"TOP", "LEFT", "RIGHT", "BOTTOM"
  boolean isDefinedJumps;
  float jumpAmount;
  int numJumps;


  Slider(float x_, float y_, float w_, float r_) {
    this.name = "";
    this.title = "";
    this.min = 0;
    this.max = 1;
    this.x = x_;
    this.y = y_;
    this.w = w_;
    this.r = r_;
    this.slidePosition = x_;
    this.textColor = #bc5a84;
    this.lineColor = #bc5a84;
    this.tickColor = #bc5a84;
    this.slideFillColor = #bc5a84;
    this.slideStrokeColor = #323299;
    this.lineWeight = 4;
    this.tickWeight = 2;
    this.slideStrokeWeight = 3;
    this.slideMoving = false;
    this.slideValue = 0;
    this.titlePosition = "LEFT";
    this.isDefinedJumps = false;
    this.jumpAmount = 0;
    this.numJumps = 0;
  }

  void display() {
    if (!mousePressed) {
      this.slideMoving = false;
    }
    //if (this.mouseOver(false) && mousePressed) {
    //  this.slideMoving = true;
    //}
    ellipseMode(RADIUS);
    stroke(this.lineColor);
    strokeWeight(this.lineWeight);
    line(this.x, this.y, this.x + this.w, this.y);
    stroke(this.slideStrokeColor);
    strokeWeight(this.slideStrokeWeight);
    fill(this.slideFillColor);
    ellipse(this.slidePosition, this.y, this.r, this.r);
    if (this.slideMoving) {
      this.slidePosition = constrain(mouseX, this.x, this.x + this.w);
    }
    this.slideValue = map(this.slidePosition, this.x, this.x + this.w, this.min, this.max);
    fill(this.textColor);
    textAlign(CENTER, BOTTOM);
    text(nf(this.slideValue, 0, 2), this.x + this.w / 2.0, this.y - this.r);
    switch(this.titlePosition) {
    case "LEFT":
      textAlign(RIGHT, CENTER);
      text(this.title, this.x - this.r, this.y - textAscent() * gTextScalar);
      break;
    case "RIGHT":
      textAlign(LEFT, CENTER);
      text(this.title, this.x + this.w + this.r, this.y - textAscent() * gTextScalar);
      break;
    case "TOP":
      textAlign(CENTER, BOTTOM);
      text(this.title, this.x + this.w / 2.0, this.y - this.r - textAscent() - textDescent());
      break;
    case "BOTTOM":
      textAlign(CENTER, TOP);
      text(this.title, this.x + this.w / 2.0, this.y + this.r);
      break;
    default:
      textAlign(RIGHT, CENTER);
      text(this.title, this.x - this.r, this.y);
      break;
    }
  }

  boolean mouseOver(boolean calledByScreen) {
    boolean mouseOver = (dist(mouseX, mouseY, this.slidePosition, this.y) <= this.r);
    if (calledByScreen) {
      if (mouseOver) {
        this.slideMoving = true;
      }
    }
    return (dist(mouseX, mouseY, this.slidePosition, this.y) <= this.r);
  }

  Slider setName(String n_) {
    this.name = n_;
    return this;
  }

  Slider setTitle(String t_) {
    this.title = t_;
    return this;
  }

  Slider setMin(float m_) {
    this.min = m_;
    return this;
  }

  Slider setMax(float m_) {
    this.max = m_;
    return this;
  }

  Slider setTitlePosition(String t_) {
    this.titlePosition = t_;
    return this;
  }

  Slider setLineColor(color l_) {
    this.lineColor = l_;
    return this;
  }

  Slider setDrawOrder(int d_) {
    this.drawOrder = d_;
    return this;
  }

  String getName() {
    return this.name;
  }
  int getDrawOrder() {
    return this.drawOrder;
  }

  String getValue() {
    return str(this.slideValue);
  }

  String getType() {
    return this.TYPE;
  }
}
