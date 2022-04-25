class Screen {
  
  ArrayList<Interactable> components;
  String name;
  
  Screen(){
    this.components = new ArrayList<Interactable>();
    this.name = "";
  }
  
  
  void display(){
    for (Interactable component : components){
      component.display();
    }
  }
  
  String checkClick(){
    for (int i = this.components.size() - 1; i >= 0; i--){
      Interactable component = this.components.get(i);
      if (component.mouseOver(true)){
        return this.name + ":" + component.getType() + ":" + component.getName();
      }
    }
    return "";
  }
  
  ArrayList<String> getValues(){
    ArrayList<String> vals = new ArrayList<String>();
    for (Interactable component : components){
      vals.add(this.name + ":" + component.getType() + ":" + component.getName() + ":" + component.getValue());
    }
    return vals;
  }
  
  void reset(){
    for (Interactable com : this.components){
      com.reset();
    }
  }
  
  void orderComponents(){
    SortedSet<Interactable> sortedComponents = new TreeSet<>(Comparator.comparingInt(component -> component.getDrawOrder()));
    for (Interactable com : this.components){
      sortedComponents.add(com);
    }
    this.components = new ArrayList<>(sortedComponents);
    
  }
  
  String getName(){
    return this.name;
  }
  
  Interactable getInteractable(String n_){
    for (Interactable com : this.components){
      if (com.getName().equals(n_)){
        return com;
      }
    }
    return null;
  }
  
  void addComponent(Interactable c_){
    this.components.add(c_);
  }
  
  void setName(String n_){
    this.name = n_;
  }
  
  void printOrder(){
    for (int i = 0; i < this.components.size(); i++){
      println(str(i) + ": " + this.components.get(i).getName() + " [" + this.components.get(i).getDrawOrder() + "]");
    }
    
  }
  
}
