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
//float duty = 1.0/2.0;


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(ledPin, OUTPUT); 
}

void loop()
{
  unsigned long currentTime = millis();
  
  if(currentTime - previousTime > (1000/freq) {
    previousTime = currentTime;
    
    if(ledStat == LOW)
      ledState = HIGH;
    else
      ledState = LOW;
    
    digitalWrite(ledPin, ledState);
  }
}


