# motor_controller
dc motor controller

wout zweers enschede NL
www.woutzweers.nl
www.wowlab.nl
zweers@dds.nl

created to develop software for 12V 25A DC motor controller
cimg4744 kopieren

introduction:

To control a dc motor several ways are feasible. In general however one method that can be used over and over for different motors is efficient working. It will then not be the best solution for all situations but if the controller is powerfull enough to work for many situations this is acceptable and efficient in the long run.

a suitable controller was found in the powerfull Parallax HB25 controller. This can be controlled conveniently with the cheap arduino (or similar) microcontroller
The software for this controller can be developed cheaply.

this controller receives puls length coded steering signals, similar to servo controller signals. the arduino sends a puls with the appropriate legth to the driver, and the arduino itself can receive various kinds of signals: puls length, -100_ +100%, forward, neutral, backward etc. The code for the arduino is developed as an arduino sketch and uploaded (flashed) through the serial port. After that the arduino can function on itself. 
The signal provided however must be appropriate for this and it is generated with a processing sketch (program) which runs on the computer.

this repository contains a combination of arduino sketches for the arduino and processing sketches to be used on the pc or mac

list of materials:

controller: parallax HB 25 motor controller
https://www.parallax.com/product/29144

motor: any 12V DC motor.

ballast: 12V 1A bulb, for low-amps dc motors

arduino: uno nano or similar clone
download softwar:
http://www.arduino.cc/en/Main/Software

processing
download processing: 
https://processing.org/download/

12V DC power source (used: velleman labps3005D lab power supply or similar)
http://www.velleman.eu/products/view/?id=417862
