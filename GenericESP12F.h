#define MAIN_INCLUDED

// Inclusions
#include "src/LibraryTemplate.h" // << Rename this template to whatever your library you develope.

/*  ESP12F Generic Module Settings
  - Upload Speed: 115200
  - Crystal Frequency: 26MHz
  - Debug Port: Disabled
  - Flash Size: 4MB (FS:2MB OTA:~1019KB)
  - Flash Frequency: 80MHz
  - Flash Mode: DOUT
  - lwIP Variant: V2 Lower Memory
  - Builtin LED: 2
  - Debug Level: none
  - MMU: 32KB cache + 32KB IRAM
  - Non-32 Bit Access: Use pgm_read macros for IRAM/PROGMEM
  - Reset Method: dtr (aka NodeMCU)
  - Espressif FW: nonos-sdk-2.2.1+119
  - SSL Support: All SSL ciphers
  - Stack Protection: Disabled
  - VTables: Flash
  - Erase Sketch: (as needed...)
  - CPU Frequency: 160MHz

  ESP12F module labeld as ESP8266MOD with Espressif logo may fail to wake form deep sleep with GPIO 16 connected to RST, but NOT the older AI Thinker variant.
  (Something's wrong with the internal reset circuit... It also needs double reset to wake on button press.)
  The solution is an additional 10k pullup to SD0(MISO). More on that here: https://github.com/esp8266/Arduino/issues/6007
*/


LibraryTemplate LibTemp = LibraryTemplate ();


void setup ()
{
  // Serial
  Serial.begin (115200);
  Serial.println ();
  Serial.println ();
  Serial.println (LibTemp.GetHello ());
}

void loop ()
{
  Serial.println ("ESP8266 Reporting! :D");
  delay (1000);
}
