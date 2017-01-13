/*
POISSION STIMULATION TEST
*/

// SPECIFY PARAMETERS FOR STIMULATION FOR ALL PINS

const int numChan = 4; // Number of channels to be used
int myPins[] = {0, 1, 2, 3}; // What pins will be used?

boolean ledState[numChan];
long previousTime[numChan];
// Fill values for empty parameter vectors

// SPECIFY PARAMETERS FOR RANDOM STIMULATION
float lambdaON[] = {50, 15, 300, 20}; // this is the poission parameter for the distrubtion of on times which is poth the mean and the std dev
float lambdaOFF[] = {100, 10, 300, 55}; // lambda for off times
float nextTime[] = {0.0, 0.0, 0.0, 0.0};

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  for (int i = 0; i < numChan; i++){
    pinMode(myPins[i], OUTPUT);
    ledState[i] = HIGH;
    previousTime[i] = 0;
  }

}

void loop() {

// method for oscillating stimulation
unsigned long currentTime = millis();

  for (int i = 0; i < numChan; i++){
      if(ledState[i] == HIGH) {
        if (currentTime > nextTime[i]) {
              ledState[i] = LOW;
              digitalWrite(myPins[i], ledState[i]);
              float k = poiss(lambdaOFF[i]); // pick a Off duration using lamda off
              nextTime[i] = currentTime + k;
        }
     }

       if(ledState[i] == LOW) {
        if (currentTime > nextTime[i]) {
              ledState[i] = HIGH;
              digitalWrite(myPins[i], ledState[i]);
              float k = poiss(lambdaON[i]); // pick a On duration using lamda on
              nextTime[i] = currentTime + k;
        }
     }
  }




}

  // method for possion stimulation
        float poiss(float lambda)
      {
        return 1000*60*(-log(1.0f - random(RAND_MAX) / ((float)RAND_MAX + 1)) / lambda);
      }
