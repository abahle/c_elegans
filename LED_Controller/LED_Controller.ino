/*
  C. elegans optogenetic control for 8 parallel systems of LED arrays to stimulate c. elegans 
*/

// TODO: Print on and off times for the random stimulation to serial port so that 
// python can writes this to a file.
// Create a way to toggle the stimulation on and off so that the video program can synchronize
// with and control the stimulation

// SPECIFY PARAMETERS FOR STIMULATION FOR ALL PINS

// CHANNEL VARIABLES
const int numChan_Periodic = 2;
const int numChan_Poission = 2;

int myPins[] = {0,1,2,3}; // What pins will be used?
int Periodic_Pins[] = {0,1}; // What pins will be used?
int Poission_Pins[] = {2,3}; // What pins will be used?
//char stim_type[] = {}; // Which channels to you want to be periodic and


// SPECIFY PARAMETERS FOR PERIODIC STIMULATION
float omega[] = {1000,500}; // specify frequency in times per MINUTE
float alpha[] = {1.0/5.0, 1.0/5.0}; // duty cycle for periodic stim
float periodicON[numChan_Periodic];
float periodicOFF[numChan_Periodic];
float nextTime[numChan_Periodic];

// SPECIFY PARAMETERS FOR RANDOM STIMULATION
float lambdaON[] = {50, 15}; // this is the poission parameter for the distrubtion of on times 
float lambdaOFF[] = {100, 10}; // lambda for off times


// Initialize other stuff
boolean ledState_Periodic[numChan_Periodic];
boolean ledState_Poission[numChan_Poission];
long previousTime[numChan_Periodic];
unsigned long t;

// the setup function runs once when you press reset or power the board
void setup() {
  Serial.begin(115200);
  // initialize digital pin LED_BUILTIN as an output.
  for (int i = 0; i < numChan_Periodic; i++){
    pinMode(Periodic_Pins[i], OUTPUT);
    ledState_Periodic[i] = LOW;
    periodicON[i] = ((1000*60/omega[i])*(alpha[i]));
    periodicOFF[i] = ((1000*60/omega[i])*(1-alpha[i]));
    previousTime[i] = 0;
    nextTime[i] = 0;
  }

    for (int i = 0; i < numChan_Poission; i++){
    pinMode(Poission_Pins[i], OUTPUT);
    ledState_Poission[i] = LOW;
    periodicON[i] = ((1000*60/omega[i])*(alpha[i]));
    periodicOFF[i] = ((1000*60/omega[i])*(1-alpha[i]));

  }

}

void loop() {

// method for oscillating stimulation
unsigned long currentTime = millis();

//PERIODIC STIMULATION METHODS
for (int i = 0; i < numChan_Periodic; i++){
 if(ledState_Periodic[i] == HIGH) {
  if (currentTime - previousTime[i] > periodicON[i]) {
    previousTime[i] = currentTime;
    ledState_Periodic[i] = LOW;
    digitalWrite(Periodic_Pins[i], ledState_Periodic[i]);
  }
 }
    if(ledState_Periodic[i] == LOW ) {
    if (currentTime - previousTime[i] > periodicOFF[i]) {
      previousTime[i] = currentTime;
      ledState_Periodic[i] = HIGH;
      digitalWrite(Periodic_Pins[i], ledState_Periodic[i]);
    }
  }
}

// RANDOM STIMULATION METHODS
  for (int i = 0; i < numChan_Poission; i++){
      if(ledState_Poission[i] == HIGH) {
        if (currentTime > nextTime[i]) {
              ledState_Poission[i] = LOW;
              digitalWrite(Poission_Pins[i], ledState_Poission[i]);
              float k = poiss(lambdaOFF[i]); // pick a Off duration using lamda off
              nextTime[i] = currentTime + k;
              t = millis();
              Serial.print(t);
              Serial.print(" ");
              Serial.print(Poission_Pins[i]);
              Serial.print(" ");
              Serial.print("Turned Off \n");

        }
     }

       if(ledState_Poission[i] == LOW) {
        if (currentTime > nextTime[i]) {
              ledState_Poission[i] = HIGH;
              digitalWrite(Poission_Pins[i], ledState_Poission[i]);
              float k = poiss(lambdaON[i]); // pick a On duration using lamda on
              nextTime[i] = currentTime + k;
              t = millis();
              Serial.print(t);
              Serial.print(" ");
              Serial.print(Poission_Pins[i]);
              Serial.print(" ");
              Serial.print("Turned On \n");
        }
     }
  }



}
  // method for possion stimulation
        float poiss(float lambda)
      {
        return 1000*60*(-log(1.0f - random(RAND_MAX) / ((float)RAND_MAX + 1)) / lambda);
      }
