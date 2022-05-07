class Button extends Component<Button> {
  String shape;     //circle, rectangle
  int shapeMode;    //how processing should display the shape, CORNER, CORNERS, RADIUS, CENTER
  color hoverColor; //color to turn the fill color when the mouse is hovered over the button
  boolean asLabel;  //whether the button should just be a label or an actual button. Label disables hoverColor, clicks still register

  Button(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    this.TYPE = "Button";
    this.shape = "rectangle";
    this.shapeMode = CORNER;
    this.hoverColor = color(140);
    this.asLabel = false;
  }

  void display() {
    float textX = this.x; //default case, for RADIUS or CENTER
    float textY = this.y;

    switch(this.shapeMode) { //set where the text should be displayed based on the shape mode
    case CORNER: //move from corner to the center
      textX += this.w / 2.0;
      textY += this.h / 2.0;
      break;
    case CORNERS: //move from corner to the center, w and h are coordinates of other corner this time
      textX += (this.w - this.x) / 2.0;
      textY += (this.h - this.y) / 2.0;
      break;
    }

    //set up all of the parameters for shape drawing
    rectMode(this.shapeMode);
    ellipseMode(this.shapeMode);
    textAlign(CENTER, CENTER);
    textSize(this.textSize);
    fill(this.fillColor);
    strokeWeight(this.strokeWeight);
    stroke(this.strokeColor);
    if (!this.asLabel && this.mouseOver(false)) fill(this.hoverColor); //override fill color if mouse is over and this isn't a label
    if (this.strokeWeight == 0)                 noStroke();

    if (this.shape.equals("rectangle")) {
      rect(this.x, this.y, this.w, this.h, this.rounding);
    } else if (this.shape.equals("circle")) {
      ellipse(this.x, this.y, this.w, this.h);
    } else {
      return;
    }

    fill(this.textColor);
    text(this.label, textX, textY - textAscent() * gTextScalar);
  }


  boolean mouseOver(boolean calledByScreen) { //get the top left and bottom right x / y coordinates, and make sure mouse x / y are between them
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
    } else if (this.shape.equals("circle")) { //get center point and radius, make sure distance from mouse position to center is less than radius
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
