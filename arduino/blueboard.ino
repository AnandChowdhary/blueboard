#include <SoftwareSerial.h>
// software serial #1: RX = digital pin 10, TX = digital pin 11
SoftwareSerial portOne(8, 9);
long resetTime;
int resetInterval;

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  resetInterval = 10000;
  resetTime = millis() + resetInterval;
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // Start each software serial port
  portOne.begin(9600);
  pinMode(4,OUTPUT);
  digitalWrite(4,HIGH);

}

void loop() {
  // By default, the last intialized port is listening.
  // when you want to listen on a port, explicitly select it:
  portOne.listen();
  
  // while there is data coming in, read it
  // and send to the hardware serial port:
  while (portOne.available() > 0) {
    char inByte = portOne.read();
    Serial.print(inByte);
  }
 //restart();
}

void restart(){
  if (millis() >= resetTime){
    digitalWrite(4,LOW);
    delay(100);
    digitalWrite(4,HIGH);
   // Serial.println("reset");
    resetTime = millis() + resetInterval;
}
}

