# [Slimeotron](https://github.com/lafelabs/slimeotron)

### An artificial neuron based on the [slimezistor](https://github.com/lafelabs/slimezistor) and the [trash robot](https://www.trashrobot.org) geometron printer.

### [link to slimeotron on tiktok](https://www.tiktok.com/@trash_robot/video/7202413835377216814)

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

