class Group{
  
  String name;
  float x;
  float y;
  float w;
  float h;
  float horizontalGap;
  float verticalGap;
  int numHorizontalComponents;
  int numVerticalComponents;
  
  
  Group(JSONObject groupSettings){
    this.name = groupSettings.hasKey("Name") ? groupSettings.getString("Name") : "";
    this.x = groupSettings.hasKey("X") ? groupSettings.getFloat("X") : -1;
    this.y = groupSettings.hasKey("Y") ? groupSettings.getFloat("Y") : -1;
    this.w = groupSettings.hasKey("W") ? groupSettings.getFloat("W") : -1;
    this.h = groupSettings.hasKey("H") ? groupSettings.getFloat("H") : -1;
    this.horizontalGap = groupSettings.hasKey("Horizontal Gap") ? groupSettings.getFloat("Horizontal Gap") : -1;
    this.verticalGap = groupSettings.hasKey("Vertical Gap") ? groupSettings.getFloat("Vertical Gap") : -1;
    this.numHorizontalComponents = 0;
    this.numVerticalComponents = 0;
  }
  
  
  boolean compareNames(String nameToCheck){
    return nameToCheck.equals(this.name);
  }
  
  
  boolean addComponent(){
    
    
    return true;
  }
  
  
}
