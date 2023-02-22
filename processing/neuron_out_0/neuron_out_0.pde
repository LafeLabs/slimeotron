import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
float minFreq = 500;
float maxFreq = 1500;
float scale = 1.0; // adjust this to change the gain

void setup() {
  size(800, 600);
  background(255);
  
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
  
  // set up the graph
  stroke(0);
  strokeWeight(2);
  fill(255);
  rect(0, 0, width, height);
}

void draw() {
  background(255);
  fft.analyze(spectrum);
  
  // calculate the total integrated power between minFreq and maxFreq
  float totalPower = 0;
  int minIndex = Math.round(minFreq / (44100.0f / bands));
  int maxIndex = Math.round(maxFreq / (44100.0f / bands));
  for(int i = minIndex; i < maxIndex; i++) {
    totalPower += spectrum[i];
  }
  
  // plot the integrated power as a line on a log scale
  println(1000*totalPower);
  background(255); // set background to white
  noStroke(); // disable stroke for the rectangle
  fill(100*totalPower*255); // set fill color to grayscale #808080
  rect(0, 0, width, height); // draw the rectangle
  
}
