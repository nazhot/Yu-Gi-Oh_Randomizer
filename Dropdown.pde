class DropDown extends Component<DropDown> {
  ArrayList<String> entries;
  ArrayList<Boolean> selected;
  float entryHeight;
  float entryWidth;
  boolean multiSelect;
  boolean isOpen;
  color selectedColor;
  color hoverColor;
  boolean alwaysOpen;
  boolean isVertical;
  String direction;
  boolean selectAll;
  int titleHorizontalOrientation;
  int entryHorizontalOrientation;
  float entryVsTitleOrientationPercent;
  boolean titleStroke;

  DropDown(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    this.TYPE = "DropDown";
    this.entries = new ArrayList<String>();
    this.selected = new ArrayList<Boolean>();
    this.entryHeight = h_;
    this.entryWidth = w_;
    this.multiSelect = false;
    this.isOpen = false;
    this.alwaysOpen = false;
    this.selectedColor = #ff8b53;
    this.hoverColor = #ffa57a;
    this.isVertical = true;
    this.direction = "DOWN";
    this.selectAll = false;
    this.titleHorizontalOrientation = LEFT;
    this.entryHorizontalOrientation = LEFT;
    this.entryVsTitleOrientationPercent = 0;
    this.titleStroke = true;
  }


  void display() {
    rectMode(CORNER);
    fill(this.fillColor);
    stroke(this.strokeColor);
    strokeWeight(this.strokeWeight);
    if (!this.titleStroke) {
      noStroke();
    }
    rect(this.x, this.y, this.w, this.h, this.rounding);
    fill(this.textColor);

    textSize(this.textSize);
    String tempTitle = this.label;
    if (!this.isOpen && !this.alwaysOpen) {
      boolean moreThanOne = false;
      for (int i = 0; i < this.selected.size(); i++) {
        if (this.selected.get(i)) {
          if (moreThanOne) {
            tempTitle += "...";
            break;
          }
          tempTitle += this.entries.get(i);

          moreThanOne = true;
        }
      }
    }
    textAlign(this.titleHorizontalOrientation, CENTER);
    float titleX = this.x + this.w * 0.02;
    if (this.titleHorizontalOrientation == CENTER) {
      titleX += this.w * 0.48;
    }
    text(tempTitle, titleX, this.y + this.h / 2.0 - textAscent() * gTextScalar);
    if (this.isOpen || this.alwaysOpen) {
      strokeWeight(this.strokeWeight);
      stroke(this.strokeColor);
      float entryXOffset = map(this.entryVsTitleOrientationPercent, 0, 1, 0, this.w - this.entryWidth);
      float rectX = this.x + entryXOffset;
      float rectY = this.y;
      float textX = this.x + this.entryWidth * .02 + entryXOffset;
      float textY = this.y + this.h / 2.0 - textAscent() * gTextScalar;
      if (this.isVertical) {
        rectY += this.h;
        textY += this.h / 2.0 + this.entryHeight / 2.0;
      } else {
        rectY += this.h / 2.0 - this.entryHeight / 2.0;
        rectX += this.entryWidth;
        textX += this.entryWidth;
      }
      if (this.entryHorizontalOrientation == CENTER) {
        textX += this.entryWidth * 0.48;
      }
      textAlign(this.entryHorizontalOrientation, CENTER);
      for (int i = 0; i < this.entries.size(); i++) {

        String entry = this.entries.get(i);
        float extraWidth = 0;
        if (this.selected.get(i)) {
          fill(this.selectedColor);
          extraWidth += this.entryWidth * .1;
        } else {
          fill(this.fillColor);
        }
        rect(rectX - extraWidth / 2.0, rectY, this.entryWidth + extraWidth, this.entryHeight, this.rounding);
        fill(this.textColor);
        text(entry, textX + this.entryWidth * .02, textY);
        if (this.isVertical) {
          rectY += this.entryHeight;
          textY += this.entryHeight;
        } else {
          rectX += this.entryWidth;
          textX += this.entryWidth;
        }
      }
    }
  }


  int mouseOverEntry() {
    float entryXOffset = map(this.entryVsTitleOrientationPercent, 0, 1, 0, this.w - this.entryWidth);
    if (mouseX >= this.x + entryXOffset && mouseX <= this.x + this.entryWidth + entryXOffset) {
      for (int i = 0; i < this.entries.size(); i++) {
        if (mouseY >= this.y + this.h + this.entryHeight * i && mouseY <= this.y + this.h + this.entryHeight * (i + 1)) {
          return i;
        }
      }
    }
    return -1;
  }

  boolean mouseOver(boolean calledByScreen) {
    boolean isMouseOver = (mouseX >= this.x && mouseX <= this.x + this.w && mouseY >= this.y && mouseY <= this.y + this.h);
    boolean isMouseOverEntry = false;
    if (this.isOpen || this.alwaysOpen) {
      int index = this.mouseOverEntry();
      if (index >= 0) {
        isMouseOverEntry = true;
        if (this.selectAll && index == 0) {
          boolean allSelected = true;
          for (int i = 1; i < this.selected.size(); i++) {
            if (!this.selected.get(i)) {
              allSelected = false;
              break;
            }
          }
          this.selected.set(0, true);
          for (int i = 1; i < this.selected.size(); i++) {
            this.selected.set(i, !allSelected);
          }
        }
        if (this.multiSelect) {
          this.selected.set(index, !this.selected.get(index));
        } else {
          boolean tempSelected = !this.selected.get(index);
          for (int i = 0; i < this.selected.size(); i++) {
            this.selected.set(i, false);
          }
          this.selected.set(index, tempSelected);
        }
      }
    }
    if (isMouseOver) {
      this.toggleIsOpen();
    }


    return isMouseOver || isMouseOverEntry;
  }

  void reset() {
    for (int i = 0; i < this.selected.size(); i++) {
      this.selected.set(i, false);
    }
    this.isOpen = false;
  }



  DropDown setMultiSelect(boolean m_) {
    this.multiSelect = m_;
    return this;
  }

  DropDown setIsVertical(boolean i_) {
    this.isVertical = i_;
    return this;
  }

  DropDown addEntry(String e_) {
    this.entries.add(e_);
    this.selected.add(false);
    return this;
  }

  DropDown setAlwaysOpen(boolean a_) {
    this.alwaysOpen = a_;
    return this;
  }


  DropDown setEntryHeight(float e_) {
    this.entryHeight = e_;
    return this;
  }

  DropDown setEntryWidth(float e_) {
    this.entryWidth = e_;
    return this;
  }

  DropDown addEntries(ArrayList<String> e_) {
    for (String entry : e_) {
      this.entries.add(entry);
      this.selected.add(false);
    }
    return this;
  }

  DropDown addEntries(String[] e_) {
    for (String entry : e_) {
      this.entries.add(entry);
      this.selected.add(false);
    }
    return this;
  }

  DropDown addSelectAll() {
    this.selectAll = true;
    this.entries.add(0, "Select All");
    this.selected.add(0, false);
    return this;
  }

  DropDown setIsOpen(boolean i_) {
    this.isOpen = i_;
    return this;
  }

  DropDown toggleIsOpen() {
    this.isOpen = !this.isOpen;
    return this;
  }

  DropDown setTitleHorizontalOrientation(int t_) {
    this.titleHorizontalOrientation = t_;
    return this;
  }

  DropDown setEntryHorizontalOrientation(int e_) {
    this.entryHorizontalOrientation = e_;
    return this;
  }

  DropDown setEntryVsTitleOrientationPercent(float e_) {
    this.entryVsTitleOrientationPercent = e_;
    return this;
  }

  DropDown setTitleStroke(boolean t_) {
    this.titleStroke = t_;
    return this;
  }

  String getValue() {
    String val = "";
    for (int i = 0; i < this.selected.size(); i++) {
      if (this.selected.get(i)) {
        if (val.length() > 0) {
          val += ",";
        }
        val += this.entries.get(i);
      }
    }
    return val;
  }

  DropDown setMultipliers(float colMultiplier, float rowMultiplier) {
    this.x *= colMultiplier;
    this.w *= colMultiplier;
    this.y *= rowMultiplier;
    this.h *= rowMultiplier;
    this.entryWidth *= colMultiplier;
    this.entryHeight *= rowMultiplier;
    this.textSize *= colMultiplier;
    return this;
  }
}
