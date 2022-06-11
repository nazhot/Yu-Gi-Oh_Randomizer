class ImageGridCollection extends Component<ImageGridCollection> {
  
  ArrayList<ImageGrid> grids;
  int gridIndex;
  
  
  ImageGridCollection(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    this.TYPE = "ImageGrid";
    this.grids = new ArrayList<ImageGrid>();
    this.gridIndex = 0;
  }
  
  
  
  void display(){
    if (this.gridIndex >= this.grids.size() || this.gridIndex < 0) return;
    
    this.grids.get(this.gridIndex).display();
  }
  
  
  ImageGridCollection setIndex(int i_){
    this.gridIndex = i_;
    return this;
  }
  
  Card getHoveredCard(){
    return this.grids.get(this.gridIndex).getHoveredCard();
  }
  
  void addImageGrid(ImageGrid i_){
    this.grids.add(i_);
  }
  
  void incrementScreen(int code){
    this.grids.get(this.gridIndex).incrementScreen(code);
  }
  
  void clearScreen(){
    for (ImageGrid i : this.grids){
      i.clearScreen();
    }
    this.grids.clear();
  }
  
  
  
  
  
  
  
  
  
  
  
}
