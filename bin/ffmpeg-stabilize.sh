#!/bin/bash

# Do magical video stabilization using vid.stab and ffmpeg

#### Sauces ####
# Original details = https://www.epifocal.net/blog/video-stabilization-with-ffmpeg
# vid.stab manual = http://public.hronopik.de/vid.stab/features.php
# vid.stab github = https://github.com/georgmartius/vid.stab
# ffmpeg manual, vidstabdetect = http://www.ffmpeg.org/ffmpeg-filters.html#vidstabdetect-1
# ffmpeg manual, vidstabtransform = http://www.ffmpeg.org/ffmpeg-filters.html#vidstabtransform-1
# ffmpeg manual, unsharp filter = http://www.ffmpeg.org/ffmpeg-filters.html#unsharp

#### Steps to Magic ####
# 1. Read video and generate transforms file (vidstabdetect) - phase 1
#   Options:
#   result          transforms file, default "transforms.trf"
#   shakiness       integer(1,10), how shaky is the source video - 1 is least, 10 max. default 5
#   accuracy        integer(1,15), how accurage of detection, balance speed. default 15 (max)
#   stepsize        search region, default 6px
#   mincontrast     float(0,1), threshold for local measurement. default 0.3
#   tripod          reference frame # for tripod mode, count starts at 1. sets "static" scene to reference all stabilization to. 0 = disabled
#   show            integer(0,2) generate visualization?
# 2. Apply transforms and generate smoothed video (vidstabtransform) - phase 2
#   Options:
#   input           transforms file from phase 1
#   smoothing       integer, number of frames (value*2+1) for filtering camera movement. Default = 10, which is 10 before and 10 after; larger values=smoother. 0 = static cam?
#   optalgo         camera path optimization algorithm; gauss (default), avg
#   maxshift        maximum pixels to translate frame, default = -1 (no max)
#   maxangle        maximum angle in deg to rotate frame, default = -1 (no max)
#   crop            how to handle boarder - 'keep' - hold prior frame; 'black' always fill with black
#   invert          int(0,1) if 1, invert al transforms
#   relative        consider transforms relative to prior frame if 1; else absolute. defautl 0, absolute
#   zoom            percentage zoom; positive = zoom in, negative = zoom out; default 0
#   optzoom         set optimal zooming to avoid borders; 0 = disabled, 1 = optimal static zoom; 2 = optimal adaptive zoom
#   zoomspeed       float(0,5) - percent to zoom per frame (only when optzoom = 2) default 0.25
#   interpol        type of interpolation - 'no' = none; 'linear' = linear only horizontal; 'bilinear'  linear both directions (default); 'bicubic' = bicubic both directions
#   tripod          int(1,0) - virtual tripod mode = relative=0:smoothing=0; default 0. Goes with tripod opt for vidstabdetect
#   debug           int(1,0) - increase logging if 1
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

#### NOTES ####
# For first pass, make sure output is null, add: "-f null -"

# Format (first pass):
#   ffmpeg -i $INPUT_VIDEO -vf vidstabdetect=$VIDSTAB_PHASE1_OPTS -f null -
# note, if debug/viz opts passed, an output video file should be set

# Format (second pass):
#   ffmpeg -i $INPUT_VIDEO -vf vidstabtransform=$VIDSTAB_PHASE2_OPTS,unsharp=$UNSHARP_OPTS $OUTPUT_VIDEO

