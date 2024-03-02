#define MAIN_INCLUDED

// Inclusions
#include "Source/Core/Core.h" // I store project files for PC software in Soruce/Core directory, and include all .h files into Core.h to keep main clean.
// I've also hidden some trivial stuff into Core.h (such as includes for thread, chrono, iostream, and using namespace std) to keep this clean.
#include "src/LibraryTemplate.h" // << Rename this template to whatever your library you develope.


LibraryTemplate LibTemp = LibraryTemplate ();

// Familiar? ;)
void setup ()
{
  // This runs at start.
  
  //Serial.begin (115200); << Just kidding... :) Not required for PC!
  cout << LibTemp.GetHello () << "\n"; // Equivalent to: Serial.println ("PC Reporting! :D");
}

void loop ()
{
  // This loops infinitely. (...so the program will run until ctrl + c is pressed to kill it.)
  
  cout << "PC Reporting! :D" << "\n";
  // Sorry no easy blinking LED on PC. Serial equivalent will have to do. :P
  this_thread::sleep_for (chrono::milliseconds (1000)); // Equivalent to: delay (1000); but chrono can do hours, minutes, seconds, milliseconds, microseconds, and even nanoseconds.
  
  // Some good resources for those who want to learn proper C++
  // Very good C++ tutorial playlist: https://www.youtube.com/watch?v=18c3MTX0PK0&list=PLlrATfBNZ98dudnM48yfGUldqGD0S4FFb
  // Language references: https://cplusplus.com/reference/
}



// Proper C++ way...
int main (int argc, char *argv[])
{
  // Your code comes here.
  setup ();
  while (true)
    loop ();
  
  return 0;
}
