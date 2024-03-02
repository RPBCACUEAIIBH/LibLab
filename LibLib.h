// Grand library header
#warning "Compiling Unnamed Library..."

#if ! defined (LIB_INCLUDED) && defined (AVR)
#include "ProMini.h"
#warning "Architecture: AVR"
#endif

#if ! defined (LIB_INCLUDED) && defined (ESP8266)
#include "GenericESP12F.h"
#warning "Architecture: ESP8266"
#endif

#if ! defined (LIB_INCLUDED) && defined (PICO_RP2040)
#include "RPPico.h"
#warning "Architecture: PICO_RP2040"
#endif

// Yest that's right! Parts of my HexaLib library will run on PC as well, which will be very useful if I need PC drivers for my microcontroller projects. :)
#if ! defined (LIB_INCLUDED) && defined (PCSoftware)
#include "PCOnly.h"
#warning "Architecture: PC"
#endif
