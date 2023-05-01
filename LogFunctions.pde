void addToLog(String logName, String textToAdd, String format) {
  String editedText = format;
  editedText = editedText.replaceAll("%ys", "    ");
  editedText = editedText.replaceAll("%Ms", "  ");
  editedText = editedText.replaceAll("%ds", "  ");
  editedText = editedText.replaceAll("%hs", "  ");
  editedText = editedText.replaceAll("%ms", "  ");
  editedText = editedText.replaceAll("%ss", "  ");
  if (editedText.contains("%us")) {
    String spaces = "";
    for (int i = 0; i < System.getProperty("user.name").length(); i++) {
      spaces += " ";
    }
    editedText = editedText.replaceAll("%us", spaces);
  }
  editedText = editedText.replaceAll("%y", nf(year(), 4));
  editedText = editedText.replaceAll("%M", nf(month(), 2));
  editedText = editedText.replaceAll("%d", nf(day(), 2));
  editedText = editedText.replaceAll("%h", nf(hour(), 2));
  editedText = editedText.replaceAll("%m", nf(minute(), 2));
  editedText = editedText.replaceAll("%s", nf(second(), 2));
  editedText = editedText.replaceAll("%u", System.getProperty("user.name"));

  editedText = editedText.replaceAll("%a", textToAdd);
  File log = new File(dataPath(logName));
  if (!log.exists()) {
    createFile(log);
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(log, true)));
    out.println(editedText);
    out.flush();
    out.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void createFile(File f) {
  File parentDir = f.getParentFile();
  try {
    parentDir.mkdirs();
    f.createNewFile();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}
