/*
  C. elegans optogenetic control for 8 parallel systems of LED arrays to stimulate c. elegans 
*/

// TODO: 
// SHOULD BE ABLE TO RECEIVE TWO CHARACTERS OF THE SERIAL PORT 
// ONE FOR ON AND ONE FOR OFF
// Test all periodic or all random


// SPECIFY PARAMETERS FOR STIMULATION FOR ALL PINS

// CHANNEL VARIABLES
const int numChan_Periodic = 3;
const int numChan_Poission = 0;

int myPins[] = {0,1,2}; // What pins will be used?
int Periodic_Pins[] = {0,1,2}; // What pins will be used?
int Poission_Pins[] = {}; // What pins will be used?


// SPECIFY PARAMETERS FOR PERIODIC STIMULATION
float omega[] = {1.0/5.0,1.0/5.0,1.0/5.0}; // specify frequency in times per MINUTE
float alpha[] = {1.0/60.0, 1.0/60.0, 1.0/60.0,}; // duty cycle for periodic stim
float periodicON[numChan_Periodic];
float periodicOFF[numChan_Periodic];
float nextTime[numChan_Periodic];

// SPECIFY PARAMETERS FOR RANDOM STIMULATION
float lambdaON[] = {}; // this is the poission parameter for the distrubtion of on times 
float lambdaOFF[] = {}; // lambda for off times


// Initialize other stuff
boolean ledState_Periodic[numChan_Periodic];
boolean ledState_Poission[numChan_Poission];
long previousTime[numChan_Periodic];
unsigned long t;
boolean rig_status = false;

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

if(rig_status){
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
            t = millis();
                Serial.print(t);
                Serial.print(" ");
                Serial.print(Periodic_Pins[i]);
                Serial.print(" ");
                Serial.print("On \n");
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
                Serial.print("Off \n");
  
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
              Serial.print("On \n");
        }
     }
  }
}

 // METHOD FOR TURNING STIMULATION ON AND OFF

  if (Serial.available()>0){
    char input = Serial.read();
    if (input == 'S'){ // "S" was entered - start!
      // Set some variable to a permissve state
      if(~rig_status){
        rig_status = true;      
      }
    }
      
    if(input == 'X'){ // "X" was entered - stop!
      // Set the same variable to a non-permissive state
      if(rig_status){
      rig_status = false;
      // SET ALL PINS TO LOW
        for (int i = 0; i < numChan_Periodic; i++){
          digitalWrite(Periodic_Pins[i], LOW);
        }
    
        for (int i = 0; i < numChan_Poission; i++){
          digitalWrite(Poission_Pins[i], LOW);
        }
      }
    }

  }

}
  // method for geting a duration from a poission distribution
        float poiss(float lambda)
      {
        return 1000*60*(-log(1.0f - random(RAND_MAX) / ((float)RAND_MAX + 1)) / lambda);
      }
