#!/bin/bash
set -ex # paranoid
#.....................
# Matthew's Photo Import Tool
#
# Configuration File: 
# stuff

# Execution Plan
#  Initalize variables
#  Parse command line
#  Parse configuration file
#  Prepare list of input files
#  - Extract metadata for filenames
#  - Build new filenames per name scheme
#  -- How to generate repeatable, consistent sequence #s
#  --- Time based (but handle out-of-order filenames!)
#  --- Sort based on time w/in day
#  - Determine move type:
#  -- Copy to library (default)
#  -- Move to library (require switch)
#  -- Rename in place (discover but display message, require switch)
#  - Display statistics to user, request confirmation (suppores w/ flag)
#  - Execute move type
#  -- Secure move! MD5Sum prior/post move? Other?
#  -- Display progress
#  -- Handle conflicts (PARANOID)
#  - Cloud backup of files (if configured, also skippable via command line)
#  -- Cloud backup could be run in parallel to move????
#  - Write log
#  - Display final results

# Exif Time:
# exiftool -CreateDate $fileName

# ... Handle Arguments ...
# http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

for i in "$@"
do
    case $i in 
        -h|--help)
            echo "Test Help"
            shift
            ;;
        *)
            inFile="$i"
            echo $inFile
            ;;
    esac
done
#.... the big loop ....


# Get current file path & name
iFileName=$(basename "$inFile")
iFileName_Ext="${iFileName##*.}"
iFileName_Base="${iFileName%.*}"

echo "iFileName_Ext: $iFileName_Ext, iFileName_Base: $iFileName_Base"

# Test for XMP sidecar

echo "Looking for sidecar $inFile.xmp"

if [ -s "$inFile.xmp" ]; then
    echo "XMP Sidecar Located";
    inFileXmp="$inFile.xmp"
fi

# Bash trick to extract from http://stackoverflow.com/questions/3603988/how-to-parse-of-exif-time-stamps-with-bash-script

SPEC=$(exiftool -CreateDate "$inFile")
read X X fYear fMonth fDay fHour fMinute fSecond <<<${SPEC//:/ }

echo "Found in $inFile: Year $fYear Month $fMonth Day $fDay Hour $fHour Minute $fMinute Second $fSecond"

# File Time:

# Naming Format:

# Images:
# $baseDir/$year/$month/$year$month$day[_$event]_$number.$ext

# Video:
# $baseDir/$year/$month/$yearh$month$day[_$event]_$number.$ext

# interesting data to work with:
# Date - split to yyyy mm dd variables
# Sequence Number - for inter-event/day sequencing... get from ? 
# Event - would need to be import argument
# Camera - from Exif

# If there's an XMP - move it with the file - same basename +.xmp

# Backup to ACD?

# Upload to GooglePhotos?
