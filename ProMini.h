#define MAIN_INCLUDED

// Inclusions
//#include "YourLibrary.h"

void setup ()
{
  // Serial
  Serial.begin(115200);
}

void loop ()
{
  delay (1000);
  Serial.println ("AVR Reporting! :D");
}