#ifndef LibraryTemplate_H
#define LibraryTemplate_H


#ifdef PCSoftware // When compiling for PC
  #define PROGMEM // This removes PROGMEM keywords for PC

  // PC specific includes here
  #include <cstring>
  #include <cstdint>
#else
  // Shared microcontroller specific includes
  #include <stdint.h>
  #include <Arduino.h>
  
  #ifdef __AVR__
    // AVR specific includes
    #include <avr/pgmspace.h>
  #elif defined(ESP8266) || defined(ESP32)
    // ESP specific includes
    #include <pgmspace.h>
  #elif defined(ARDUINO_ARCH_RP2040)
    // RP2040 specific includes
    #define PROGMEM // This removes PROGMEM keywords for RP2040
  #endif
#endif




class LibraryTemplate
{
  private:
  char * Hello = (char *) "Hello from the library template!";

  public:
  LibraryTemplate () {};
  LibraryTemplate (const char * Str) {strcpy (Hello, Str);};
  ~LibraryTemplate () {};
  
  void SetStr (const char * Str);
  const char * GetHello () const;
};

#endif
