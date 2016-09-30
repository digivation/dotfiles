#!/bin/bash
set -x # paranoid
#.....................
# Matthew's Photo Import Tool
#
# Configuration File: 
# stuff
configFile=~/.config/importphotosrc 

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
#  Determine move type:
#  -- Copy to library (default)
#  -- Move to library (require switch)
#  -- Rename in place (discover but display message, require switch)
#  Display statistics to user, request confirmation (suppores w/ flag)
#  Execute move type
#  -- Secure move! MD5Sum prior/post move? Other?
#  -- Display progress
#  -- Handle conflicts (PARANOID)
#  Cloud backup of files (if configured, also skippable via command line)
#  -- Cloud backup could be run in parallel to move????
#  Write log
#  Display final results

#  Parse command line
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

#  Parse configuration file
function read_config {
    echo "Reading configuration file"
    if [ -s $configFile ]; then
        source $configFile
    fi
}

#  Prepare list of input files
#  - Extract metadata for filenames
#  - Build new filenames per name scheme
#  -- How to generate repeatable, consistent sequence #s
#  --- Time based (but handle out-of-order filenames!)
#  --- Sort based on time w/in day
#  --- What if there are some destination day files already in destination!
function read_input_directory {
    echo "Gathering files"

    if [ ! -d "$1" ]; then
        echo "read_input_directory: invalid directory"
    fi

    # glob files in the dirctory
    shopt -s nullglob
    dirfiles=("${1}/*")
    
    temp_input_file=$(mktemp -t image_input_tmp.XXXX)

    # process each file into an array
    count=0
    for i in ${dirfiles[@]}; do
        util_split_filepath $i

        if [[ "$input_filename" == '._'*  ]]; then
            echo "skipping crap"
            continue
        fi

        if [[ ("$image_exts" =~ "$input_extension") && ( -r $i ) ]]; then
            # Process image file
#            echo "IMAGE FOUND! $i"
            process_input_file "image" $i

            echo "$sorthelper" >> $temp_input_file
            continue
        elif [[ ("$video_exts" =~ "$input_extension") && ( -r $i ) ]]; then
            # Process video file
            echo "VIDEO FOUND! $i"
            process_input_file "video" $i
            continue
        fi

#        if [[ "$sidecar_exts" =~ $input_extension ]]; then
            # a sidecar, skip
#            echo "SIDECAR FOUND $i"
#            unset dirfiles[$count]
#            count=$(( $count + 1 ))
#            continue
#        fi

        
        # at this point we are on a file that's not a sidecar
        # TODO add handling for non-images (ie, whitelist extensions)


        # Build date sorted list (expand this to use exif first)
        # http://stackoverflow.com/questions/25577074/iterate-through-list-of-filenames-in-order-they-were-created-in-bash

#        sorthelper=();
#        for file in *; do
            # We need something that can easily be sorted.
            # Here, we use "<date><filename>".
            # Note that this works with any special characters in filenames

#            sorthelper+=("$(stat -n -f "%Sm%N" -t "%Y%m%d%H%M%S" -- "$file")"); # Mac OS X only
            # or
#            sorthelper+=("$(stat --printf "%Y    %n" -- "$file")"); # Linux only
#        done;

#        sorted=();
#        while read -d $'\0' elem; do
            # this strips away the first 14 characters (<date>) 
#            sorted+=("${elem:14}");
#        done < <(printf '%s\0' "${sorthelper[@]}" | sort -z)

 #       for file in "${sorted[@]}"; do
            # do your stuff...
#            echo "$file";
#        done;

        let count++
    done
    echo "Sorting found images by time.."
    temp_input_sort=$(mktemp -t image_input_sort.XXXX)
    sort -n $temp_input_file > $temp_input_sort


    echo "Generating new file names"
    if [[ ! -d $def_destination ]]; then
        echo "Bad default destination"
        exit 1
    fi

    # Get Date from file
    while IFS=':' read -r $unixdate $infile 
    do
        echo $unixdate $infile
    done <"$temp_input_sort"
}

# Build the input line

function process_input_file {
    case $1 in
        "image")
            unset sorthelper
            # get metadata date for sort
            SPEC=$(exiv2 -g DateTimeOriginal "$2")
            read X X X fYear fMonth fDay fHour fMinute fSecond <<<${SPEC//:/ }

            sorthelper="$(date --date="$fMonth/$fDay/$fYear $fHour:$fMinute:$fSecond" +"%s"):$2"
#            echo $sorthelper
            ;;
        "video")
            echo "building video line"
            ;;
        *)
            echo "unknown option, error"
            exit 1
    esac


}

# Test for XMP sidecar
function locate_sidecar_files {
#    echo "Finding Sidecars"
    unset located_sidecar
    if [ -s "$1.xmp" ]; then
        echo "XMP Sidecar Located";
        located_sidecar="$1.xmp"
    fi
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
    unset input_directory
    unset input_filename
    unset input_extension

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
    if [[ ! -d $def_destination ]]; then
        echo "Bad default destination"
        exit 1
    fi

    # Get Date from file
    while IFS=':' read -r $unixdate $infile 
    do
        echo $unixdate $infile
    done < "$1"
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
read_input_directory $input_directory
# Get current file path & name



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

