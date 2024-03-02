/* LibLab - For Library development.
  Notes: Leave the .ino file as is! Instead create a YourArchitecture.h file similar to one of ProMini.h, GenericESP12F.h and RPPico.h, and a new entry for your microcontroller's architecture into LibLab.h or re-use one of those if your platform is similar. After that:
    - Open this in Arduino IDE 2.X.X
    - Connect the platforms you want to work on and select appropriate settings.
    - Upload sketch as usual, to make sure it compiles.
    - Connect and select different platform
    - Upload sketch as usual. (The idea is that you should be able to just select your microcontroller in the dropdown box above, and hit upload, and it should work for whatever you selected.)
    - Your library's header file should be #included into each of YourPlatform.h file(s), NOT in here. (The conditional includsion in the LibLab.h file should decide what gets included into the .ino file during compilation.)

    - You find a library template in the src subdirectry. (my AI assistant said that arduino IDE compiles .ino, .cpp, .h files for A. directly from the project directory, src subdirectory, or libraries folder.)
    - PC files are in Source, and Source/Core subdirectories. Those should not be compiled by the arduino IDE. Build.sh uses Build subdirectory for PC version, thus the 2 projects can coexist.

    Compile and run Source/Main.cpp to test for PC.
    - On Ubuntu open a terminal, enter the LibLab directory and run Build.sh with --rebuild-all option at first. (Once built, it's faster to build without --rebuild-all option since it checks for modified files, but sometimes it helps to rebuild all when build fails. It's fast enough anyway since it's a relatively "simple" multi threaded shell script using g++ without all the bells and wistles of make, that may slow it down. Dependencies, libraries, source directories, program name, and build options, as well as thread limit can be changed easily in Build.conf.)
    
    (On windows or mac you may have to set up make or something similar to build it. Do note that Build.sh passes -Wc++11-compat -fno-exceptions -DPCSoftware to g++ when building the library template for PC, but not for the entire project... Arduino compatible stuff should be C++ 11 without throwing exception, and no trri. -fno-rtti is also required for arduino, but for performance and simplicity reasons Build.sh passes it to g++ for the entire project. -DPCSoftware is required since #define PCSoftware is not seen by the library since it's compiled before Main.cpp, so you must pass it to g++ in advance to avoid including microcontroller specific stuff when compiling the library for PC.)
*/

#include "LibLib.h"