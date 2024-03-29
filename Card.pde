class Card {

  PImage cardImage;
  String name;
  String betaName;
  String type;
  String description;
  int level;
  int atk;
  int def;
  String atkDisplay;
  String defDisplay;
  String attribute;
  int id;
  int betaId;
  String archetype;
  String race;
  int konamiId;
  boolean hasEffect;
  String treatedAs;
  ArrayList<String> formats;

  Card(JSONObject cardInfo) {
    this.name = cardInfo.getString("name");
    this.race = cardInfo.getString("race");
    this.description = cardInfo.getString("desc");
    this.archetype = cardInfo.getString("archetype");
    this.id = cardInfo.getInt("id");
    this.type = cardInfo.getString("type");
    this.attribute = cardInfo.isNull("attribute") ? "" : cardInfo.getString("attribute");
    this.atk = cardInfo.isNull("atk") ? -1 : cardInfo.getInt("atk");
    this.def = cardInfo.isNull("def") ? -1 : cardInfo.getInt("def");
    JSONObject misc = cardInfo.getJSONArray("misc_info").getJSONObject(0);
    this.formats = new ArrayList<String>();
    this.konamiId = misc.isNull("konami_id") ? -1 : misc.getInt("konami_id");
    this.betaName = misc.isNull("beta_name") ? "" : misc.getString("beta_name");
    this.betaId = misc.isNull("beta_id") ? -1 : misc.getInt("beta_id");
    this.hasEffect = misc.isNull("has_effect") ? false : boolean(misc.getInt("has_effect"));
    this.atkDisplay = misc.isNull("question_atk") ? str(this.atk) : "?";
    this.defDisplay = misc.isNull("question_def") ? str(this.def) : "?";
    for (int i = 0; i < misc.getJSONArray("formats").size(); i++) {
      this.formats.add(misc.getJSONArray("formats").getString(i));
    }
    this.cardImage = null;
  }


  boolean checkCard(String nameOrId){
    return (nameOrId.toLowerCase().equals(this.name.toLowerCase()) || 
    nameOrId.equals(str(this.id)) || 
    nameOrId.equals(str(this.konamiId)) || 
    nameOrId.toLowerCase().equals(betaName.toLowerCase()));
  }

  boolean compareStat(String statName, String comparison, String statValue) {
    if (comparison.equals("") || statValue.equals("")) return true; //currently blank just means all is allowed
    int stat = 0;
    switch(statName) {
    case "atk":
      stat = this.atk;
      break;
    case "def":
      stat = this.def;
      break;
    }
    if (stat == -1) return true; //-1 means that the card does not have a stat value (trap/spell cards)
    switch(comparison){
      case ">":
        return stat > int(statValue);
      case ">=":
      return stat >= int(statValue);
      case "<":
      return stat < int(statValue);
      case "<=":
      return stat <= int(statValue);
      case "=":
      return stat == int(statValue); 
    }
    return false;
  }
  
  ArrayList<String> getFormats(){
    return this.formats;
  }
  
  int getId(){
    return this.id;
  }
  
  int getBetaId(){
    return this.betaId;
  }
  
  int getKonamiId(){
    return this.konamiId;
  }
  
  String getName(){
    return this.name;
  }
  
  String getBetaName(){
    return this.betaName;
  }
  
  boolean getHasEffect(){
    return this.hasEffect;
  }
    
  boolean compareRaceOrAttribute(String[] list, String compareWhat){
    if (list.length == 0) return false;
    if (this.type.equals("Spell Card") || this.type.equals("Trap Card")) return true;
    String cardProperty = "";
    if (compareWhat.equals("Race")) cardProperty = this.race;
    else if (compareWhat.equals("Attribute")) cardProperty = this.attribute;
    for (String listItem : list){
      if (listItem.equals(cardProperty)) return true;
    }
    return false;
  }

  PImage getImage(){
    return this.cardImage;
  }
  
  String getDescription(){
    return this.description;
  }
  
  String getType(){
    return this.type;
  }
  
}
