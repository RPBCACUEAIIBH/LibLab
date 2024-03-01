#define MAIN_INCLUDED

// Inclusions
#include <thread>
#include <chrono>
#include <iostream>
//#include "YourLibrary.h"

using namespace std;

void setup ()
{
  
}

void loop ()
{
  while (true)
  {
    cout << "PC Reporting! :D" << "\n";
    this_thread::sleep_for (chrono::seconds (1));
  }
}

int main (int argc, char *argv[])
{
  // Your code comes here.
  setup ();
  loop ();
  
  return 0;
}
