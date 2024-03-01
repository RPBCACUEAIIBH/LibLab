#define MAIN_INCLUDED

// Inclusions
//#include "YourLibrary.h"

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

// EEPROM allocation table
const unsigned int EEPROMSize = 4096;
const unsigned int RandomSeedEEPROM = 1020;
//*/

const uint64_t SleepFor = 3000000; // 3s = 3,000,000 us (or 3e6)
uint32_t WakeCounter = 0;


void setup ()
{
  // Serial
  Serial.begin(115200);
  Serial.println ();
  Serial.println ();

  // Log Settings
  //LogSettings (4, 0); // LogLevel, LogGroup(optional)
  //String Msg;

  // Wake Options...
  /*Log ("Reset reason: " + ESP.getResetReason (),3,1);
  if (strcmp (ESP.getResetReason ().c_str (), "Deep-Sleep Wake") == 0)
    ESP.rtcUserMemoryRead (0, &WakeCounter, sizeof (WakeCounter));
  Log ("Wake Count: " + String (WakeCounter),3,1);//*/

  // EEPROM
  /*Msg = F ("Allocating ");
  Msg += String (EEPROMSize);
  Log (Msg + F (" bytes of flash as EEPROM."), 3, 1);
  EEPROM.begin (EEPROMSize);//*/

  // Random seed if needed...
  //RNGInit (RandomSeedEEPROM);

  //Log (F ("Initialisation done!"), 3, 1);
}

void loop ()
{
  Serial.println ("ESP8266 Reporting! :D");
  delay (1000);
  //Log ("ESP8266 Reporting! :D", 3, 1);

  /*Log ("Going to sleep for " + String (SleepFor) + " us...",3,1);
  WakeCounter += 1;
  ESP.rtcUserMemoryWrite (0, &WakeCounter, sizeof (WakeCounter));
  ESP.deepSleep (SleepFor, WAKE_RF_DEFAULT); // Time in us, WAKE_RF_DEFAULT / WAKE_RF_DISABLED
  //*/
}