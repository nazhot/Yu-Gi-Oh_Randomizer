class ImageGrid extends Component<ImageGrid> {
  ArrayList<Card> cards;
  color cardHoverColor;
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
  int hoveredCardIndex;
  PGraphics tempCanvas;
  int currentScreen;
  int numCardsOnScreen;
  int numRows;
  int numScreens;
  ArrayList<PImage> allScreens;


  ImageGrid(PApplet theParent, float x_, float y_, float w_, float h_) {
    super(theParent, x_, y_, w_, h_);
    this.TYPE = "ImageGrid";
    this.cards = new ArrayList<Card>();
    this.cardHoverColor = color(71, 85, 214);
    this.cardHoverStrokeWeight = 3;
    this.numCols = 1;
    this.horizontalMargin = 5;
    this.horizontalGap = 5;
    this.verticalMargin = 5;
    this.verticalGap = 5;
    this.widthHeightRatio = 1;
    this.hoveredCardIndex = -1;
    this.refreshImageDimensions();
    this.currentScreen = 0;
    this.tempCanvas = null;
    this.allScreens = new ArrayList<PImage>();
  }

  void draw() {
    rectMode(CORNER);
    this.hoveredCardIndex = this.mouseOverEntry();
    fill(this.fillColor);
    if (this.strokeWeight == 0) {
      noStroke();
    } else {
      stroke(this.strokeColor);
      strokeWeight(this.strokeWeight);
    }
    rect(this.x, this.y, this.w, this.h);
    if (this.allScreens.size() > 0 ) {
      image(this.allScreens.get(this.currentScreen), this.x, this.y);
    }

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
    return mouseOver;
  }

  void clearScreen() {
    this.currentScreen = 0;
    for (int i = 0; i < this.allScreens.size(); i++) {
      g.removeCache(this.allScreens.get(i));
    }
    this.allScreens = new ArrayList<PImage>();
    this.cards = new ArrayList<Card>();
  }

  ImageGrid makeScreens(JSONObject banlist) {
    println("Starting to make screens");
    println("Number of screens: " + this.numScreens);
    println("Number of cards: " + this.cards.size());
    for (int screen = 0; screen < this.numScreens; screen++) {
      g.removeCache(this.tempCanvas);
      this.tempCanvas = createGraphics(int(this.x + this.w), int(this.y + this.h));
      tempCanvas.beginDraw();
      int startCard = screen * this.numCardsOnScreen;
      int endCard = min(this.cards.size(), (screen + 1) * this.numCardsOnScreen);
      tempCanvas.textAlign(CENTER, CENTER);
      tempCanvas.textSize(20);
      for (int i = startCard; i < endCard; i++) {
        float topLeftX = this.getImageX((i - startCard) % this.numCardsOnScreen) - this.x;
        float topLeftY = this.getImageY((i - startCard) % this.numCardsOnScreen) - this.y;
        PImage tempImage = loadImage(imageFolder + this.cards.get(i).getId() + imageExtension);

        if (tempImage != null) {
          tempCanvas.image(tempImage, topLeftX, topLeftY, this.imageWidth, this.imageHeight);
          if (banlist.size() == 0) continue;
          if (banlist.hasKey(str(this.cards.get(i).getId()))) {
            int banNum = banlist.getInt(str(this.cards.get(i).getId()));
            if (banNum < 3) {
              tempCanvas.image(loadImage(dataPath("") + "/Images/" + str(banNum) + ".png"), topLeftX + this.imageWidth - 20, topLeftY, 20, 20);
            }
          } else if (banlist.hasKey(this.cards.get(i).getName())) {
            int banNum = banlist.getInt(this.cards.get(i).getName());
            if (banNum < 3) {
              tempCanvas.image(loadImage(dataPath("") + "/Images/" + str(banNum) + ".png"), topLeftX + this.imageWidth - 20, topLeftY, 20, 20);
            }
          }
        }
      }
      tempCanvas.endDraw();
      this.allScreens.add(tempCanvas.get());
    }
    return this;
  }



  void incrementScreen(int code) {
    if (code == LEFT) {
      this.currentScreen = max(0, --this.currentScreen);
    } else if (code == RIGHT) {
      this.currentScreen = min(this.numScreens - 1, ++this.currentScreen);
    }
  }

  void refreshImageDimensions() {
    this.imageWidth = (this.w - this.horizontalMargin * 2 - this.horizontalGap * (this.numCols - 1))/this.numCols;
    this.imageHeight = imageWidth * this.widthHeightRatio;
    this.numRows = floor(1.0 *  this.h/ this.imageHeight);
    this.numCardsOnScreen = this.numRows * this.numCols;
    this.totalGridHeight = this.verticalMargin + this.imageHeight * (numRows) + this.verticalGap * (numRows - 1);
    this.numScreens = ceil(1.0 * this.cards.size() / this.numCardsOnScreen);
  }

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

  ImageGrid addCard(Card c_) {
    this.cards.add(c_);
    this.refreshImageDimensions();
    return this;
  }

  ImageGrid addCards(ArrayList<Card> c_) {
    this.cards.addAll(c_);
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


  ImageGrid setMultipliers(float colMultiplier, float rowMultiplier) {
    this.x *= colMultiplier;
    this.w *= colMultiplier;
    this.y *= rowMultiplier;
    this.h *= rowMultiplier;
    this.refreshImageDimensions();
    return this;
  }
}
