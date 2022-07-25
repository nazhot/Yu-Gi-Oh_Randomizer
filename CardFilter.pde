ArrayList<Deck> generateDecks() {
  ArrayList<Deck> decks = new ArrayList<Deck>();


  return decks;
}

ArrayList<Card> getFormatCards() {
  /*
  -Get the current screen
   -Use the components/values from that screen to filter the list by:
   -Formats: check if card has the user picked format in its list of formats
   -Stats: compare atk/def of monster cards to make sure they fit user defined parameters
   -Race/Attribute: compare the race/attribute of monster cards to make sure they fall within the ones the user selected
   */
  Screen currentScreen = controller.getCurrentScreen();
  addToLog(gLogName, "FILTERING CARDS:", gLogFormat);
  ArrayList<Card> cardListForFormat = generateCardList(allCards, currentScreen.getComponent("format").getValue());
  addToLog(gLogName, "After format filter: " + cardListForFormat.size(), gLogSizeFormat);
  cardListForFormat = trimCardListByStats(cardListForFormat,
    currentScreen.getComponent("atkCompare").getValue(),
    currentScreen.getComponent("atkValue").getValue(),
    currentScreen.getComponent("defCompare").getValue(),
    currentScreen.getComponent("defValue").getValue()
    );
  addToLog(gLogName, "After stats filter: " + cardListForFormat.size(), gLogSizeFormat);
  cardListForFormat = trimCardListByRaceOrAttribute(cardListForFormat, currentScreen.getComponent("monsterType").getValue(), "Race");
  addToLog(gLogName, "After race filter: " + cardListForFormat.size(), gLogSizeFormat);
  cardListForFormat = trimCardListByRaceOrAttribute(cardListForFormat, currentScreen.getComponent("monsterAttribute").getValue(), "Attribute");
  addToLog(gLogName, "After attribute filer: " + cardListForFormat.size(), gLogSizeFormat);
  return cardListForFormat;
}


Deck makeDeck() {
  Screen currentScreen = controller.getCurrentScreen();
  ArrayList<Card> cardListForFormat = getFormatCards();

  int maxTrapCards = int(currentScreen.getComponent("trapCountValue").getValue());
  int maxSpellCards = int(currentScreen.getComponent("spellCountValue").getValue());
  int maxNormalCards = int(currentScreen.getComponent("normalCountValue").getValue());
  int maxEffectCards = int(currentScreen.getComponent("effectCountValue").getValue());
  int maxRitualCards = int(currentScreen.getComponent("ritualCountValue").getValue());
  int maxFusionCards = int(currentScreen.getComponent("fusionCountValue").getValue());

  float multTrapCards = float(currentScreen.getComponent("multTrap").getValue());
  float multSpellCards = float(currentScreen.getComponent("multSpell").getValue());
  float multNormalCards = float(currentScreen.getComponent("multNormal").getValue());
  float multEffectCards = float(currentScreen.getComponent("multEffect").getValue());
  float multRitualCards = float(currentScreen.getComponent("multRitual").getValue());
  float multFusionCards = float(currentScreen.getComponent("multFusion").getValue());

  int maxCards = maxTrapCards + maxSpellCards + maxNormalCards + maxEffectCards + maxFusionCards + maxRitualCards;

  Deck deck = new Deck(maxCards);
  deck.setMultValues(multTrapCards, multSpellCards, multNormalCards, multEffectCards, multRitualCards, multFusionCards);
  deck.setMaxTypeCounts(maxTrapCards, maxSpellCards, maxNormalCards, maxEffectCards, maxRitualCards, maxFusionCards);
  int numTrys = 0;
  String banListName = currentScreen.getComponent("banList").getValue();
  JSONObject banListJSON = loadBanList(banListName);
  while (deck.addCards(cardListForFormat, banListJSON) && numTrys < 10) {
    numTrys++;
  }

  return deck;
}

ArrayList<Card> generateCardList(ArrayList<Card> tempList, String format) {
  if (format.equals("")) return tempList; //currently no format selected = every card
  ArrayList<Card> cardList = new ArrayList<Card>();
  for (Card card : tempList) {
    if (card.getFormats().contains(format)) {
      cardList.add(card);
    }
  }
  return cardList;
}

ArrayList<Card> trimCardListByStats(ArrayList<Card> tempList, String defCompare, String defValue, String atkCompare, String atkValue) {
  ArrayList<Card> cardList = new ArrayList<Card>();
  for (Card card : tempList) {
    if (card.compareStat("atk", atkCompare, atkValue) && card.compareStat("def", defCompare, defValue)) cardList.add(card);
  }
  return cardList;
}

ArrayList<Card> trimCardListByRaceOrAttribute(ArrayList<Card> tempList, String list, String compareWhat) {
  if (list.equals("")) return tempList;
  String[] array = list.split(",");
  ArrayList<Card> cardList = new ArrayList<Card>();
  for (Card card : tempList) {
    if (card.compareRaceOrAttribute(array, compareWhat)) cardList.add(card);
  }

  return cardList;
}

JSONObject loadBanList(String fileName) {
  if (fileName.equals("")) return new JSONObject();
  return loadJSONObject(dataPath("") + "/BanLists/" + fileName);
}

void loadBanLists() {
  File banListFolder = new File(dataPath("") + "/BanLists"); //get the names of the files that are in the ban list folder, which are used to both load the ban list, and also to set the name of the banlist
  for (String banListFile : banListFolder.list()) {
    banLists.add(banListFile);
  }
}
