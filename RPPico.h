#define MAIN_INCLUDED

// Inclusions
//#include "YourLibrary.h"



void setup () // Core 0
{
  // Serial
  Serial.begin (115200);
}

void loop () // Core 0
{
  Serial.println ("RP2040 Reporting! :D");
  delay (1000);
}

void setup1 () // Core 1
{
  
}

void loop1 () // Core 1
{
  
}