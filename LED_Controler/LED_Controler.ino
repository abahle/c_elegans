/*
  C. elegans optogenetic control for 8 parallel systems of four LEDs
  This 
*/

// Pins
const int ledPin = 0;
int ledState = LOW;
long previousTime = 0;
// frequency and duty cycle for periodic and poisson stimulation
const int freq = 1;
float alpha = 1.0/2.0;
const int dur1 = ((1000/freq)*(alpha));
const int dur2 = ((1000/freq)*(1-alpha));



// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(ledPin, OUTPUT); 
}

void loop()
{
  unsigned long currentTime = millis();

  if(ledState == LOW ) {
    if (currentTime - previousTime > dur2) {
      previousTime = currentTime;
      ledState = HIGH;
      digitalWrite(ledPin, ledState);
    }
  }
 if(ledState == HIGH) {
  if (currentTime - previousTime > dur1) {
    previousTime = currentTime;
    ledState = LOW;
    digitalWrite(ledPin, ledState);
  }
 }
    
    
}


