class Slider extends Component<Slider> {
  float min;
  float max;
  float slidePosition;
  color lineColor;
  color tickColor;
  color slideFillColor;
  color slideStrokeColor;
  float lineWeight;
  float tickWeight;
  float slideStrokeWeight;
  boolean slideMoving;
  String titlePosition; //"TOP", "LEFT", "RIGHT", "BOTTOM"
  boolean isDefinedJumps;
  float jumpAmount;
  int numJumps;


  Slider(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    this.TYPE = "Slider";
    this.min = 0;
    this.max = 1;
    this.slidePosition = x_;
    this.lineColor = #bc5a84;
    this.tickColor = #bc5a84;
    this.slideFillColor = #bc5a84;
    this.slideStrokeColor = #323299;
    this.lineWeight = 4;
    this.tickWeight = 2;
    this.slideStrokeWeight = 3;
    this.slideMoving = false;
    this.titlePosition = "LEFT";
    this.isDefinedJumps = false;
    this.jumpAmount = 0;
    this.numJumps = 0;
  }

  void display() {
    if (!mousePressed) {
      this.slideMoving = false;
    }
    ellipseMode(RADIUS);
    stroke(this.lineColor);
    strokeWeight(this.lineWeight);
    line(this.x, this.y, this.x + this.w, this.y);
    stroke(this.slideStrokeColor);
    strokeWeight(this.slideStrokeWeight);
    fill(this.slideFillColor);
    ellipse(this.slidePosition, this.y, this.h, this.h);
    if (this.slideMoving) {
      this.slidePosition = constrain(mouseX, this.x, this.x + this.w);
    }
    this.value = str(map(this.slidePosition, this.x, this.x + this.w, this.min, this.max));
    fill(this.textColor);
    textSize(this.textSize);
    textAlign(CENTER, BOTTOM);
    text(nf(float(this.value), 0, 2), this.x + this.w / 2.0, this.y - this.h);
    switch(this.titlePosition) {
    case "LEFT":
      textAlign(RIGHT, CENTER);
      text(this.label, this.x - this.h, this.y - textAscent() * gTextScalar);
      break;
    case "RIGHT":
      textAlign(LEFT, CENTER);
      text(this.label, this.x + this.w + this.h, this.y - textAscent() * gTextScalar);
      break;
    case "TOP":
      textAlign(CENTER, BOTTOM);
      text(this.label, this.x + this.w / 2.0, this.y - this.h - textAscent() - textDescent());
      break;
    case "BOTTOM":
      textAlign(CENTER, TOP);
      text(this.label, this.x + this.w / 2.0, this.y + this.h);
      break;
    default:
      textAlign(RIGHT, CENTER);
      text(this.label, this.x - this.h, this.y);
      break;
    }
  }

  boolean mouseOver(boolean calledByScreen) {
    boolean mouseOver = (dist(mouseX, mouseY, this.slidePosition, this.y) <= this.h);
    if (calledByScreen) {
      if (mouseOver) {
        this.slideMoving = true;
      }
    }
    return (dist(mouseX, mouseY, this.slidePosition, this.y) <= this.h);
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
  
  Slider setTextColor(color t_){
    this.textColor = t_;
    return this;
  }

  Slider setMultipliers(float colMultiplier, float rowMultiplier) {
    this.x *= colMultiplier;
    this.w *= colMultiplier;
    this.y *= rowMultiplier;
    this.h *= rowMultiplier;
    this.slidePosition *= colMultiplier;
    this.textSize *= colMultiplier;
    return this;
  }
  
  void reset(){
    this.slidePosition = this.x;
  }
  
}
