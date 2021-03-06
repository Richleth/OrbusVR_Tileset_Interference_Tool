class GuiElement {
  private int x1, y1, w, h; //Controls the text area and shape location
  private int shapeStrokeWeight; //Controls stroke weight of the shape
  private int id; //ID of the object
  private int displayCode;
  private int[][] shapeVertices; //2D Array of vertices for the shape (Format: {{x,y},{x,y},{x,y}} )
  private String text; //The text that can be displayed
  private color strokeColor; //Color of lines
  private color fillColor; //Color of fill
  private color textColor; //Color of text
  private boolean border; //Does shape have a border
  private boolean shapeFilled; //Does shape have fill
  private boolean shapeClosed; //Is shape closed
  private boolean textVisibility; //Is text visible
  private boolean hidden = false; //Fully controls button visibility
  private PShape shape; //Controller for the shape
  private GuiElementClickBehavior guiElementBehavior; //Controller for the click behavior 
  private GuiElementDisplayBehavior displayBehavior; //Controller for the display behavior
  private int wLength;
  private float tSize;
  private float c2 = 0.7;

  private void shapeSetup() {
    push();
    strokeWeight(shapeStrokeWeight);
    stroke(strokeColor);
    shape = createShape();
    shape.beginShape();
    println("Shape created for GuiElement id "+id);
    if (!border) {
      shape.setVisible(false);
      println("Shape creation for GuiElement id "+id+": has noStroke()");
    }
    for (int i = 0; i < shapeVertices.length; i++) { // Loop through vertices array to set shape's vertices
      shape.vertex(shapeVertices[i][0]+x1, shapeVertices[i][1]+y1);
      println("Shape creation for GuiElement id "+id+": Vertex created at "+(shapeVertices[i][0])+","+ (shapeVertices[i][1]));
    }
    if (shapeClosed) { // Determine if shape ends closed or not
      shape.endShape(CLOSE);
      println("Shape creation for GuiElement id "+id+": ended CLOSE");
    } else {
      shape.endShape();
      println("Shape creation for GuiElement id "+id+": ended default");
      println(shapeClosed);
    }
    if (!shapeFilled) {
      shape.setFill(false); // Determine if shape is filled or not
      println("Shape creation for GuiElement id "+id+": has noFill()");
    } else {
      shape.setFill(fillColor);
    }
    pop();
  }

  GuiElement(int[] a, int[][] tShapeVertices, int tDisplayCode, String tText, color[] tColors, boolean tBorder, boolean tShapeFilled, 
    boolean tShapeClosed, boolean tTextVisibility, GuiElementClickBehavior behavior, GuiElementDisplayBehavior tDisplayBehavior) {
    float c1 = 0.7;
    x1 = a[0];
    y1 = a[1];
    w = a[2];
    h = a[3];
    shapeStrokeWeight = a[4];
    id = a[5];
    shapeVertices = tShapeVertices;
    displayCode = tDisplayCode;
    text = tText;
    strokeColor = tColors[0];
    fillColor = tColors[1];
    textColor = tColors[2];
    border = tBorder;
    shapeFilled = tShapeFilled;
    shapeClosed = tShapeClosed;
    textVisibility = tTextVisibility;
    shapeSetup();
    guiElementBehavior = behavior;
    displayBehavior = tDisplayBehavior;
    // Dynamic text size
    wLength = text.length();
    tSize = c1*sqrt((w * h)/wLength);
  }
  GuiElement(int[] a, String tText, int tDisplayCode, color[] tColors, boolean tBorder, boolean tShapeFilled, 
    boolean tShapeClosed, boolean tTextVisibility, GuiElementClickBehavior clickBehavior, GuiElementDisplayBehavior tDisplayBehavior, int[][] tShapeVertices) {
    float c1 = 0.7;
    x1 = a[0];
    y1 = a[1];
    w = a[2];
    h = a[3];
    shapeStrokeWeight = a[4];
    id = a[5];
    shapeVertices = tShapeVertices;
    displayCode = tDisplayCode;
    text = tText;
    strokeColor = tColors[0];
    fillColor = tColors[1];
    textColor = tColors[2];
    border = tBorder;
    shapeFilled = tShapeFilled;
    shapeClosed = tShapeClosed;
    textVisibility = tTextVisibility;
    shapeSetup();
    guiElementBehavior = clickBehavior;
    displayBehavior = tDisplayBehavior;
    // Dynamic text size
    wLength = text.length();
    tSize = c1*sqrt((w * h)/wLength);
  }
  GuiElement(PShape tShape, int[] a, String tText, int tDisplayCode, color tTextColor, boolean tTextVisibility, GuiElementClickBehavior clickBehavior, GuiElementDisplayBehavior tDisplayBehavior) {
    float c1 = 0.7;
    x1 = a[0];
    y1 = a[1];
    w = a[2];
    h = a[3];
    shapeStrokeWeight = a[4];
    id = a[5];
    shape = tShape;
    displayCode = tDisplayCode;
    text = tText;
    textColor = tTextColor;
    textVisibility = tTextVisibility;
    shapeSetup();
    guiElementBehavior = clickBehavior;
    displayBehavior = tDisplayBehavior;
    wLength = text.length();
    tSize = c1*sqrt((w * h)/wLength);
  }

  int getButtonLocation(int i) {
    switch(i) {
    case 0:
      return x1;
    case 1:
      return y1;
    case 2:
      return w;
    case 3:
      return h;
    default:
      return 0;
    }
  }

  void setHidden() {
    hidden = true;
  }
  void setVisible() {
    hidden = false;
  }

  void setElementText(String replacementText) {
    text = replacementText;
  }

  void setElementDisplayCode(int code) {
    displayCode = code;
  }

  void display() {
    if (!hidden) {
      noFill();
      //rect(x1,y1,w,h); Rect test command for debugging purposes (click zone hitbox)
      push();
      shape(shape);
      displayBehavior.doDisplayAction(id, displayCode);
      if (textVisibility) {
        wLength = text.length();
        tSize = c2*sqrt((w * h)/wLength);
        fill(textColor);
        textSize(tSize);
        textAlign(CENTER);

        text(text, x1+5, y1+10, w-10, h-10);
      }
      pop();
    }
  }
  void performGuiElementBehavior() {
    if (mouseX >= x1 && mouseY >= y1 && mouseX <= x1+w && mouseY <= y1+h && !hidden) {
      guiElementBehavior.doClickAction(id);
    }
  }
}
