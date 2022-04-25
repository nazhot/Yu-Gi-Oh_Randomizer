class Card{
  
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
  
  
  
  
  Card(JSONObject cardInfo){
    this.name = cardInfo.getString("name");
    this.race = cardInfo.getString("race");
    this.description = cardInfo.getString("desc");
    this.archetype = cardInfo.getString("archetype");
    this.id = cardInfo.getInt("id");
    this.type = cardInfo.getString("type");
    JSONObject misc = cardInfo.getJSONArray("misc_info").getJSONObject(0);
    this.formats = new ArrayList<String>();
    this.konamiId = misc.isNull("konami_id") ? -1 : misc.getInt("konami_id");
    this.hasEffect = misc.isNull("has_effect") ? false : boolean(misc.getInt("has_effect"));
    this.atkDisplay = misc.isNull("question_atk") ? str(this.atk) : "?";
    this.defDisplay = misc.isNull("question_def") ? str(this.def) : "?";
    for (int i = 0; i < misc.getJSONArray("formats").size(); i++){
      this.formats.add(misc.getJSONArray("formats").getString(i));
    }
  }
  
  
  
  
  
  
  
  
  
  
  
  
}
