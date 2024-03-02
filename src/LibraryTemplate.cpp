#include "LibraryTemplate.h"


void LibraryTemplate::SetStr (const char * Str)
{
  strcpy (Hello, Str);
}

const char * LibraryTemplate::GetHello () const
{
  return Hello;
}
