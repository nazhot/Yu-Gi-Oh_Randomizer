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
String imageFolder;
String imageExtension;


void setup() {
  size(1050, 700);

  textFont(createFont("Yu-Gi-Oh! Matrix Small Caps 2", 30)); // 8
  imageFolder = dataPath("") + "/CardImagesJPG/";
  imageExtension = ".jpg";
  //textFont(createFont("FreeMono", 30));
  allCardsJSON = loadJSONArray("data/allCards.json");
  banLists = new ArrayList<String>();
  loadBanLists();

  formats = new ArrayList<String>();
  allCards = new ArrayList<Card>();
  ArrayList<String> cardTypes = new ArrayList<String>();
  for (int i = 0; i < allCardsJSON.size(); i++) {
    JSONObject object = allCardsJSON.getJSONObject(i);
    allCards.add(new Card(object));
    if (!cardTypes.contains(allCards.get(allCards.size() - 1).getType())) {
      cardTypes.add(allCards.get(allCards.size() - 1).getType());
    }
    for (String format : allCards.get(allCards.size() - 1).getFormats()) {
      if (!formats.contains(format)) {
        formats.add(format);
      }
    }
  }
  //for (String s : cardTypes) {
  //  println(s);
  //}
  controller = new Controller();
  mainScreen = new Screen();
  viewAllCardsScreen = new Screen();

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

  mainScreen.addComponent(new DropDown(horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setTitle("Monster Type(s): ")
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
    .setEntryVsTitleOrientationPercent(0.5)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setTitle("Monster Attribute(s): ")
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
    .setTitle("Format: ")
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
    .setTitle("Ban List: ")
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
    .setTitle("Set Cards: ")
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
    .setTitle("Mult. Trap")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multSpell")
    .setTitle("Mult. Spell")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multNormal")
    .setTitle("Mult. Normal")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multEffect")
    .setTitle("Mult. Effect")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multFusion")
    .setTitle("Mult. Fusion")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multRitual")
    .setTitle("Mult. Ritual")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
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
    .setTextField("")
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
    .setTextField("")
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
    .setTextField("")
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
    .setTextField("")
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
    .setTextField("")
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
    .setTextField("")
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
    .setTitle("")
    .addEntries(comparisons)
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setTitleHorizontalOrientation(CENTER)
    .setEntryHorizontalOrientation(CENTER)
    .setTextSize(35)
    .setTitleStroke(false)
    );

  mainScreen.addComponent(new TextBox(145, 280, 120, 30)
    .setName("atkValue")
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setTextField("1000")
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
    .setTitle("")
    .addEntries(comparisons)
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setTitleHorizontalOrientation(CENTER)
    .setEntryHorizontalOrientation(CENTER)
    .setTextSize(35)
    .setTitleStroke(false)
    );

  mainScreen.addComponent(new TextBox(410, 280, 120, 30)
    .setName("defValue")
    .setRounding(5)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5)
    .setTextField("1000")
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    );



  mainScreen.setName("main");


  cardScreen = new Screen();

  cardScreen.addComponent(new Button(5, 5, 15, 15)
    .setDrawOrder(30)
    .setName("Back")
    .setLabel("Back")
    .setTextSize(10)
    .setRounding(10)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    );
  cardScreen.setName("card");

  cardScreen.addComponent(new ImageGrid(22, 0, width * 0.80, height - 1)
  .setDrawOrder(20)
  .setNumCols(10)
  .setHorizontalGap(0)
  .setName("cards")
  );

  viewAllCardsScreen.addComponent(new ImageGrid(22, 0, width * 0.80, height - 1)
    .setDrawOrder(20)
    .setNumCols(10)
    .setHorizontalGap(0)
    .setName("cards"));
  viewAllCardsScreen.addComponent(new Button(5, 5, 15, 15)
    .setDrawOrder(30)
    .setName("Back")
    .setLabel("Back")
    .setTextSize(10)
    .setRounding(10)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
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
  if (screenName.equals("card") || screenName.equals("viewAllCards")) {
    ImageGrid tempGrid = (ImageGrid) controller.getCurrentScreen().getInteractable("cards");
    Card largeCard = tempGrid.getHoveredCard();
    if (largeCard != null) {
      PImage largeCardImage = loadImage(imageFolder + largeCard.getId() + imageExtension);
      if (largeCardImage != null) {
        image(largeCardImage, 22 + width * 0.80, 0, width - (22 + width * 0.80), (width - (22 + width * 0.80)) * 1.5);
        textAlign(LEFT, TOP);
        fill(255);
        textSize(20);
        text(largeCard.getDescription(), 24 + width * 0.80, (width - (22 + width * 0.80)) * 1.5, width - (26 + width * 0.80), height - (width - (22 + width * 0.80)) * 1.5);
      }
    }
  }
}


void loadBanLists() {
  File banListFolder = new File(dataPath("") + "/BanLists");
  for (String banListFile : banListFolder.list()) {
    banLists.add(banListFile);
  }
}


void mousePressed() {
  String test = controller.checkClick();
  if (test.length() > 0) {
    println(test);
    if (test.equals("main:Button:Randomize")) {
      //controller.getCurrentScreen().reset();
      ArrayList<String> randomValues = controller.getValues();
      for (String value : randomValues) {
        println(value);
      }
      ImageGrid gridTemp = (ImageGrid) controller.getScreen("card").getInteractable("cards");
      gridTemp.clearScreen();
      Deck deck = makeDeck();
      ArrayList<Card> validCards = deck.getCards();
      deck.makeYDK("tester");
      for (Card card : validCards) {
        gridTemp.addCard(card);
      }
      gridTemp.makeScreens();
      controller.setCurrentScreen("card");
    } else if (test.equals("card:Button:Back")) {
      controller.setCurrentScreen("main");
    } else if (test.equals("viewAllCards:Button:Back")) {
      controller.setCurrentScreen("main");
    } else if (test.equals("main:Button:viewAllCards")) {
      ImageGrid gridTemp = (ImageGrid) controller.getScreen("viewAllCards").getInteractable("cards");
      gridTemp.clearScreen();
      ArrayList<Card> formatCards = getFormatCards();
      println(formatCards.size());
      for (Card card : formatCards) {
        gridTemp.addCard(card);
      }
      gridTemp.makeScreens();
      controller.setCurrentScreen("viewAllCards");
    }
  }
}

void keyPressed() {
  if (controller.getCurrentScreenName().equals("card")) {
    if (key == CODED) {
      ImageGrid tempGrid = (ImageGrid) controller.getCurrentScreen().getInteractable("cards");
      tempGrid.incrementScreen(keyCode);
    }
  } else if (controller.getCurrentScreenName().equals("viewAllCards")) {
    if (key == CODED) {
      ImageGrid tempGrid = (ImageGrid) controller.getCurrentScreen().getInteractable("cards");
      tempGrid.incrementScreen(keyCode);
    }
  }
}
