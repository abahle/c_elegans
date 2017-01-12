/*
  C. elegans optogenetic control for 8 parallel systems of four LEDs
  This
*/

// Pins
const int numChan = 8;
const int ledPin1 = 0;
const int ledPin2 = 1;
int ledState1 = LOW;
int ledState2 = LOW;
long previousTime1 = 0;
long previousTime2 = 0;
// specify frequency and duty cycle for periodic
const int freq1 = 7;
float alpha1 = 1.0/2.0;
const int freq2 = 3;
float alpha2 = 1.0/4.0;
const int dur1 = ((1000/freq1)*(alpha1));
const int dur2 = ((1000/freq1)*(1-alpha1));
const int dur3 = ((1000/freq2)*(alpha2));
const int dur4 = ((1000/freq2)*(1-alpha2));
// specify parameters for poission
const int lambda = ;


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  for (x = 0; x > numChan; x++)
  pinMode(x, OUTPUT);
}
}

void loop() {

// method for oscillating stimulation
  unsigned long currentTime = millis();

 if(ledState1 == HIGH) {
  if (currentTime - previousTime1 > dur1) {
    previousTime1 = currentTime;
    ledState1 = LOW;
    digitalWrite(ledPin1, ledState1);
  }
 }
    if(ledState1 == LOW ) {
    if (currentTime - previousTime1 > dur2) {
      previousTime1 = currentTime;
      ledState1 = HIGH;
      digitalWrite(ledPin1, ledState1);
    }
  }

// method for possion stimulation




}
