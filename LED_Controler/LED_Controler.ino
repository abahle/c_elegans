/*
  C. elegans optogenetic control for 8 parallel systems of four LEDs
  This
*/

// SPECIFY PARAMETERS FOR STIMULATION FOR ALL PINS
#include <math.h>
#include <stdlib.h>

const int numChan = 4; // Number of channels to be used
int myPins[] = {0,1,2,3}; // What pins will be used?
// SPECIFY PARAMETERS FOR PERIODIC STIMULATION
float omega[] = {10,20,40,40}; // specify frequency in times per MINUTE
float alpha[] = {1.0/5.0, 1.0/5.0, 1.0/5.0, 1.0/5.0}; // specify duty cycle for periodic stim
int on[numChan];
int off[numChan];
boolean ledState[numChan];
long previousTime[numChan];
// Fill values for empty parameter vectors


// SPECIFY PARAMETERS FOR RANDOM STIMULATION
//const int lambda = ; // this is the poission parameter which is poth the mean and the std dev


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  for (int i = 0; i < numChan; i++){
    pinMode(myPins[i], OUTPUT);
    ledState[i] = LOW;
    on[i] = ((1000*60/omega[i])*(alpha[i]));
    off[i] = ((1000*60/omega[i])*(1-alpha[i]));
    previousTime[i] = 0;
  }

}

void loop() {

// method for oscillating stimulation
unsigned long currentTime = millis();

for (int i = 0; i < numChan; i++){
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



