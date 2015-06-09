import processing.serial.*;  
import controlP5.*;

ControlP5 controlP5;
Textarea textArea;

Textfield pwm;
String stringP = "";

byte defaultComPort = 0;
int defaultBaudrate = 115200;

//Dropdown lists
DropdownList COMports;                   // Define the variable ports as a Dropdownlist.
Serial serialPort;                       // Define the variable port as a Serial object.
int portNumber = -1;                     // The dropdown list will return a float value, which we will connvert into an int. We will use this int for that.

DropdownList baudrate;
int selectedBaudrate = -1;               // Used to indicate which baudrate has been selected
String[] baudrates = { "1200", "2400", "4800", "9600", "19200", "38400", "57600", "115200" };

boolean connectedSerial;
boolean aborted;

void setup()
{
  controlP5 = new ControlP5(this);
  size(340, 250);
  
  textArea = controlP5.addTextarea("txt").setPosition(110, 110).setSize(220, 130).setLineHeight(14)
    .setColorBackground(color(0,0,0))
    .scroll(1).hideScrollbar();

  PFont font = createFont("arial", 22);
  
  pwm = controlP5.addTextfield("PWM", 10, 65, 85, 35);
  pwm.setFont(font);
  pwm.setFocus(true);
  pwm.setAutoClear(false);

  controlP5.addButton("Submit", 0, 110, 65, 60, 35);

  controlP5.addButton("fullReverse", 0, 10, 130, 85, 30);
  controlP5.addButton("neutral", 0, 10, 170, 85, 30);
  controlP5.addButton("fullForward", 0, 10, 210, 85, 30);

  COMports = controlP5.addDropdownList("COMPort", 10, 25, 100, 200); // Make a dropdown list with all comports
  customize(COMports); // Setup the dropdownlist by using a function

  baudrate = controlP5.addDropdownList("Baudrate", 120, 25, 55, 200); // Make a dropdown with all the available baudrates   
  customize(baudrate); // Setup the dropdownlist by using a function

  controlP5.addButton("Connect", 0, 190, 9, 45, 15);
  controlP5.addButton("Disconnect", 0, 240, 9, 52, 15);
}

void draw() {
  background(200);

  fill(0, 102, 153);
  textSize(16); 
  textAlign(LEFT); 
  text("Set PWM Value:", 10, 55);
}

void fullReverse(int theValue) {
  if (connectedSerial) 
  {
    serialPort.write("pos 1000");
  }
  else
    addTextToTextArea("[Error] Establish a serial connection first!\n");
}

void neutral(int theValue) {
  if (connectedSerial) 
  {
    serialPort.write("pos 1500");
  }
  else
    addTextToTextArea("[Error] Establish a serial connection first!\n");
}

void fullForward(int theValue) {
  if (connectedSerial) 
  {
    serialPort.write("pos 2000");
  }
  else
    addTextToTextArea("[Error] Establish a serial connection first!\n");
}

void Submit(int theValue) {
  if (connectedSerial)
  {    
    String output = "pos " + pwm.getText();
    serialPort.write(output);
    delay(10);
  }
  else
    addTextToTextArea("[Error] Establish a serial connection first!\n");
}

void Clear(int theValue) {
  pwm.clear();
}

void serialEvent(Serial serialPort)
{
  String input = serialPort.readString();
  addTextToTextArea(input);
  serialPort.clear();  // Empty the buffer
}

void addTextToTextArea(String text) {
  String s = textArea.getText();
  s += text;
  textArea.setText(s);
}

void keyPressed() 
{
  if (key == TAB)//'\t'
  {
    if (pwm.isFocus())
    {
      pwm.setFocus(false);
    }
    else
      pwm.setFocus(true);
  }
  else if (key == ENTER) // '\n'
    Submit(0);
}

void customize(DropdownList ddl) 
{
  ddl.setBackgroundColor(color(200));//Set the background color of the line between values
  ddl.setItemHeight(20);//Set the height of each item when the list is opened.
  ddl.setBarHeight(15);//Set the height of the bar itself.

  ddl.captionLabel().style().marginTop = 3;//Set the top margin of the lable.  
  ddl.captionLabel().style().marginLeft = 3;//Set the left margin of the lable.  
  ddl.valueLabel().style().marginTop = 3;//Set the top margin of the value selected.

  if (ddl.name() == "Baudrate")
  {
    ddl.captionLabel().set("Baudrate");
    for (int i=0; i<baudrates.length; i++)
      ddl.addItem(baudrates[i], i); // give each item a value
  }
  else if (ddl.name() == "COMPort")
  {
    ddl.captionLabel().set("Select COM port");//Set the lable of the bar when nothing is selected. 
    //Now well add the ports to the list, we use a for loop for that.
    for (int i=0; i<serialPort.list().length; i++)    
      ddl.addItem(serialPort.list()[i], i);//This is the line doing the actual adding of items, we use the current loop we are in to determin what place in the char array to access and what item number to add it as.
  }
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) 
  {
    if (theEvent.group().name() == "COMPort")     
      portNumber = int(theEvent.group().value());//Since the list returns a float, we need to convert it to an int. For that we us the int() function.    
    else if (theEvent.group().name() == "Baudrate")    
      selectedBaudrate = int(theEvent.group().value());
  }
}
void Connect(int theValue)
{     
  if (selectedBaudrate != -1 && portNumber != -1 && !connectedSerial)//Check if com port and baudrate is set and if there is not already a connection established
  {
    addTextToTextArea("[Note] Connected to Serial\n");    
    serialPort = new Serial(this, Serial.list()[portNumber], Integer.parseInt(baudrates[selectedBaudrate]));
    connectedSerial = true;
    serialPort.bufferUntil('\n');
    serialPort.write("G;"); // Go
  }
  else if (portNumber == -1)
    addTextToTextArea("[Error] Select COM Port first!\n");
  else if (selectedBaudrate == -1)
    addTextToTextArea("[Error] Select baudrate first!\n");
  else if (connectedSerial)
    addTextToTextArea("[Error] Already connected to a port!\n");
}
void Disconnect(int theValue)
{
  if (connectedSerial)//Check if there is a connection established
  {
    addTextToTextArea("[Note] Disconnected from Serial\n");
    serialPort.stop();
    serialPort.clear(); // Empty the buffer
    connectedSerial = false;
  }
  else
    addTextToTextArea("[Error] Couldn't disconnect\n");
}
