class Controller  {
  
  ArrayList<Screen> screens;
  Screen currentScreen;
  ArrayList<Screen> backgroundScreens;
  
  Controller(){
    this.screens = new ArrayList<Screen>();
    this.currentScreen = null;
    this.backgroundScreens = new ArrayList<Screen>();
  }
  
  void display(){
    for (Screen screen : this.backgroundScreens){
      screen.display();
    }
    this.currentScreen.display();
  }
  
  String checkClick(){
    return this.currentScreen.checkClick();
  }
  
  ArrayList<String> getValues(){
    return this.currentScreen.getValues();
  }
  
  Screen getCurrentScreen(){
    return this.currentScreen;
  }
  
  Screen getScreen(String name){
    for (Screen screen : this.screens){
      if (screen.getName().equals(name)) return screen;
    }
    return null;
  }
  
  String getCurrentScreenName(){
    return this.currentScreen.getName();
  }
  
  void changeScreen(String n_){
    
    
    
  }
  
  
  
  void setCurrentScreen(String n_){
    for (Screen screen : this.screens){
      if (screen.getName().equals(n_)){
        this.currentScreen = screen;
        break;
      }
    }
  }
  
  void addScreen(Screen s_){
    s_.orderComponents();
    this.screens.add(s_);
  }
  
  
  
  
  
  
}
