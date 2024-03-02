#define MAIN_INCLUDED

// Inclusions
#include "src/LibraryTemplate.h" // << Rename this template to whatever your library you develope.


LibraryTemplate LibTemp = LibraryTemplate ();


void setup () // Core 0
{
  // Serial
  delay (1000);
  Serial.begin (115200);
  Serial.println ("");
  Serial.println ("");

  Serial.println (LibTemp.GetHello ()); // Pico doesn't currently reset when serial monitor starts, so you may need to unplug - re-plug for this to show up.
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
