
/*
 ADXL3xx 3-axis accelerometer example for Educational BoosterPack MK II
 http://boosterpackdepot.info/wiki/index.php?title=Educational_BoosterPack_MK_II
 
 Absolute rating/conversion can be determined from the ADXL3xx datasheet.
 As a quick reference, for LaunchPads with 12-bit ADC (MSP430F5529, Tiva C, etc.), 
 the entire analog  range is [0,4096]. For simple tilting calculation 
 [-1g,1g] ~ = [mid-800, mid + 800] = [2048-800,2048+800] = [1248,2848]
 
 Modified from ADXL3xx example by David A. Mellis & Tom Igoe
 
 Reads an Analog Devices ADXL3xx accelerometer and communicates the
 acceleration to the computer.  The pins used are designed to be easily
 compatible with the breakout boards from Sparkfun, available from:
 http://www.sparkfun.com/commerce/categories.php?c=80

 http://www.arduino.cc/en/Tutorial/ADXL3xx

 The circuit:

 * analog 25: z-axis
 * analog 24: y-axis
 * analog 23: x-axis
 
 created 2 Jul 2008
 by David A. Mellis
 modified 30 Aug 2011
 by Tom Igoe 
 modified 03 Dec 2013
 by Dung Dang
 
 This example code is in the public domain.

*/


// Rundora (Accelerometer and Heartrate)


const int zpin = 25;                  // z-axis (only on 3-axis models)
int vals[20];
int count=0; //for pace 
int count2=0; //for heart rate

volatile int counter =0;

void setup()
{
  // By default MSP432 has analogRead() set to 10 bits. 
  // This Sketch assumes 12 bits. Uncomment to line below to set analogRead()
  // to 12 bit resolution for MSP432.
  //analogReadResolution(12);

  // initialize the serial communications:
  Serial.begin(9600);
  pinMode(36, INPUT);
  attachInterrupt(36, plus, RISING);
}

void loop()
{
  int curVal = ((int) analogRead(zpin)) - 2048;
  if(count==20){
    count2=count2+1;
    count=0;
    for(int i=0;i<20;i++){
      Serial.print(vals[i]);
      Serial.print("\t");
    }
    //Serial.println(counter);
    //counter=0;
    if(count2==5){
      Serial.print(counter);
      count2=0;
      counter=0;
    }
    else{
      Serial.print(0);
    }
    Serial.println();
  }
  vals[count]=curVal;
  count=count+1;
  // delay before next reading:
  delay(50);
}

void plus(){
  counter++;
}
