void cutDownJSON() {
  JSONObject preJSON = loadJSONObject("largeAllCards.json");
  JSONArray jsonArray = preJSON.getJSONArray("data");
  JSONArray newJsonArray = new JSONArray();
  for (int i = 0; i < jsonArray.size(); i++) {
    JSONObject object = jsonArray.getJSONObject(i);
    object.remove("card_sets");
    object.remove("card_images");
    object.remove("card_prices");
    object.getJSONArray("misc_info").getJSONObject(0).remove("views");
    object.getJSONArray("misc_info").getJSONObject(0).remove("viewsweek");
    object.getJSONArray("misc_info").getJSONObject(0).remove("upvotes");
    object.getJSONArray("misc_info").getJSONObject(0).remove("downvotes");
    newJsonArray.setJSONObject(i, object);
  }

  saveJSONArray(newJsonArray, "allCards.json");
}

void addFormats(String fileName, String formatName) {
  JSONArray all = loadJSONArray("data/allCards.json");
  ArrayList<String> cardsNotAdded = new ArrayList<String>();
  String[] fileLines = loadStrings(fileName);
  for (String f : fileLines) {
    cardsNotAdded.add(f);
  }
  for (int i = 0; i < all.size(); i++) {
    JSONObject cardJSON = all.getJSONObject(i);
    Card card = new Card(cardJSON);
    for (String fileLine : fileLines) {
      if (card.checkCard(fileLine)) {
        boolean alreadyInFormat = false;
        for (int j = 0; j < cardJSON.getJSONArray("misc_info").getJSONObject(0).getJSONArray("formats").size(); j++) {
          if (cardJSON.getJSONArray("misc_info").getJSONObject(0).getJSONArray("formats").getString(j).equals(formatName)) {
            alreadyInFormat = true;
            cardsNotAdded.remove(fileLine);
            break;
          }
        }
        if (!alreadyInFormat) {
          cardJSON.getJSONArray("misc_info").getJSONObject(0).getJSONArray("formats").append(formatName);
          cardsNotAdded.remove(fileLine);
        }
      }
    }
  }
  saveJSONArray(all, dataPath("") + "/allCards.json");
  for (String f : cardsNotAdded){
    println(f);
  }
}


void makeFormatFile(String fileName, String formatName) {
  JSONArray all = loadJSONArray("data/allCards.json");
  PrintWriter newFile = createWriter(fileName);
  for (int i = 0; i < all.size(); i++) {
    JSONObject cardJSON = all.getJSONObject(i);
    JSONArray formats = cardJSON.getJSONArray("misc_info").getJSONObject(0).getJSONArray("formats");
    boolean matchFormat = false;
    for (int j = 0; j < formats.size(); j++) {
      if (formats.getString(j).equals(formatName)) {
        matchFormat = true;
        break;
      }
    }
    if (matchFormat) {
      newFile.println(cardJSON.getString("name"));
    }
  }
  newFile.flush();
  newFile.close();
}

void compareFiles(String file1, String file2) {
  String[] file1Contents = loadStrings(file1);
  String[] file2Contents = loadStrings(file2);
  for (String line1 : file1Contents) {
    boolean bothHave = false;
    for (String line2 : file2Contents) {
      if (line1.toLowerCase().equals(line2.toLowerCase())) {
        bothHave = true;
        break;
      }
    }
    if (!bothHave) {
      println(line1);
    }
  }
}
