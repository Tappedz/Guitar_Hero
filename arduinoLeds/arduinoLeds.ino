//PROYECTO GUITAR HERO
#include <FastLED.h>
//#include <Thread.h>
//#include <Firmata.h>

#define DATA_PIN  2   
#define PIN_BUTTON_VERDE  3
#define PIN_BUTTON_ROJO 4
#define PIN_BUTTON_AMARILLO 5
#define PIN_BUTTON_AZUL 6
#define  VibrationCoin1 8
#define  VibrationCoin2 9
#define  VibrationCoin3 10

unsigned long startTime = 0; 
unsigned long vibrationDuration = 250;

#define NUM_LEDS  40
#define DELAY_INTERVAL 250
CRGB leds[NUM_LEDS];

int previousButtonState_AZUL= HIGH;
int previousButtonState_ROJO= HIGH;
int previousButtonState_AMARILLO= HIGH;
int previousButtonState_VERDE= HIGH;

void setup(){
  leds[0] = CRGB::Green;
  leds[19] = CRGB::Red;
  leds[20] = CRGB::Yellow;
  leds[39] = CRGB::Blue;
  FastLED.setBrightness(50);
  FastLED.addLeds<WS2813, DATA_PIN, GRB>(leds, NUM_LEDS);
  pinMode(VibrationCoin1, OUTPUT);
  pinMode(VibrationCoin2, OUTPUT);
  pinMode(VibrationCoin3, OUTPUT);
  pinMode(PIN_BUTTON_VERDE, INPUT_PULLUP);
  pinMode(PIN_BUTTON_ROJO, INPUT_PULLUP);
  pinMode(PIN_BUTTON_AMARILLO, INPUT_PULLUP);
  pinMode(PIN_BUTTON_AZUL, INPUT_PULLUP);

  Serial.begin(9600);

  
}

void loop() {
   int buttonState_AZUL= digitalRead(PIN_BUTTON_AZUL);
   int buttonState_ROJO= digitalRead(PIN_BUTTON_ROJO);
   int buttonState_AMARILLO= digitalRead(PIN_BUTTON_AMARILLO);
   int buttonState_VERDE= digitalRead(PIN_BUTTON_VERDE);
  
  while (Serial.available() > 0) {   // Comprobamos si processing envía un valor
    int inputNumber = Serial.read();
    if(inputNumber >= 0 && inputNumber <= 9) {
      array1(inputNumber);
    }
    else if(inputNumber >= 10 && inputNumber <= 19) {
      array2(inputNumber);
    }
    else if(inputNumber >= 20 && inputNumber <= 29) {
      array3(inputNumber);
    }
    else if(inputNumber >= 30 && inputNumber <= 39) {
      array4(inputNumber);
    }
    else if (inputNumber == 41) {
      startTime = millis();
      digitalWrite(VibrationCoin1, HIGH); 

    }
  }
  if (millis() - startTime >= vibrationDuration) {
    digitalWrite(VibrationCoin1, LOW); 

  } 
  FastLED.show();

  
 if (buttonState_VERDE == LOW && previousButtonState_VERDE == HIGH) {
          Serial.println(0);
          delay(50);

    }

  if (buttonState_ROJO == LOW && previousButtonState_ROJO == HIGH) {
          Serial.println(1);
          delay(50);
    }
    
  if (buttonState_AMARILLO == LOW && previousButtonState_AMARILLO == HIGH) {
          Serial.println(2);
          delay(50);
    }
  if (buttonState_AZUL == LOW && previousButtonState_AZUL == HIGH) {
          Serial.println(3);
          delay(50);
          //leds[39] = CRGB::Blue;
          //FastLED.show();  // send the updated pixel colors to the NeoPixel hardware.
    }
  
  previousButtonState_VERDE = buttonState_AZUL;
  previousButtonState_ROJO = buttonState_ROJO;
  buttonState_AMARILLO = buttonState_AMARILLO;
  previousButtonState_AZUL = buttonState_AZUL;

}
  



void array1(int dot) { 
        //for(int dot = 9; dot >= 0; dot--) { 
  if(dot == 9) {
    leds[dot] = CRGB::Green;
  }
  else {
    leds[dot] = CRGB::Green;
    leds[dot + 1] = CRGB::Black;
  } 
}


void array2(int dot) { 
  if(dot == 1) {
    leds[dot] = CRGB::Red;
  }
  else {
    leds[dot] = CRGB::Red;
    leds[dot - 1] = CRGB::Black;
  } 
}


void array3(int dot) { 
  if(dot == 29) {
    leds[dot] = CRGB::Yellow;
  }
  else {
    leds[dot] = CRGB::Yellow;
    leds[dot + 1] = CRGB::Black;
  } 
}


void array4(int dot) { 
  if(dot == 30) {
    leds[dot] = CRGB::Blue;
  }
  else {
    leds[dot] = CRGB::Blue;
    leds[dot - 1] = CRGB::Black;
  } 
}

/*
  if (millis() - startTime >= vibrationDuration) {
        digitalWrite(VibrationCoin1, LOW);
        startTime = millis();
      } else {
        digitalWrite(VibrationCoin1, HIGH); // Enciende el motor
      }
      */

