/*
  C. elegans optogenetic control for 8 parallel systems of four LEDs
  This 
*/

// Pins
const int LED_PIN1 = 0;
const int freq = 1;
float duty = 1.0/2.0;
// frequency and duty cycle for periodic and poisson stimulation

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_PIN1, OUTPUT); 
  //Serial.begin(9600);
  //while (! Serial); // Wait until Serial is ready - Leonardo
  //Serial.println("Enter LED Number 0 to 7 or 'x' to clear");
}

// the loop function runs over and over again forever
void loop() {
       for(int x = 0; x <= freq-1; x++){
      digitalWrite(LED_PIN1, HIGH);   // turn the LED on (HIGH is the voltage level)
      //delay((1000/omega)*alpha);                       // wait for a second
      delay((1000/freq)*duty);
      digitalWrite(LED_PIN1, LOW);    // turn the LED off by making the voltage LOW
      //delay((1000/omega)*(1-alpha)); 
      delay((1000/freq)*(1-duty));
       }
       //how to operate two simulataneously
       
}


