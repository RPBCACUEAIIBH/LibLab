#define MAIN_INCLUDED

// Inclusions
#include "src/LibraryTemplate.h" // << Rename this template to whatever your library you develope.


LibraryTemplate LibTemp = LibraryTemplate ();


void setup ()
{
  // Serial
  Serial.begin(115200);
  Serial.println ("");
  Serial.println ("");
  Serial.println (LibTemp.GetHello ());
}

void loop ()
{
  delay (1000);
  Serial.println ("AVR Reporting! :D");
}
