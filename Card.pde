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
    this.type = cardInfo.getString("type");
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
    nameOrId.toLowerCase().equals(this.betaName.toLowerCase()));
  }

  boolean compareStat(String statName, String comparison, String statValue) {
    if (comparison.equals("") || statValue.equals("")) return true;
    int stat;
    switch(statName) {
    case "atk":
      stat = this.atk;
      break;
    case "def":
      stat = this.def;
      break;
    default:
      stat = 0;
    }
    if (stat == -1) return true;
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
  
  boolean compareRace(String[] races){
    if (races.length == 0) return false;
    if (this.type.equals("Spell Card") || this.type.equals("Trap Card")) return true;
    for (String race : races){
      if (race.equals(this.race)) return true;
    }
    return false;
  }
  
  //void addImage(){
  //  this.cardImage = loadImage("data/CardImages/" + this.id + ".png");
  //}
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
