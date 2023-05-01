import processing.javafx.*;

import java.util.*;
import java.io.*;
import SimpleGUI.*;

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

String gLogFormat = "%y:%M:%d-%h:%m:%s %u %a";
String gLogSizeFormat = "%ys %Ms %ds %hs %ms %ss %us %a";
String gLogName = "log";

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


ArrayList<Deck> randomDecks;

void setup() {
  size(1200, 700);
  addToLog(gLogName, "#########################START PROGAM#########################", "%a");
  textFont(createFont("Yu-Gi-Oh! Matrix Regular Small Caps 2.ttf", 30)); // 8
  println(CENTER);
  imageFolder = dataPath("") + "/CardImagesJPG/";
  imageExtension = ".jpg";
  
  allCardsJSON = loadJSONArray("data/allCards.json");
  banLists = new ArrayList<String>();
  formats = new ArrayList<String>();
  allCards = new ArrayList<Card>();
  randomDecks = new ArrayList<Deck>();
  controller = new Controller(this);
  mainScreen = new Screen(this, "0w", "0h", "1w", "1h");
  cardScreen = new Screen(this, "0w", "0h", "1w", "1h");
  viewAllCardsScreen = new Screen(this, "0w", "0h", "1w", "1h");

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
  addToLog(gLogName, "(" + banLists.size() + ") ban lists loaded!", gLogFormat);
  addToLog(gLogName, "(" + allCards.size() + ") total cards loaded!", gLogSizeFormat);
  addToLog(gLogName, "(" + formats.size() + ") different formats found! " + formats.toString(), gLogSizeFormat);

  //Every single component added to all of the screens, working on making this into imports from JSON files instead, to make editing/readability quite a bit easier

  mainScreen.addComponent(new Button(this, width - 120, height - 55, 115, 50)
    .setDrawOrder(drawOrder--)
    .setName("Randomize")
    .setLabel("Randomize")
    .setTextSize(30)
    .setRounding(10.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setStrokeWeight(1)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new Button(this, width / 2.0, height - 30.0, 115.0, 50.0)
    .setDrawOrder(drawOrder--)
    .setName("clearAll")
    .setShapeMode(CENTER)
    .setLabel("Clear All")
    .setTextSize(30)
    .setRounding(10.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setStrokeWeight(1)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new Button(this, 5, height - 55, 150, 50)
    .setDrawOrder(drawOrder--)
    .setName("viewAllCards")
    .setLabel("View All Cards")
    .setTextSize(30)
    .setRounding(10.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setStrokeWeight(1)
    .setTextScalar(gTextScalar)
    );

  float rowOneWidth = (width - horizontalMargin * 2 - (rowOneCount - 1) * horizontalGap) / rowOneCount;
  int buttonColumn = 0;
  println(rowOneWidth);

  mainScreen.addComponent(new DropDown(this, horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Monster Type(s): ")
    .setName("monsterType")
    .setDrawOrder(drawOrder--)
    .setRounding(5.0)
    .setTextSize(15)
    .addEntries(monsterTypes)
    .setEntryHeight("20a")
    .setEntryWidth("80a")
    .setMultiSelect(true)
    .addSelectAll()
    .setEntryHorizontalOrientation(CENTER)
    .setEntryVsTitleOrientationPercent(0.0)
    .setFillColor(#fde68a)
    .setSelectedColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(this, horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Monster Attribute(s): ")
    .setName("monsterAttribute")
    .setDrawOrder(drawOrder--)
    .setRounding(5.0)
    .setTextSize(15)
    .addEntries(monsterAttributes)
    .setEntryHeight("20a")
    .setEntryWidth("80a")
    .setMultiSelect(true)
    .addSelectAll()
    .setEntryHorizontalOrientation(CENTER)
    .setFillColor(#fde68a)
    .setSelectedColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(this, horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Format: ")
    .setName("format")
    .setDrawOrder(drawOrder--)
    .setRounding(5.0)
    .setTextSize(15)
    .addEntries(formats)
    .setEntryHeight("20a")
    .setEntryWidth("80a")
    .setEntryHorizontalOrientation(CENTER)
    .setFillColor(#fde68a)
    .setSelectedColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(this, horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Ban List: ")
    .setName("banList")
    .setDrawOrder(drawOrder--)
    .setRounding(5.0)
    .setTextSize(15)
    .addEntries(banLists)
    .setEntryHeight("20a")
    .setEntryWidth("80a")
    .setEntryHorizontalOrientation(CENTER)
    .setFillColor(#fde68a)
    .setSelectedColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;
  mainScreen.addComponent(new DropDown(this, horizontalMargin + (rowOneWidth + horizontalGap) * buttonColumn, rowOneY, rowOneWidth, rowOneHeight)
    .setLabel("Set Cards: ")
    .setName("setCards")
    .setDrawOrder(drawOrder--)
    .setRounding(5.0)
    .setTextSize(15)
    .addEntries(setCards)
    .setEntryHeight("20a")
    .setEntryWidth("80a")
    .setEntryHorizontalOrientation(CENTER)
    .setFillColor(#fde68a)
    .setSelectedColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );

  float rowTwoWidth = (width - rowTwoHorizontalMargin * 2 - (rowTwoCount - 1) * rowTwoHorizontalGap) / rowTwoCount;
  buttonColumn = 0;

  mainScreen.addComponent(new Slider(this, rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multTrap")
    .setLabel("Mult. Trap")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    .setSlideFillColor(#bc5a84)
    .setSlideStrokeColor(#a086b7)
    .setSlideStrokeWeight(2)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(this, rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multSpell")
    .setLabel("Mult. Spell")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    .setSlideFillColor(#bc5a84)
    .setSlideStrokeColor(#a086b7)
    .setSlideStrokeWeight(2)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(this, rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multNormal")
    .setLabel("Mult. Normal")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    .setSlideFillColor(#bc5a84)
    .setSlideStrokeColor(#a086b7)
    .setSlideStrokeWeight(2)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(this, rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multEffect")
    .setLabel("Mult. Effect")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    .setSlideFillColor(#bc5a84)
    .setSlideStrokeColor(#a086b7)
    .setSlideStrokeWeight(2)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(this, rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multFusion")
    .setLabel("Mult. Fusion")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    .setSlideFillColor(#bc5a84)
    .setSlideStrokeColor(#a086b7)
    .setSlideStrokeWeight(2)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(this, rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multRitual")
    .setLabel("Mult. Ritual")
    .setTitlePosition("TOP")
    .setDrawOrder(drawOrder--)
    .setLineColor(#fde68a)
    .setTextSize(25)
    .setTextColor(#bc5a84)
    .setSlideFillColor(#bc5a84)
    .setSlideStrokeColor(#a086b7)
    .setSlideStrokeWeight(2)
    .setTextScalar(gTextScalar)
    );

  float rowThreeWidth = (width - horizontalMargin * 2 - (rowThreeCount - 1) * horizontalGap) / rowThreeCount;
  float labelWidth = rowThreeWidth * rowThreeLabelPercent;
  float textBoxWidth = rowThreeWidth - labelWidth;
  buttonColumn = 0;

  mainScreen.addComponent(new Button(this, horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("trapCount")
    .setLabel("Trap Count:")
    .setAsLabel(true)
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("trapCountValue")
    .setValue("")
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setRounding(5.0)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(this, horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("spellCount")
    .setLabel("Spell Count:")
    .setAsLabel(true)
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("spellCountValue")
    .setValue("")
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(this, horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("normalCount")
    .setLabel("Normal Count:")
    .setAsLabel(true)
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("normalCountValue")
    .setValue("")
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(this, horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("effectCount")
    .setLabel("Effect Count:")
    .setAsLabel(true)
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("effectCountValue")
    .setValue("")
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(this, horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("fusionCount")
    .setLabel("Fusion Count:")
    .setAsLabel(true)
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("fusionCountValue")
    .setValue("")
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  buttonColumn++;

  mainScreen.addComponent(new Button(this, horizontalMargin + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, labelWidth, 30)
    .setName("ritualCount")
    .setLabel("Ritual Count:")
    .setAsLabel(true)
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, horizontalMargin + labelWidth + buttonColumn * (rowThreeWidth + horizontalGap), rowThreeY, textBoxWidth, 30)
    .setName("ritualCountValue")
    .setValue("")
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setDrawOrder(drawOrder--)
    .setTextScalar(gTextScalar)
    );


  mainScreen.addComponent(new Button(this, 5, 280, 70, 30)
    .setName("atkLabel")
    .setLabel("ATK")
    .setAsLabel(true)
    .setDrawOrder(drawOrder--)
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new DropDown(this, 75, 280, 70, 30)
    .setName("atkCompare")
    .addEntries(comparisons)
    .setRounding(5.0)
    .setDrawOrder(drawOrder--)
    .setTitleHorizontalOrientation(CENTER)
    .setEntryHorizontalOrientation(CENTER)
    .setTextSize(35)
    .setTitleStroke(true)
    .setFillColor(#fde68a)
    .setSelectedColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, 145, 280, 120, 30)
    .setName("atkValue")
    .setRounding(5.0)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setValue("1000")
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new Button(this, 270, 280, 70, 30)
    .setName("defLabel")
    .setLabel("DEF")
    .setAsLabel(true)
    .setDrawOrder(drawOrder--)
    .setRounding(5.0)
    .setFillColor(#fde68a)
    .setTextSize(25)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new DropDown(this, 340, 280, 70, 30)
    .setName("defCompare")
    .addEntries(comparisons)
    .setRounding(5.0)
    .setDrawOrder(drawOrder--)
    .setTitleHorizontalOrientation(CENTER)
    .setEntryHorizontalOrientation(CENTER)
    .setTextSize(35)
    .setTitleStroke(true)
    .setFillColor(#fde68a)
    .setSelectedColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, 410, 280, 120, 30)
    .setName("defValue")
    .setRounding(5.0)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setValue("1000")
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new Button(this, 535, 280, 120, 30)
    .setName("numDecks")
    .setLabel("Num. Decks:")
    .setRounding(5.0)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setAsLabel(true)
    .setTextSize(25)
    .setTextScalar(gTextScalar)
    );

  mainScreen.addComponent(new TextBox(this, 655, 280, 40, 30)
    .setName("numDecksValue")
    .setRounding(5.0)
    .setDrawOrder(drawOrder--)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setValue("1")
    .setTextSize(30)
    .setHorizontalOrientation(CENTER)
    .setTextScalar(gTextScalar)
    );



  cardScreen.addComponent(new Button(this, 5, 5, 15, 15)
    .setDrawOrder(30)
    .setName("Back")
    .setLabel("Back")
    .setTextSize(10)
    .setRounding(10.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );


  cardScreen.addComponent(new ImageGridCollection(this, 22, 0, width * 0.80, height - 1)
    .setDrawOrder(20)
    .setName("cards")
    .setFillColor(0)
    .setTextScalar(gTextScalar)
    );

  viewAllCardsScreen.addComponent(new ImageGridCollection(this, 22, 0, width * 0.80, height - 1)
    .setDrawOrder(20)
    .setName("cards")
    .setFillColor(0)
    .setTextScalar(gTextScalar)
    );
  viewAllCardsScreen.addComponent(new Button(this, 5, 5, 15, 15)
    .setDrawOrder(30)
    .setName("Back")
    .setLabel("Back")
    .setTextSize(10)
    .setRounding(10.0)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setTextScalar(gTextScalar)
    );

  viewAllCardsScreen.addComponent(new Image(this, 22 + width * 0.80, 0, width - (22 + width * 0.80), (width - (22 + width * 0.80)) * 1.5)
    .setDrawOrder(40)
    .setName("hoveredCard")
    .setTextScalar(gTextScalar)
    );

  cardScreen.addComponent(new Image(this, 22 + width * 0.80, 0, width - (22 + width * 0.80), (width - (22 + width * 0.80)) * 1.5)
    .setDrawOrder(40)
    .setName("hoveredCard")
    .setTextScalar(gTextScalar)
    );

  viewAllCardsScreen.addComponent(new Text(this, 24 + width * 0.80, (width - (22 + width * 0.80)) * 1.5, width - (26 + width * 0.80), height - (width - (22 + width * 0.80)) * 1.5)
    .setDrawOrder(50)
    .setName("cardDescription")
    .setTextColor(color(255))
    .setTextSize(17)
    .setTextScalar(gTextScalar)
    );

  cardScreen.addComponent(new Text(this, 24 + width * 0.80, (width - (22 + width * 0.80)) * 1.5, width - (26 + width * 0.80), height - (width - (22 + width * 0.80)) * 1.5)
    .setDrawOrder(50)
    .setName("cardDescription")
    .setTextColor(color(255))
    .setTextSize(17)
    .setTextScalar(gTextScalar)
    );

  viewAllCardsScreen.setName("viewAllCards");
  controller.addScreen(mainScreen);
  controller.addScreen(cardScreen);
  controller.addScreen(viewAllCardsScreen);
  controller.setCurrentScreen("main");
}


void draw() {
  background(35);
  controller.draw();
  String screenName = controller.getCurrentScreenName();
  if (screenName.equals("card") || screenName.equals("viewAllCards")) { //check if the screen is either of the two that shows cards, and if so set the image/description for the side pane
    ImageGridCollection tempGrid = (ImageGridCollection) controller.getCurrentScreen().getComponent("cards");
    Card largeCard = tempGrid.getHoveredCard();
    if (largeCard != null) {
      Image tempImage = (Image) controller.getCurrentScreen().getComponent("hoveredCard");
      tempImage.setImageFileName(imageFolder + largeCard.getId() + imageExtension);
      Text tempText = (Text) controller.getCurrentScreen().getComponent("cardDescription");
      tempText.setLabel(largeCard.getDescription());
    }
  }
}



void mousePressed() {
  JSONObject temp = controller.checkClick();
  if (temp!= null){
  String test = temp.getString("Screen") + ":" + temp.getString("Type") + ":" + temp.getString("Name");
  println(test);
    //addToLog(gLogName, test, gLogFormat);
    if (test.equals("main:Button:Randomize")) { //MAKE DECKS SETUP
      ArrayList<String> randomValues = controller.getValues();
      Screen cardScreen = controller.getScreen("card");
      addToLog(gLogName, "RANDOMIZING, WITH FOLLOWING VALUES:", gLogFormat);
      for (String value : randomValues) {
        addToLog(gLogName, value, gLogSizeFormat);
      }
      ImageGridCollection gridTemp = (ImageGridCollection) cardScreen.getComponent("cards");
      cardScreen.removeComponents("deck");
      gridTemp.clearScreen();
      gridTemp.setIndex(0);
      randomDecks.clear();
      int numDecks = 1;
      try {
        numDecks = Integer.parseInt(controller.getCurrentScreen().getComponent("numDecksValue").getValue());
      }
      catch(NumberFormatException e) {
        addToLog(gLogName, "Error with number of decks input (" + controller.getCurrentScreen().getComponent("numDecksValue").getValue() + "): defaulting to 1", gLogFormat);
      }
      ArrayList<Card> validCards = new ArrayList<Card>();
      String banListName = controller.getCurrentScreen().getComponent("banList").getValue();
      JSONObject banListJSON = loadBanList(banListName);
      for (int i = 0; i < numDecks; i++) {
        Deck deck = makeDeck();
        randomDecks.add(deck);
        validCards.addAll(deck.getCards());
        deck.makeYDK("random" + str(i + 1));
        gridTemp.addImageGrid(new ImageGrid(this, cardScreen, 22, 0, width * 0.80, height - 1)
          .setDrawOrder(20)
          .setNumCols(10)
          .setHorizontalGap(0)
          .setFillColor(0)
          .addCards(deck.getCards())
          .makeScreens(banListJSON)
          .setName("cardGrid")
          );
        cardScreen.addComponent(new Button(this, 0, 40 + i * 22, 20, 20)
          .setLabel(str(i + 1))
          .setName("deck" + str(i))
          .setFillColor(i == 0 ? #bc5a84 : #fde68a)
          .setHoverColor(#ff8b53)
          );
      }
      //for (Card card : validCards) {
      //  gridTemp.addCard(card);
      //}
      //gridTemp.makeScreens(banListJSON);
      controller.setCurrentScreen("card");
    } else if (test.equals("card:Button:Back")) {
      controller.setCurrentScreen("main");
    } else if (test.equals("viewAllCards:Button:Back")) {
      controller.setCurrentScreen("main");
    } else if (test.contains("Back")){
      controller.setCurrentScreen("main");
    } else if (test.equals("main:Button:viewAllCards")) { //VIEW ALL CARDS SETUP
      ImageGridCollection gridTemp = (ImageGridCollection) controller.getScreen("viewAllCards").getComponent("cards");
      gridTemp.clearScreen();
      gridTemp.setIndex(0);
      ArrayList<Card> formatCards = getFormatCards();
      println(formatCards.size());
      //for (Card card : formatCards) {
      //  gridTemp.addCard(card);
      //}
      String banListName = controller.getCurrentScreen().getComponent("banList").getValue();
      JSONObject banListJSON = loadBanList(banListName);
      gridTemp.addImageGrid(new ImageGrid(this, viewAllCardsScreen, 22, 0, width * 0.80, height - 1)
        .setDrawOrder(20)
        .setNumCols(10)
        .setHorizontalGap(0)
        .setFillColor(0)
        .addCards(formatCards)
        .makeScreens(banListJSON)
        .setName("cardGrid")
        );
      controller.setCurrentScreen("viewAllCards");
    } else if (test.equals("main:Button:clearAll")) { //CLEAR ALL
      controller.getCurrentScreen().reset();
    } else if (temp.getString("Screen").equals("card") && temp.getString("Name").contains("deck")) {
      int deckNumber = int(temp.getString("Screen").substring(4, temp.getString("Name").length()));
      ImageGridCollection tempGrid = (ImageGridCollection) controller.getCurrentScreen().getComponent("cards");
      tempGrid.setIndex(deckNumber);
      int index = 0;
      while (controller.getCurrentScreen().getComponent("deck" + str(index)) != null) {
        if (index == deckNumber) {
          controller.getCurrentScreen().getComponent("deck" + str(index)).setFillColor(#bc5a84);
        } else {
          controller.getCurrentScreen().getComponent("deck" + str(index)).setFillColor(#fde68a);
        }
        index++;
      }
    }
  }
}

void keyPressed() {
  if (controller.getCurrentScreenName().equals("card") || controller.getCurrentScreenName().equals("viewAllCards")) {
    if (key == CODED) {
      ImageGridCollection tempGrid = (ImageGridCollection) controller.getCurrentScreen().getComponent("cards");
      tempGrid.incrementScreen(keyCode);
    }
  }
}
