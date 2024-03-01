#! /bin/bash

### BSD 3-Clause License ### 
# 
# Copyright (c) 2021, Tibor Áser Veres All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 
#     Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 
#     Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# 
#     Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
############################

### Instructions ###
# Operation should be very simple Run: Build.sh it should take care of installing dependencies, as well as compiling.
# This script does not check for options recursively it passes them to your program at execution. With 1 exception below.
# The script is advanced but not full proof, if you experience weird issues you may wanna run it with "--rebuild-all" as FIRST option. (The reset of the options will be passed...)

### Good to know ###
# This script is based on my multi threaded bash script template available with my BashTool project: http://osrc.rip/Projects/BashTool.html under BSD 3-Clause "New" or "Revised" License.
# Threads can read the same variables/input files, but they must only write their own output files, and variables to avoid interference, and data corruption. There is no mutex in bash as far as I know...

### Finding roots ###
PWDir="$(pwd)"
cd $(cd "$(dirname "$0")"; pwd -P)
OwnDir="$(pwd)"
cd "$PWDir"

### Variables ###
ConfigFile="$OwnDir/Build.conf" # This file will be copied into WDir when it's created. Edit that if you need to interact with the running script.
Order=""
ThreadLimit=""
BatchSize=""
DevStuff=$(grep "DevStuff:" "$ConfigFile") # Read entire line containing the word "Dependencies:" from config file
DevStuff=($DevStuff) # String to array
DevStuff=${DevStuff[@]:1} # Shift array and convert back to string
Dependencies=$(grep "Dependencies:" "$ConfigFile") # Read entire line containing the word "Dependencies:" from config file
Dependencies=($Dependencies) # String to array
Dependencies=${Dependencies[@]:1} # Shift array and convert back to string
Libraries=""
Version="v1.2"

### Functions ###
function Message # $1 => "message"; $2 => E/W/I (Message Level: Error/Warning/Info);
{
  Level=""
  case $2
  in
                 [Ee]* ) Level="Error:"
                      ;;
                 [Ww]* ) Level="Warning:"
                      ;;
                   *) Level="Info:"
                      ;;
  esac
  echo "Build.sh: $(date -Iseconds) $Level $1"
}

function Listen # Listening to user input
{
  # This function is called by the Main process loads variables for the Main process only...
  if [[ ! -f $ConfigFile ]]
  then
    Message "$ConfigFile file does not exist... Aborting!" E
    exit
  else
    Order=$(grep "Order:" "$ConfigFile" | awk '{ print $2 }') # Read second word only from a line containing the word "Order:"
    ThreadLimit=$(grep "ThreadLimit:" "$ConfigFile" | awk '{ print $2 }')
    BatchSize=$(grep "BatchSize:" "$ConfigFile" | awk '{ print $2 }')
    Libraries=$(grep "Libraries:" "$ConfigFile")
    Libraries=($Libraries)
    Libraries=${Libraries[@]:1}
    SourceDirectories=$(grep "SourceDirectories:" "$ConfigFile")
    SourceDirectories=($SourceDirectories)
    SourceDirectories=${SourceDirectories[@]:1}
    Warnings=$(grep "Warnings:" "$ConfigFile")
    Warnings=($Warnings)
    Warnings=${Warnings[@]:1}
    WarningsMainOnly=$(grep "WarningsMainOnly:" "$ConfigFile")
    WarningsMainOnly=($WarningsMainOnly)
    WarningsMainOnly=${WarningsMainOnly[@]:1}
    ArduinoCompat=$(grep "ArduinoCompat:" "$ConfigFile")
    ArduinoCompat=($ArduinoCompat)
    ArduinoCompat=${ArduinoCompat[@]:1}
    PerformanceOpt=$(grep "PerformanceOpt:" "$ConfigFile")
    PerformanceOpt=($PerformanceOpt)
    PerformanceOpt=${PerformanceOpt[@]:1}
    ProgramName=$(grep "ProgramName:" "$ConfigFile")
    ProgramName=($ProgramName)
    ProgramName=${ProgramName[@]:1}
  fi
  if [[ $ThreadLimit -gt $ThreadCount || $ThreadLimit == 0 ]]
  then
    ThreadNumber=$ThreadCount
    if [[ $ThreadLimit != 0 ]]
    then
      Message "Thread limit ignored! Your CPU only has $ThreadCount threads!" W
    fi
  else
    ThreadNumber=$ThreadLimit
  fi
}

function Feed # $1 - Thread ID
{
  for i in $(seq $BatchSize)
  do
    
    
    
    # Select next file and feed it to an idle thread
    if [[ $BuildPointer -lt $NumFiles ]]
    then
      touch "$WDir/T$1D$i"
      X=0
      NextToBuild=""
      for File in $BuildQueue
      do
      	if [[ $X -eq $BuildPointer ]]
      	then
      	  NextToBuild="$File"
      	  break
      	fi
        X=$(( $X + 1 ))
      done
      echo "$NextToBuild" > "$WDir/T$1D$i"
      BuildPointer=$(( $BuildPointer + 1 ))
    else
      Var="Order: $(grep "Order" "$ConfigFile" | awk '{ print $2 }')"
      sed -i "s/$Var/Order:\ Stop/" "$ConfigFile"
      Order="Stop"
      break
    fi
    
    
    
  done
  if [[ $Order != "Stop" ]]
  then
    echo "State R" > "$WDir/Thread$1"
  fi
}

function Thread # $1 - Thread ID
{
  while [[ $(grep "State" "$WDir/Thread$Thread" | awk '{ print $2 }') != "C" ]]
  do
    if [[ $(grep "State" "$WDir/Thread$Thread" | awk '{ print $2 }') == "R" ]]
    then
      DeepSleep[$1]=0
      Y=""
      X=1
      while [[ $Y != "Done" ]]
      do
        if [[ -f "$WDir/T$1D$X" ]]
        then
          
          
          # Compile
          Changed="false"
          File=$(cat "$WDir/T$1D$X")
          BuildDir="$OwnDir/Build"
          SourceDir="${File%/*}"
          File="${File##*/}"
          NewSumH=$(md5sum "$OwnDir/$SourceDir/$File.h" | awk '{ print $1 }')
          NewSumCPP=$(md5sum "$OwnDir/$SourceDir/$File.cpp" | awk '{ print $1 }')
          if [[ -f "$BuildDir/$File.sum" && "$TotalRebuild" != "true" ]]
          then
            OldSumH=$(grep "H" "$BuildDir/$File.sum" | awk '{ print $2 }')
            OldSumCPP=$(grep "CPP" "$BuildDir/$File.sum" | awk '{ print $2 }')
            if [[ $NewSumH != $OldSumH || $NewSumCPP != $OldSumCPP || ! -f "$OwnDir/Build/$File.o" ]]
            then
              Message "Thread $1: Compiling $File.cpp ($File.h and/or $File.cpp changed.)" I
            else
              Message "Thread $1: Compiling $File.cpp (Directly or indirectly includes new or changed files.)" I
            fi
          else
            if [[ "$TotalRebuild" == "true" ]]
            then
              Message "Thread $1: Compiling $File.cpp (Full rebuild requested.)" I
            else
              Message "Thread $1: Compiling $File.cpp (No record of it's compillation yet.)" I
            fi
          fi
          rm -rf "$OwnDir/Build/$File.o"
          if [[ "$OwnDir/$SourceDir" == "$OwnDir/HexaLib" ]]
          then
            Message "Using \"$ArduinoCompat\" for $OwnDir/$SourceDir/$File.cpp"
	    g++ -std=c++14 -g -o "$OwnDir/Build/$File.o" -c "$OwnDir/$SourceDir/$File.cpp" -I "$OwnDir/HexaLib" $Libraries $PerformanceOpt $Warnings $ArduinoCompat
	  else
	    g++ -std=c++14 -g -o "$OwnDir/Build/$File.o" -c "$OwnDir/$SourceDir/$File.cpp" -I "$OwnDir/HexaLib" $Libraries $PerformanceOpt $Warnings
	  fi
          echo "H $NewSumH" > "$BuildDir/$File.sum"
          echo -n "CPP $NewSumCPP" >> "$BuildDir/$File.sum"
          echo -n "" > "$WDir/T$1D$X"
          
          
          
        else
          Y="Done"
        fi
        X=$(( $X + 1 ))
      done
      echo "State I" > "$WDir/Thread$1"
    else
      if [[ ${DeepSleep[$1]} -lt $(grep "SleepAfter" "$ConfigFile" | awk '{ print $2 }') ]] # Deep sleep means only checking for job less often
      then
        DeepSleep[$1]=$(( ${DeepSleep[$1]} + 1 ))
        sleep $(grep "FeedFrequency" "$ConfigFile" | awk '{ print $2 }')
      else
        Message "Thread$1 is sleeping..." I
        sleep $(grep "SleepFor" "$ConfigFile" | awk '{ print $2 }')
      fi
    fi
  done
  echo "State Offline" > "$WDir/Thread$1"
}

# Checking for dependencies
Message "Build.sh $Version"
Message "checking for dependencies" I
for i in $Dependencies
do
  if [[ -z $(dpkg -l | grep "$i") ]]
  then
    Message "This needs $Dependencies packages installed!" I
    read -p "Do you want to install them now? (y/n): " Yy
    if [[  "$Yy" == [Yy]*  ]]
    then
      sudo apt-get update
      sudo apt-get -y install $Dependencies
    else
      Message "Too bad... This software won't work without them! Aborting..." I
      exit
    fi
  fi
done
for i in $DevStuff
do
  if [[ -z $(dpkg -l | grep "$i") ]]
  then
    read -t 7 -p "Do you want to install basic development programs? If you're not a dev you probably won't need these.: " Yy
    if [[  "$Yy" == [Yy]*  ]]
    then
      sudo apt-get update
      sudo apt-get -y install $DevStuff
    fi
  fi
done

# Root check
if [[ $(whoami) == "root" ]]
then
  Message "The script was not designed to run as root... Aborting!" E
  exit
fi

# Loading variables
X=$(lscpu | grep 'CPU(s):' | awk '{ print $2 }')
ThreadCount=$(echo $X | awk '{ print $1 }')
Listen # Initialization of values from config file...
if [[ $ThreadLimit == 0 ]]
then
  Message "Thread limit: 0 (unlimited)" I
else
  Message "Thread limit: $ThreadLimit" I
fi

# WDir
RNum=$RANDOM
while [[ -d "/run/user/$(id -u $USER)/WDir$RNum" ]]
do
  RNum=$RANDOM
done
# The trheads communicate via files, so the WDir must be in tmpfs(aka file system in RAM) for good performance, and also to avoid wearing out SSDs. "/run/user/$(id -u $USER)" is tmpfs owned by the user...
WDir="/run/user/$(id -u $USER)/WDir$RNum"
Message "Preparing WDir! ($WDir)" I
mkdir "$WDir"
if [[ ! -d "$WDir" ]]
then
  Message "Work direcotry couldn not be created at $WDir Aborting!" E
  exit
else
  cp -a "$ConfigFile" "$WDir/Build.conf"
  ConfigFile="$WDir/Build.conf"
fi

### Execution ###
T1=$(date -Ins)
Message "Starting to build at: $T1" I





# Here's the place for initial operations.
CppFiles=""
for SourceDir in $SourceDirectories # HexaLib
do
  for i in $(ls "$OwnDir/$SourceDir" | grep ".cpp") # HexaLib
  do
    if [[ -z "$CppFiles" ]]
    then
      CppFiles="$SourceDir/${i%.*}"
    else
      CppFiles="$CppFiles $SourceDir/${i%.*}"
    fi
  done
done

# Select files that changed and those that include them unless option $1 is "--rebuild-all"
BuildQueue=""
TotalRebuild="false"
if [[ "$1" == "--rebuild-all" ]]
then
  BuildQueue="$CppFiles"
  TotalRebuild="true"
  rm -Rf "$OwnDir/Build"
  mkdir "$OwnDir/Build"
  shift
else
  for i in $CppFiles
  do
    Changed="false"
    BuildDir="$OwnDir/Build"
    SourceDir="${i%/*}"
    File="${i##*/}"
    NewSumH=$(md5sum "$OwnDir/$SourceDir/$File.h" | awk '{ print $1 }')
    NewSumCPP=$(md5sum "$OwnDir/$SourceDir/$File.cpp" | awk '{ print $1 }')
    if [[ -f "$BuildDir/$File.sum" ]]
    then
      OldSumH=$(grep "H" "$BuildDir/$File.sum" | awk '{ print $2 }')
      OldSumCPP=$(grep "CPP" "$BuildDir/$File.sum" | awk '{ print $2 }')
      if [[ $NewSumH != $OldSumH || $NewSumCPP != $OldSumCPP || ! -f "$OwnDir/Build/$File.o" ]]
      then
        Changed="true"
      fi
    else
      Changed="true"
    fi
    if [[ $Changed == "true" ]]
    then
      if [[ -z $BuildQueue ]]
      then
        BuildQueue="$i"
      else
        NewFile="true"
        for iii in $BuildQueue
        do
          if [[ "$i" == "$iii" ]]
          then
            NewFile="false"
            break
          fi
        done
        if [[ $NewFile == "true" ]]
        then
          BuildQueue="$BuildQueue $i"
        fi
      fi
      for ii in $CppFiles
      do
        File2="${ii##*/}"
        SourceDir2="${ii%/*}"
        if [[ "$File" != "$File2" && ! -z $(grep "#include" "$SourceDir2/$File2.h" | grep "$File.h\"") || "$File" != "$File2" && ! -z $(grep "#include" "$SourceDir2/$File2.cpp" | grep "$File.h\"") ]]
        then
          NewFile="true"
          for iii in $BuildQueue
          do
            if [[ "$SourceDir2/$File2" == "$iii" ]]
            then
              NewFile="false"
              break
            fi
          done
          if [[ $NewFile == "true" ]]
          then
            BuildQueue="$BuildQueue $SourceDir2/$File2"
          fi
        fi
      done
    fi
  done
  # Find library headers on build queue, that include their entire directory(eg. HexaLib/HexaLib.h, Source/Engine/Engine.h, etc.)
  LibHeaders=""
  for i in $BuildQueue
  do
    SourceDir="${i%/*}"
    File="${i##*/}"
    if [[ "$SourceDir" == "$File" || "$SourceDir" == "Source/$File" ]]
    then
      if [[ -z $LibHeaders ]]
      then
        LibHeaders="$i"
      else
        LibHeaders="$LibHeaders"
      fi
    fi
  done
  # Mark all files that include library headers listed in BuildQueue.
  for i in $LibHeaders
  do
    SourceDir="${i%/*}"
    File="${i##*/}"
    for ii in $CppFiles
      do
        File2="${ii##*/}"
        SourceDir2="${ii%/*}"
        if [[ "$File" != "$File2" && ! -z $(grep "#include" "$SourceDir2/$File2.h" | grep "$File.h\"") || "$File" != "$File2" && ! -z $(grep "#include" "$SourceDir2/$File2.cpp" | grep "$File.h\"") ]]
        then
          NewFile="true"
          for iii in $BuildQueue
          do
            if [[ "$SourceDir2/$File2" == "$iii" ]]
            then
              NewFile="false"
              break
            fi
          done
          if [[ $NewFile == "true" ]]
          then
            BuildQueue="$BuildQueue $SourceDir2/$File2"
          fi
        fi
      done
  done
fi

DoneBuilding=0
BuildPointer=0
NumFiles=0
for i in $BuildQueue
do
  NumFiles=$(( NumFiles + 1 ))
done






# Preparing threads
for Thread in $(seq $ThreadCount) # Maximum number of threads must be created even if the limit is lower for the flexibility of activating/deactivating them later
do
  Message "Creating Thread $Thread!" I
  touch "$WDir/Thread$Thread"
  echo "State: I" >> "$WDir/Thread$Thread"
  DeepSleep[$Thread]=0
  Thread $Thread& # These threads should not be closed, they sleep until they are fed data and their status is set to R. They will exit with the main process.
done
#Message "To stop the building process run: sed -i \"s/Order:\\ Run/Order:\\ Stop/\" \"$ConfigFile\"" I

if [[ ! -f "$WDir/Results" ]]
then
  touch "$WDir/Results"
else
  echo -n "" > "$WDir/Results" # clearing results... you may not want to do that if the operation you're doing is very long, and may be done in more then 1 session...
fi
while [[ $Order != "Stop" ]]
do
  if [[ $Order == "Run" && ${DeepSleep[0]} -ge $(grep "SleepAfter" "$ConfigFile" | awk '{ print $2 }') ]]
  then
    Message "Main process active!" I
  fi
  for Thread in $(seq $ThreadNumber)
  do
    if [[ $(grep "State" "$WDir/Thread$Thread" | awk '{ print $2 }') == "I" && $Order == "Run" ]]
    then
      Feed $Thread
      if [[ ${DeepSleep[$Thread]} -ge $(grep "SleepAfter" "$ConfigFile" | awk '{ print $2 }') ]] # If it has been paused it must wake the threads
      then
        DeepSleep[$Thread]=0
        Message "Waking Thread$Thread..." I
      fi
    fi
  done
  if [[ $Order == "Run" ]] # Main process should not go into deep sleep if $Order == "Run"
  then
    DeepSleep[0]=0
  fi
  if [[ ${DeepSleep[0]} -lt $(grep "SleepAfter" "$ConfigFile" | awk '{ print $2 }') ]]
  then
    DeepSleep[0]=$(( ${DeepSleep[0]} + 1 ))
    sleep $(grep "FeedFrequency" "$ConfigFile" | awk '{ print $2 }')
  else
    Message "Main process is sleeping..." I
    sleep $(grep "SleepFor" "$ConfigFile" | awk '{ print $2 }')
  fi
  Listen
done
# Waiting for all threads to finish
Wait=true
Message "Waiting for threads to finish." I
while [[ $Wait == true ]]
do
  Wait=false
  sleep 0.01
  for Thread in $(seq $ThreadCount)
  do
    if [[ $(grep "State" "$WDir/Thread$Thread" | awk '{ print $2 }') == "R" ]]
    then
      Wait=true
    else
      if [[ $(grep "State" "$WDir/Thread$Thread" | awk '{ print $2 }') == "I" ]]
      then
        echo "State C" > "$WDir/Thread$Thread"
        Wait=true
      else
        if [[ $(grep "State" "$WDir/Thread$Thread" | awk '{ print $2 }') != "Offline" ]]
        then
          Wait=true
        fi
      fi
    fi
  done
done
Message "All threads are offline." I





# Assemble everything...
Main="Main"
Message "Compiling Main" I
Files=$(ls $OwnDir/Build/*.o)
Binaries=""
for i in "$Files"
do
  if [[ -z $Binaries ]]
  then
    Binaries="$i"
  else
    Binaries="$Binaries $i"
  fi
done
rm -f "$OwnDir/$ProgramName"
g++ -std=c++14 -g -o "$OwnDir/$ProgramName" "$OwnDir/Source/$Main.cpp" -I "$OwnDir/HexaLib" $Binaries $Libraries $PerformanceOpt $Warnings $WarningsMainOnly





### Finishing ###
T2=$(date -Ins)
Message "Finished at: $T2" I
# Here you can calculate runtime, summary of what's done, maybe percentage if the operation was not entirely finished, etc.
rm -Rf $WDir

echo ""
if [[ -f "$OwnDir/$ProgramName" ]]
then
  read -p "Do you want to run it? (y/n): " Yy
else
  echo "Sorry... Build failed! :-/"
  Yy="n"
fi

if [[ "$Yy" == [Yy]* ]]
then
  echo ""
  "$OwnDir/$ProgramName" "$@"
fi
