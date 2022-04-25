void cutDownJSON(){
  JSONObject preJSON = loadJSONObject("largeAllCards.json");
  JSONArray jsonArray = preJSON.getJSONArray("data");
  JSONArray newJsonArray = new JSONArray();
  for (int i = 0; i < jsonArray.size(); i++){
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
