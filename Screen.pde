class Screen {

  ArrayList<Component> components;
  String name;
  int gridRows;
  int gridCols;
  float rowMultiplier;
  float colMultiplier;

  Screen() {
    this.components = new ArrayList<Component>();
    this.name = "";
    this.gridRows = height;
    this.gridCols = width;
    this.rowMultiplier = 1;
    this.colMultiplier = 1;
  }


  void display() {
    for (Component component : components) {
      component.display();
    }
  }

  String checkClick() {
    for (int i = this.components.size() - 1; i >= 0; i--) {
      Component component = this.components.get(i);
      if (component.mouseOver(true)) {
        return this.name + ":" + component.getType() + ":" + component.getName();
      }
    }
    return "";
  }

  ArrayList<String> getValues() {
    ArrayList<String> vals = new ArrayList<String>();
    for (Component component : components) {
      vals.add(this.name + ":" + component.getType() + ":" + component.getName() + ":" + component.getValue());
    }
    return vals;
  }

  void reset() {
    for (Component com : this.components) {
      com.reset();
    }
  }

  //void orderComponents() { /doesn't work with older version of processing
  //  SortedSet<Interactable> sortedComponents = new TreeSet<>(Comparator.comparingInt(component -> component.getDrawOrder()));
  //  for (Interactable com : this.components) {
  //    sortedComponents.add(com);
  //  }
  //  this.components = new ArrayList<>(sortedComponents);
  //}
  

  String getName() {
    return this.name;
  }

  Component getComponent(String n_) {
    for (Component com : this.components) {
      if (com.getName().equals(n_)) {
        return com;
      }
    }
    return null;
  }

  void addComponent(Component c_) {
    boolean isAdded = false;
    c_.setMultipliers(this.colMultiplier, this.rowMultiplier);
    for (int i = 0; i < this.components.size(); i++) {
      if (c_.getDrawOrder() <= this.components.get(i).getDrawOrder()) {
        this.components.add(i, c_);
        isAdded = true;
        break;
      }
    }
    if (!isAdded) this.components.add(c_);
    println("Added " + c_.getName() + " with no issue");
  }
  
  void removeComponent(String c_){
    for (Component c : this.components){
      if (c.getName().equals(c_)){
        this.components.remove(c);
        break;
      }
    }
  }
  
  void removeComponents(String c_){
    Iterator<Component> allComponents = this.components.iterator();
    while(allComponents.hasNext()){
      if (allComponents.next().getName().contains(c_)){
        allComponents.remove();
      }
    }
  }

  Screen setName(String n_) {
    this.name = n_;
    return this;
  }

  void printOrder() {
    for (int i = 0; i < this.components.size(); i++) {
      println(str(i) + ": " + this.components.get(i).getName() + " [" + this.components.get(i).getDrawOrder() + "]");
    }
  }

  void setComponenetsMultipliers(){
    for (Component c : this.components){
      c.setMultipliers(this.colMultiplier, this.rowMultiplier);
    }
  }

  Screen setGridRows(int g_) {
    this.gridRows = g_;
    this.rowMultiplier = 1.0 * g_ / height;
    this.setComponenetsMultipliers();
    return this;
  }

  Screen setGridCols(int g_) {
    this.gridCols = g_;
    this.colMultiplier = 1.0 * g_ / width;
    this.setComponenetsMultipliers();
    return this;
  }

  Screen setRowMultiplier(float r_) {
    this.rowMultiplier = r_;
    this.gridRows = round(r_ * height);
    this.setComponenetsMultipliers();
    return this;
  }

  Screen setColMultiplier(float c_) {
    this.colMultiplier = c_;
    this.gridCols = round(c_ * width);
    this.setComponenetsMultipliers();
    return this;
  }
}
