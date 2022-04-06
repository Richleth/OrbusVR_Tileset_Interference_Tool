void InitLayout() {
  TEXTBOX receiver = new TEXTBOX();
  receiver.W = 500;
  receiver.H = 35;
  receiver.X = 125;
  receiver.trueX = 125;
  receiver.Y = 50;
  textboxes.add(receiver);
}
void drawDropdownMenu() {
  if (nameDropdownMenuOpen) {
    try {
      if (readyToParse == false) {
        println("---Not Ready To Parse---");
      }
      line = reader.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
      println("CATCH IO");
    }
    if (line == null) {
      if (readyToParse == false) {
        frameRate(360);
        println("---Ready To Parse---");
        readyToParse = true;
      }
    } else {
      //Below code allows for dynamic adding of names to a list
      sameName = false;
      String[] pieces = split(line, " "); 
      if (pieces.length >= 7) {
        println("Length Check Success");
        if (pieces[pieces.length-1].equals("(Critical)")) {
          println("length - 1 check");
          addNames(pieces, 2);
        } else if (pieces[1].equals("[Combat]") && ((pieces[pieces.length-2].equals("from") && pieces[pieces.length-3].equals("damage")) || pieces[pieces.length-2].equals("damage"))) {
          //println("fallback");
          addNames(pieces, 1);
        }
      }
    }
  }
}
void addNames(String[] pieces, int arrayIndex) {
  String[] subPieces = split(pieces[pieces.length-arrayIndex], "(");
  if (subPieces.length == 1) {
    println("Success 2a");
    for (int i = 0; i < names.size(); i++) {
      if (subPieces[0].equals(names.get(i))) {
        sameName = true;
        println("SameName");
        break;
      }
    }
    if (!sameName) {
      println("Success 3a");
      try {
        names.add(subPieces[0]);
        playerDropdown.get(ScrollableList.class, "dropdown").clear();
        playerDropdown.get(ScrollableList.class, "dropdown").addItems(names);
      } 
      catch (UnsupportedOperationException e) {
        e.printStackTrace();
      }
    }
  }
} 
void parseCombatLog() {
  try {
    if (readyToParse == false) {
      println("---Not Ready To Parse---");
    }
    line = reader.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line = null;
    println("CATCH IO");
  }
  if (line == null) {
    if (readyToParse == false) {
      frameRate(360);
      println("---Ready To Parse---");
      readyToParse = true;
    }
  } else {
    //Below code allows for dynamic adding of names to a list
    sameName = false;
    String[] pieces = split(line, " "); 
    if (pieces.length >= 7) {
      // println("Length Check Success");
      if (pieces[pieces.length-1].equals("(Critical)") && pieces[pieces.length-2].equals(nameChosen)) {
        // println("length - 1 check");
        float damageWithoutCrit = float(pieces[pieces.length-5])/critDamagePlus;
        testDataController.newDataPoint(damageWithoutCrit, timer);
        //println(damageWithoutCrit);
      } else if (pieces[pieces.length-1].equals(nameChosen) && pieces[1].equals("[Combat]") && ((pieces[pieces.length-2].equals("from") && pieces[pieces.length-3].equals("damage")) || pieces[pieces.length-2].equals("damage"))) {
        //println("fallback");
        testDataController.newDataPoint(float(pieces[pieces.length-4]), timer);
        // println(float(pieces[pieces.length-4]));
      }
    }
  }
}
void parseCombatLogInit() {
  try {
    if (readyToParse == false) {
      println("---Not Ready To Parse---");
    }
    line = reader.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line = null;
    println("CATCH IO");
  }
  if (line == null) {
    if (readyToParse == false) {
      frameRate(360);
      println("---Ready To Parse---");
      readyToParse = true;
    }
  } else {
    //Below code allows for dynamic adding of names to a list
    sameName = false;
    String[] pieces = split(line, " "); 
    if (pieces.length >= 7) {
      //println("Length Check Success");
      if (pieces[pieces.length-1].equals("(Critical)") && pieces[pieces.length-2].equals(nameChosen)) {
        //println("length - 1 check");
        float damageWithoutCrit = float(pieces[pieces.length-5])/critDamagePlus;
        testDataController.newDataPoint(damageWithoutCrit, 1);
        //println(damageWithoutCrit);
        combatStarted = true;
      } else if (pieces[pieces.length-1].equals(nameChosen) && pieces[1].equals("[Combat]") && ((pieces[pieces.length-2].equals("from") && pieces[pieces.length-3].equals("damage")) || pieces[pieces.length-2].equals("damage"))) {
        //println("fallback");
        testDataController.newDataPoint(float(pieces[pieces.length-4]), 1);
        //println(float(pieces[pieces.length-4]));
        combatStarted = true;
      }
    }
  }
}
void addGuiButtonsFromFile() {
  addGuiButtonsFromFileContent();
  while (line2 != null) {
    addGuiButtonsFromFileContent();
  }
}
void addGuiButtonsFromFileContent() {
  try {
    line2 = reader2.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if (line2 == null) {
    // Stop reading because of an error or file is empty
  } else {
    try {
      String[] pieces = splitTokens(line2, "|_");

      if (pieces[0].equals("Example")) {
        //Checking to see if line2 is an example or not
      } else {

        for (int i = 16; i < pieces.length; i+=2) {
          verts.add(new int[]{int(pieces[i]), int(pieces[i+1])});
        }
        int[][] vertsConvert = new int[verts.size()][2];
        for (int i = 0; i < verts.size(); i++) {
          vertsConvert[i] = verts.get(i);
        }
        verts.clear();
        //min 15
        BehaviorFactory factory = new BehaviorFactory(pieces[14]);
        GuiElementClickBehavior clickBehavior = factory.createClickBehavior(pieces[14]);
        GuiElementDisplayBehavior displayBehavior = factory.createDisplayBehavior(pieces[15]);
        color[] colors = {unhex(pieces[7]), unhex(pieces[8]), unhex(pieces[9])};
        guiController.createGuiElement(new int[] {int(pieces[0]), int(pieces[1]), int(pieces[2]), int(pieces[3]), int(pieces[4]), 
          id}, pieces[5], int(pieces[6]), colors, boolean(pieces[10]), boolean(pieces[11]), 
          boolean(pieces[12]), boolean(pieces[13]), clickBehavior, displayBehavior, vertsConvert);
        id++;
      }
    } 
    catch (ArrayIndexOutOfBoundsException e) {
      e.printStackTrace();
    }
  }
}
JSONObject newData() {
  JSONObject damageData = testDataController.returnFloatLists();
  JSONObject controlData = damageData;
  controlData.setString("playerName", nameChosen);
  controlData.setFloat("controlDpsResult", avgDps);
  controlData.setFloat("testDpsResult", avgDps);
  controlData.setJSONArray("testDpsData", damageData.getJSONArray("testDpsData"));
  controlData.setJSONArray("controlDpsData", damageData.getJSONArray("controlDpsData"));

  /*
  Using wrong keys? NEEDS TO BE TESTED
   JSONArray damageDataToReturn = new JSONArray();
   JSONArray frameDataToReturn = new JSONArray();
   JSONArray controlDpsDataToReturn = new JSONArray();
   JSONArray testDpsDataToReturn = new JSONArray();
   
   */

  //Need to calculate data varience here
  controlData.setJSONArray("damagesDelt", damageData.getJSONArray("damagesDelt"));
  //println(controlData.getJSONArray("damagesDelt"));
  controlData.setJSONArray("frameDamageDelt", damageData.getJSONArray("frameDamageDelt"));
  println(controlData, damageData);
  println(controlData.getJSONArray("damagesDelt").size());

  double varience = 0; // Potentially do varience on the AVG Dps values instead || SWAPPED TO AVG DPS VALUES, NEEDS TESTING
  for (int i = 0; i < controlData.getJSONArray("testDpsData").size(); i++) { //testDpsData is always the same as control as what in the player data object gets updated is determined w/ a string
    varience += Math.pow((controlData.getJSONArray("testDpsData").getFloat(i) - avgDps), 2);
    println(varience);
  }
  varience /= controlData.getJSONArray("testDpsData").size();
  println();
  println(varience);
  controlData.setDouble("controlDataVarience", varience); // ARRAY IN ARRAY LIKE [[]] NEEDS TO BE OJBECT IN ARRAY [{}]
  controlData.setDouble("testDataVarience", varience);
  controlData.setJSONObject("tilesets", new JSONObject()); //TO BE IMPLEMENTED LATER
  return controlData;
}
