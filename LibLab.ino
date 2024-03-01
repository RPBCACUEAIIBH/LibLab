/* LibLab - For Library development.
  Notes: Leave the .ino file as is! Instead create a YourArchitecture.h file similar to one of ProMini.h, GenericESP12F.h and RPPico.h, and a new entry for your microcontroller's architecture into LibLab.h or re-use one of those if your platform is similar. After that:
    - Open this in Arduino IDE 2.X.X
    - Connect the platforms you want to work on and select appropriate settings.
    - Upload sketch as usual, to make sure it compiles.
    - Connect and select different platform
    - Upload sketch as usual. (The idea is that you should be able to just select your microcontroller in the dropdown box above, and hit upload, and it should work for whatever you selected.)
    - Your library's header file should be #included into each of YourPlatform.h file(s), NOT in here. (The conditional includsion in the LibLab.h file should decide what gets included into the .ino file during compilation.)

    Compile and run Source/Main.cpp to test for PC. (On Ubuntu simply run Build.sh, on windows or mac you may have to set up make, or something similar to build it.)
*/

#include "LibLib.h"