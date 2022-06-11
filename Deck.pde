class Deck {

  int maxCards;
  ArrayList<Card> cards;
  JSONObject multValues;
  JSONObject currentTypeCounts;
  JSONObject maxTypeCounts;
  JSONObject typeConversion;

  Deck(int m_) {
    this.maxCards = m_;
    this.cards = new ArrayList<Card>();
    this.multValues = new JSONObject();
    this.currentTypeCounts = new JSONObject();
    this.maxTypeCounts = new JSONObject();
    this.typeConversion = new JSONObject();
    this.setCurrentTypeCounts();
    this.typeConversion.setString("Spell Card", "Spell");
    this.typeConversion.setString("Effect Monster", "Effect");
    this.typeConversion.setString("Normal Monster", "Normal");
    this.typeConversion.setString("Flip Effect Monster", "Effect");
    this.typeConversion.setString("Trap Card", "Trap");
    this.typeConversion.setString("Union Effect Monster", "Effect");
    this.typeConversion.setString("Fusion Monster", "Fusion");
    this.typeConversion.setString("Pendulum Effect Monster", "Effect");
    this.typeConversion.setString("Link Monster", "");
    this.typeConversion.setString("XYZ Monster", "");
    this.typeConversion.setString("Synchro Monster", "");
    this.typeConversion.setString("Synchro Tuner Monster", "");
    this.typeConversion.setString("Tuner Monster", "Effect");
    this.typeConversion.setString("Gemini Monster", "");
    this.typeConversion.setString("Normal Tuner Monster", "Normal");
    this.typeConversion.setString("Spirit Monster", "");
    this.typeConversion.setString("Ritual Effect Monster", "Ritual");
    this.typeConversion.setString("Skill Card", "");
    this.typeConversion.setString("Token", "");
    this.typeConversion.setString("Ritual Monster", "Ritual");
    this.typeConversion.setString("Toon Monster", "Effect");
    this.typeConversion.setString("Pendulum Normal Monster", "");
    this.typeConversion.setString("Synchro Pendulum Effect Monster", "");
    this.typeConversion.setString("Pendulum Tuner Effect Monster", "");
    this.typeConversion.setString("XYZ Pendulum Effect Monster", "");
    this.typeConversion.setString("Pendulum Effect Fusion Monster", "");
    this.typeConversion.setString("Pendulum Effect Ritual Monster", "");
    this.typeConversion.setString("Pendulum Flip Effect Monster", "");
  }

  void setMultValues(float multTraps, float multSpells, float multNormal, float multEffect, float multRitual, float multFusion) {
    this.multValues.setFloat("Trap", multTraps);
    this.multValues.setFloat("Spell", multSpells);
    this.multValues.setFloat("Normal", multNormal);
    this.multValues.setFloat("Effect", multEffect);
    this.multValues.setFloat("Ritual", multRitual);
    this.multValues.setFloat("Fusion", multFusion);
  }

  void setCurrentTypeCounts() {
    this.currentTypeCounts.setInt("Trap", 0);
    this.currentTypeCounts.setInt("Spell", 0);
    this.currentTypeCounts.setInt("Normal", 0);
    this.currentTypeCounts.setInt("Effect", 0);
    this.currentTypeCounts.setInt("Ritual", 0);
    this.currentTypeCounts.setInt("Fusion", 0);
  }

  void setMaxTypeCounts(int maxTrap, int maxSpell, int maxNormal, int maxEffect, int maxRitual, int maxFusion) {
    this.maxTypeCounts.setInt("Trap", maxTrap);
    this.maxTypeCounts.setInt("Spell", maxSpell);
    this.maxTypeCounts.setInt("Normal", maxNormal);
    this.maxTypeCounts.setInt("Effect", maxEffect);
    this.maxTypeCounts.setInt("Ritual", maxRitual);
    this.maxTypeCounts.setInt("Fusion", maxFusion);
  }

  int getNumCards() {
    return this.cards.size();
  }

  boolean addCards(ArrayList<Card> cardList, JSONObject banList) {
    if (this.maxCards == 0) return false;
    Collections.shuffle(cardList);
    for (int i = 0; i < cardList.size(); i++) {
      Card card = cardList.get(i);
      String cardType = this.typeConversion.getString(card.getType());
      if (!cardType.equals("")) {
        int cardsOfCurrentType = this.currentTypeCounts.getInt(cardType);
        int maxOfCurrentType = this.maxTypeCounts.getInt(cardType);
        int banAmount = banList.isNull(str(card.getId())) ? 3 : banList.getInt(str(card.getId()));
        banAmount = banList.isNull(str(card.getKonamiId())) ? banAmount : banList.getInt(str(card.getKonamiId()));
        banAmount = banList.isNull(card.getName()) ? banAmount : banList.getInt(card.getName());
        banAmount = banList.isNull(card.getBetaName()) ? banAmount : banList.getInt(card.getBetaName());
        banAmount = banList.isNull(str(card.getBetaId())) ? banAmount : banList.getInt(str(card.getBetaId()));
        int numCanAdd = min(banAmount, maxOfCurrentType - cardsOfCurrentType, this.maxCards - this.cards.size()) -  Collections.frequency(this.cards, card);
        int numAdded = 0;
        for (int j = 0; j < numCanAdd; j++) {
          if (j == 0) {
            this.cards.add(card);
            numAdded++;
          } else {
            if (random(1) < this.multValues.getFloat(cardType)) {
              this.cards.add(card);
              numAdded++;
            }
          }
        }
        this.currentTypeCounts.setInt(cardType, cardsOfCurrentType + numAdded);
        if (this.cards.size() >= this.maxCards) return false;
      }
    }
    return this.cards.size() < this.maxCards;
  }

  ArrayList<Card> getCards() {
    return this.cards;
  }
  
  void makeYDK(String fileName){
    PrintWriter ydkFile = createWriter(fileName + ".ydk");
    ydkFile.println("#main");
    for (Card card : this.cards){
      ydkFile.println(str(card.getId()));
    }
    ydkFile.println("!side");
    ydkFile.println("!extra");
    ydkFile.flush();
    ydkFile.close();   
  }
  
}
