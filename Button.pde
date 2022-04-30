class Button extends Component<Button> {
  String shape; //circle, rectangle
  int shapeMode;
  color hoverColor;
  boolean asLabel;

  Button(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    this.TYPE = "Button";
    this.shape = "rectangle";
    this.shapeMode = CORNER;
    this.hoverColor = color(140);
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

  String getShape() {
    return this.shape;
  }
  
  Button setShape(String s_) {
    this.shape = s_;
    return this;
  }

  Button setShapeMode(int s_) {
    this.shapeMode = s_;
    return this;
  }

  Button setHoverColor(color h_) {
    this.hoverColor = h_;
    return this;
  }

  Button setAsLabel(boolean a_) {
    this.asLabel = a_;
    return this;
  }
  
}
