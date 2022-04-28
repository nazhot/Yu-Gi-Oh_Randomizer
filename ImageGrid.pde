class ImageGrid extends Interactable {
  String TYPE = "ImageGrid";
  float x;
  float y;
  float w;
  float h;
  //ArrayList<PImage> images;
  ArrayList<Card> cards;
  //ArrayList<String> imageNames;
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
  float totalGridHeight;
  int drawOrder;
  int hoveredCardIndex;
  float scrollBarX;
  float scrollBarY;
  float scrollBarW;
  float scrollBarH;
  float scrollBarOffset;
  PGraphics tempCanvas;
  PImage currentCanvas;
  int currentScreen;
  int numCardsOnScreen;
  int numRows;
  int numScreens;
  ArrayList<PImage> allScreens;


  ImageGrid(float x_, float y_, float w_, float h_) {
    this.x = x_;
    this.y = y_;
    this.w = w_;
    this.h = h_;
    //this.images = new ArrayList<PImage>();
    this.cards = new ArrayList<Card>();
    //this.imageNames = new ArrayList<String>();
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
    this.currentScreen = 0;
    this.tempCanvas = null;
    this.currentCanvas = null;
    this.allScreens = new ArrayList<PImage>();
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
    //image(this.currentCanvas, this.x, this.y);
    //image(this.currentCanvas, this.x, this.y);
    if (this.allScreens.size() > 0 ) {
      image(this.allScreens.get(this.currentScreen), this.x, this.y);
    }

    //for (int i = 0; i < this.cards.size(); i++) {
    //  float imageX = this.getImageX(i);
    //  float imageY = this.getImageY(i);
    //  if (this.cards.get(i).getImage() != null) {
    //    image(this.cards.get(i).getImage(), imageX, imageY, this.imageWidth, this.imageHeight);
    //  }
    //}

    if (this.hoveredCardIndex > -1) {
      rectMode(CORNER);
      stroke(this.cardHoverColor);
      strokeWeight(this.cardHoverStrokeWeight);
      noFill();
      rect(this.getImageX(this.hoveredCardIndex), this.getImageY(this.hoveredCardIndex), this.imageWidth, this.imageHeight);
    }
    textAlign(LEFT, TOP);
    textSize(30);
    fill(255);
    text(str(this.currentScreen + 1) + "/" + str(this.numScreens), this.x + this.horizontalMargin, this.y + this.verticalMargin);
  }

  int mouseOverEntry() {
    int hoveredOverEntry = -1;

    for (int i = 0; i < this.cards.size(); i++) {
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
  void clearScreen(){
    this.currentScreen = 0;
    this.allScreens = new ArrayList<PImage>();
    this.cards = new ArrayList<Card>();
  }
  void makeScreen() {
    g.removeCache(this.currentCanvas);
    g.removeCache(this.tempCanvas);
    this.tempCanvas = createGraphics(int(this.x + this.w), int(this.y + this.h));
    tempCanvas.beginDraw();
    this.currentCanvas = createImage(int(this.x + this.w), int(this.y + this.h), RGB);
    int startCard = this.currentScreen * this.numCardsOnScreen;
    int endCard = min(this.cards.size(), (this.currentScreen + 1) * this.numCardsOnScreen);
    for (int i = startCard; i < endCard; i++) {
      //float topLeftX = ((i - startCard) % this.numCols) * (this.imageWidth + this.horizontalGap) + this.horizontalMargin ;
      //float topLeftY = floor((i - startCard) / this.numCols) * (this.imageHeight + this.verticalGap) + this.verticalMargin;
      float topLeftX = this.getImageX((i - startCard) % this.numCardsOnScreen) - this.x;
      float topLeftY = this.getImageY((i - startCard) % this.numCardsOnScreen) - this.y;
      tempCanvas.image(loadImage(imageFolder + this.cards.get(i).getId() + imageExtension), topLeftX, topLeftY, this.imageWidth, this.imageHeight);
    }
    tempCanvas.endDraw();
    currentCanvas = tempCanvas.get();
  }

  void makeScreens() {
    for (int screen = 0; screen < this.numScreens; screen++) {
      //g.removeCache(this.currentCanvas);
      g.removeCache(this.tempCanvas);
      this.tempCanvas = createGraphics(int(this.x + this.w), int(this.y + this.h));
      tempCanvas.beginDraw();
      //this.currentCanvas = createImage(int(this.x + this.w), int(this.y + this.h), RGB);
      int startCard = screen * this.numCardsOnScreen;
      int endCard = min(this.cards.size(), (screen + 1) * this.numCardsOnScreen);
      for (int i = startCard; i < endCard; i++) {
        //float topLeftX = ((i - startCard) % this.numCols) * (this.imageWidth + this.horizontalGap) + this.horizontalMargin ;
        //float topLeftY = floor((i - startCard) / this.numCols) * (this.imageHeight + this.verticalGap) + this.verticalMargin;
        float topLeftX = this.getImageX((i - startCard) % this.numCardsOnScreen) - this.x;
        float topLeftY = this.getImageY((i - startCard) % this.numCardsOnScreen) - this.y;
        PImage tempImage = loadImage(imageFolder + this.cards.get(i).getId() + imageExtension);
        if (tempImage != null) {
          //tempCanvas.image(loadImage("data/CardImages/" + this.cards.get(i).getId() + ".png"), topLeftX, topLeftY, this.imageWidth, this.imageHeight);
          tempCanvas.image(tempImage, topLeftX, topLeftY, this.imageWidth, this.imageHeight);
        }
      }
      tempCanvas.endDraw();
      //currentCanvas = tempCanvas.get();
      this.allScreens.add(tempCanvas.get());
    }
  }



  void incrementScreen(int code) {
    if (code == LEFT) {
      this.currentScreen--;
      this.currentScreen = max(0, this.currentScreen);
    } else if (code == RIGHT) {
      this.currentScreen++;
      this.currentScreen = min(this.numScreens - 1, this.currentScreen);
    }
    //this.makeScreens();
  }

  void refreshImageDimensions() {
    this.imageWidth = (this.w - this.horizontalMargin * 2 - this.horizontalGap * (this.numCols - 1))/this.numCols;
    this.imageHeight = imageWidth * this.widthHeightRatio;
    this.numRows = floor(1.0 *  this.h/ this.imageHeight);
    this.numCardsOnScreen = this.numRows * this.numCols;
    this.totalGridHeight = this.verticalMargin + this.imageHeight * (numRows) + this.verticalGap * (numRows - 1);
    this.numScreens = ceil(1.0 * this.cards.size() / this.numCardsOnScreen);
  }

  //String getShownIndexes(){

  //}

  float getImageX(int cardIndex) {
    int columnNumber = cardIndex % this.numCols;
    return this.x + this.horizontalMargin + columnNumber * (this.imageWidth + this.horizontalGap);
  }

  float getImageY(int cardIndex) {
    int rowNumber = floor(1.0 * cardIndex / this.numCols);
    return this.y + this.verticalMargin + rowNumber * (this.imageHeight + this.horizontalGap);
  }

  Card getHoveredCard() {
    if (this.hoveredCardIndex > -1) {
      return this.cards.get(min(this.cards.size() - 1, this.numCardsOnScreen * this.currentScreen + this.hoveredCardIndex));
    }
    return null;
  }

  ImageGrid setName(String n_) {
    this.name = n_;
    return this;
  }


  ImageGrid addCard(Card c_) {
    //c_.addImage();
    this.cards.add(c_);
    this.refreshImageDimensions();
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
