ArrayList<Deck> generateDecks() {
  ArrayList<Deck> decks = new ArrayList<Deck>();


  return decks;
}

ArrayList<Card> getFormatCards() {
  Screen currentScreen = controller.getCurrentScreen();
  ArrayList<Card> cardListForFormat = generateCardList(allCards, currentScreen.getInteractable("format").getValue());
  println("First filter: " + cardListForFormat.size());
  cardListForFormat = trimCardListByStats(cardListForFormat,
    currentScreen.getInteractable("atkCompare").getValue(),
    currentScreen.getInteractable("atkValue").getValue(),
    currentScreen.getInteractable("defCompare").getValue(),
    currentScreen.getInteractable("defValue").getValue()
    );
  println("Second filter: " + cardListForFormat.size());
  cardListForFormat = trimCardListByRace(cardListForFormat, currentScreen.getInteractable("monsterType").getValue());
  println("Third filer: " + cardListForFormat.size());
  return cardListForFormat;
}


Deck makeDeck() {
  Screen currentScreen = controller.getCurrentScreen();
  ArrayList<Card> cardListForFormat = getFormatCards();
  int maxTrapCards = int(currentScreen.getInteractable("trapCountValue").getValue());
  int maxSpellCards = int(currentScreen.getInteractable("spellCountValue").getValue());
  int maxNormalCards = int(currentScreen.getInteractable("normalCountValue").getValue());
  int maxEffectCards = int(currentScreen.getInteractable("effectCountValue").getValue());
  int maxRitualCards = int(currentScreen.getInteractable("ritualCountValue").getValue());
  int maxFusionCards = int(currentScreen.getInteractable("fusionCountValue").getValue());
  
  
  float multTrapCards = float(currentScreen.getInteractable("multTrap").getValue());
  float multSpellCards = float(currentScreen.getInteractable("multSpell").getValue());
  float multNormalCards = float(currentScreen.getInteractable("multNormal").getValue());
  float multEffectCards = float(currentScreen.getInteractable("multEffect").getValue());
  float multRitualCards = float(currentScreen.getInteractable("multRitual").getValue());
  float multFusionCards = float(currentScreen.getInteractable("multFusion").getValue());
  
  
  int maxCards = maxTrapCards + maxSpellCards + maxNormalCards + maxEffectCards + maxFusionCards + maxRitualCards;
  //int maxNumberOfCards =
  
  Deck deck = new Deck(maxCards);
  deck.setMultValues(multTrapCards, multSpellCards, multNormalCards, multEffectCards, multRitualCards, multFusionCards);
  deck.setMaxTypeCounts(maxTrapCards, maxSpellCards, maxNormalCards, maxEffectCards, maxRitualCards, maxFusionCards);
  int numTrys = 0;
  String banListName = currentScreen.getInteractable("banList").getValue();
  JSONObject banListJSON;
  if (banListName.equals("")){
    banListJSON = new JSONObject();
  } else {
    banListJSON = loadJSONObject(dataPath("") + "/BanLists/" + banListName);
  }
  while (deck.addCards(cardListForFormat, banListJSON) && numTrys < 100) {
    numTrys++;
  }
  //println("All cards: " + allCards.size());
  //println("Format cards: " + cardListForFormat.size());
  //for (Card card : cardListForFormat) {
  //  //cardScreen.getInteractable("cards").addImage(loadImage("data/CardImages/" + card.getId() + ".png"));
  //  imageTest.addCard(card);
  //}
  //imageTest.makeScreens();



  return deck;
}

ArrayList<Card> generateCardList(ArrayList<Card> tempList, String format) {
  if (format.equals("")) return tempList;
  ArrayList<Card> cardList = new ArrayList<Card>();
  for (Card card : tempList) {
    if (card.getFormats().contains(format)) cardList.add(card);
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

ArrayList<Card> trimCardListByRace(ArrayList<Card> tempList, String races) {
  if (races.equals("")) return tempList;
  String[] racesArray = races.split(",");
  ArrayList<Card> cardList = new ArrayList<Card>();
  for (Card card : tempList) {
    if (card.compareRace(racesArray)) cardList.add(card);
  }

  return cardList;
}
