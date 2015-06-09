/*
Patrick Horst 2015

Arduino code for PWM driven motorcontroller (ex. HB25)

Commands:
pos [value]  = position: Value 1000 to 2000   [ex. "pos 2000"]
step [value] = smoothness: Value 1 to 50      [ex. "step 20"]
*/

#define SERVO_PIN 8

int currentPosition = 1500;
int commandPosition = 1500;
int tempCommandPos = 1500;
int increment = 5;
byte rotateSpeed = 1;

String commandString, arduinoSendString, arduinoTempSendString;

void setup() 
{
  Serial.begin(9600);
  pinMode(SERVO_PIN, OUTPUT);
  arduinoSendString = String();
  arduinoTempSendString = String();
}

void loop() {
  if (Serial.available()) 
  {
    commandString = Serial.readStringUntil('\n');
    Serial.println(commandString);
    
    // set CommandPosition
    if(commandString.indexOf("pos ") >= 0) 
    {
        String TempPosString = commandString.substring(4, commandString.length());
        tempCommandPos = TempPosString.toInt();
        
        if((tempCommandPos > 2000) || (tempCommandPos < 500)) 
        {
          tempCommandPos = 1500;
        }
        
        commandPosition = tempCommandPos;
        
        // ...
        arduinoTempSendString = "[Arduino]: Position is now: ";
        arduinoSendString = arduinoTempSendString + commandPosition;
        Serial.println(arduinoSendString);
      
    } 
    // Set increment size
    else if (commandString.indexOf("step ") >= 0) 
    {
        String TempStepString = commandString.substring(5, commandString.length());
        
        increment = TempStepString.toInt();
        
        arduinoTempSendString = "[Arduino]: Step size is now: ";
        arduinoSendString = arduinoTempSendString + increment;
        Serial.println(arduinoSendString);
        
    } 
    // else error - wrong command...
    else 
    {
        Serial.println("Error: Wrong command recieved!");
    }
  }
  
  if (commandPosition > currentPosition)
  {
     currentPosition = currentPosition + increment;
     Serial.println(currentPosition, DEC);
     rotate();
  }
 
  if (commandPosition < currentPosition)
  {
     currentPosition = currentPosition - increment;
     Serial.println(currentPosition, DEC);
     rotate();
  }
  
  if (commandPosition == currentPosition) 
  {
     currentPosition = commandPosition;
     rotate();
     delay(100);
  }
  delay(1);
}

void rotate() 
{
  digitalWrite(SERVO_PIN, HIGH);
  delayMicroseconds(currentPosition);
  digitalWrite(SERVO_PIN, LOW);
  delayMicroseconds(20);
}
