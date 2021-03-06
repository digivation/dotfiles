#!/bin/bash
#
# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_POSITIONAL_SINGLE([input_file],[Input Video],[])
# ARG_OPTIONAL_SINGLE([output_file],[o],[Output Video file name])
# ARG_OPTIONAL_SINGLE([shake],[],[Shakiness of source, 1 is smallest, 10 is max],[5])
# ARG_OPTIONAL_SINGLE([smooth],[],[Smoothing to apply to output, bigger is smoother],[10])
# ARG_OPTIONAL_SINGLE([phase],[],[Do first or second pass])
# ARG_HELP([The general script's help msg])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.4.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate

die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}

begins_with_short_option()
{
	local first_option all_short_options
	all_short_options='oh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}



# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_output_file=
_arg_shake="5"
_arg_smooth="15"
_arg_phase=

print_help ()
{
	echo "The general script's help msg"
	printf 'Usage: %s [-o|--output_file <arg>] [--shake <arg>] [--smooth <arg>] [--phase <arg>] [-h|--help] <input_file>\n' "$0"
	printf "\t%s\n" "<input_file>: Input Video"
	printf "\t%s\n" "-o,--output_file: Output Video file name (no default)"
	printf "\t%s\n" "--shake: Shakiness of source, 1 is smallest, 10 is max (default: '"5"')"
	printf "\t%s\n" "--smooth: Smoothing to apply to output, bigger is smoother (default: '"10"')"
	printf "\t%s\n" "--phase: Do first or second pass (no default)"
	printf "\t%s\n" "-h,--help: Prints help"
}

# THE PARSING ITSELF
while test $# -gt 0
do
	_key="$1"
	case "$_key" in
		-o*|--output_file|--output_file=*)
			_val_from_long="${_key##--output_file=}"
			_val_from_short="${_key##-o}"
			if test "$_val_from_long" != "$_key"
			then
				_val="$_val_from_long"
			elif test "$_val_from_short" != "$_key" -a -n "$_val_from_short"
			then
				_val="$_val_from_short"
			else
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_val="$2"
				shift
			fi
			_arg_output_file="$_val"
			;;
		--shake|--shake=*)
			_val="${_key##--shake=}"
			if test "$_val" = "$_key"
			then
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_val="$2"
				shift
			fi
			_arg_shake="$_val"
			;;
		--smooth|--smooth=*)
			_val="${_key##--smooth=}"
			if test "$_val" = "$_key"
			then
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_val="$2"
				shift
			fi
			_arg_smooth="$_val"
			;;
		--phase|--phase=*)
			_val="${_key##--phase=}"
			if test "$_val" = "$_key"
			then
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_val="$2"
				shift
			fi
			_arg_phase="$_val"
			;;
		-h*|--help)
			print_help
			exit 0
			;;
		*)
			_positionals+=("$1")
			;;
	esac
	shift
done

_positional_names=('_arg_input_file' )
_required_args_string="'input_file'"
test ${#_positionals[@]} -lt 1 && _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 1 (namely: $_required_args_string), but got only ${#_positionals[@]}." 1
test ${#_positionals[@]} -gt 1 && _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 1 (namely: $_required_args_string), but got ${#_positionals[@]} (the last one was: '${_positionals[*]: -1}')." 1
for (( ii = 0; ii < ${#_positionals[@]}; ii++))
do
	eval "${_positional_names[ii]}=\${_positionals[ii]}" || die "Error during argument parsing, possibly an Argbash bug." 1
done

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# Main script
# Do magical video stabilization using vid.stab and ffmpeg

#### Sauces ####
# Original details = https://www.epifocal.net/blog/video-stabilization-with-ffmpeg
# vid.stab manual = http://public.hronopik.de/vid.stab/features.php
# vid.stab github = https://github.com/georgmartius/vid.stab
# ffmpeg manual, vidstabdetect = http://www.ffmpeg.org/ffmpeg-filters.html#vidstabdetect-1
# ffmpeg manual, vidstabtransform = http://www.ffmpeg.org/ffmpeg-filters.html#vidstabtransform-1
# ffmpeg manual, unsharp filter = http://www.ffmpeg.org/ffmpeg-filters.html#unsharp

# Execution patterns:
# 1. Single file mode; input -> output
#
# 2. Folder Mode; inputdir -> process all -> output
# 3. Playlist mode?; inputList -> Load and process -> outputs

#### Steps to Magic ####
# 1. Read video and generate transforms file (vidstabdetect) - phase 1
#   Options:
#   result          transforms file, default "transforms.trf"
#   shakiness       integer(1,10), how shaky is the source video - 1 is least, 10 max. default 5
#   accuracy        integer(1,15), how accurage of detection, balance speed. default 15 (max)
#   stepsize        search region, default 6px
#   mincontrast     float(0,1), threshold for local measurement. default 0.25
#   tripod          reference frame # for tripod mode, count starts at 1. sets "static" scene to reference all stabilization to. 0 = disabled
#   show            integer(0,2) generate visualization?
NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
TRANSFORM_RESULTS="$_arg_input_file-transform.trf"
#SHAKE_FACTOR="5"
SHAKE_FACTOR="$_arg_shake"
ACCURACY_FACTOR="15"
STEPSIZE="6"
MINCONTRAST="0.25"
TRIPOD="0"
GENERATE_VIZ="0"

# Assemble the options!
VIDSTAB_PHASE1_OPTS="result=$TRANSFORM_RESULTS:shakiness=$SHAKE_FACTOR:accuracy=$ACCURACY_FACTOR:stepsize=$STEPSIZE:mincontrast=$MINCONTRAST:tripod=$TRIPOD:show=$GENERATE_VIZ"

echo "Analysis Options: $VIDSTAB_PHASE1_OPTS"

# 2. Apply transforms and generate smoothed video (vidstabtransform) - phase 2
#   Options:
#   input           transforms file from phase 1
#   smoothing       integer, number of frames (value*2+1) for filtering camera movement. Default = 15, which is 15 before and 15 after; larger values=smoother. 0 = static cam?
#   optalgo         camera path optimization algorithm; gauss (default), avg
#   maxshift        maximum pixels to translate frame, default = -1 (no max)
#   maxangle        maximum angle in deg to rotate frame, default = -1 (no max)
#   crop            how to handle boarder - 'keep' - hold prior frame; 'black' always fill with black
#   invert          int(0,1) if 1, invert all transforms
#   relative        consider transforms relative to prior frame if 1; 0 absolute. defautl 1, relative
#   zoom            percentage zoom; positive = zoom in, negative = zoom out; default 0
#   optzoom         set optimal zooming to avoid borders; 0 = disabled, 1 = optimal static zoom; 2 = optimal adaptive zoom
#   zoomspeed       float(0,5) - percent to zoom per frame (only when optzoom = 2) default 0.25
#   interpol        type of interpolation - 'no' = none; 'linear' = linear only horizontal; 'bilinear'  linear both directions (default); 'bicubic' = bicubic both directions
#   tripod          int(1,0) - virtual tripod mode = relative=0:smoothing=0; default 0. Goes with tripod opt for vidstabdetect
#   debug           int(1,0) - increase logging if 1
#SMOOTHING_FACTOR="10"
SMOOTHING_FACTOR="$_arg_smooth"
PATH_ALGO="gauss"
MAX_SHIFT="-1"
MAX_ANGLE="-1"
CROP="keep"
INVERT="0"
RELATIVE_XFORM="1"
STD_ZOOM_PERCENT="0"
ADAPTIVE_ZOOM="1"
ZOOMSPEED="0.25"
INTERPOLATION="bilinear"
DEBUG="0"

# Assemble the options!
VIDSTAB_PHASE2_OPTS="input=$TRANSFORM_RESULTS:smoothing=$SMOOTHING_FACTOR:optalgo=$PATH_ALGO:maxshift=$MAX_SHIFT:maxangle=$MAX_ANGLE:crop=$CROP:invert=$INVERT:relative=$RELATIVE_XFORM:zoom=$STD_ZOOM_PERCENT:optzoom=$ADAPTIVE_ZOOM:zoomspeed=$ZOOMSPEED:interpol=$INTERPOLATION:debug=$DEBUG"

echo "Transform Options: $VIDSTAB_PHASE2_OPTS"

# 2a. Unsharp mask should be applied to output because /reasons/
#   always recommended to use.
#   default setting:
#       unsharp=5:5:0.8:3:3:0.4
#   "improves output"
#
#   Options:
#   luma_msize_x    int(3,23) - luma matrix horizontal, must be odd. default 5
#   luma_msize_y    int(3,23) - luma matrix vertical, must be odd. default 5
#   luma_amount     float(-1.5,1.5) - strength of luma effect - positive sharpens, negative blurs
#   chroma_msize_x  int(3,23) - chroma matrix horizontal, must be odd, default 5
#   chroma_msize_y  int(3,23) - chroma matrix vertical, must be odd, default 5
#   chroma_amount   float(-1.5,1.5) - strength of chroma effect - positive sharpens, negative blurs
#   opencl          int(0,1) - if 1, enable OpenCL
OPENCL=1 # OpenCL enabled
UNSHARP_OPTS="5:5:0.8:3:3:0.4:$OPENCL"

echo "Unsharp Options: $UNSHARP_OPTS"

#### NOTES ####
# For first pass, make sure output is null, add: "-f null -"

# Format (first pass):
#   ffmpeg -i $INPUT_VIDEO -vf vidstabdetect=$VIDSTAB_PHASE1_OPTS -f null -
# note, if debug/viz opts passed, an output video file should be set

# Format (second pass):
#   ffmpeg -i $INPUT_VIDEO -vf vidstabtransform=$VIDSTAB_PHASE2_OPTS,unsharp=$UNSHARP_OPTS $OUTPUT_VIDEO
#   ffmpeg -i $INPUT_VIDEO -vf vidstabtransform=$VIDSTAB_PHASE2_OPTS,unsharp=$UNSHARP_OPTS $EXTRA_FFMPEG_FLAGS $OUTPUT_VIDEO

# $EXTRA_FFMPEG_FLAGS Extra flags for second pass:
#   -acodec copy        stream copy the audio (good)
#   -vcodec libx264     set video codec to x246
#       -preset slow    ??
#       -tune film      ??
#       -crf 18         ?? lower is better

#EXTRA_FFMPEG_FLAGS="-acodec copy"
#EXTRA_FFMPEG_FLAGS="-c:v dnxhd -profile:v dnxhr_lb -c:a pcm_s24le"
EXTRA_FFMPEG_FLAGS="-c:v dnxhd -profile:v dnxhr_hqx -pix_fmt yuv422p10le -c:a pcm_s24le"

echo "Extra FFMPEG Flags: $EXTRA_FFMPEG_FLAGS"

INPUT_VIDEO="$_arg_input_file"
OUTPUT_VIDEO="$_arg_output_file"

if [ "$_arg_phase" != "" -a "$_arg_phase" == "1" ]; then
    echo "Assembled Phase 1 Command: ffmpeg -i $INPUT_VIDEO -vf vidstabdetect=$VIDSTAB_PHASE1_OPTS -f null -"
    ffmpeg -i $INPUT_VIDEO -vf vidstabdetect=$VIDSTAB_PHASE1_OPTS -f null -
fi

if [ "$_arg_phase" != "" -a "$_arg_phase" == "2" ]; then
    echo "Assembled Phase 2 Command: ffmpeg -i $INPUT_VIDEO -vf vidstabtransform=$VIDSTAB_PHASE2_OPTS,unsharp=$UNSHARP_OPTS $EXTRA_FFMPEG_FLAGS $OUTPUT_VIDEO"
    ffmpeg -i $INPUT_VIDEO -vf vidstabtransform=$VIDSTAB_PHASE2_OPTS,unsharp=$UNSHARP_OPTS $EXTRA_FFMPEG_FLAGS $OUTPUT_VIDEO
fi

if [ "$_arg_phase" == "" ]; then
    echo "Removing transform file"
    rm $TRANSFORM_RESULTS
fi


# ] <-- needed because of Argbash
