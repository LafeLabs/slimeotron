# [Slimeotron](https://github.com/lafelabs/slimeotron)

### [webeditor.html](webeditor.html)

### An artificial neuron based on the [slimezistor](https://github.com/lafelabs/slimezistor) and the [trash robot](https://www.trashrobot.org) geometron printer.

This project uses one [Arduino Uno](https://en.wikipedia.org/wiki/Arduino_Uno), two [Adafruit Circuit Playground Express](https://learn.adafruit.com/adafruit-circuit-playground-express) boards, a [custom pcb from pcbway](https://www.pcbway.com/project/shareproject/Trash_Robot_main__brain__board.html), 3 [stepper motor boards from pololu robotics](https://www.pololu.com/product/2966), 3 cardboard cubes, and various electronics and art supplies. 

### [link to slimeotron on tiktok](https://www.tiktok.com/@trash_robot/video/7202413835377216814)

### [slimeotron part 2 on tiktok](https://www.tiktok.com/@trash_robot/video/7202754417244818731)



### Processing For Optical neuron Out 0

Audio signals can be turned into pixels which are picked up by the 

This takes the integrated power spectral density(maybe, need to check units) of the incoming audio signal over some band and turns that into a grey scale pixel intensity on a rectangle.  You need to install the library for processing.sound.

```
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
```

### Optical Neuron Arduino Code:


```
int x0;

void setup() {
  // put your setup code here, to run once:
    Serial.begin(9600);
    
}

void loop() {
  // put your main code here, to run repeatedly:

  x0 = analogRead(A8);
  x0 *= 1.5;
  //x0 -= 16;
  if(x0<0){
    x0 = 0;
  }
  if(x0 > 255){
    x0 = 255;
  }
  analogWrite(A0,x0);
  Serial.println(x0); 

}
```

Install the "[minim](https://code.compartmental.net/minim/)" sound library in processing and then copy/past this code from the help from the project page for that to play a test song:


```
/**
  * This sketch demonstrates how to create synthesized sound with Minim using an <code>AudioOutput</code> and the
  * default instrument built into an <code>AudioOutput</code>. By using the <code>playNote</code> method you can 
  * schedule notes to played at some point in the future, essentially allowing to you create musical scores with 
  * code. Because they are constructed with code, they can be either deterministic or different every time. This
  * sketch creates a deterministic score, meaning it is the same every time you run the sketch. It also demonstrates 
  * a couple different versions of the <code>playNote</code> method.
  * <p>
  * For more complex examples of using <code>playNote</code> check out 
  * algorithmicCompExample and compositionExample in the Synthesis folder.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

void setup()
{
  size(512, 200, P3D);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // set the tempo of the sequencer
  // this makes the first argument of playNote 
  // specify the start time in quarter notes
  // and the duration becomes relative to the length of a quarter note
  // by default the tempo is 60 BPM (beats per minute).
  // at 60 BPM both start time and duration can be interpreted as seconds.
  // to retrieve the current tempo, use getTempo().
  out.setTempo( 80 );
  
  // pause the sequencer so our note play back will be rock solid
  // if you don't do this, then tiny bits of error can occur since 
  // the sequencer is running in parallel with you note queueing.
  out.pauseNotes();
  
  // given start time, duration, and frequency
  out.playNote( 0.0, 0.9, 97.99 );
  out.playNote( 1.0, 0.9, 123.47 );
  
  // given start time, duration, and note name  
  out.playNote( 2.0, 2.9, "C3" );
  out.playNote( 3.0, 1.9, "E3" );
  out.playNote( 4.0, 0.9, "G3" );
    
  // given start time and note name or frequency
  // (duration defaults to 1.0)
  out.playNote( 5.0, "" );
  out.playNote( 6.0, 329.63);
  out.playNote( 7.0, "G4" );
  
  // the note offset is simply added into the start time of 
  // every subsequenct call to playNote. It's expressed in beats.
  // to get the current note offset, use getNoteOffset().
  out.setNoteOffset( 8.1 );
  
  // because only given a note name or frequency
  // starttime defaults to 0.0 and duration defaults to 1.0
  out.playNote( "G5" );
  out.playNote( 987.77 );
  
  // now we can start the sequencer again to hear our sequence
  out.resumeNotes();
}

void draw()
{
  background(0);
  stroke(255);
  
  // draw the waveforms
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50 );
    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 );
  }
}
```


### Geometron Hypercube Trajectory:

The robot probe moves in a cube as shown.  An external signal on the A0 pin of the robot control board changes the unit of the cube.  This signal comes from the optical neuron Adafruit circuit playground express board.

![](https://raw.githubusercontent.com/LafeLabs/slimeotron/main/trashmagic/cube-spelling.svg)

![](https://raw.githubusercontent.com/LafeLabs/slimeotron/main/trashmagic/cube.svg)

### Geometron Hypercube Arduino Code

```
char Glyph[] = "H";

int delayus = 3000;//delayMicroseconds(delayus); for each step, 2 ms for 1 step is about 2 ms for 20 microns or 10 microns per ms

int unit = 30;//53 steps = 1 mm, 1 step = 18.9 microns, unit of 106 is 2 mm, 212 is 4 mm, 

//30 is 0.566 mm

int side = unit;

//these are the pin numbers of the buttons on the controller.  Connect to ground to activate.
int xleftPin = 10;
int xrightPin = 7;
int yawayPin = 9;
int ytowardsPin = 8;
int zdownPin = 11;
int zupPin = 12;

int x0 = 0;
int goPin = 6;
int stopPin = 5;

//connect these pins to the MP6500 stepper motor control board:
int dirPin3 = 19;
int stepPin3 = 18;
int enPin3 = 17;
int dirPin1 = 16;
int stepPin1 = 15;

int enPin1 = 13;

int dirPin2 = 2;
int stepPin2 = 3;
int enPin2 = 4;

boolean xleftBool = false;
boolean xrightBool = false;
boolean yawayBool = false;
boolean ytowardsBool = false;
boolean zdownBool = false;
boolean zupBool = false;
boolean goBool = false;
boolean stopBool = false;

int select = 0;

void setup() {

    pinMode(xleftPin,INPUT_PULLUP); 
    pinMode(xrightPin,INPUT_PULLUP); 
    pinMode(yawayPin,INPUT_PULLUP); 
    pinMode(ytowardsPin,INPUT_PULLUP); 
    pinMode(zdownPin,INPUT_PULLUP); 
    pinMode(zupPin,INPUT_PULLUP); 
    pinMode(goPin,INPUT_PULLUP); 
    pinMode(stopPin,INPUT_PULLUP); 

    pinMode(dirPin1,OUTPUT);
    pinMode(stepPin1,OUTPUT);
    pinMode(enPin1,OUTPUT);
    pinMode(dirPin2,OUTPUT);
    pinMode(stepPin2,OUTPUT);
    pinMode(enPin2,OUTPUT);
    pinMode(dirPin3,OUTPUT);
    pinMode(stepPin3,OUTPUT);
    pinMode(enPin3,OUTPUT);

    digitalWrite(dirPin1,LOW);
    digitalWrite(stepPin1,LOW);
    digitalWrite(enPin1,HIGH);
    digitalWrite(dirPin2,LOW);
    digitalWrite(stepPin2,LOW);
    digitalWrite(enPin2,HIGH);
    digitalWrite(dirPin3,LOW);
    digitalWrite(stepPin3,LOW);
    digitalWrite(enPin3,HIGH);
    
    Serial.begin(9600);

}

void loop() { 
  
 
  xleftBool = !digitalRead(xleftPin);
  xrightBool = !digitalRead(xrightPin);
  yawayBool = !digitalRead(yawayPin);
  ytowardsBool = !digitalRead(ytowardsPin);
  zdownBool = !digitalRead(zdownPin);
  zupBool = !digitalRead(zupPin);
  goBool = !digitalRead(goPin);
  stopBool = !digitalRead(stopPin);
  
  if(goBool){
      printGlyph(Glyph); 
  }

  if(xleftBool){
     moveLeft(1);
  }
  if(xrightBool){
     moveRight(1);
  }
  if(zdownBool){
    moveUp(1); 
  }
  if(zupBool){
    moveDown(1); 
  }
  if(yawayBool){
    moveAway(1);
  }
  if(ytowardsBool){
    moveTowards(1);
 }
}

void moveLeft(int nSteps){
     digitalWrite(dirPin1,LOW);
     digitalWrite(enPin1,LOW);
     
     for(int index = 0;index < nSteps;index++){
       digitalWrite(stepPin1,HIGH);
       delayMicroseconds(delayus); 
       digitalWrite(stepPin1,LOW);
       delayMicroseconds(delayus); 

     }          
     digitalWrite(enPin1,HIGH);   
     digitalWrite(enPin2,HIGH);   
}

void moveRight(int nSteps){
     digitalWrite(dirPin1,HIGH);
     digitalWrite(enPin1,LOW);
    
     for(int index = 0;index < nSteps;index++){
       digitalWrite(stepPin1,HIGH);
       delayMicroseconds(delayus); 
       digitalWrite(stepPin1,LOW);
       delayMicroseconds(delayus); 

     }          
     digitalWrite(enPin1,HIGH);   
     digitalWrite(enPin3,HIGH);   

}

void moveDown(int nSteps){
     digitalWrite(dirPin3,HIGH);
     digitalWrite(enPin3,LOW);
     
     for(int index = 0;index < nSteps;index++){
       digitalWrite(stepPin3,HIGH);
       delayMicroseconds(delayus); 
       digitalWrite(stepPin3,LOW);
       delayMicroseconds(delayus); 
     }          
     digitalWrite(enPin1,HIGH);   
     digitalWrite(enPin3,HIGH);   

}

void moveUp(int nSteps){
     digitalWrite(dirPin3,LOW);
     digitalWrite(enPin3,LOW);     
     for(int index = 0;index < nSteps;index++){
       digitalWrite(stepPin3,HIGH);
       delayMicroseconds(delayus); 
       digitalWrite(stepPin3,LOW);
       delayMicroseconds(delayus); 
     }          
     digitalWrite(enPin3,HIGH);    
     digitalWrite(enPin1,HIGH);

}

void moveAway(int nSteps){
     digitalWrite(dirPin2,LOW);
     digitalWrite(enPin2,LOW);
     
     for(int index = 0;index < nSteps;index++){
       digitalWrite(stepPin2,HIGH);
       delayMicroseconds(delayus); 
       digitalWrite(stepPin2,LOW);
       delayMicroseconds(delayus); 
     }          
     digitalWrite(enPin2,HIGH);   
}

void moveTowards(int nSteps){
     digitalWrite(dirPin2,HIGH);
     digitalWrite(enPin2,LOW);
     
     for(int index = 0;index < nSteps;index++){
       digitalWrite(stepPin2,HIGH);
       delayMicroseconds(delayus); 
       digitalWrite(stepPin2,LOW);
       delayMicroseconds(delayus); 
     }          
     digitalWrite(enPin2,HIGH);   
}


void geometronAction(char action){
  
  x0 = analogRead(A0);
  unit = 26 + (52000*x0/1024)/1000;
  side = unit; 
  Serial.println(side); 

  stopBool = !digitalRead(stopPin);
  if(stopBool){
    delay(500);
    while(true){
      if(!digitalRead(goPin)){
        stopBool = false;
        break;
      }
      if(!digitalRead(stopPin)){
        break;
      }
      xleftBool = !digitalRead(xleftPin);
      xrightBool = !digitalRead(xrightPin);
      yawayBool = !digitalRead(yawayPin);
      ytowardsBool = !digitalRead(ytowardsPin);
      zdownBool = !digitalRead(zdownPin);
      zupBool = !digitalRead(zupPin);
      if(xleftBool){
         moveLeft(1);
      }
      if(xrightBool){
         moveRight(1);
      }
      if(zdownBool){
        moveUp(1); 
      }
      if(zupBool){
        moveDown(1); 
      }
      if(yawayBool){
        moveAway(1);
      }
      if(ytowardsBool){
        moveTowards(1);
      }
      
    }
  }
  if(action == 'a'){
     moveRight(side);
  }
  if(action == 'b'){
     moveLeft(side);
  }
  if(action == 'c'){
    moveAway(side);
  }
  if(action == 'd'){
    moveTowards(side);
  }
  if(action == 'e'){
    moveUp(side);
  }
  if(action == 'f'){
    moveDown(side);
  }
  if(action == 'g'){
    side /= 2;
  }
  if(action == 'h'){
    side *= 2;
  }
  if(action == 'A'){
    geometronSequence("efa");//4 mm up and 4 mm down, then move 4 mm right
  }
  if(action == 'B'){
    geometronSequence("efb");//4 mm up 4 mm down, then 4 mm left 
  }
  if(action == 'C'){
    geometronSequence("efc");//4 mm up, 4 mm down, then 4 mm away
  }
  if(action == 'D'){
    geometronSequence("efd");//4 mm up, 4 mm down, 4 mm towards
  }
  if(action == 'E'){
    //geometronSequence("ACBD");//upa an down around in a square of 1 mm, so a 1 mm cube
    geometronSequence("fceafdeb");//up,back,down,right, up,towards, down, left, (1 mm cube)
  }
  if(action == 'F'){
    geometronSequence("EEEEEEEEEE");//10 cubes
  }
  if(action == 'G'){
    geometronSequence("FFFFFFFFFF");//100 cubes
  }
  if(action == 'H'){
    geometronSequence("GGGGGGGGGG");//1000 cubes
  }
}


void printGlyph(char localGlyph[]){
  side=unit;
   for(int index = 0;index <= sizeof(Glyph);index++){
    if(!stopBool){
      geometronAction(localGlyph[index]);    
    }
   }  
}


void geometronSequence(String glyph){
  //for loop thru the String
  int index = 0;
  for(index = 0;index < glyph.length();index++){
    if(!stopBool){
      geometronAction(glyph.charAt(index));      
    }
   }
}
```

### Audio Neuron Code on Arduino:

Circuit playground express code

```

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
```


Install [Processing](https://processing.org) to convert audio signals into pixels to the optical neuron.

## Processing to do:

 - figure out how to record data sets both time and frequency domain for export to other visualization software
 - figure out how to load and visualize recorded data sets in processing
 - figure out how to create 3d visualization of data sets which python can transform into blender files for the artists to work with
 - get a simple neuron link working with a specific FFT component controlling the output level of a big square of pixels on the screen which go from black to white in greyscale
 - get processing to work on the ubuntu machine 
 - and raspberry pi
 - and android



Use this processing code to get an FFT of the audio signal:

```
import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

void setup() {
  size(512, 512);
  background(255);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
}      

void draw() { 
  background(255);
  fft.analyze(spectrum);

  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  line( i, height, i, height - spectrum[i]*height*1500 );
  } 
}

```


### HTML test pixel for input to Optical Neuron:

```
<!DOCTYPE html>
<html>
<head>
<style> 
div {
  width: 700px;
  height: 700px;
  background-color: white;
  animation-name: example;
  animation-duration: 2s;
  animation-iteration-count: 1000; 
}

@keyframes example {
  from {background-color: white;}
  to {background-color: black;}
}
</style>
</head>
<body>

<h1>CSS Animation</h1>

<div></div>


</body>
</html>

```

### Electronics Kit Parts

 - [3 motor controller boards from Pololu(10x3=$30)](https://www.pololu.com/product/2966)
 - [Custom printed circuit board to connect Arduino to controllers and connectors($2/ea in lots of 20 with shipping)](https://www.pcbway.com/project/shareproject/Trash_Robot_main__brain__board.html)
 - [straight 0.1 inch headers from Digikey(buy about 2 per kit at about 60 cents each)](https://www.digikey.com/en/products/detail/chip-quik-inc/HDR100IMP40M-G-V-TH/5978197)
 - [Ribbon cable from Digikey(about $8 for about 6 kits worth for about $2/kit rounding up )](https://www.digikey.com/en/products/detail/assmann-wsw-components/AWG28-20-F-1-300-R/2391636)
 - [8 buttons for controller from Digikey(about $1 for all 8)](https://www.digikey.com/en/products/detail/te-connectivity-alcoswitch-switches/FSM2JRT/529664)
 - [Cables from Digikey to connect stepper motors in DVD drive stages to circuit board(about $10 for 3 of them)](https://www.digikey.com/en/products/detail/molex/2177971043/14637940)
 - [Arduino Uno from Sparkfun($25, some off brand UNOs have power supply problems for this application, test any new board to see if it stalls out)](https://www.sparkfun.com/products/11021)
 - [9 pin socket headers](https://www.digikey.com/en/products/detail/samtec-inc/SSQ-109-03-T-S/1111949)

![](https://pcbwayfile.s3-us-west-2.amazonaws.com/web/21/02/16/1105143577771.png)

![](https://raw.githubusercontent.com/LafeLabs/geometronmagic/main/cube/uploadimages/kit.jpg)

Assemble the kit into a "brain".  

## Control Panel Geometry

[![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/symbolfeed/controller.svg)](https://raw.githubusercontent.com/LafeLabs/hypercube/main/symbolfeed/controller.svg)

![](https://raw.githubusercontent.com/LafeLabs/geometronmagic/main/cube/uploadimages/controller-outside.jpg)

## Assembled Electronics Kit Photo

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/assembledkit.jpg)

![](https://raw.githubusercontent.com/LafeLabs/geometronmagic/main/cube/uploadimages/brain-assembly.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/bottomcutout,jpg)

![](https://i.imgur.com/hz4C54Y.jpg)

![](https://i.imgur.com/hz4C54Y.jpg)

##  DVD drive cables

[Cables from Digikey to connect stepper motors in DVD drive stages to circuit board(about $10 for 3 of them)](https://www.digikey.com/en/products/detail/molex/2177971043/14637940)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/stagesraw.png)

![](https://i.imgur.com/zvVKp6T.jpg)

![](https://i.imgur.com/7KoLTuc.jpg)


## Z axis Stage Assembly


![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/zbase.jpg)

## X and Y axis stage assemblies

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/xystages.jpg)


## Cardboard assembly

Assemble cardboard cubes by first getting large numbers of self-replicating 4 inch squares.  To make one cube we need a set of either 12 or 8 side pieces and either 2 or 3 bottom pieces and 5 plain squares.  

### Side Panel Layout

[![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/symbolfeed/side.svg)](https://raw.githubusercontent.com/LafeLabs/hypercube/main/symbolfeed/side.svg)

Now cut out 3 of the bottom pieces, and stack them into a fifth glued panel. 


![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/cardboardbottom.jpg)


.svg file for laser cutter:

[![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/symbolfeed/bottom.svg)](https://raw.githubusercontent.com/LafeLabs/hypercube/main/symbolfeed/bottom.svg)

Assemble the sides into the base as shown:

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/cardboardcorner.jpg)

Cut out 4 inch squares, print on them, glue them to the panels, and hold it all together with rubber bands:

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/touchgrass.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/dandylion0.png)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/road3cubes.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/zoomcubebox.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/zoomcube2.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/zoomcube3.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/zoomcube4.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/cube-bottom-pattern.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/cube-side-pattern.jpg)

Every cube we produce in the Trash Robot Network is part of the Geometron Hypercube.  Therefore to grow the Hypercube, we produce and distribute as many cubes as we can, and always evolve the cubes to make them better over time and to solve specific problems to bring us closer to Trash Magic.


## Action Geometry Tools: Rulers and Shapes

To make geometric constructions out of cardboard trash, we use the tools of Action Geometry, which are created with the Geometron Language.  These include the ruler, which we cut from 0.2 or 0.25 inch thick neon green acrylic and the shape sets which we cut from 0.1 or 0.125 inch thick neon green acrylic.  

### Geometron Ruler

The Geometron Ruler is one inch by six inches. One side has tenths and the other halves, quarters and eights. The highest quality rulers are made from quarter inch neon green acrylic with a laser cutter.  Any ruler can be used to make more rulers.  Cereal box cardboard is a good material.  Find a maker space or individual with a laser cutter.  Dig through the waste bin to find extra acrylic.  Place the outlines and etch and make rulers.  Give them away and spread the word of Geometron, Trash Magic, Trash Robot and so on.  Also you can use [Ponoko.com](https://www.ponoko.com/) to get large numbers of rulers made and can sell those if you so choose.  

Using Ponoko.com is only cost effective if you have a budget of over 1000 dollars, then the cost per ruler can drop to about a dollar and a half.  Also, Ponoko only has eighth inch acrylic and quarter inch is the nicest.  For best results, go find 0.2 inch or quarter inch neon green acrylic somewhere, find a laser cutter and print these out yourself.  All the files for this are below.  

This is some 6 inch rulers from both green and yellow acrylic and a 15 cm metric ruler.

![](https://raw.githubusercontent.com/LafeLabs/geometronmagic/main/cube/uploadimages/rulers-photo.jpg)

Ruler Outline SVG file:

[![](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruleroutline.svg)](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruleroutline.svg)

Ruler Etch pattern PNG file:  

[![](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruleretch.png)](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruleretch.png)

Ruler 2 color SVG file for Ponoko.com:

[![](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler2color.svg)](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler2color.svg)


Set of 8 rulers in one SVG file for Ponoko.com:

[![](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/rulers8.svg)](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/rulers8.svg)

Centimeters PNG file for etch.  Print out with 15 centimeter width and 2 cm height:

[![](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler-cm-etch.png)](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler-cm-etch.png)

centimeters Ruler Outline SVG file, line up with etch and make 15x2 cm:

[![](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler-cm-outline.svg)](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler-cm-outline.svg)

One ruler with etch and cut in different layers:

[![](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler-cm.svg)](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler-cm.svg)

Set of 8 cm rulers in one SVG file for Ponoko.com:

[![](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler-cm-array.svg)](https://raw.githubusercontent.com/LafeLabs/pibrary/main/factory/rulerimageset/uploadimages/ruler-cm-array.svg)

## Shapes

These shapes are used for constructions based on fundamental symmetries: fourfold, eightfold, threefold, fivefold, and sixfold.  For best results, we cut them out from eight inch neon green acrylic with a laser cutter.

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/shapes.jpg)

![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/uploadimages/shapes2.jpg)
 
.svg file for use in laser cutter.  Each shape has side of 3 inches, so this is a 6 inch wide file:

[![](https://raw.githubusercontent.com/LafeLabs/hypercube/main/symbolfeed/shapes.svg)](https://raw.githubusercontent.com/LafeLabs/hypercube/main/symbolfeed/shapes.svg)

These can all also be constructed using the tools of classical geometry(compass and ruler) or a ruler and a protractor.  So they can be made by hand and cut out from cardboard or paper trash if no laser or acrylic is available.






