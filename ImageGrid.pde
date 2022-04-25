class ImageGrid extends Interactable {
  String TYPE = "ImageGrid";
  float x;
  float y;
  float w;
  float h;
  ArrayList<PImage> images;
  color backgroundColor;
  color strokeColor;
  color cardHoverColor;
  int strokeWeight;
  int cardHoverStrokeWeight;
  int numCols;
  float imageWidth;
  float imageHeight;
  float horizontalMargin;
  float horizontalGap;
  float verticalMargin;
  float verticalGap;
  float widthHeightRatio;
  int drawOrder;
  int hoveredCardIndex;


  ImageGrid(float x_, float y_, float w_, float h_) {
    this.x = x_;
    this.y = y_;
    this.w = w_;
    this.h = h_;
    this.images = new ArrayList<PImage>();
    this.backgroundColor = color(0);
    this.strokeColor = color(255);
    this.cardHoverColor = color(71, 85, 214);
    this.strokeWeight = 1;
    this.cardHoverStrokeWeight = 3;
    this.numCols = 1;
    this.horizontalMargin = 5;
    this.horizontalGap = 5;
    this.verticalMargin = 5;
    this.verticalGap = 5;
    this.widthHeightRatio = 1;
    this.drawOrder = 1;
    this.hoveredCardIndex = -1;
    this.refreshImageDimensions();
  }

  void display() {
    rectMode(CORNER);
    this.hoveredCardIndex = this.mouseOverEntry();
    fill(this.backgroundColor);
    if (this.strokeWeight == 0) {
      noStroke();
    } else {
      stroke(this.strokeColor);
      strokeWeight(this.strokeWeight);
    }
    rect(this.x, this.y, this.w, this.h);
    for (int i = 0; i < this.images.size(); i++) {
      float imageX = this.getImageX(i);
      float imageY = this.getImageY(i);
      image(this.images.get(i), imageX, imageY, this.imageWidth, this.imageHeight);
    }
    if (this.hoveredCardIndex > -1) {
      rectMode(CORNER);
      stroke(this.cardHoverColor);
      strokeWeight(this.cardHoverStrokeWeight);
      noFill();
      rect(this.getImageX(this.hoveredCardIndex), this.getImageY(this.hoveredCardIndex), this.imageWidth, this.imageHeight);
    }
  }

  int mouseOverEntry() {
    int hoveredOverEntry = -1;

    for (int i = 0; i < this.images.size(); i++) {
      float imageX = this.getImageX(i);
      float imageY = this.getImageY(i);
      if (mouseX >= imageX && mouseX <= imageX + imageWidth && mouseY >= imageY && mouseY <= imageY + imageHeight) {
        return i;
      }
    }

    return hoveredOverEntry;
  }

  boolean mouseOver(boolean calledByScreen) {
    boolean mouseOver = (mouseX >= this.x && mouseX <= this.x + this.w && mouseY >= this.y && mouseY <= this.y + this.h);
    //if (mouseOver) {
    //  this.hoveredCardIndex = this.mouseOverEntry();
    //}
    return mouseOver;
  }



  void refreshImageDimensions() {
    this.imageWidth = (this.w - this.horizontalMargin * 2 - this.horizontalGap * (this.numCols - 1))/this.numCols;
    this.imageHeight = imageWidth * this.widthHeightRatio;
  }
  
  float getImageX(int cardIndex){
    int columnNumber = cardIndex % this.numCols;
    return this.x + this.horizontalMargin + columnNumber * (this.imageWidth + this.horizontalGap);
  }
  
  float getImageY(int cardIndex){
    int rowNumber = floor(1.0 * cardIndex / this.numCols);
    return this.y + this.verticalMargin + rowNumber * (this.imageHeight + this.horizontalGap);
  }
  
  PImage getHoveredCard(){
    if (this.hoveredCardIndex > 0){
      return this.images.get(this.hoveredCardIndex);
    }
    return null;
  }
  
  ImageGrid setName(String n_){
    this.name = n_;
    return this;
  }

  ImageGrid addImage(PImage i_) {
    this.images.add(i_);
    return this;
  }

  ImageGrid setHorizontalMargin(float h_) {
    this.horizontalMargin = h_;
    this.refreshImageDimensions();
    return this;
  }

  ImageGrid setHorizontalGap(float h_) {
    this.horizontalGap = h_;
    this.refreshImageDimensions();
    return this;
  }

  ImageGrid setVerticalMargin(float v_) {
    this.verticalMargin = v_;
    this.refreshImageDimensions();
    return this;
  }

  ImageGrid setVerticalGap(float v_) {
    this.verticalGap = v_;
    this.refreshImageDimensions();
    return this;
  }

  ImageGrid setWidthHeightRatio(float w_) {
    this.widthHeightRatio = w_;
    this.refreshImageDimensions();
    return this;
  }

  ImageGrid setNumCols(int n_) {
    this.numCols = n_;
    this.refreshImageDimensions();
    return this;
  }

  ImageGrid setStrokeColor(color s_) {
    this.strokeColor = s_;
    return this;
  }

  ImageGrid setBackgroundColor(color f_) {
    this.backgroundColor = f_;
    return this;
  }

  ImageGrid setStrokeWeight(int s_) {
    this.strokeWeight = s_;
    return this;
  }

  ImageGrid setDrawOrder(int d_) {
    this.drawOrder = d_;
    return this;
  }
}
