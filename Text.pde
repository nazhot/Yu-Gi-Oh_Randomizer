class Text extends Component<Text> {

  Text(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    this.TYPE = "Text";
  }


  void display() {
    textSize(this.textSize);
    fill(this.textColor);
    textAlign(LEFT, TOP);
    text(this.label, this.x, this.y, this.w, this.h);
  }

}
