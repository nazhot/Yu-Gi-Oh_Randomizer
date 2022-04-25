class Button extends Interactable {
  String TYPE = "Button";
  float x;
  float y;
  float w;
  float h;
  float rounding;
  String name;
  String label;
  int drawOrder;
  String shape; //circle, rectangle
  int shapeMode;
  color fillColor;
  color hoverColor;
  color strokeColor;
  color textColor;
  int strokeWeight;
  float textSize;
  boolean asLabel;

  Button(float x_, float y_, float w_, float h_) {
    this.x = x_;
    this.y = y_;
    this.w = w_;
    this.h = h_;
    this.rounding = 0;
    this.name = "";
    this.label = "";
    this.drawOrder = 0;
    this.shape = "rectangle";
    this.shapeMode = CORNER;
    this.fillColor = color(220);
    this.hoverColor = color(140);
    this.strokeColor = color(0);
    this.textColor = color(0);
    this.strokeWeight = 0;
    this.textSize = 12;
    this.asLabel = false;
  }



  void display() {
    float textX;
    float textY;

    switch(this.shapeMode) {
    case CORNER:
      textX = this.x + this.w / 2.0;
      textY = this.y + this.h / 2.0;
      break;
    case CORNERS:
      textX = this.x + (this.w - this.x) / 2.0;
      textY = this.y + (this.h - this.y) / 2.0;
      break;
    default:
      textX = this.x;
      textY = this.y;
      break;
    }


    if (!this.asLabel && this.mouseOver(false)) {
      fill(this.hoverColor);
    } else {
      fill(this.fillColor);
    }
    if (this.strokeWeight == 0) {
      noStroke();
    } else {
      strokeWeight(this.strokeWeight);
      stroke(this.strokeColor);
    }
    rectMode(this.shapeMode);
    ellipseMode(this.shapeMode);
    textAlign(CENTER, CENTER);
    textSize(this.textSize);
    if (this.shape.equals("rectangle")) {
      rect(this.x, this.y, this.w, this.h, this.rounding);
      fill(this.textColor);
      text(this.label, textX, textY - textAscent() * gTextScalar);
    } else if (this.shape.equals("circle")) {
      ellipse(this.x, this.y, this.w, this.h);
      fill(this.textColor);
      text(this.label, textX, textY - textAscent() * gTextScalar);
    } else {
      return;
    }
  }


  boolean mouseOver(boolean calledByScreen) {
    if (this.shape.equals("rectangle")) {
      switch(this.shapeMode) {
      case CORNER:
        return (mouseX >= this.x && mouseX <= this.x + this.w && mouseY >= this.y && mouseY <= this.y + this.h);
      case CORNERS:
        return (mouseX >= this.x && mouseX <= this.w && mouseY >= this.y && mouseY <= this.h);
      case CENTER:
        return (mouseX >= this.x - this.w / 2.0 && mouseX <= this.x + this.w / 2.0 && mouseY >= this.y - this.h / 2.0&& mouseY <= this.y + this.h / 2.0);
      case RADIUS:
        return (mouseX >= this.x - this.w && mouseX <= this.x + this.w && mouseY >= this.y - this.h && mouseY <= this.y + this.h);
      default:
        return false;
      }
    } else if (this.shape.equals("circle")) {
      switch(this.shapeMode) {
      case CORNER:
        return (dist(mouseX, mouseY, this.x + this.w / 2.0, this.y + this.h / 2.0) <= this.w / 2.0);
      case CORNERS:
        return (dist(mouseX, mouseY, this.x + (this.w - this.x) / 2.0, this.y + (this.h - this.y) / 2.0) <= (this.w - this.x) / 2.0);
      case CENTER:
        return (dist(mouseX, mouseY, this.x, this.y) <= this.w / 2.0);
      case RADIUS:
        return (dist(mouseX, mouseY, this.x, this.y) <= this.w);
      default:
        return false;
      }
    }
    return false;
  }

  float getX() {
    return this.x;
  }

  float getY() {
    return this.y;
  }

  float getWidth() {
    return this.w;
  }

  float getHeight() {
    return this.h;
  }

  float getRounding() {
    return this.rounding;
  }

  String getName() {
    return this.name;
  }

  String getLabel() {
    return this.label;
  }

  int getDrawOrder() {
    return this.drawOrder;
  }

  String getShape() {
    return this.shape;
  }
  
  String getType(){
    return this.TYPE;
  }

  Button setX(float x_) {
    this.x = x_;
    return this;
  }

  Button setY(float y_) {
    this.y = y_;
    return this;
  }

  Button setWidth(float w_) {
    this.w = w_;
    return this;
  }

  Button setHeight(float h_) {
    this.h = h_;
    return this;
  }

  Button setRounding(float r_) {
    this.rounding = r_;
    return this;
  }

  Button setName(String n_) {
    this.name = n_;
    return this;
  }

  Button setLabel(String l_) {
    this.label = l_;
    return this;
  }

  Button setShape(String s_) {
    this.shape = s_;
    return this;
  }

  Button setDrawOrder(int d_) {
    this.drawOrder = d_;
    return this;
  }

  Button setShapeMode(int s_) {
    this.shapeMode = s_;
    return this;
  }

  Button setFillColor(color f_) {
    this.fillColor = f_;
    return this;
  }

  Button setHoverColor(color h_) {
    this.hoverColor = h_;
    return this;
  }

  Button setStrokeColor(color s_) {
    this.strokeColor = s_;
    return this;
  }

  Button setStrokeWeight(int s_) {
    this.strokeWeight = s_;
    return this;
  }

  Button setTextSize(float t_) {
    this.textSize = t_;
    return this;
  }

  Button setAsLabel(boolean a_) {
    this.asLabel = a_;
    return this;
  }
}
