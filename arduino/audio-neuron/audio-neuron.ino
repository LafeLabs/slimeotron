/* This example samples the microphone for 50 milliseconds repeatedly
 * and returns the max sound pressure level in dB SPL
 * https://en.wikipedia.org/wiki/Sound_pressure
 *
 * open the serial plotter window in the arduino IDE for a nice graph
 * of sound pressure level over time.
 */

#include <Adafruit_CircuitPlayground.h>

int x0 = 0;
float gain = 8.0;
float baseline = 60.0;

void setup() {
  CircuitPlayground.begin();
  Serial.begin(115200);
}

void loop() {
  x0 = int(gain*(CircuitPlayground.mic.soundPressureLevel(10) - baseline));
  if(x0 < 0){
    x0 = 0;
  }
  if(x0 > 255){
    x0 = 255;
  }
  Serial.println(x0);
  for(int index = 0;index < 10;index++){
    CircuitPlayground.setPixelColor(index, x0,   x0,   x0);  
  }
}
