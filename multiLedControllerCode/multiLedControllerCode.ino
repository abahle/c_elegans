
void setup() {
  Serial.begin(115200);
  //for (int j=0; j<28; j++)
  //  pinMode(j, OUTPUT);
}




void loop() {
  if (Serial.available()>1){
    char pin = Serial.read()-65;
    char val = (Serial.read()-48)*255/9;
    Serial.print((int) pin);
    Serial.print(" ");
    Serial. println((int) val);
    if (pin >=0 && pin <= 25){
      analogWrite(pin, val);
      //Serial.println("Writing high!");
    }
  }
}
