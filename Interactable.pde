class Interactable{
  String TYPE = "Interactable";
  int drawOrder;
  String name;
  float rounding;
  float textSize;
  
  
  Interactable(){
    
  }
  
  void display(){
    
  }
  
  boolean mouseOver(boolean calledByScreen){
    return true;
  }
  
  boolean clicked(){
    return true;
  }
  
  int getDrawOrder(){
    return this.drawOrder;
  }
  
  String getName(){
    return name;
  }
  
  String getValue(){
    return "";
  }
  
  String getType(){
    return this.TYPE;
  }
  
  void reset(){
    
  }
  
  Interactable setName(String n_){
    name = n_;
    return this;
  }
  
  Interactable setDrawOrder(int d_){
    this.drawOrder = d_;
    return this;
  }
  
  Interactable setRounding(float r_){
    this.rounding = r_;
    return this;
  }
  
  Interactable setTextSize(float t_){
    this.textSize = t_;
    return this;
  }
  
  Interactable addEntries(String[] e_){
    return this;
  }
  
  Interactable setEntryHeight(float e_){
    return this;
  }
  
  Interactable setEntryWidth(float e_){
    return this;
  }
  
  Interactable setMultiSelect(boolean m_){
    return this;
  }
  
  Interactable addSelectAll(){
    return this;
  }
  
  
}
