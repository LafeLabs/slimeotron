int outpin = 6;
int x0 = 0;//value of analog pin A0
int vmin = 500;//upper voltage trigger to toggle digital LOW
int vmax = 600;//lower voltage trigger to toggle digital HIGH

void setup() {

    pinMode(outpin,OUTPUT);
    digitalWrite(outpin,LOW);
    Serial.begin(9600);

}

void loop() {
  x0 = analogRead(A0);
  if(x0 > vmax){
    digitalWrite(outpin,LOW);  
  }
  if(x0 < vmin){
    digitalWrite(outpin,HIGH);
  }
  Serial.println(x0);
//  delay(1);
}
