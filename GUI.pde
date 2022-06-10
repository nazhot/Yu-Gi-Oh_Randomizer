import java.util.*;
import java.io.*;

Screen mainScreen; //starting screen with all the options for you to change
Screen cardScreen; //screen that shows the deck generated based on your options
Screen viewAllCardsScreen; //screen that shows ALL cards available with the options selected
Controller controller; //the overall controller, which holds all of the screens

JSONArray allCardsJSON;   //JSONArray that holds all of the cards in yugioh
ArrayList<Card> allCards; //ArrayList holding all of the card objects

String[] monsterTypes = {"Aqua", "Beast", "Beast-Warrior", "Cyberse", "Dinosaur", "Divine-Beast", "Dragon", "Fairy", "Fiend", "Fish", "Insect", "Machine", "Plant",
  "Psychic", "Pyro", "Reptile", "Rock", "Sea Serpent", "Spellcaster", "Thunder", "Warrior", "Winged Beast", "Wyrm", "Zombie"};

String[] monsterAttributes = {"DARK", "DIVINE", "EARTH", "FIRE", "LIGHT", "WATER", "WIND"};

ArrayList<String> formats;  //formats available, based on "formats" list attached to each card in allCardsJSON
ArrayList<String> banLists; //ban lists available, based on files in the /data/BanLists folder

String[] setCards = {"Set Cards 1", "Draw Cards", "Staples"}; //TODO: needs to be updated in V2 to actually do things, both pulling files and having it effect

String[] comparisons = {"<", "<=", "=", ">=", ">"}; //all of the different comparisons that can be done to atk and def


float gTextScalar = 0.15; //the multiple to use when attempting to center text. 0.15 has appeared to be working great for this font
int horizontalMargin = 5; //these are all of the parameters for adjusting the positions of rows of sliders/dropdowns, for easy changing if need be
int horizontalGap = 5;    //TODO: update this to be a lot cleaner
int verticalMargin = 5;
int verticalGap = 5;
int rowOneCount = 5;
int rowOneY = 5;
int rowOneHeight = 30;
int rowTwoHorizontalMargin = 15;
int rowTwoHorizontalGap = 25;
int rowTwoY = 150;
int rowTwoCount = 6;
float sliderRadius = 10;
int rowThreeCount = 6;
int rowThreeY = 200;
float rowThreeLabelPercent = 0.8;
int drawOrder = 100;

String imageFolder; //where the images are stored
String imageExtension; //what the extension is for the images
int gridRows; //421
int gridCols; //421

ArrayList<Deck> randomDecks;

void setup() {
  size(1200, 700);

  textFont(createFont("Yu-Gi-Oh! Matrix Small Caps 2", 30)); // 8

  imageFolder = dataPath("") + "/CardImagesJPG/";
  imageExtension = ".jpg";

  allCardsJSON = loadJSONArray("data/allCards.json");
  banLists = new ArrayList<String>();
  formats = new ArrayList<String>();
  allCards = new ArrayList<Card>();
  randomDecks = new ArrayList<Deck>();
  controller = new Controller();
  mainScreen = new Screen();
  cardScreen = new Screen();
  viewAllCardsScreen = new Screen();



  mainScreen.setName("main");
  cardScreen.setName("card");



  loadBanLists();

  for (int i = 0; i < allCardsJSON.size(); i++) { //make every Card object, and add it to the allCards arrayList, get the formats
    JSONObject object = allCardsJSON.getJSONObject(i);
    Card newCard = new Card(object);
    allCards.add(newCard);
    for (String format : newCard.getFormats()) {
      if (!formats.contains(format)) formats.add(format);
    }
  }

  //Every single component added to all of the screens, working on making this into imports from JSON files instead, to make editing/readability quite a bit easier

  mainScreen.addComponent(new Button(width - 120, height - 55, 115, 50)
    .setDrawOrder(drawOrder--)
    .setName("Randomize")
    .setLabel("Randomize")
    .setTextSize(30)
    .setRounding(10)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setStrokeWeight(1)
    );

  mainScreen.addComponent(new Button(width / 2.0, height - 30, 115, 50)
    .setDrawOrder(drawOrder--)
    .setName("clearAll")
    .setShapeMode(CENTER)
    .setLabel("Clear All")
    .setTextSize(30)
    .setRounding(10)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setStrokeWeight(1)
    );

  mainScreen.addComponent(new Button(5, height - 55, 150, 50)
    .setDrawOrder(drawOrder--)
    .setName("viewAllCards")
    .setLabel("View All Cards")
    .setTextSize(30)
    .setRounding(10)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setStrokeWeight(1)
    );

  float rowOneWidth = (width - horizontalMargin * 2 - (rowOneCount - 1) * horizontalGap) / rowOneCount;
  int buttonColumn = 0;
  println(rowOneWidth);

  mainScreen.addComponent(new DropDown(horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Monster Type(s): ")
    .setName("monsterType")
    .setDrawOrder(drawOrder--)
    .setRounding(5)
    .setTextSize(15)
    .addEntries(monsterTypes)
    .setEntryHeight(20)
    .setEntryWidth(80)
    .setMultiSelect(true)
    .addSelectAll()
    .setEntryHorizontalOrientation(CENTER)
    .setEntryVsTitleOrientationPercent(0.0)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Monster Attribute(s): ")
    .setName("monsterAttribute")
    .setDrawOrder(drawOrder--)
    .setRounding(5)
    .setTextSize(15)
    .addEntries(monsterAttributes)
    .setEntryHeight(20)
    .setEntryWidth(80)
    .setMultiSelect(true)
    .addSelectAll()
    .setEntryHorizontalOrientation(CENTER)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Format: ")
    .setName("format")
    .setDrawOrder(drawOrder--)
    .setRounding(5)
    .setTextSize(15)
    .addEntries(formats)
    .setEntryHeight(20)
    .setEntryWidth(80)
    .setEntryHorizontalOrientation(CENTER)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Ban List: ")
    .setName("banList")
    .setDrawOrder(drawOrder--)
    .setRounding(5)
    .setTextSize(15)
    .addEntries(banLists)
    .setEntryHeight(20)
    .setEntryWidth(80)
    .setEntryHorizontalOrientation(CENTER)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Set Cards: ")
    .setName("setCards")
    .setDrawOrder(drawOrder--)
    .setRounding(5)
    .setTextSize(15)
    .addEntries(setCards)
    .setEntryHeight(20)
    .setEntryWidth(80)
    .setEntryHorizontalOrientation(CENTER)
    );

  float rowTwoWidth = (width - rowTwoHorizontalMargin * 2 - (rowTwoCount - 1) * rowTwoHorizontalGap) / rowTwoCount;
  buttonColumn = 0;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multTrap")
    .setLabel("Mult. Trap")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multSpell")
    .setLabel("Mult. Spell")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multNormal")
    .setLabel("Mult. Normal")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multEffect")
    .setLabel("Mult. Effect")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multFusion")
    .setLabel("Mult. Fusion")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multRitual")
    .setLabel("Mult. Ritual")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    );

  float rowThreeWidth = (width - horizontalMargin * 2 - (rowThreeCount - 1) * horizontalGap) / rowThreeCount;
  float labelWidth = rowThreeWidth * rowThreeLabelPercent;
  float textBoxWidth = rowThreeWidth - labelWidth;
  buttonColumn = 0;

  mainScreen.addComponent(new Button(horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("trapCount")
    .setLabel("Trap Count:")
    .setAsLabel(true)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    );

  mainScreen.addComponent(new TextBox(horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("trapCountValue")
    .setValue("")
    .setRounding(5)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("spellCount")
    .setLabel("Spell Count:")
    .setAsLabel(true)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    );

  mainScreen.addComponent(new TextBox(horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("spellCountValue")
    .setValue("")
    .setRounding(5)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("normalCount")
    .setLabel("Normal Count:")
    .setAsLabel(true)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    );

  mainScreen.addComponent(new TextBox(horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("normalCountValue")
    .setValue("")
    .setRounding(5)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("effectCount")
    .setLabel("Effect Count:")
    .setAsLabel(true)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    );

  mainScreen.addComponent(new TextBox(horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("effectCountValue")
    .setValue("")
    .setRounding(5)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("fusionCount")
    .setLabel("Fusion Count:")
    .setAsLabel(true)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    );

  mainScreen.addComponent(new TextBox(horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("fusionCountValue")
    .setValue("")
    .setRounding(5)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("ritualCount")
    .setLabel("Ritual Count:")
    .setAsLabel(true)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    );

  mainScreen.addComponent(new TextBox(horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("ritualCountValue")
    .setValue("")
    .setRounding(5)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    );


  mainScreen.addComponent(new Button(5, 280, 70, 30)
    .setName("atkLabel")
    .setLabel("ATK")
    .setAsLabel(true)
    .setDrawOrder(drawOrder--)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    );

  mainScreen.addComponent(new DropDown(75, 280, 70, 30)
    .setName("atkCompare")
    .addEntries(comparisons)
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setTitleHorizontalOrientation(CENTER)
    .setEntryHorizontalOrientation(CENTER)
    .setTextSize(35)
    .setTitleStroke(true)
    );

  mainScreen.addComponent(new TextBox(145, 280, 120, 30)
    .setName("atkValue")
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setValue("1000")
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    );

  mainScreen.addComponent(new Button(270, 280, 70, 30)
    .setName("defLabel")
    .setLabel("DEF")
    .setAsLabel(true)
    .setDrawOrder(drawOrder--)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    );

  mainScreen.addComponent(new DropDown(340, 280, 70, 30)
    .setName("defCompare")
    .addEntries(comparisons)
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setTitleHorizontalOrientation(CENTER)
    .setEntryHorizontalOrientation(CENTER)
    .setTextSize(35)
    .setTitleStroke(true)
    );

  mainScreen.addComponent(new TextBox(410, 280, 120, 30)
    .setName("defValue")
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setValue("1000")
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    );

  mainScreen.addComponent(new Button(535, 280, 120, 30)
    .setName("numDecks")
    .setLabel("Num. Decks:")
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setAsLabel(true)
    .setTextSize(25)
    );

  mainScreen.addComponent(new TextBox(655, 280, 40, 30)
    .setName("numDecksValue")
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setValue("1")
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)

    );



  cardScreen.addComponent(new Button(5, 5, 15, 15)
    .setDrawOrder(30)
    .setName("Back")
    .setLabel("Back")
    .setTextSize(10)
    .setRounding(10)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    );


  cardScreen.addComponent(new ImageGridCollection(22, 0, width * 0.80, height - 1)
    .setDrawOrder(20)
    .setName("cards")
    .setFillColor(0)
    );

  viewAllCardsScreen.addComponent(new ImageGridCollection(22, 0, width * 0.80, height - 1)
    .setDrawOrder(20)
    .setName("cards")
    .setFillColor(0)
    );
  viewAllCardsScreen.addComponent(new Button(5, 5, 15, 15)
    .setDrawOrder(30)
    .setName("Back")
    .setLabel("Back")
    .setTextSize(10)
    .setRounding(10)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    );

  viewAllCardsScreen.addComponent(new Image(22 + width * 0.80, 0, width - (22 + width * 0.80), (width - (22 + width * 0.80)) * 1.5)
    .setDrawOrder(40)
    .setName("hoveredCard")
    );

  cardScreen.addComponent(new Image(22 + width * 0.80, 0, width - (22 + width * 0.80), (width - (22 + width * 0.80)) * 1.5)
    .setDrawOrder(40)
    .setName("hoveredCard")
    );

  viewAllCardsScreen.addComponent(new Text(24 + width * 0.80, (width - (22 + width * 0.80)) * 1.5, width - (26 + width * 0.80), height - (width - (22 + width * 0.80)) * 1.5)
    .setDrawOrder(50)
    .setName("cardDescription")
    .setTextColor(color(255))
    .setTextSize(17)
    );

  cardScreen.addComponent(new Text(24 + width * 0.80, (width - (22 + width * 0.80)) * 1.5, width - (26 + width * 0.80), height - (width - (22 + width * 0.80)) * 1.5)
    .setDrawOrder(50)
    .setName("cardDescription")
    .setTextColor(color(255))
    .setTextSize(17)
    );

  viewAllCardsScreen.setName("viewAllCards");
  controller.addScreen(mainScreen);
  controller.addScreen(cardScreen);
  controller.addScreen(viewAllCardsScreen);
  controller.setCurrentScreen("main");
}


void draw() {
  background(35);
  controller.display();
  String screenName = controller.getCurrentScreenName();
  if (screenName.equals("card") || screenName.equals("viewAllCards")) { //check if the screen is either of the two that shows cards, and if so set the image/description for the side pane
    ImageGrid tempGrid = (ImageGrid) controller.getCurrentScreen().getInteractable("cards");
    Card largeCard = tempGrid.getHoveredCard();
    if (largeCard != null) {
      Image tempImage = (Image) controller.getCurrentScreen().getInteractable("hoveredCard");
      tempImage.setImageFileName(imageFolder + largeCard.getId() + imageExtension);
      Text tempText = (Text) controller.getCurrentScreen().getInteractable("cardDescription");
      tempText.setLabel(largeCard.getDescription());
    }
  }
}


void loadBanLists() {
  File banListFolder = new File(dataPath("") + "/BanLists"); //get the names of the files that are in the ban list folder, which are used to both load the ban list, and also to set the name of the banlist
  for (String banListFile : banListFolder.list()) {
    banLists.add(banListFile);
  }
}


void mousePressed() {
  String test = controller.checkClick();
  if (test.length() > 0) {
    println(test);
    if (test.equals("main:Button:Randomize")) { //MAKE DECKS SETUP
      ArrayList<String> randomValues = controller.getValues();
      Screen cardScreen = controller.getScreen("card");
      for (String value : randomValues) {
        println(value);
      }
      ImageGridCollection gridTemp = (ImageGridCollection) cardScreen.getInteractable("cards");
      cardScreen.removeComponents("deck");
      gridTemp.clearScreen();
      gridTemp.setIndex(0);
      randomDecks.clear();
      int numDecks = 1;
      try {
        numDecks = Integer.parseInt(controller.getCurrentScreen().getInteractable("numDecksValue").getValue());
      } catch(NumberFormatException e){
        println("Error with number of decks input: defaulting to 1");
      }
      ArrayList<Card> validCards = new ArrayList<Card>();
      for (int i = 0; i < numDecks; i++){
        Deck deck = makeDeck();
        randomDecks.add(deck);
        validCards.addAll(deck.getCards());
        deck.makeYDK("random" + str(i + 1));
        cardScreen.addComponent(new Button(0, 40 + i * 22, 20, 20)
        .setLabel(str(i + 1))
        .setName("deck" + str(i))
        );
      }
      for (Card card : validCards) {
        gridTemp.addCard(card);
      }
      String banListName = controller.getCurrentScreen().getInteractable("banList").getValue();
      JSONObject banListJSON = loadBanList(banListName);
      gridTemp.makeScreens(banListJSON);
      controller.setCurrentScreen("card");
    } else if (test.equals("card:Button:Back")) {
      controller.setCurrentScreen("main");
    } else if (test.equals("viewAllCards:Button:Back")) {
      controller.setCurrentScreen("main");
    } else if (test.equals("main:Button:viewAllCards")) { //VIEW ALL CARDS SETUP
      ImageGridCollection gridTemp = (ImageGridCollection) controller.getScreen("viewAllCards").getInteractable("cards");
      gridTemp.clearScreen();
      gridTemp.setIndex(0);
      ArrayList<Card> formatCards = getFormatCards();
      println(formatCards.size());
      for (Card card : formatCards) {
        gridTemp.addCard(card);
      }
      String banListName = controller.getCurrentScreen().getInteractable("banList").getValue();
      JSONObject banListJSON = loadBanList(banListName);
      gridTemp.makeScreens(banListJSON);
      controller.setCurrentScreen("viewAllCards");
    } else if (test.equals("main:Button:clearAll")) { //CLEAR ALL
      controller.getCurrentScreen().reset();
    }
  }
}

void keyPressed() {
  if (controller.getCurrentScreenName().equals("card") || controller.getCurrentScreenName().equals("viewAllCards")) {
    if (key == CODED) {
      ImageGridCollection tempGrid = (ImageGridCollection) controller.getCurrentScreen().getInteractable("cards");
      tempGrid.incrementScreen(keyCode);
    }
  }
}
