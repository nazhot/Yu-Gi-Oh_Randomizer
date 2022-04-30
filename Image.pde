class Image extends Component<Image> {

  String imageFileName;

  Image(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    this.TYPE = "Image";
    this.imageFileName = "";
  }


  void display() {
    PImage image = loadImage(this.imageFileName);
    if (image != null) {
      image(image, this.x, this.y, this.w, this.h);
    }
  }


  Image setImageFileName(String i_) {
    this.imageFileName = i_;
    return this;
  }
}
