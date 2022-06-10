class TextBox extends Component<TextBox> {
  color hoverColor;
  int horizontalOrientation;
  boolean isSelected;
  boolean keyReleased;
  String defaultValue;


  TextBox(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    this.TYPE = "TextBox";
    this.hoverColor = color(140);
    this.horizontalOrientation = LEFT;
    this.isSelected = false;
    this.keyReleased = true;
    this.defaultValue = "";
  }

  void display() {
    if (keyPressed && this.isSelected && this.keyReleased) {
      this.keyReleased = false;
      if (key != CODED) {
        if (key == BACKSPACE) {
          if (this.value.length() > 0) {
            this.value = this.value.substring(0, this.value.length() - 1);
          }
        } else if (key == ESC || key == TAB || key == ENTER || key == RETURN ||key == DELETE) {
        } else {
          this.value += key;
        }
      }
    }
    if (!keyPressed && !this.keyReleased) {
      this.keyReleased = true;
    }

    if (mousePressed && !this.mouseOver(false)) {
      this.isSelected = false;
    }

    rectMode(CORNER);
    if (this.isSelected || this.mouseOver(false)) {
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
    rect(this.x, this.y, this.w, this.h, this.rounding);
    fill(this.textColor);
    textSize(this.textSize);
    textAlign(this.horizontalOrientation, CENTER);
    float textX = this.x + this.w * 0.02;
    if (this.horizontalOrientation == CENTER) {
      textX += this.w * 0.48;
    } else if (this.horizontalOrientation == RIGHT) {
      textX += this.w * 0.96;
    }
    text(this.value, textX, this.y + this.h / 2.0 - textAscent() * gTextScalar);
  }


  boolean mouseOver(boolean calledByScreen) {
    boolean mouseOver = (mouseX >= this.x && mouseX <= this.x + this.w && mouseY >= this.y && mouseY <= this.y + this.h);
    if (calledByScreen) {
      this.isSelected = mouseOver;
    }

    return mouseOver;
  }

  TextBox setHoverColor(color h_) {
    this.hoverColor = h_;
    return this;
  }

  TextBox setHorizontalOrientation(int h_) {
    this.horizontalOrientation = h_;
    return this;
  }
  
  TextBox setDefaultValue(String d_){
    this.defaultValue = d_;
    return this;
  }
  
  String getValue(){
    if (this.value.equals("")) return this.defaultValue;
    return this.value;
  }
  
  void reset(){
    this.value = "";
  }

}
