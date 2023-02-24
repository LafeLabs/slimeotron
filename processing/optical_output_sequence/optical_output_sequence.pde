int[] colors = {
  0xff000000,  // black
  0xff404040,  // dark gray
  0xff808080,  // gray
  0xffb0b0b0,  // light gray
  0xffffffff  // white
};

int[] colorDurations = {
  1000,  // black duration
  500,  // dark gray duration
  250,  // gray duration
  120,  // light gray duration
  1000   // white duration
};

int currentColorIndex = 0;
int currentColor = colors[currentColorIndex];
int colorDuration = colorDurations[currentColorIndex];
int colorChangeTime = 0;

void setup() {
  size(600, 600);
}

void draw() {
  background(255);  // clear the background

  // change color when the current color duration has elapsed
  if (millis() - colorChangeTime >= colorDuration) {
    currentColorIndex = (currentColorIndex + 1) % colors.length;
    currentColor = colors[currentColorIndex];
    colorDuration = colorDurations[currentColorIndex];
    colorChangeTime = millis();
  }

  // draw the square with the current color
  fill(currentColor);
  rect(0, 0, width, height);
}
