/*
  C. elegans optogenetic control for 8 parallel systems of four LEDs
  This
*/

// SPECIFY PARAMETERS FOR STIMULATION FOR ALL PINS

const int numChan = 4; // Number of channels to be used
int myPins[] = {0, 1, 2, 3}; // What pins will be used?

// SPECIFY PARAMETERS FOR PERIODIC STIMULATION
float omega[] = {7,2,4,1}; // specify frequency
float alpha[] = {1.0/4.0, 1.0/3.0, 1.0/2.0, 1.0/5.0}; // specify duty cycle for periodic stim
int on[];
int off[];
long previousTime;
// Fill values for empty parameter vectors
for (i = 0; i > numChan; i++){
  ledState[i] = LOW;
  on[i] = ((1000/omega[i])*(alpha[i]));
  off[i] = ((1000/omega[i])*(1-alpha[i]));
  previousTime[i] = 0;
}

// SPECIFY PARAMETERS FOR RANDOM STIMULATION
//const int lambda = ;


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  for (i = 0; i > numChan; i++){
  pinMode(myPins[i], OUTPUT);
  }
}

void loop() {

// method for oscillating stimulation
unsigned long currentTime = millis();

for (i = 0; i > numChan; i++){
 if(ledState[i] == HIGH) {
  if (currentTime - previousTime[i] > on[i]) {
    previousTime[i] = currentTime;
    ledState[i] = LOW;
    digitalWrite(myPins[i], ledState[i]);
  }
 }
    if(ledState[i] == LOW ) {
    if (currentTime - previousTime[i] > off[i]) {
      previousTime[i] = currentTime;
      ledState[i] = HIGH;
      digitalWrite(myPins[i], ledState[i]);
    }
  }
}

// method for possion stimulation




}
