#!/bin/bash
set -ex # paranoid
#.....................
# Matthew's Photo Import Tool
#
# Configuration File: 
# stuff
configFile=~/.config/importphotorc

# Execution Plan
#  Parse command line
#  Parse configuration file
#  Prepare list of input files
#  - Extract metadata for filenames
#  - Build new filenames per name scheme
#  -- How to generate repeatable, consistent sequence #s
#  --- Time based (but handle out-of-order filenames!)
#  --- Sort based on time w/in day
#  --- What if there are some destination day files already in destination!
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

function parse_commands {
    echo "Reading arguments"
    # ... Handle Arguments ...
    # http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#    while [[ $# -gt 1 ]]
    while (( $# >= 1 ))
        do
        key="$1"

        case $key in
            -s|--single)
                echo "Single file mode"
                operation_mode='single'
                input_path="$2"
                util_split_filepath $input_path
                shift # past argument
            ;;
            -l|--lib)
                LIBPATH="$2"
                shift # past argument
            ;;
            -h|--help)
                DEFAULT=YES
            ;;
            *)
                # No command passed; check if directory on command line
                if [ -d "$key" ]; then
                    operation_mode='directory'
                    echo "Directory mode"
                    input_directory=$key
                else
                    # Not directory, check if file
                    if [ -f "$key" ]; then
                        operation_mode='single'
                        input_path="$key"
                        util_split_filepath $input_path
                    else
                        # Nope... display usage
                        echo "Unknown option $key"
                        exit 1
                    fi
                fi
            ;;
        esac
        shift # past argument or value
    done
}

function read_config {
    echo "Reading configuration file"
    if [ -s $configFile ]; then
        . $configFile
    fi
}

function read_input_directory {
    echo "Gathering files"
}

function read_file_metadata {
    echo "Getting metadata from $1"
    # Bash trick to extract from 
    # http://stackoverflow.com/questions/3603988/how-to-parse-of-exif-time-stamps-with-bash-script

    SPEC=$(exiftool -CreateDate "$inFile")
    read X X fYear fMonth fDay fHour fMinute fSecond <<<${SPEC//:/ }

    echo "Found in $inFile: Year $fYear Month $fMonth Day \
        $fDay Hour $fHour Minute $fMinute Second $fSecond"
}

function util_split_filepath {
    if [ -z "$1" ]; then
        echo "util_split_filepath passed empty path!"
        return 1
    fi

    input_directory=$(dirname "$1")
    input_filename=$(basename "$1")
    input_extension="${1##*.}"

}

function build_destination_filenames {
    echo "Generating new file names"
}

function scan_destiation {
    echo "Scanning destination"
}

function build_action_list {
    echo "Preparing to import"
}
#.... the big loop ....


parse_commands $@ 
read_config
# Get current file path & name
iFileName=$(basename "${infilename}")
iFileName_Ext="${infilename##*.}"
iFileName_Base="${infilename%.*}"

echo "filename: $iFileName iFileName_Ext: $iFileName_Ext, iFileName_Base: $iFileName_Base"

# Test for XMP sidecar

echo "Looking for sidecar $inFile.xmp"

if [ -s "$inFile.xmp" ]; then
    echo "XMP Sidecar Located";
    inFileXmp="$inFile.xmp"
fi


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

