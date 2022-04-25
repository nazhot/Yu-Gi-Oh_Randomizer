import java.util.*;
Screen mainScreen;
Screen cardScreen;
Controller controller;
ImageGrid imageTest;
JSONArray allCardsJSON;
ArrayList<Card> cards;

String[] monsterTypes = {"Aqua", "Beast", "Beast-Warrior", "Cyberse", "Dinosaur", "Divine-Beast", "Dragon", "Fairy", "Fiend", "Fish", "Insect", "Machine", "Plant",
  "Psychic", "Pyro", "Reptile", "Rock", "Sea Serpent", "Spellcaster", "Thunder", "Warrior", "Winged Beast", "Wyrm", "Zombie"};

String[] monsterAttributes = {"DARK", "DIVINE", "EARTH", "FIRE", "LIGHT", "WATER", "WIND"};

String[] formats = {"GX", "Stairway", "GOAT", "Speed Duel"};
String[] banLists = {"GX", "Stairway", "GOAT", "Speed Duel"};
String[] setCards = {"Set Cards 1", "Draw Cards", "Staples"};

String[] comparisons = {"<", "<=", "=", ">=", ">"};


float gTextScalar = 0.15;
int horizontalMargin = 5;
int horizontalGap = 5;
int verticalMargin = 5;
int verticalGap = 5;
int rowOneCount = 5;
int rowOneY = 5;
int rowOneHeight = 30;
int rowTwoHorizontalMargin = 15;
int rowTwoHorizontalGap = 25;
int rowTwoY = 150;
int rowTwoCount = 5;
float sliderRadius = 10;


void setup() {
  size(1050, 700);
  //textFont(createFont("Yu-Gi-Oh! Matrix Book", 30)); // 7
  //textFont(createFont("Yu-Gi-Oh! Matrix Small Caps 1", 30)); // 8
  textFont(createFont("Yu-Gi-Oh! Matrix Small Caps 2", 30)); // 8
  //textFont(createFont("StoneSerif-Semibold", 30)); // 5
  //textFont(createFont("Yu-Gi-Oh! ITC Stone Serif Bold Small Caps", 30)); // 8
  //textFont(createFont("Yu-Gi-Oh! ITC Stone Serif LT Italic", 30)); // 6
  //textFont(createFont("FreeMono", 30));
  allCardsJSON = loadJSONArray("data/allCards.json");
  cards = new ArrayList<Card>();
  for (int i = 0; i < allCardsJSON.size(); i++){
    JSONObject object = allCardsJSON.getJSONObject(i);
    cards.add(new Card(object));
  }
  controller = new Controller();
  mainScreen = new Screen();

  mainScreen.addComponent(new Button(width - 120, height - 55, 115, 50)
    .setDrawOrder(200)
    .setName("Randomize")
    .setLabel("Randomize")
    .setTextSize(30)
    .setRounding(10)
    .setFillColor(#fde68a)
    .setHoverColor(#ff8b53)
    .setStrokeWeight(1)
    );

  mainScreen.addComponent(new Button(5, height - 55, 115, 50)
    .setDrawOrder(201)
    .setName("viewCards")
    .setLabel("View Cards")
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
    .setDrawOrder(20)
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
    .setDrawOrder(30)
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
    .setDrawOrder(40)
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
    .setDrawOrder(50)
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
    .setDrawOrder(60)
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
    .setName("multTraps")
    .setTitle("Mult. Traps")
    .setTitlePosition("TOP")
    .setDrawOrder(19)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multSpells")
    .setTitle("Mult. Spells")
    .setTitlePosition("TOP")
    .setDrawOrder(18)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multNormal")
    .setTitle("Mult. Normal")
    .setTitlePosition("TOP")
    .setDrawOrder(17)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multEffect")
    .setTitle("Mult. Effect")
    .setTitlePosition("TOP")
    .setDrawOrder(16)
    .setLineColor(#fde68a)
    );

  buttonColumn++;

  mainScreen.addComponent(new Slider(rowTwoHorizontalMargin + buttonColumn * (rowTwoWidth + rowTwoHorizontalGap), rowTwoY, rowTwoWidth, sliderRadius)
    .setName("multFusion")
    .setTitle("Mult. Fusion")
    .setTitlePosition("TOP")
    .setDrawOrder(15)
    .setLineColor(#fde68a)
    );

  mainScreen.addComponent(new Button(5, 200, 70, 30)
    .setName("atkLabel")
    .setLabel("ATK")
    .setAsLabel(true)
    .setDrawOrder(14)
    .setRounding(5)
    .setFillColor(#fde68a)
    .setTextSize(25)
    );

  mainScreen.addComponent(new DropDown(75, 200, 70, 30)
    .setName("atkCompare")
    .setTitle("")
    .addEntries(comparisons)
    .setRounding(5)
    .setDrawOrder(13)
    .setTitleHorizontalOrientation(CENTER)
    .setEntryHorizontalOrientation(CENTER)
    .setTextSize(35)
    .setTitleStroke(false)
    );

  mainScreen.addComponent(new TextBox(145, 200, 120, 30)
    .setName("atkValue")
    .setTextField("")
    .setRounding(5)
    .setDrawOrder(12)
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
  imageTest = new ImageGrid(22, 0, width * 0.80, height - 1);
  imageTest.setDrawOrder(20).setNumCols(10).setHorizontalGap(0).setName("cards");
  //File cardImageDirectory = new File(sketchPath() + "/data/CardImages");
  //for (File f : cardImageDirectory.listFiles()){
  //  imageTest.addImage(loadImage(sketchPath() + "/data/CardImages/"+ f.getName()));
  //}
  
  cardScreen.addComponent(imageTest);

  controller.addScreen(mainScreen);
  controller.addScreen(cardScreen);
  controller.setCurrentScreen("main");
}


void draw() {
  background(35);
  controller.display();
  if (controller.getCurrentScreenName().equals("card")){
    PImage largeCard = imageTest.getHoveredCard();
    if (largeCard != null){
      image(largeCard, 22 + width * 0.80, 0, width - (22 + width * 0.80), (width - (22 + width * 0.80)) * 1.5);
    }
  }
}


void mousePressed() {
  String test = controller.checkClick();
  if (test.length() > 0) {
    println(test);
    if (test.equals("main:Button:Randomize")) {
      //controller.getCurrentScreen().reset();
      ArrayList<String> randomValues = controller.getValues();
      for (String value : randomValues){
        println(value);
      }
      controller.setCurrentScreen("card");
    } else if (test.equals("card:Button:Back")) {
      controller.setCurrentScreen("main");
    }
  }
}
