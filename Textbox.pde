class TextBox extends Interactable {
  String TYPE = "TextBox";
  String name;
  String textField;
  float x;
  float y;
  float w;
  float h;
  color fillColor;
  color hoverColor;
  color textColor;
  color strokeColor;
  float strokeWeight;
  float textSize;
  int rounding;
  int drawOrder;
  int horizontalOrientation;
  boolean isSelected;
  boolean keyReleased;


  TextBox(float x_, float y_, float w_, float h_) {

    this.name = "";
    this.textField = "";
    this.x = x_;
    this.y = y_;
    this.w = w_;
    this.h = h_;
    this.fillColor = color(220);
    this.hoverColor = color(140);
    this.strokeColor = color(0);
    this.textColor = color(0);
    this.strokeWeight = 0;
    this.textSize = 20;
    this.textSize = 12;
    this.rounding = 0;
    this.drawOrder = 0;
    this.horizontalOrientation = LEFT;
    this.isSelected = false;
    this.keyReleased = true;
  }

  void display() {
    if (keyPressed && this.isSelected && this.keyReleased) {
      this.keyReleased = false;
      if (key != CODED) {
        if (key == BACKSPACE) {
          if (this.textField.length() > 0) {
            this.textField = this.textField.substring(0, this.textField.length() - 1);
          }
        } else if (key == ESC || key == TAB || key == ENTER || key == RETURN ||key == DELETE) {
        } else {
          this.textField += key;
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
    text(this.textField, textX, this.y + this.h / 2.0 - textAscent() * gTextScalar);
  }


  boolean mouseOver(boolean calledByScreen) {
    boolean mouseOver = (mouseX >= this.x && mouseX <= this.x + this.w && mouseY >= this.y && mouseY <= this.y + this.h);
    if (calledByScreen) {
      this.isSelected = mouseOver;
    }

    return mouseOver;
  }

  String getName() {
    return this.name;
  }

  int getDrawOrder() {
    return this.drawOrder;
  }

  String getValue() {
    return this.textField;
  }

  String getType() {
    return this.TYPE;
  }


  TextBox setName(String n_) {
    this.name = n_;
    return this;
  }

  TextBox setTextField(String t_) {
    this.textField = t_;
    return this;
  }

  TextBox setRounding(int r_) {
    this.rounding = r_;
    return this;
  }

  TextBox setFillColor(color f_) {
    this.fillColor = f_;
    return this;
  }

  TextBox setHoverColor(color h_) {
    this.hoverColor = h_;
    return this;
  }

  TextBox setDrawOrder(int d_) {
    this.drawOrder = d_;
    return this;
  }

  TextBox setTextSize(float t_) {
    this.textSize = t_;
    return this;
  }

  TextBox setHorizontalOrientation(int h_) {
    this.horizontalOrientation = h_;
    return this;
  }
}
